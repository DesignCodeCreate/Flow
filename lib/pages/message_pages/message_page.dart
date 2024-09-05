// ignore_for_file: deprecated_member_use

import 'package:flow/models/flow_client.dart';
import 'package:flow/models/keyboard_listener.dart';
import 'package:flow/models/utils.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';

class MessagePage extends StatefulWidget {
  final Room room;
  const MessagePage({required this.room, super.key});

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late final Future<Timeline> _timelineFuture;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  // ignore: unused_field
  int _count = 0;

  @override
  void initState() {
    _timelineFuture = widget.room.getTimeline(
        onChange: (i) {
          _listKey.currentState?.setState(() {});
        },
        onInsert: (i) {
          _listKey.currentState?.insertItem(i);
          _count++;
        },
        onRemove: (i) {
          _count--;
          _listKey.currentState?.removeItem(i, (_, __) => const ListTile());
        },
        onUpdate: () {});
    super.initState();
  }

  final TextEditingController _sendController = TextEditingController();

  void _send() {
    widget.room.sendTextEvent(_sendController.text.trim());
    _sendController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final FlowClient client = Provider.of<FlowClient>(context);

    return KeyboardListenerFlow(
      onEnterPressed: () {
        if (_sendController.text.isNotEmpty) {
          for (String char in _sendController.text.split("")) {
            if (char != " ") {
              _send();
              break;
            } else {}
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: getProfilePicture(widget.room, client),
            )
          ],
          title: Text(widget.room.name),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder<Timeline>(
                  future: _timelineFuture,
                  builder: (context, snapshot) {
                    final timeline = snapshot.data;
                    timeline?.requestHistory();

                    if (timeline == null) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    _count = timeline.events.length;
                    return Column(
                      children: [
                        Center(
                          child: TextButton(
                              onPressed: timeline.requestHistory,
                              child: Text(
                                'Load more...',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary),
                              )),
                        ),
                        Divider(
                          height: 1,
                          color: Theme.of(context).colorScheme.secondary,
                          thickness: 2,
                        ),
                        Expanded(
                          child: AnimatedList(
                            key: _listKey,
                            reverse: true,
                            initialItemCount: timeline.events.length,
                            itemBuilder: (context, i, animation) => timeline
                                        .events[i].relationshipEventId !=
                                    null
                                ? Container()
                                : ScaleTransition(
                                    scale: animation,
                                    child: Opacity(
                                      opacity: timeline.events[i].status.isSent
                                          ? 1
                                          : 0.5,
                                      child: ListTile(
                                        leading: getProfilePicturePerson(
                                            timeline.events[i].sender, client),
                                        title: Row(
                                          children: [
                                            Expanded(
                                              child: Text(timeline
                                                  .events[i].sender
                                                  .calcDisplayname()),
                                            ),
                                            Text(
                                              timeline.events[i].originServerTs
                                                  .toLocal()
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                          ],
                                        ),
                                        subtitle: Text(timeline.events[i]
                                            .getDisplayEvent(timeline)
                                            .body),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const Divider(
                height: 1,
                color: Colors.transparent,
              ),
              Container(
                color: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextField(
                          controller: _sendController,
                          decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3,
                                  color: Theme.of(context).colorScheme.primary),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            icon: getProfilePicturePerson(
                                User(client.userID!, room: widget.room),
                                client),
                            hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary),
                            hintText: 'Send message',
                          ),
                        )),
                        const SizedBox(
                          width: 8,
                        ),
                        IconButton(
                          padding: EdgeInsets.all(3),
                          style: ButtonStyle(
                              elevation: WidgetStatePropertyAll(4),
                              enableFeedback: true),
                          icon: Icon(
                            Icons.send,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                          onPressed: _send,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
