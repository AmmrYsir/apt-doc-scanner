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
    print('DEBUG: DocumentListNotifier build()');
    _loadDocuments();
    return [];
  }

  Future<void> _loadDocuments() async {
    print('DEBUG: _loadDocuments() started');
    try {
      final repository = ref.read(documentRepositoryProvider);
      final docs = await repository.getAllDocuments();
      print('DEBUG: Found ${docs.length} documents in DB');
      state = docs;
    } catch (e) {
      print('DEBUG: Error loading documents: $e');
    }
  }

  Future<void> addDocument(String name, List<String> imagePaths) async {
    print('DEBUG: addDocument() triggered for: $name');
    try {
      final repository = ref.read(documentRepositoryProvider);
      final document = Document(
        id: const Uuid().v4(),
        name: name,
        imagePaths: imagePaths,
        createdAt: DateTime.now(),
      );
      print('DEBUG: Saving document ${document.id} to repository...');
      await repository.saveDocument(document);
      print('DEBUG: Document saved. Refreshing list...');
      await _loadDocuments();

      // Auto-sync attempt
      syncDocument(document.id);
    } catch (e) {
      print('DEBUG: Error adding document: $e');
    }
  }

  Future<void> deleteDocument(String id) async {
    final repository = ref.read(documentRepositoryProvider);
    await repository.deleteDocument(id);
    await _loadDocuments();
  }

  Future<void> syncDocument(String id) async {
    print('DEBUG: syncDocument() for $id');
    final syncService = ref.read(syncServiceProvider);
    final repository = ref.read(documentRepositoryProvider);

    final docIndex = state.indexWhere((d) => d.id == id);
    if (docIndex == -1) return;

    final doc = state[docIndex];
    if (doc.isSynced) return;

    final provider = SyncProvider.googleDrive;

    try {
      final syncedDoc = await syncService.syncDocument(doc, provider);
      if (syncedDoc != null) {
        print('DEBUG: Sync success for $id');
        await repository.updateDocument(syncedDoc);
        await _loadDocuments();
      } else {
        print('DEBUG: Sync returned null for $id');
      }
    } catch (e) {
      print('DEBUG: Sync error for $id: $e');
    }
  }
}

final documentListProvider = NotifierProvider<DocumentListNotifier, List<Document>>(() {
  return DocumentListNotifier();
});

