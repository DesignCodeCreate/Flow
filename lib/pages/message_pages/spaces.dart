// ignore_for_file: unused_local_variable

import 'package:flow/models/utils.dart';
import 'package:flutter/material.dart';
import 'package:flow/models/flow_client.dart';
import 'package:flow/pages/message_pages/message_page.dart';
import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';

class Spaces extends StatefulWidget {
  const Spaces({super.key});

  @override
  State<Spaces> createState() => _SpacesState();
}

// spaces should be a list of spaces.
// When tapped it should show a list of
// rooms that when clicked show messages -> Message_Page.

class _SpacesState extends State<Spaces> {
  @override
  void initState() {
    super.initState();
  }

  void _join(Room room) async {
    final FlowClient client = Provider.of<FlowClient>(context, listen: false);

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

  // ignore: unused_element
  void _logout() async {
    final FlowClient client = Provider.of<FlowClient>(context, listen: false);
    await client.logoutFlow(context);
  }

  String getMessageType(int i) {
    final FlowClient client = Provider.of<FlowClient>(context, listen: false);
    List<String> messageTypes = [
      "m.room.message",
      "m.room.encrypted",
    ];
    if (messageTypes.contains(client.rooms[i].lastEvent?.type)) {
      return client.rooms[i].lastEvent!.body;
    } else {
      return 'No messages';
    }
  }

  @override
  Widget build(BuildContext context) {
    late final client = Provider.of<FlowClient>(context, listen: false);

    List<Room> listOfRooms = [];
    for (int i = 0; i < client.rooms.length; i++) {
      if (client.rooms[i].isSpace) {
        listOfRooms.add(client.rooms[i]);
      }
    }

    return Scaffold(
      body: StreamBuilder(
        stream: client.onSync.stream,
        builder: (context, _) => ListView.builder(
          itemCount: listOfRooms.length,
          itemBuilder: (context, i) => ListTile(
            leading: getProfilePicture(listOfRooms[i], client),
            title: Row(
              children: [
                // ignore: deprecated_member_use
                Expanded(child: Text(listOfRooms[i].displayname)),
                if (listOfRooms[i].notificationCount > 0)
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.deepOrange.shade600,
                    child: Text(listOfRooms[i].notificationCount.toString()),
                  )
              ],
            ),
            subtitle: Text(
              getMessageType(i),
              maxLines: 1,
            ),
            onTap: () => _join(listOfRooms[i]),
          ),
        ),
      ),
    );
  }
}
