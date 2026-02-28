import 'package:flutter_test/flutter_test.dart';
import 'package:apt_doc_scanner/domain/models/document.dart';
import 'package:apt_doc_scanner/presentation/providers/document_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:apt_doc_scanner/domain/repositories/document_repository.dart';
import 'package:apt_doc_scanner/data/sources/sync_service.dart';

@GenerateMocks([DocumentRepository, SyncService])
import 'document_scanner_test.mocks.dart';

void main() {
  group('Document Model Tests', () {
    test('should convert to and from map correctly', () {
      final now = DateTime.now();
      final doc = Document(
        id: '1',
        name: 'Test Doc',
        imagePaths: ['path/1', 'path/2'],
        createdAt: now,
        isSynced: true,
        googleDriveId: 'drive_123',
      );

      final map = doc.toMap();
      expect(map['id'], '1');
      expect(map['name'], 'Test Doc');
      expect(map['imagePaths'], 'path/1,path/2');
      expect(map['isSynced'], 1);

      final fromMap = Document.fromMap(map);
      expect(fromMap.id, '1');
      expect(fromMap.name, 'Test Doc');
      expect(fromMap.imagePaths, ['path/1', 'path/2']);
      expect(fromMap.isSynced, true);
      expect(fromMap.googleDriveId, 'drive_123');
    });
  });

  group('DocumentListNotifier Tests', () {
    late MockDocumentRepository mockRepo;
    late MockSyncService mockSync;
    late ProviderContainer container;

    setUp(() {
      mockRepo = MockDocumentRepository();
      mockSync = MockSyncService();

      when(mockRepo.getAllDocuments()).thenAnswer((_) async => []);

      container = ProviderContainer(
        overrides: [
          documentRepositoryProvider.overrideWithValue(mockRepo),
          syncServiceProvider.overrideWithValue(mockSync),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state should be empty list', () async {
      expect(container.read(documentListProvider), []);
    });

    test('addDocument should call repository and update state', () async {
      final imagePaths = ['path/1'];
      final name = 'New Doc';

      when(mockRepo.saveDocument(any)).thenAnswer((_) async => {});
      when(mockRepo.getAllDocuments()).thenAnswer(
        (_) async => [
          Document(
            id: 'uuid',
            name: name,
            imagePaths: imagePaths,
            createdAt: DateTime.now(),
          ),
        ],
      );
      when(mockSync.syncDocument(any, any)).thenAnswer((_) async => null);

      await container
          .read(documentListProvider.notifier)
          .addDocument(name, imagePaths);

      verify(mockRepo.saveDocument(any)).called(1);
      expect(container.read(documentListProvider).length, 1);
      expect(container.read(documentListProvider).first.name, name);
    });
  });
}
