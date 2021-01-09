import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:tinder/model/message.dart';
import 'package:tinder/repositories/chat_repositories.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(this._chatRepository) : super(ChatInitialState());

  ChatRepository _chatRepository;

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    if (event is MessageStreamEvent) {
      yield* _mapStreamToState(
          currentUserId: event.currentUserId,
          selectedUserId: event.selectedUserId);
    }
    if (event is SendChatEvent) {
      yield* _mapSendMessageToState(message: event.message);
    }
  }

   Stream<ChatState> _mapStreamToState(
      {String currentUserId, String selectedUserId}) async* {
    yield ChatLoadingState();
    Stream<QuerySnapshot> messageStream = _chatRepository.getMessages(
        currentUserId: currentUserId, selectedUserId: selectedUserId);
    yield ChatLoadedState(messageStream: messageStream);
  }

  Stream<ChatState> _mapSendMessageToState({Message message}) async* {
    await _chatRepository.sendMessage(message: message);
  }
}
