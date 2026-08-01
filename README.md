# Recipe App (Flutter)

A Flutter application that fetches recipe data using TheMealDB API, implementing Clean Architecture (Repository Pattern), pagination, cached network images, and state management.

## Features
- API integration (TheMealDB)
- Repository Pattern
- Null-safety JSON parsing
- Loading, Error, and Empty states with Retry logic
- Pull-to-refresh & Infinite Scroll Pagination
- Image caching with `cached_network_image`

## Packages Used
- `http`: ^1.2.0
- `cached_network_image`: ^3.3.1

## Getting Started
1. Clone the repository
2. Run `flutter pub get`
3. Run `flutter run`
