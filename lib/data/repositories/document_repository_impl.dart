import '../../domain/models/document.dart';
import '../../domain/repositories/document_repository.dart';
import '../sources/local_db.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  final LocalDatabase _localDB = LocalDatabase.instance;

  @override
  Future<List<Document>> getAllDocuments() async {
    final maps = await _localDB.queryAllDocuments();
    return maps.map((map) => Document.fromMap(map)).toList();
  }

  @override
  Future<void> saveDocument(Document document) async {
    await _localDB.insertDocument(document.toMap());
  }

  @override
  Future<void> deleteDocument(String id) async {
    await _localDB.deleteDocument(id);
  }

  @override
  Future<void> updateDocument(Document document) async {
    await _localDB.updateDocument(document.toMap());
  }
}
