# APT Doc Scanner - Implementation Details

## Overview
APT Doc Scanner is a high-performance document scanning application built with Flutter. It focuses on a premium, non-Material user experience using Cupertino and custom components. The app integrates native scanning capabilities (ML Kit on Android, VisionKit on iOS) and provides automated cloud synchronization with Google Drive and iCloud.

## Tech Stack
- **Framework:** Flutter (Cupertino-based UI)
- **State Management:** Riverpod (Notifier & StateNotifier)
- **Persistence:** SQLite (`sqflite`) for metadata, local file system for images.
- **Scanning:** `flutter_doc_scanner` (Native Bridge)
- **Cloud Sync:** 
  - Google Drive (`googleapis`, `google_sign_in`)
  - iCloud (`icloud_storage`)
- **Routing:** `go_router`

## Architecture
The project follows **Feature-based Clean Architecture**:

- `lib/core/`: Application-wide configurations like the router.
- `lib/domain/`: 
  - `models/`: Plain data classes (e.g., `Document`).
  - `repositories/`: Abstract definitions of data operations.
- `lib/data/`:
  - `repositories/`: Concrete implementations of domain repositories.
  - `sources/`: Data source logic (API clients, Database helpers, Sync services).
- `lib/presentation/`:
  - `providers/`: Riverpod providers for business logic.
  - `screens/`: Main application pages.
  - `widgets/`: Reusable UI components.
  - `theme/`: Custom design system definitions.

## Key Files
- `lib/main.dart`: App entry point and ProviderScope setup.
- `lib/data/sources/local_db.dart`: SQLite initialization and operations.
- `lib/data/sources/sync_service.dart`: Orchestrates cloud backups.
- `lib/presentation/screens/home_screen.dart`: Primary UI for document management and scanning trigger.
- `lib/presentation/screens/profile_screen.dart`: User settings and authentication.

## Implementation Notes
- **Non-Material UI:** We explicitly avoided Material widgets to create a bespoke aesthetic. Custom scaffolds and navigation bars provide a consistent "Premium" feel across platforms.
- **Sync Logic:** Automatic synchronization is triggered immediately after a successful scan, ensuring minimal data loss.
- **Tests:** Unit tests cover model serialization and business logic in providers using `mockito`.
