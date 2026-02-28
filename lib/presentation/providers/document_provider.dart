import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/document.dart';
import '../../domain/repositories/document_repository.dart';
import '../../data/repositories/document_repository_impl.dart';
import '../../data/sources/sync_service.dart';
import 'package:uuid/uuid.dart';

final documentRepositoryProvider = Provider<DocumentRepository>((ref) {
  return DocumentRepositoryImpl();
});

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService();
});

class DocumentListNotifier extends Notifier<List<Document>> {
  @override
  List<Document> build() {
    _loadDocuments();
    return [];
  }

  Future<void> _loadDocuments() async {
    final repository = ref.read(documentRepositoryProvider);
    state = await repository.getAllDocuments();
  }

  Future<void> addDocument(String name, List<String> imagePaths) async {
    final repository = ref.read(documentRepositoryProvider);
    final document = Document(
      id: const Uuid().v4(),
      name: name,
      imagePaths: imagePaths,
      createdAt: DateTime.now(),
    );
    await repository.saveDocument(document);
    await _loadDocuments();

    // Auto-sync attempt (can be moved to a background worker later)
    await syncDocument(document.id);
  }

  Future<void> deleteDocument(String id) async {
    final repository = ref.read(documentRepositoryProvider);
    await repository.deleteDocument(id);
    await _loadDocuments();
  }

  Future<void> syncDocument(String id) async {
    final syncService = ref.read(syncServiceProvider);
    final repository = ref.read(documentRepositoryProvider);

    final docIndex = state.indexWhere((d) => d.id == id);
    if (docIndex == -1) return;

    final doc = state[docIndex];
    if (doc.isSynced) return;

    // Default to Google Drive for now, unless iOS
    final provider = SyncProvider.googleDrive; // Should be dynamic in Phase 6

    final syncedDoc = await syncService.syncDocument(doc, provider);
    if (syncedDoc != null) {
      await repository.updateDocument(syncedDoc);
      await _loadDocuments();
    }
  }
}

final documentListProvider =
    NotifierProvider<DocumentListNotifier, List<Document>>(() {
      return DocumentListNotifier();
    });
