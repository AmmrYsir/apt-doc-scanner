class Document {
  final String id;
  final String name;
  final List<String> imagePaths;
  final DateTime createdAt;
  final bool isSynced;
  final String? googleDriveId;
  final String? iCloudId;

  Document({
    required this.id,
    required this.name,
    required this.imagePaths,
    required this.createdAt,
    this.isSynced = false,
    this.googleDriveId,
    this.iCloudId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imagePaths': imagePaths.join(','),
      'createdAt': createdAt.toIso8601String(),
      'isSynced': isSynced ? 1 : 0,
      'googleDriveId': googleDriveId,
      'iCloudId': iCloudId,
    };
  }

  factory Document.fromMap(Map<String, dynamic> map) {
    return Document(
      id: map['id'],
      name: map['name'],
      imagePaths: (map['imagePaths'] as String).split(','),
      createdAt: DateTime.parse(map['createdAt']),
      isSynced: map['isSynced'] == 1,
      googleDriveId: map['googleDriveId'],
      iCloudId: map['iCloudId'],
    );
  }
}
