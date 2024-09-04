// ignore_for_file: deprecated_member_use, unused_local_variable

import 'package:flow/models/flow_client.dart';
import 'package:flow/models/utils.dart';
import 'package:flow/pages/message_pages/message_page.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';

class Rooms extends StatefulWidget {
  const Rooms({Key? key}) : super(key: key);

  @override
  _RoomsState createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
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

  String getMessageType(Room room) {
    List<String> messageTypes = [
      "m.room.message",
      "m.room.encrypted",
    ];
    if (messageTypes.contains(room.lastEvent?.type)) {
      return room.lastEvent!.body;
    } else {
      return 'No messages';
    }
  }

  @override
  Widget build(BuildContext context) {
    late final client = Provider.of<FlowClient>(context, listen: false);

    List<Room> listOfRooms = [];
    for (int i = 0; i < client.rooms.length; i++) {
      if (!client.rooms[i].isSpace) {
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
              getMessageType(listOfRooms[i]),
              maxLines: 1,
            ),
            onTap: () => _join(listOfRooms[i]),
          ),
        ),
      ),
    );
  }
}
