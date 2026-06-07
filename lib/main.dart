import 'package:flutter/material.dart';
import 'app.dart';
import 'core/config/environment.dart';

void main() async {
  // 1. Ensure bindings are initialized for async setup
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize environment configuration (set to dev by default)
  EnvironmentConfig.init(env: Environment.dev);

  // 3. Initialize any other pre-run dependencies here (e.g., Firebase, Hive)

  // 4. Run the application
  runApp(const VangoLiveAdminApp());
}
