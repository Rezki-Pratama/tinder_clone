import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tinder/bloc/authentication/bloc/authentication_bloc.dart';
import 'package:tinder/bloc/profile/bloc/profile_bloc.dart';
import 'package:tinder/repositories/user_repositories.dart';
import 'package:tinder/ui/utilities.dart';
import 'package:tinder/ui/widgets/custom_button.dart';
import 'package:tinder/ui/widgets/gender.dart';

class ProfileForm extends StatefulWidget {
  final UserRepository _userRepository;

  ProfileForm({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final TextEditingController _nameController = TextEditingController();
  final _picker = ImagePicker();
  String gender, interestedIn;
  DateTime age;
  File photo;
  GeoPoint location;
  ProfileBloc _profileBloc;

  UserRepository get _userRepository => widget._userRepository;

  bool get isFilled =>
      _nameController.text.isNotEmpty &&
      gender != null &&
      interestedIn != null &&
      photo != null &&
      age != null;

  bool isButtonEnabled(ProfileState state) {
    return isFilled && !state.isSubmitting;
  }

  _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    location = GeoPoint(position.latitude, position.longitude);
  }

  _onSubmitted() async {
    await _getLocation();
    _profileBloc.add(
      Submitted(
          name: _nameController.text,
          age: age,
          location: location,
          gender: gender,
          interestedIn: interestedIn,
          photo: photo),
    );
  }

  _getImage() async {
    PickedFile getPic = await _picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 20,
        maxHeight: 480,
        maxWidth: 640);
    if (getPic != null) {
      setState(() {
        photo = File(getPic.path);
      });
    }
  }

  @override
  void initState() {
    _getLocation();
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<ProfileBloc, ProfileState>(
      //bloc: _profileBloc,
      listener: (context, state) {
        if (state.isFailure) {
          print("Failed");
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Profile Creation Unsuccesful'),
                    Icon(Icons.error)
                  ],
                ),
              ),
            );
        }
        if (state.isSubmitting) {
          print("Submitting");
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Submitting'),
                    CircularProgressIndicator()
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          print("Success!");
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              color: colorRed,
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Container(
                    width: size.width,
                    child: CircleAvatar(
                      radius: size.width * 0.2,
                      backgroundColor: Colors.transparent,
                      child: photo == null
                          ? GestureDetector(
                              onTap: _getImage,
                              child: Image.asset('assets/profilephoto.png'),
                            )
                          : GestureDetector(
                              onTap: _getImage,
                              child: CircleAvatar(
                                radius: size.width * 0.3,
                                backgroundImage: FileImage(photo),
                              ),
                            ),
                    ),
                  ),
                  textFieldWidget(_nameController, "Name", size),
                  GestureDetector(
                    onTap: () {
                      DatePicker.showDatePicker(
                        context,
                        showTitleActions: true,
                        minTime: DateTime(1900, 1, 1),
                        maxTime: DateTime(DateTime.now().year - 19, 1, 1),
                        theme: DatePickerTheme(
                            headerColor: Colors.white,
                            backgroundColor: colorRed,
                            itemStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                            cancelStyle:
                                TextStyle(color: colorRed, fontSize: 16, fontWeight: FontWeight.bold),
                            doneStyle:
                                TextStyle(color: colorRed, fontSize: 16, fontWeight: FontWeight.bold)),
                        onConfirm: (date) {
                          setState(() {
                            age = date;
                          });
                          print(age);
                        },
                      );
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.height * 0.02),
                      child: Material(
                        color: Colors.white,
                        elevation: 20,
                        borderRadius: BorderRadius.circular(size.height * 0.03),
                        child: Container(
                          width: size.width,
                          child: Padding(
                            padding: EdgeInsets.all(size.height * 0.02),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  age == null
                                      ? 'Enter your birthday'
                                      : formatDate(
                                          age, [dd, '-', MM, '-', yyyy]),
                                  style: TextStyle(
                                      color: colorRed,
                                      fontSize: size.height * 0.02),
                                ),
                                Icon(FontAwesomeIcons.calendarAlt,
                                    color: colorRed),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.height * 0.02),
                        child: Text(
                          "Gender",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: size.height * 0.025),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          genderWidget(
                              FontAwesomeIcons.venus, "Female", size, gender,
                              () {
                            setState(() {
                              gender = "Female";
                            });
                          }),
                          genderWidget(
                              FontAwesomeIcons.mars, "Male", size, gender, () {
                            setState(() {
                              gender = "Male";
                            });
                          }),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.height * 0.02),
                        child: Text(
                          "Interested",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: size.height * 0.025),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          genderWidget(FontAwesomeIcons.venus, "Female", size,
                              interestedIn, () {
                            setState(() {
                              interestedIn = "Female";
                            });
                          }),
                          genderWidget(
                              FontAwesomeIcons.mars, "Male", size, interestedIn,
                              () {
                            setState(() {
                              interestedIn = "Male";
                            });
                          }),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(size.height * 0.02),
                    child: GestureDetector(
                        onTap: () {
                          print(isButtonEnabled(state));
                          if (isButtonEnabled(state)) {
                            _onSubmitted();
                          } else {}
                        },
                        child: CustomButton(
                          text: 'SAVE',
                          color: colorRed,
                          boxDecorationColor:
                              isButtonEnabled(state) ? Colors.white : colorRed,
                          textColor:
                              isButtonEnabled(state) ? colorRed : Colors.white,
                        )),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget textFieldWidget(controller, text, size) {
  return Padding(
    padding: EdgeInsets.all(size.height * 0.02),
    child: Material(
      color: Colors.white,
      elevation: 20,
      borderRadius: BorderRadius.circular(size.height * 0.03),
      child: Padding(
        padding: EdgeInsets.only(left: size.height * 0.03),
        child: TextField(
          controller: controller,
          style: TextStyle(color: colorRed),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: -10),
            border:
                UnderlineInputBorder(borderSide: BorderSide(color: colorRed)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
            hintText: "Name",
            errorStyle: TextStyle(color: colorRed),
            hintStyle: TextStyle(color: colorRed, fontSize: size.height * 0.02),
          ),
        ),
      ),
    ),
  );
}
