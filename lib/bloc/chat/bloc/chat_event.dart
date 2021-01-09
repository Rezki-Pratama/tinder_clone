part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class SendChatEvent extends ChatEvent {
  final Message message;

  SendChatEvent({this.message});

  @override
  List<Object> get props => [message];
}

class MessageStreamEvent extends ChatEvent {
  final String currentUserId, selectedUserId;

  MessageStreamEvent({this.currentUserId, this.selectedUserId});

  @override
  List<Object> get props => [currentUserId, selectedUserId];
}