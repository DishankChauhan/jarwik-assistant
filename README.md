# jarwik

A new Flutter project.

## Getting Started

# 🎯 Jarwik - AI Voice Assistant for Productivity

**Jarwik** is an AI-powered voice assistant mobile app built with Flutter, designed to compete with April AI. It helps professionals manage emails and calendars hands-free through voice commands.

## 📋 **MVP Feature Requirements for YC Application**

### **Phase 1: Core MVP (8-12 weeks)**
**Goal**: Launch-ready app with essential features

#### **Must-Have Features**:
1. **Voice-to-Text Email Processing**
   - Connect to Gmail/Outlook APIs
   - Voice dictation for email replies
   - Basic email summarization using AI

2. **Calendar Integration**
   - Connect to Google Calendar/Apple Calendar
   - Voice-activated event creation
   - Meeting reminder notifications

3. **Basic Authentication & Security**
   - OAuth integration (Google, Microsoft)
   - Secure token storage
   - Basic user profile management

4. **Simple Voice Interface**
   - Speech-to-text processing
   - Text-to-speech responses
   - Basic command recognition

### **Phase 2: Enhanced Features (4-6 weeks)**
**Goal**: Differentiation and user retention

#### **Advanced Features**:
1. **Smart Email Categorization**
   - AI-powered email priority scoring
   - Automatic promotional email detection
   - VIP sender identification

2. **Meeting Intelligence**
   - Auto-extract meeting locations from emails
   - Generate meeting summaries
   - Action item extraction

3. **Personal Assistant Capabilities**
   - Learn user communication patterns
   - Personalized response suggestions
   - Smart scheduling recommendations

### **Phase 3: Competitive Advantages (4-6 weeks)**
**Goal**: Unique selling propositions

#### **Differentiation Features**:
1. **Multi-Platform Support** (vs April's iOS-only)
   - Android compatibility
   - Web dashboard
   - Cross-device synchronization

2. **Team Collaboration**
   - Shared calendar management
   - Team email delegation
   - Meeting coordination

3. **Advanced Automation**
   - Custom workflow creation
   - Integration with Slack, Notion, etc.
   - Smart follow-up reminders

## 🛠 **Tech Stack**

```
Frontend: Flutter (iOS/Android)
Backend: Node.js + Express / Python FastAPI
Database: PostgreSQL + Redis (caching)
AI/ML: OpenAI GPT-4 API / Anthropic Claude
Voice: Google Speech-to-Text API / Apple Speech
Email APIs: Gmail API, Microsoft Graph API
Calendar APIs: Google Calendar API, Microsoft Graph
Cloud: AWS / Google Cloud Platform
Authentication: Firebase Auth / Auth0
```

## 🏗 **Project Architecture**

The project follows Clean Architecture principles with feature-based organization:

```
lib/
├── core/
│   ├── theme/
│   ├── router/
│   ├── constants/
│   └── utils/
├── features/
│   ├── auth/
│   ├── voice/
│   ├── email/
│   ├── calendar/
│   └── dashboard/
├── shared/
│   ├── widgets/
│   ├── models/
│   └── services/
└── main.dart
```

## 🚀 **Getting Started**

### Prerequisites
- Flutter SDK 3.32.8+
- Dart 3.8.1+
- iOS 13.0+ / Android API 21+
- Xcode 16.4+ (for iOS)

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd jarwik-mobile
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run on iOS Simulator**
   ```bash
   flutter run -d "iPhone 16 Pro Max"
   ```

4. **Run on Android Emulator**
   ```bash
   flutter run -d android
   ```

## 🔧 **Development Setup**

### Voice Permissions (iOS)
Add to `ios/Runner/Info.plist`:
```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access to process voice commands</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>This app needs speech recognition to understand voice commands</string>
```

### Firebase Setup
1. Create a Firebase project
2. Add iOS and Android apps
3. Download and add config files
4. Initialize Firebase in `main.dart`

## 📱 **Current Features**

- ✅ Beautiful splash screen with brand identity
- ✅ Voice assistant button with real-time feedback
- ✅ Speech-to-text processing
- ✅ Text-to-speech responses
- ✅ Basic AI command processing
- ✅ Modern UI/UX with dark/light theme support
- ✅ iOS 13.0+ compatibility

## 🔮 **Upcoming Features**

- [ ] Gmail API integration
- [ ] Google Calendar integration
- [ ] Firebase Authentication
- [ ] Email summarization with AI
- [ ] Smart scheduling
- [ ] Multi-language support
- [ ] Push notifications
- [ ] Analytics dashboard

## 🏆 **Competitive Analysis vs April AI**

| Feature | April AI | Jarwik | Status |
|---------|----------|---------|---------|
| Voice Commands | ✅ iOS Only | 🚧 iOS/Android | In Development |
| Email Management | ✅ Premium | 🚧 Core Feature | Planning |
| Calendar Integration | ✅ Premium | 🚧 Core Feature | Planning |
| AI Summarization | ✅ Premium | 🚧 Enhanced AI | Planning |
| Multi-Platform | ❌ iOS Only | ✅ iOS/Android/Web | Advantage |
| Team Features | ❌ Individual | ✅ Team Collaboration | Advantage |
| Pricing | $29/month | 🚧 Freemium + Premium | Planning |

## 📈 **Roadmap to YC Application**

### Month 1-2: MVP Development
- [ ] Core voice processing
- [ ] Basic email integration
- [ ] Simple calendar features
- [ ] User authentication

### Month 3: Beta Testing
- [ ] Internal testing
- [ ] User feedback integration
- [ ] Performance optimization
- [ ] Bug fixes

### Month 4: YC Application
- [ ] Demo video creation
- [ ] Pitch deck preparation
- [ ] User metrics gathering
- [ ] YC application submission

## 🧪 **Testing**

Run tests:
```bash
flutter test
```

Run widget tests:
```bash
flutter test test/widget_test.dart
```

## 📝 **License**

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 **Contributing**

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📞 **Support**

For questions and support:
- Email: support@jarwik.com
- Discord: [Join our community]
- Documentation: [docs.jarwik.com]

---

**Built with ❤️ for busy professionals who want to reclaim their time.**
