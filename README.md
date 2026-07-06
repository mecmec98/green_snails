# green_snails

A Flutter recipe-sharing and e-commerce app backed by Supabase and an Express API server.

## Progress

### Authentication
- [x] Email/password login
- [x] Google OAuth sign-in
- [x] "Remember me" persistence
- [x] Auth state listener / auto-redirect
- [ ] Sign-up page (provider supports it, no UI)

### Home Dashboard
- [x] Auto-scrolling banner carousel
- [x] Navigation cards (Recipes, Market)
- [x] Shopping list FAB with bottom sheet

### Recipes
- [x] Browse public recipes list
- [x] Recipe detail page (ingredients, instructions, categories, reviews)
- [x] My Recipes grid with category filter chips
- [x] Create recipe form (dynamic ingredients/instructions, category multi-select, public toggle)
- [x] Recipe reviews (view + add rating/comment)
- [x] Favorite toggle
- [ ] Edit recipe page (service/provider support exists)
- [ ] Delete recipe (service/provider support exists)
- [ ] Search recipes (service/provider support exists)
- [ ] Pagination / infinite scroll (service/provider support exists)
- [ ] Image upload for recipes

### Market
- [x] Browse market items list
- [ ] Market item detail page
- [ ] Create market item (service/provider support exists)
- [ ] Edit/delete market item (service/provider support exists)
- [ ] Search market (service/provider support exists)
- [ ] Pagination / infinite scroll (service/provider support exists)
- [ ] Image upload for market items

### My Store
- [x] List user's own store items
- [x] Create store item
- [ ] Edit/delete store item (service/provider support exists)
- [ ] Image upload for store items

### Profile
- [x] View display name, email, avatar
- [ ] Edit profile page (service/provider support exists)

### Settings
- [ ] Settings page content (placeholder only)

### Platform
- [ ] iOS compatibility — generate `ios/` platform folder and configure Google Sign-In
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
