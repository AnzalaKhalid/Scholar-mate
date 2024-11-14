// privacy_policy_page.dart
import 'package:flutter/material.dart';
import 'package:scholar_mate/features/setting/widgets/privacySection.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
        backgroundColor: const Color.fromARGB(255, 1, 97, 205),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            PrivacySection(
              title: "Introduction",
              content: "This app values your privacy and is committed to protecting your data. "
                  "This privacy policy explains what data we collect and how we use it.",
            ),
            PrivacySection(
              title: "Data Collection",
              content: "We collect data such as your personal information (name, email), usage "
                  "data (pages accessed, time spent), and device information (IP address). "
                  "This helps us personalize and improve your experience.",
            ),
            PrivacySection(
              title: "Data Usage",
              content: "Your data is used for account management, providing notifications, and "
                  "enhancing the app experience. We may also use data for app analytics.",
            ),
            PrivacySection(
              title: "Data Sharing",
              content: "Your data is never sold. We only share data with third parties when "
                  "necessary, such as with analytics providers, to improve app performance.",
            ),
            PrivacySection(
              title: "Data Security",
              content: "We employ encryption, secure storage, and access control to protect "
                  "your data from unauthorized access.",
            ),
            PrivacySection(
              title: "User Rights",
              content: "You have the right to access, correct, and delete your data. Contact us "
                  "to exercise these rights or if you have any questions.",
            ),
            PrivacySection(
              title: "Policy Changes",
              content: "We may update this privacy policy over time. You will be notified of "
                  "significant changes to the policy.",
            ),
            PrivacySection(
              title: "Contact Information",
              content: "If you have questions or concerns, please contact us at ",
              email: "scholarmate4@gmail.com", // Pass the email here
            ),
          ],
        ),
      ),
    );
  }
}
