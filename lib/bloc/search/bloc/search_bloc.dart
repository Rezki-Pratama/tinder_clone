import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tinder/model/user.dart';
import 'package:tinder/repositories/search_repositories.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._searchRepository) : super(InitialSearchState());

  SearchRepository _searchRepository;

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SelectUserEvent) {
      yield* _mapSelectToState(
          currentUserId: event.currentUserId,
          selectedUserId: event.selectedUserId,
          name: event.name,
          photoUrl: event.photoUrl);
    }
    if (event is SkipUserEvent) {
      yield* _mapSkipToState(
        currentUserId: event.currentUserId,
        selectedUserId: event.selectedUserId,
      );
    }
    if (event is LoadUserEvent) {
      yield* _mapLoadUserToState(currentUserId: event.userId);
    }
  }

    Stream<SearchState> _mapSelectToState(
      {String currentUserId,
      String selectedUserId,
      String name,
      String photoUrl}) async* {
    yield LoadingState();

    User user = await _searchRepository.selectUser(currentUserId, selectedUserId, name, photoUrl);
    User currentUser = await _searchRepository.getUserInterests(currentUserId);

    yield LoadUserState(user, currentUser);
  }

  Stream<SearchState> _mapSkipToState(
      {String currentUserId, String selectedUserId}) async* {
        
    yield LoadingState();
    User user = await _searchRepository.skipUser(currentUserId, selectedUserId);
    User currentUser = await _searchRepository.getUserInterests(currentUserId);

    yield LoadUserState(user, currentUser);
  }

  Stream<SearchState> _mapLoadUserToState({String currentUserId}) async* {
    yield LoadingState();
    User user = await _searchRepository.getUser(currentUserId);
    User currentUser = await _searchRepository.getUserInterests(currentUserId);

    yield LoadUserState(user, currentUser);
  }

}
