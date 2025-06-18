Problem Statement for Mobile Project
There is currently no centralized, easily available, and real-time mobile platform that effectively links
volunteers, non-profit organizations (NGOs), and local community leaders, despite the increased interest
in community service and volunteering among adolescents and students. Finding activities that fit their
interests, availability, or geography is a challenge for many prospective volunteers, particularly students.
At the same time, NGOs and event planners struggle to find trustworthy volunteers, monitor participation,
and handle criticism.
This disparity has led to
● Volunteering options in local communities are not well-known.
● Ineffective communication and coordination between volunteers and organizers.
● Absence of responsibility and organized data monitoring for event results, participant
responsibilities, or hours worked.
● Young people are not given enough credit or encouragement to actively engage in social good.
● security issues brought on by unconfirmed users or ambiguous roles in events.
Proposed Solution
To address this problem, IST students will develop LocalLoop, a role-based Flutter mobile application
with a Firebase backend, aimed at bridging the gap between volunteers and community organizers
through a real-time, smart, and inclusive platform.
The app will support the following user roles:
1. Admin
➢ Manage user accounts and permissions
➢ Moderate content and verify NGO/event organizers
➢ Monitor analytics and engagement stats
2. Organization/NGO
Create and manage volunteer opportunities
❖ View volunteer profiles and assign roles
❖
❖ Track attendance and hours served
❖
❖ Post event reports and updates
3. Volunteer/User
Discover and register for nearby events
Build a volunteering profile with badges
Track hours and receive digital certificates
Rate experiences and give feedback
Key Features to Be Implemented
➔ Role-based authentication and access control (Firebase Authentication + Firestore rules)
➔ Location-aware event discovery
➔ Real-time notifications and reminders
➔ Volunteer dashboard with service hours and stats
➔ Event participation tracking with check-in/check-out
➔ Feedback and review system for each event
➔ Certificate generation for completed volunteering
➔ Admin dashboard (mobile/tablet optimized)
Technology Stack
Frontend:
❖ Flutter (for cross-platform mobile development)
❖ Material 3 for sleek UI design
❖ Provider/Riverpod for state management or any other state management mechanism
Backend:
❖ Firebase Authentication (email, Google sign-in)
❖ Cloud Firestore
❖ Firebase Cloud Functions
❖ Firebase Storage
❖ Firebase Messaging (push notifications)
