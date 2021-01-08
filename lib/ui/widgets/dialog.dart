
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tinder/ui/utilities.dart';
import 'package:tinder/ui/widgets/photo.dart';

class DialogWidget extends StatelessWidget {
  final Size size;
  final String photo, gender, name, location, age;
  final Function onClose, onSelect, onSave;
  DialogWidget(
      {this.size,
      this.onClose,
      this.onSelect,
      this.onSave,
      this.photo = '',
      this.gender = '',
      this.name = '',
      this.location = '',
      this.age = '',
      
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(size.height * 0.040),
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.574,
            child: Stack(
              children: <Widget>[
                Container(
                  width: size.width * 0.95,
                  height: size.height * 0.574,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(size.height * 0.05),
                    child: PhotoWidget(
                      photoLink: photo,
                    ),
                  ),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.5),
                        blurRadius: 5.0,
                        spreadRadius: 2.0,
                        offset: Offset(3.0, 3.0),
                      )
                    ],
                    borderRadius: BorderRadius.circular(size.height * 0.05),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black54,
                            Colors.black87,
                            Colors.black
                          ],
                          stops: [
                            0.3,
                            0.4,
                            0.6,
                            0.9
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                      color: Colors.black45,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(size.height * 0.05),
                        bottomRight: Radius.circular(size.height * 0.05),
                      )),
                  width: size.width * 0.95,
                  height: size.height * 0.574,
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: size.height * 0.350),
                      child: Container(
                        decoration: BoxDecoration(
                            color: colorRed.withOpacity(0.7),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(size.height * 0.05),
                                bottomLeft:
                                    Radius.circular(size.height * 0.05))),
                        height: size.height / 7,
                        width: size.height * 0.3,
                        child: Padding(
                          padding: EdgeInsets.all(size.height * 0.02),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                      gender == 'Male'
                                          ? FontAwesomeIcons.mars
                                          : FontAwesomeIcons.venus,
                                      color: Colors.white),
                                      SizedBox(width: size.width * 0.01,),
                                  Flexible(
                                    child: Text(name + ', ' + age,
                                        softWrap: false,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Row(
                                children: [
                                  Icon(FontAwesomeIcons.mapPin,
                                      color: Colors.white),
                                      SizedBox(width: size.width * 0.01,),
                                  Flexible(
                                    child: Text(location,
                                        softWrap: false,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          ),
          SizedBox(height: size.height * 0.025),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            GestureDetector(
              onTap: onClose,
              child: Container(
                  height: size.height * 0.09,
                  width: size.width * 0.18,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(size.height * 0.05),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 5.0,
                        spreadRadius: 2.0,
                        offset: Offset(3.0, 3.0),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(size.height * 0.03),
                    child: Image.asset('assets/Close.png'),
                  )),
            ),
            GestureDetector(
              onTap: onSelect,
              child: Container(
                  height: size.height * 0.09,
                  width: size.width * 0.18,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(size.height * 0.05),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 5.0,
                        spreadRadius: 2.0,
                        offset: Offset(3.0, 3.0),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(size.height * 0.03),
                    child: Image.asset('assets/Love.png'),
                  )),
            )
          ])
        ],
      ),
    );
  }
}