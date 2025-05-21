# BlindID Movie App

A SwiftUI-based iOS application that allows users to browse movies, manage favorites, and maintain their profile.

## Features

- User Authentication (Login/Register)
- Movie Browsing with Grid Layout
- Favorite Movies Management
- User Profile Management
- Responsive Design

## Technical Stack

- SwiftUI
- MVVM Architecture
- Async/Await for Network Calls
- UserDefaults for Token Management
- IQKeyboardManager for Keyboard Handling

## Requirements

- iOS 17.6+
- Xcode 16.1+
- Swift 5.0+

## Network Layer

The app follows a clean architecture pattern for network operations:

![networkFlow](https://github.com/user-attachments/assets/0f0bd931-0341-426e-948f-3e61d261424b)

- **ViewModel**: Handles the UI logic and state management
- **SearchService**: Manages movie search and listing operations
- **ProxyService**: Base service layer that handles HTTP communications
- **Auth Manager**: Manages authentication state and token handling
- **Auth Service**: Handles authentication operations
- **Base API**: Provides common API functionality and configurations

## Dependencies

- [IQKeyboardManager](https://github.com/hackiftekhar/IQKeyboardManager) - For handling keyboard interactions

## API Endpoints

The app communicates with the following endpoints:

- Authentication: `/api/auth/login`, `/api/auth/register`
- Movies: `/api/movies`, `/api/movies/{id}`
- User: `/api/users/profile`, `/api/users/liked-movies`

## Features in Detail

### Authentication
- Login with email and password
- Register new account

### Movies
- Browse all movies in a grid layout
- View movie details
- Like/Unlike movies
- View favorite movies list

### Profile
- View user profile
- Update profile information
- Manage account settings 
