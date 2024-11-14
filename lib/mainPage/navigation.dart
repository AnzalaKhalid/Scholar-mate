import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:scholar_mate/features/ai/presentation/pages/ai_screen.dart';
import 'package:scholar_mate/features/chat/presentation/pages/chat_screen.dart';
import 'package:scholar_mate/features/library/presentation/pages/library_screen.dart';
import 'package:scholar_mate/mainPage/home.dart';
import 'package:scholar_mate/mainPage/widgets/costum_appbar.dart';
import '../features/profile/presentation/pages/profile_screen.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key, });


  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _selectedIndex = 2;


  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex); // Initialize the PageController
  }

  // Method to change pages when the bottom navigation is tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(index, duration: const Duration(milliseconds: 30), curve: Curves.easeInOut);
  }

  // Method to handle swipe between pages
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose of PageController when not needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children:   <Widget>[
          ChatPage(),
          const AiScreen(),
         const HomePage(),
          const LibraryScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 1, 97, 205),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
        child: GNav(
          gap: 6,
          backgroundColor: const Color.fromARGB(255, 1, 97, 205),
          color: Colors.white,
          activeColor: Colors.black,
          tabBackgroundColor: const Color.fromARGB(255, 219, 218, 218),

          padding: const EdgeInsets.all(8),
          tabs: const [
            GButton(
              icon: Icons.chat,
              text: 'Chat',
            ),
            GButton(
              icon: Icons.computer,
              text: 'AI',
            ),
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.library_books,
              text: 'Library',
            ),
            GButton(
              icon: Icons.person,
              text: 'Profile',
            ),
          ],
          selectedIndex: _selectedIndex,
          onTabChange: _onItemTapped,
        ),
      ),
    );
  }
}
