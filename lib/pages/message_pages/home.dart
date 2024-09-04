import 'package:flow/models/flow_client.dart';
import 'package:flow/pages/message_pages/message_page.dart';
import 'package:flow/pages/message_pages/rooms.dart';
import 'package:flow/pages/message_pages/spaces.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:matrix/matrix.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  final FlowClient client;
  const Home({super.key, required this.client});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void logout() async {
      widget.client.logoutFlow(context);
    }

    // ignore: unused_element
    void join(Room room) async {
      if (room.membership != Membership.join) {
        await room.join();
      }
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => MessagePage(
            room: room,
          ),
        ),
      );
    }

    final List<Widget> pages = [
      Rooms(),
      Spaces(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Chats",
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
        centerTitle: true,
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: GNav(
            onTabChange: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            tabs: [
              GButton(
                icon: Icons.message,
                text: "Messages",
              ),
              GButton(
                icon: Icons.space_dashboard,
                text: "Spaces",
              ),
            ],
            gap: 24,
            backgroundColor: Theme.of(context).colorScheme.primary,
            color: Theme.of(context).colorScheme.secondary,
            activeColor: Theme.of(context).colorScheme.inversePrimary,
            tabBackgroundColor: Theme.of(context).colorScheme.secondary,
            padding:
                const EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 22),
          ),
        ),
      ),
    );
  }
}
