// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

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
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        actions: [
          Container(
            height: MediaQuery.of(context).size.height * 0.12,
            width: MediaQuery.of(context).size.width * 1.0,
            decoration: const BoxDecoration(color:  Color.fromARGB(255, 1, 97, 205),),
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 const Row(
                    children: [
                      // Image.asset('assets/images/uotlogo.png', scale: 8),
                       Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Image(image: AssetImage("assets/logo3.png"),height: 100,width: 100,),
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
                        height: MediaQuery.of(context).size.height * 0.008,
                        width: MediaQuery.of(context).size.width * 0.25,
                        color: Colors.white,
                        
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.035,
                        width: MediaQuery.of(context).size.width * 0.3,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10))),
                        child:const Center(
                          // child: Text(
                          //   '${widget.namePage}',
                          //   style: const TextStyle(
                          //       fontWeight: FontWeight.bold,
                          //       fontSize: 20,
                          //       color: Colors.white),
                          // ),
                          child: Icon(
                            Icons.settings,
                            color: Colors.blue,
                            ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.007,
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10))),
                        child: const Text(""),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.005,
                        width: MediaQuery.of(context).size.width * 0.2,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10))),
                        child: const Text(""),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 1, 97, 205),
        toolbarHeight: MediaQuery.of(context).size.height * 0.15,
      ),
    );
  }
}
