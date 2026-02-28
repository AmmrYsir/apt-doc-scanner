import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/document.dart';
import '../../domain/repositories/document_repository.dart';
import '../../data/repositories/document_repository_impl.dart';
import 'package:uuid/uuid.dart';

final documentRepositoryProvider = Provider<DocumentRepository>((ref) {
  return DocumentRepositoryImpl();
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
  }

  Future<void> deleteDocument(String id) async {
    final repository = ref.read(documentRepositoryProvider);
    await repository.deleteDocument(id);
    await _loadDocuments();
  }
}

final documentListProvider =
    NotifierProvider<DocumentListNotifier, List<Document>>(() {
      return DocumentListNotifier();
    });
