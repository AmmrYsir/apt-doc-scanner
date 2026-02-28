# Implementation Plan: APT Doc Scanner

## Journal
- **2026-02-28**: Initialized Phase 1. Updated `pubspec.yaml` to remove Material Design and set version to 0.1.0. Replaced boilerplate `lib/main.dart` with a minimal `CupertinoApp`. Updated `README.md` and created `CHANGELOG.md`. Ran `dart format` and `analyze_files` - no issues found.

## Phase 1: Initial Setup
- [x] Create a Flutter package in the package directory. (Project already exists, but we will ensure structure is correct).
- [x] Remove any boilerplate in the new package that will be replaced, including the test dir, if any.
- [x] Update the description of the package in the `pubspec.yaml` and set the version number to 0.1.0.
- [x] Update the README.md to include a short placeholder description of the package.
- [x] Create the CHANGELOG.md to have the initial version of 0.1.0.
- [x] Commit this empty version of the package to the `feature/doc-scanner-init` branch.
- [x] After committing the change, start running the app with the launch_app tool on the user's preferred device.

**Post-Phase Tasks:**
- [ ] Create/modify unit tests for testing the code added or modified in this phase, if relevant.
- [ ] Run the dart_fix tool to clean up the code.
- [ ] Run the analyze_files tool one more time and fix any issues.
- [ ] Run any tests to make sure they all pass.
- [ ] Run dart_format to make sure that the formatting is correct.
- [ ] Re-read the IMPLEMENTATION.md file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
- [ ] Update the IMPLEMENTATION.md file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
- [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
- [ ] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
- [ ] After commiting the change, if the app is running, use the hot_reload tool to reload it.

## Phase 2: Core Architecture & Custom Design System
- [ ] Add base dependencies to `pubspec.yaml` (e.g., `flutter_doc_scanner`, `google_sign_in`, `googleapis`, `path_provider`, `sqflite`, `animations`, `go_router`, `flutter_riverpod` or `provider`).
- [ ] Set up the folder structure (`lib/presentation`, `lib/domain`, `lib/data`, `lib/core`).
- [ ] Implement a **Custom Design System**:
    - Define a `AppColors` class with custom HEX values (no Material palettes).
    - Define a `AppTextStyles` class for consistent typography.
    - Create base custom layout components (e.g., `AppScaffold`, `AppNavigationBar`) using `Cupertino` and `Stack`/`Container`.
- [ ] Create routing setup using `go_router` with `CupertinoPage` transitions.

**Post-Phase Tasks:** (Same as Phase 1)

## Phase 3: Document Scanner Integration
- [ ] Implement the `ScannerRepository` in the data layer using `flutter_doc_scanner`.
- [ ] Create the Document model class to hold metadata (file path, scan date, sync status).
- [ ] Build the UI to trigger the scanner and display the resulting images/PDFs in a modern grid or list using animations.

**Post-Phase Tasks:** (Same as Phase 1)

## Phase 4: Local Storage & Data Management
- [ ] Set up local SQLite database using `sqflite` to store document metadata.
- [ ] Create `LocalDatabaseRepository` to handle CRUD operations for documents.
- [ ] Connect the Scanner UI to save documents locally immediately after scanning.

**Post-Phase Tasks:** (Same as Phase 1)

## Phase 5: Cloud Synchronization (Google Drive & iCloud)
- [ ] Implement `GoogleAuthClient` and Drive API integration for Google Drive sync.
- [ ] Investigate and implement basic iCloud synchronization for iOS users (using packages like `icloud_storage`).
- [ ] Create a `SyncService` that monitors local changes and pushes them to the appropriate cloud provider based on user settings/platform.

**Post-Phase Tasks:** (Same as Phase 1)

## Phase 6: Profile & Settings UI
- [ ] Create the Profile Page UI.
- [ ] Add settings for Cloud Sync (Toggle Google Drive / iCloud, Auto-sync options).
- [ ] Implement User Authentication UI (Google Sign-In button).
- [ ] Add smooth transitions between the main scanner view and the profile view.

**Post-Phase Tasks:** (Same as Phase 1)

## Phase 7: Final Polish & Documentation
- [ ] Create a comprehensive README.md file for the package.
- [ ] Create a GEMINI.md file in the project directory that describes the app, its purpose, and implementation details of the application and the layout of the files.
- [ ] Ask the user to inspect the app and the code and say if they are satisfied with it, or if any modifications are needed.

*Note: After completing a task, if you added any TODOs to the code or didn't fully implement anything, make sure to add new tasks so that you can come back and complete them later.*
