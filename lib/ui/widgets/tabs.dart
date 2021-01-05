import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder/bloc/authentication/bloc/authentication_bloc.dart';
import 'package:tinder/ui/pages/matches.dart';
import 'package:tinder/ui/pages/messages.dart';
import 'package:tinder/ui/pages/search.dart';
import 'package:tinder/ui/utilities.dart';

class Tabs extends StatelessWidget {
  final userId;

  const Tabs({this.userId});

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      Search(
        userId: userId,
      ),
      Matches(
        userId: userId,
      ),
      Message(
        userId: userId,
      ),
    ];

    return Theme(
      data: ThemeData(
        primaryColor: colorRed,
      ),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Container(
                width: 35, child: Image.asset('assets/LinjanganLogo.png')),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                },
              )
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(48.0),
              child: Container(
                height: 48.0,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TabBar(
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.5),
                              blurRadius: 5.0, // soften the shadow
                              spreadRadius: 0.0, //extend the shadow
                              offset: Offset(
                                3.0, // Move to right 10  horizontally
                                3.0, // Move to bottom 10 Vertically
                              ),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(20),
                          color: colorRed),
                      tabs: <Widget>[
                        Tab(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                // color: colorRed,
                                border: Border.all(color: Colors.white, width: 2)),
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(Icons.search),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                // color: Colors.white,
                                border: Border.all(color: Colors.white, width: 2)),
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(Icons.people),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                // color: Colors.white,
                                border: Border.all(color: Colors.white, width: 2)),
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(Icons.message),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: pages,
          ),
        ),
      ),
    );
  }
}
