# green_snails

A Flutter recipe-sharing and e-commerce app backed by Supabase and an Express API server.

## TODO

- [ ] iOS compatibility — generate `ios/` platform folder and configure Google Sign-In
- [ ] Recipe detail page with reviews
- [ ] Market item detail page
- [ ] Image upload for recipes and market items
- [ ] Edit recipe page
- [ ] Edit profile page
- [ ] Settings page content
- [ ] Search functionality on recipes and market
- [ ] Pagination / infinite scroll on list pages
- [ ] Offline support

## Getting Started

### Prerequisites

- Flutter SDK ^3.12.2
- Android Studio or Xcode (for iOS)
- The [green_snails_server](https://github.com/mecmec98/green_snails_server) running (or deployed to Railway)

### Setup

```bash
flutter pub get
```

### Run

```bash
flutter run
```

### Build

```bash
flutter build apk --debug    # Android debug
flutter build apk --release  # Android release
```

### iOS

The `ios/` directory is not yet generated. On a Mac, run:

```bash
flutter create --platforms=ios .
```

Then configure Google Sign-In by adding `GoogleService-Info.plist` and the custom URL scheme in `Info.plist`.
