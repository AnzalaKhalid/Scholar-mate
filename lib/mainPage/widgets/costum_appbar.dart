// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:scholar_mate/features/setting/pages/settings.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  String? namePage;
  MyAppBar({super.key, this.namePage});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 65.5);

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    double appBarHeight = MediaQuery.of(context).size.height * 0.15;

    return PreferredSize(
      preferredSize: Size.fromHeight(appBarHeight),
      child: AppBar(
        actions: [
          Container(
            height: appBarHeight * 0.8, // Adjust height for the action container
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 1, 97, 205),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side (Logo)
                  Row(
                    children: [
                      
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [

                          Padding(

                            padding: const EdgeInsets.only(left: 20),
                            child: Image.asset(
                              "assets/logo3.png",
                              height: appBarHeight * 0.8, // Responsive height
                              width: appBarHeight * 0.8, // Responsive width
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      
                      Container(
                        height: appBarHeight * 0.03, 
                        width: MediaQuery.of(context).size.width * 0.25,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 3),
                      
                      Container(
                        height: appBarHeight * 0.2, 
                        width: MediaQuery.of(context).size.width * 0.3,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child:  Center(
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>const SettingsPage()));
                            },
                            child:const Icon(
                              Icons.menu,
                              color: Color.fromARGB(255, 1, 97, 205),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      
                      Container(
                        height: appBarHeight * 0.03, 
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: const Text(""),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        height: appBarHeight * 0.02, 
                        width: MediaQuery.of(context).size.width * 0.2,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: const Text(""),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 1, 97, 205),
        toolbarHeight: appBarHeight,
      ),
    );
  }
}
