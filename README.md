# 💅 Nail Store - Beautiful Nail Art Ideas

> A modern Flutter web application for discovering, saving, and sharing stunning nail art designs.

## ✨ Features

### 🎨 Design Discovery
- **Extensive Collection**: Browse thousands of nail art designs from Unsplash
- **Smart Categories**: French, Plain, Nail Art, Ombre, Glitter, Pastel, Wedding, Holiday
- **Advanced Search**: Filter by categories, colors, and popularity
- **Featured & Trending**: Discover popular and highly-rated designs

### 👤 User Experience
- **User Authentication**: Secure login/signup with persistent sessions
- **"Keep Me Signed In"**: Stay logged in across browser sessions
- **Personal Favorites**: Save and organize your favorite designs
- **User Uploads**: Upload and share your own nail art creations
- **Profile Management**: Edit profile information and track statistics

### 🚀 Modern UI/UX
- **Responsive Design**: Works perfectly on all screen sizes
- **Material Design 3**: Beautiful, modern interface with gradient themes
- **Smooth Animations**: Engaging transitions and interactions
- **Skeleton Loading**: Elegant loading states for better UX
- **Pull to Refresh**: Intuitive gesture-based refresh

### 🔧 Technical Features
- **State Management**: Provider pattern for reactive state
- **Offline Support**: Local storage for favorites and user data
- **Image Caching**: Optimized image loading with caching
- **PWA Ready**: Progressive Web App capabilities
- **Cross-platform**: Flutter web with mobile-ready architecture

## 🏗️ Architecture

### Tech Stack
- **Framework**: Flutter 3.x (Web)
- **State Management**: Provider
- **UI Components**: Material Design 3
- **Image Handling**: Cached Network Image
- **Local Storage**: SharedPreferences
- **API Integration**: Unsplash API
- **Typography**: Google Fonts (Poppins)

### Project Structure
```
lib/
├── models/           # Data models (User, NailDesign, etc.)
├── providers/        # State management (UserProvider, NailProvider)
├── screens/          # UI screens (HomeScreen, ProfileScreen, etc.)
├── services/         # API services (UnsplashService)
├── utils/            # Constants and utilities
└── widgets/          # Reusable UI components
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK (3.0+)
- Web browser (Chrome, Firefox, Safari)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://git.mulk.net/senaguventurk/nailStore.git
   cd nailStore
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run -d web-server --web-port 8080
   ```

4. **Build for production**
   ```bash
   flutter build web --web-renderer html
   ```

### Development Server
```bash
# Start development server
flutter run -d chrome --web-port 8080

# Build and serve locally
flutter build web
python3 -m http.server 8000 --directory build/web
```

## 💡 Usage

### Getting Started
1. **Sign Up/Login**: Create an account or login with existing credentials
2. **Browse Designs**: Explore nail art designs by category or search
3. **Save Favorites**: Heart designs you love to save them to your favorites
4. **Upload Your Own**: Share your nail art creations with the community
5. **Manage Profile**: Update your profile and track your statistics

### Key Features Demo

#### Authentication with Persistence
- ✅ **"Keep me signed in"** checkbox on login
- 🔄 **Auto-login** on browser restart
- 🔐 **Secure session management**

#### Advanced Search
- 🔍 Search by keywords, categories, or colors
- 📊 Sort by popularity, date, or alphabetically
- 🎯 Filter by multiple criteria simultaneously

#### User Uploads
- 📸 Upload your own nail art photos
- 🏷️ Add titles, descriptions, and categories
- 🎨 Tag with color information

## 🔧 Recent Improvements

### Authentication Persistence (Latest)
- **Problem Solved**: Users no longer need to sign up repeatedly
- **"Keep Me Signed In"**: Optional persistent login across browser sessions
- **Enhanced UX**: Remember user preferences and data
- **Error Recovery**: Robust session management with fallback mechanisms

### Performance Optimizations
- **Image Caching**: Reduced load times with intelligent caching
- **Lazy Loading**: Efficient memory usage with on-demand loading
- **Optimized Builds**: Tree-shaking and asset optimization

## 🎯 Roadmap

### Upcoming Features
- [ ] **Social Features**: Follow other users, comments, and likes
- [ ] **AI Integration**: AI-powered design recommendations
- [ ] **Mobile App**: Native iOS and Android applications
- [ ] **Push Notifications**: Real-time updates and reminders
- [ ] **Advanced Editor**: In-app design creation tools

### Technical Improvements
- [ ] **Dark Mode**: Complete dark theme implementation
- [ ] **Accessibility**: Enhanced screen reader and keyboard support
- [ ] **Performance**: Further optimization for large datasets
- [ ] **Testing**: Comprehensive unit and integration tests

## 🤝 Contributing

We welcome contributions! Here's how you can help:

### Development Setup
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes and test thoroughly
4. Commit your changes: `git commit -m 'Add amazing feature'`
5. Push to the branch: `git push origin feature/amazing-feature`
6. Submit a pull request

### Code Style
- Follow [Flutter style guide](https://docs.flutter.dev/development/tools/formatting)
- Use meaningful variable and function names
- Add comments for complex logic
- Ensure responsive design principles

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Unsplash API**: For providing beautiful nail art images
- **Flutter Community**: For excellent packages and resources
- **Material Design**: For design system inspiration
- **Google Fonts**: For beautiful typography

## 📞 Support

For questions, issues, or suggestions:
- 🐛 **Bug Reports**: Create an issue on GitLab
- 💬 **Discussions**: Use GitLab discussions for questions
- 📧 **Email**: Contact the development team

---

**Built with ❤️ using Flutter | Designed for beauty and performance**
