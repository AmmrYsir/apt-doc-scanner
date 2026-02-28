import '../../domain/models/document.dart';

abstract class DocumentRepository {
  Future<List<Document>> getAllDocuments();
  Future<void> saveDocument(Document document);
  Future<void> deleteDocument(String id);
  Future<void> updateDocument(Document document);
}
