import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:local_loop/dashboards/admin/admin_dashboard.dart';
import 'package:local_loop/dashboards/admin/analytics_screen.dart';
import 'package:local_loop/dashboards/admin/manage_events_screen.dart';
import 'package:local_loop/dashboards/admin/manage_users_screen.dart';
import 'package:local_loop/dashboards/admin/settings_screen.dart';
import 'package:local_loop/dashboards/admin/verify_ngos_screen.dart';
import 'package:local_loop/dashboards/ngo/attendance/select_event_screen.dart';
import 'package:local_loop/dashboards/ngo/create_event_screen.dart';
import 'package:local_loop/dashboards/ngo/manage_own_events.dart';
import 'package:local_loop/dashboards/ngo/manage_volunteer_screen.dart';
import 'package:local_loop/dashboards/ngo/ngo_dashbaord.dart';
import 'package:local_loop/dashboards/ngo/profile_screen.dart';
import 'package:local_loop/dashboards/ngo/profile_view_screen.dart';
import 'package:local_loop/dashboards/volunteer/certificates_screen.dart';
import 'package:local_loop/dashboards/volunteer/discover_events_screen.dart';
import 'package:local_loop/dashboards/volunteer/edit_volunteer_profile.dart';
import 'package:local_loop/dashboards/volunteer/my_feedback_screen.dart';
import 'package:local_loop/dashboards/volunteer/view_feedback_screen.dart';
import 'package:local_loop/dashboards/volunteer/volunteer_dashboard.dart';
import 'package:local_loop/dashboards/volunteer/volunteer_profile_badges_screen.dart';
import 'firebase_options.dart';
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/admin_dashboard': (context) => const AdminDashboard(),
        '/admin/manage-users': (context) => const ManageUsersScreen(),
        '/admin/analytics': (context) => const AnalyticsScreen(),
        '/admin/settings': (context) => const SettingsScreen(),
        '/admin/verify-ngos': (context) => const VerifyNgosScreen(),
        '/admin/manage-events': (context) => const ManageEventsScreen(),
        '/ngo_dashboard': (context) => const NgoDashboard(),
        '/ngo/create-event': (context) => const CreateEventScreen(),
        '/ngo/manage-events': (context) => const ManageOwnEventsScreen(),
        '/ngo/profile': (context) => const NgoProfileScreen(),
        '/ngo/view-profile': (context) => const ProfileViewScreen(),
        '/ngo/manage-volunteers': (context) => const ManageVolunteersScreen(),
        '/ngo/attendance/select-event': (context) => const SelectEventScreen(),
        '/volunteer_dashboard': (context) => const VolunteerDashboard(),
        '/volunteer/discover-events': (context) => const DiscoverEventsScreen(),
        '/volunteer/profile': (context) => const VolunteerProfileScreen(),
        '/volunteer/edit-profile': (context) => const EditVolunteerProfile(),
        '/volunteer/certificates': (context) => const CertificatesScreen(),
        '/volunteer/feedback': (context) => const FeedbackScreen(),
        '/volunteer/myfeedback': (context) => const MyFeedbackScreen(),
        





        












      },
    );
  }
}
