import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder/bloc/message/bloc/message_bloc.dart';
import 'package:tinder/repositories/message_repositories.dart';
import 'package:tinder/ui/widgets/chat.dart';

class Message extends StatefulWidget {

final String userId;
Message({ this.userId });

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  MessageRepository _messagesRepository = MessageRepository();
  MessageBloc _messageBloc;

  @override
  void initState() {
    _messageBloc = MessageBloc(_messagesRepository);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageBloc, MessageState>(
      cubit: _messageBloc,
      builder: (BuildContext context, MessageState state) {
        if (state is MessageInitialState) {
          _messageBloc.add(ChatStreamEvent(currentUserId: widget.userId));
        }
        if (state is ChatLoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ChatLoadedState) {
          Stream<QuerySnapshot> chatStream = state.chatStream;

          return StreamBuilder<QuerySnapshot>(
            stream: chatStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text("No data");
              }

              if (snapshot.data.docs.isNotEmpty) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ChatWidget(
                        creationTime:
                            snapshot.data.docs[index].data()['timestamp'],
                        userId: widget.userId,
                        selectedUserId:
                            snapshot.data.docs[index].id,
                      );
                    },
                  );
                }
              } else
                return Text(
                  " You don't have any conversations",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                );
            },
          );
        }
        return Container();
      },
    );
  }
}