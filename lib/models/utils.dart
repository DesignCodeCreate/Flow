import 'package:flow/models/flow_client.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

Widget getProfilePicture(Room room, FlowClient client) {
  int hash = 0;
  for (String char in room.id.split("")) {
    hash = char.codeUnitAt(0) + ((hash << 5) - hash);
  }
  if (room.avatar == null) {
    return CircleAvatar(
      backgroundColor: Color(hash),
      child: Text(room.name.length >= 1
          ? (room.name[0] != "#" ? room.name[0] : room.name[1].toUpperCase())
          : ""),
    );
  } else {
    return CircleAvatar(
      foregroundImage: room.avatar == null
          ? null
          : NetworkImage(room.avatar!
              // ignore: deprecated_member_use
              .getThumbnail(
                client,
                width: 56,
                height: 56,
              )
              .toString()),
    );
  }
}

Widget getProfilePicturePerson(User user, FlowClient client) {
  if (user.avatarUrl == null) {
    int hash = 0;
    for (String char in user.calcDisplayname().split("")) {
      hash = char.codeUnitAt(0) + ((hash << 5) - hash);
    }
    return CircleAvatar(
      backgroundColor: Color(hash),
      child: Text(user.calcDisplayname()[0].toUpperCase()),
    );
  } else {
    return CircleAvatar(
      foregroundImage: user.avatarUrl == null
          ? null
          : NetworkImage(user.avatarUrl!
              // ignore: deprecated_member_use
              .getThumbnail(
                client,
                width: 56,
                height: 56,
              )
              .toString()),
    );
  }
}
