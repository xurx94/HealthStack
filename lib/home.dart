import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/medicine tracker pages/hover_card.dart';
import 'profile_ui/Sliding_page.dart';
import 'app_state.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6E2EB),
      drawer: const Sliding_page(),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD6E2EB),
        shadowColor: Colors.black,
        elevation: 2,
        title: Row(
          children: [
            // Builder(
            //   builder: (context) {
            //     return IconButton(
            //       onPressed: () => Scaffold.of(context).openDrawer(),
            //       icon: const CircleAvatar(
            //         backgroundImage: AssetImage('assets/60111.jpg'),
            //         radius: 18.0,
            //       ),
            //     );
            //   },
            // ),
            const Spacer(),
            const Text(
              'Health',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                fontFamily: 'Roboto',
              ),
            ),
            const Text(
              'Stack',
              style: TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                fontFamily: 'Roboto',
              ),
            ),
            const Spacer(),
            const Image(
              image: AssetImage('assets/logo.png'),
              height: 70.0,
              width: 70.0,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Home Dashboard',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Mobile-Optimized Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
                children: [
                  // Upload Report Card
                  HoverCard(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadowColor: Colors.amberAccent,
                    onTap: () {
                      Navigator.pushNamed(context, '/upload');
                    },
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 35, // Scaled for mobile
                            backgroundColor: Color(0xFFFFF8E1),
                            child: Icon(
                              Icons.upload_file,
                              color: Colors.amber,
                              size: 32,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Upload\nReport',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Medicine Tracker Card
                  HoverCard(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadowColor: const Color.fromARGB(255, 4, 110, 8),
                    onTap: () {
                      Navigator.pushNamed(context, '/medilist');
                    },
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: Color(0xFFE8F5E9),
                            child: Icon(
                              Icons.medical_information,
                              color: Color.fromARGB(255, 4, 110, 8),
                              size: 32,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Medicine\nTracker',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // My Reports Card
                  HoverCard(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadowColor: Colors.blueAccent,
                    onTap: () {
                      Navigator.pushNamed(context, '/reports');
                    },
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: Color(0xFFE3F2FD),
                            child: Icon(
                              Icons.file_copy,
                              color: Colors.blue,
                              size: 32,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'My\nReports',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Health Stats Card
                  HoverCard(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadowColor: Colors.redAccent,
                    onTap: () {
                      Navigator.pushNamed(context, '/status');
                    },
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: Color(0xFFFFEBEE),
                            child: Icon(
                              Icons.auto_graph,
                              color: Colors.red,
                              size: 32,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'My Health\nStats',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // --- NEW: Doctor Visit Card ---
                  HoverCard(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadowColor: Colors.deepPurpleAccent,
                    onTap: () {
                      // Check the database: Do we already have an active visit?
                      final appState = context.read<AppState>();
                      if (appState.hasActiveVisit) {
                        Navigator.pushNamed(
                          context,
                          '/visit_summary',
                        ); // Go straight to the final list
                      } else {
                        Navigator.pushNamed(
                          context,
                          '/doctor_visit',
                        ); // Go to the checkbox form
                      }
                    },
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: Color(0xFFEDE7F6), // Light purple
                            child: Icon(
                              Icons.assignment_ind,
                              color: Colors.deepPurple,
                              size: 32,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Doctor\nVisit',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  HoverCard(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadowColor: const Color.fromARGB(255, 152, 9, 9),
                    onTap: () {
                      Navigator.pushNamed(context, '/symptoms');
                    },
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: Color(0xFFFFEBEE),
                            child: Icon(
                              Icons.sick,
                              color: Color.fromARGB(255, 150, 39, 2),
                              size: 32,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'My Symptoms',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
