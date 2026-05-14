import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'data/models/task_model.dart';
import 'data/models/topic_model.dart';
import 'data/models/daily_log_model.dart';
import 'data/models/achievement_model.dart';
import 'data/models/dsa_problem_model.dart';
import 'providers/theme_provider.dart';
import 'providers/task_provider.dart';
import 'providers/topic_provider.dart';
import 'providers/dsa_provider.dart';
import 'providers/achievement_provider.dart';
import 'features/splash/splash_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(TopicModelAdapter());
  Hive.registerAdapter(DailyLogModelAdapter());
  Hive.registerAdapter(AchievementModelAdapter());
  Hive.registerAdapter(DsaProblemModelAdapter());

  // Set system UI
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF121828),
    ),
  );

  runApp(const ProviderScope(child: CodeClimbApp()));
}

class CodeClimbApp extends ConsumerStatefulWidget {
  const CodeClimbApp({super.key});

  @override
  ConsumerState<CodeClimbApp> createState() => _CodeClimbAppState();
}

class _CodeClimbAppState extends ConsumerState<CodeClimbApp> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final taskNotifier = ref.read(taskProvider);
    final topicNotifier = ref.read(topicProvider);
    final dsaNotifier = ref.read(dsaProvider);
    final achievementNotifier = ref.read(achievementProvider);

    await taskNotifier.loadTasks();
    await topicNotifier.loadTopics();
    await dsaNotifier.loadProblems();
    await achievementNotifier.loadAchievements();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);

    return MaterialApp(
      title: 'CodeClimb',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeState.themeMode,
      home: _buildHome(themeState),
    );
  }

  Widget _buildHome(ThemeNotifier themeState) {
    if (_showSplash) {
      return SplashScreen(
        onComplete: () {
          setState(() => _showSplash = false);
        },
      );
    }

    if (!themeState.hasSeenOnboarding) {
      return OnboardingScreen(
        onComplete: () {
          ref.read(themeProvider).completeOnboarding();
        },
      );
    }

    return const AppShell();
  }
}
