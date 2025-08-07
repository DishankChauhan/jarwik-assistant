# Jarwik AI Voice Assistant - Copilot Instructions

<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

## Project Overview
Jarwik is an AI-powered voice assistant mobile app built with Flutter, designed to compete with April AI. It helps professionals manage emails and calendars hands-free through voice commands.

## Architecture Guidelines
- Use Clean Architecture with feature-based folder structure
- Implement Riverpod for state management
- Follow MVVM pattern for UI layer
- Use Repository pattern for data access
- Implement proper error handling and loading states

## Key Features to Implement
1. Voice-to-text email processing
2. AI-powered email summarization 
3. Calendar integration and voice commands
4. Secure authentication (OAuth2)
5. Multi-platform support (iOS/Android)
6. Real-time sync across devices

## Code Style
- Follow Flutter/Dart conventions
- Use meaningful variable and function names
- Add comprehensive documentation
- Implement proper null safety
- Use const constructors where possible

## Dependencies Focus
- speech_to_text: Voice input processing
- flutter_tts: Text-to-speech responses  
- googleapis: Email and calendar APIs
- riverpod: State management
- dio: HTTP client for API calls

## Security Considerations
- Implement secure token storage
- Use local_auth for biometric authentication
- Follow OAuth2 best practices
- Encrypt sensitive data locally
