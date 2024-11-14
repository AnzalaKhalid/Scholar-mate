import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacySection extends StatefulWidget {
  final String title;
  final String content;
  final String? email;

  const PrivacySection({super.key, 
    required this.title,
    required this.content,
    this.email,
  });

  @override
  _PrivacySectionState createState() => _PrivacySectionState();
}

class _PrivacySectionState extends State<PrivacySection> {
  bool isExpanded = false;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    userEmail = FirebaseAuth.instance.currentUser?.email; // Retrieve user's email at init
  }

  void _launchEmail(String recipientEmail) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: recipientEmail,
      queryParameters: {
        'from': userEmail ?? '', // Use the user's email as the sender
        'subject': 'Inquiry about Privacy Policy'
      },
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: Icon(
            isExpanded ? Icons.expand_less : Icons.expand_more,
            color: Colors.grey,
          ),
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 15, color: Colors.black54),
                children: [
                  TextSpan(text: widget.content),
                  if (widget.email != null)
                    TextSpan(
                      text: widget.email,
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _launchEmail(widget.email!),
                    ),
                ],
              ),
            ),
          ),
        const Divider(),
      ],
    );
  }
}
