part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  
  @override
  List<Object> get props => [];
}

class ChatInitialState extends ChatState {}

class ChatLoadingState extends ChatState {}

class ChatLoadedState extends ChatState {
  final Stream<QuerySnapshot> messageStream;

  ChatLoadedState({this.messageStream});

  @override
  List<Object> get props => [messageStream];
}
