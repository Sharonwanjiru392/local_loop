import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'theme_provider.dart';

// ── auth
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';

// ── admin
import 'package:local_loop/dashboards/admin/admin_dashboard.dart';
import 'package:local_loop/dashboards/admin/analytics_screen.dart';
import 'package:local_loop/dashboards/admin/manage_events_screen.dart';
import 'package:local_loop/dashboards/admin/manage_users_screen.dart';
import 'package:local_loop/dashboards/admin/settings_screen.dart';
import 'package:local_loop/dashboards/admin/verify_ngos_screen.dart';

// ── NGO
import 'package:local_loop/dashboards/ngo/attendance/select_event_screen.dart';
import 'package:local_loop/dashboards/ngo/create_event_screen.dart';
import 'package:local_loop/dashboards/ngo/manage_own_events.dart';
import 'package:local_loop/dashboards/ngo/manage_volunteer_screen.dart';
import 'package:local_loop/dashboards/ngo/ngo_dashbaord.dart';
import 'package:local_loop/dashboards/ngo/profile_screen.dart';
import 'package:local_loop/dashboards/ngo/profile_view_screen.dart';

// ── Volunteer
import 'package:local_loop/dashboards/volunteer/certificates_screen.dart';
import 'package:local_loop/dashboards/volunteer/discover_events_screen.dart';
import 'package:local_loop/dashboards/volunteer/edit_volunteer_profile.dart';
import 'package:local_loop/dashboards/volunteer/my_feedback_screen.dart';
import 'package:local_loop/dashboards/volunteer/view_feedback_screen.dart';
import 'package:local_loop/dashboards/volunteer/volunteer_dashboard.dart';
import 'package:local_loop/dashboards/volunteer/volunteer_profile_badges_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProv = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeProv.themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF5B2C6F),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF5B2C6F),
        brightness: Brightness.dark,
      ),

      // ── ROUTES
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),

        // admin
        '/admin_dashboard': (_) => const AdminDashboard(),
        '/admin/manage-users': (_) => const ManageUsersScreen(),
        '/admin/analytics': (_) => const AnalyticsScreen(),
        '/admin/settings': (_) => const SettingsScreen(),
        '/admin/verify-ngos': (_) => const VerifyNgosScreen(),
        '/admin/manage-events': (_) => const ManageEventsScreen(),

        // NGO
        '/ngo_dashboard': (_) => const NgoDashboard(),
        '/ngo/create-event': (_) => const CreateEventScreen(),
        '/ngo/manage-events': (_) => const ManageOwnEventsScreen(),
        '/ngo/profile': (_) => const NgoProfileScreen(),
        '/ngo/view-profile': (_) => const ProfileViewScreen(),
        '/ngo/manage-volunteers': (_) => const ManageVolunteersScreen(),
        '/ngo/attendance/select-event': (_) => const SelectEventScreen(),

        // volunteer
        '/volunteer_dashboard': (_) => const VolunteerDashboard(),
        '/volunteer/discover-events': (_) => const DiscoverEventsScreen(),
        '/volunteer/profile': (_) => const VolunteerProfileScreen(),
        '/volunteer/edit-profile': (_) => const EditVolunteerProfile(),
        '/volunteer/certificates': (_) => const CertificatesScreen(),
        '/volunteer/feedback': (_) => const FeedbackScreen(),
        '/volunteer/myfeedback': (_) => const MyFeedbackScreen(),
      },
    );
  }
}
