import 'package:assistant/animation/fade_transition.dart';
import 'package:assistant/pages/waiting_page.dart';
import 'package:assistant/widgets/gender_card.dart';
import 'package:assistant/widgets/height_card.dart';
import 'package:assistant/widgets/input_sammary.dart';
import 'package:assistant/widgets/pocimon_slider.dart';
import 'package:assistant/widgets/transition_dot.dart';
import 'package:assistant/widgets/weight_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class HeightGenderWeightPage extends StatefulWidget {

  @override
  _HeightGenderWeightPageState createState() => _HeightGenderWeightPageState();
}

class _HeightGenderWeightPageState extends State<HeightGenderWeightPage>
    with TickerProviderStateMixin {
  // animation controller
  AnimationController _animationController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var firebaseUser = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animationController.addStatusListener((status) {
      //add a listener
      if (status == AnimationStatus.completed) {
        _goToResultPage().then(
          (_) => _animationController.reset(),
        ); //reset controller when coming back
      }
    });
  }



  // initial data
  GenderType gender = GenderType.male;
  int height = 170;
  int weight = 60;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: <Widget>[
          Scaffold(
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InputSummaryCard(
                    backgroundColor: Colors.white70,
                    gender: gender,
                    weight: weight,
                    height: height,
                  ),
                  Expanded(child: _buildCards()),
                  _buildBottom(),
                ],
              ),
            ),
          ),
          TransitionDot(animation: _animationController),
        ],
      ),
    );
  }

  Widget _buildCards() {
    return Padding(
      padding: EdgeInsets.only(
        top: ScreenUtil().setHeight(8),
        left: ScreenUtil().setHeight(14),
        right: ScreenUtil().setHeight(14),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: GenderCard(
                    initialGender: GenderType.male,
                    onChange: (type) => setState(
                      () => gender = type,
                    ),
                  ),
                ),
                Expanded(
                    child: WeightCard(
                  title: 'الوزن',
                  value: 'كجم',
                  initialValue: 60,
                  onChage: (val) => setState(() => weight = val),
                ))
              ],
            ),
          ),
          Expanded(
            child: HeightCard(
              height: 170,
              onChanged: (val) => setState(() => height = val),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return Padding(
      padding: EdgeInsets.only(
        left: ScreenUtil().setHeight(16.0),
        right: ScreenUtil().setHeight(16.0),
        bottom: ScreenUtil().setHeight(22.0),
        top: ScreenUtil().setHeight(14.0),
      ),
      child: PacmanSlider(
        onSubmit: onPacmanSubmit,
        animationController: _animationController,
      ),
    );
  }

  void onPacmanSubmit() async {
    // start the animation whenever the user submitting the slider
    final documentId = ModalRoute.of(context).settings.arguments;
    CollectionReference patients = FirebaseFirestore.instance.collection('patients');
    final result = await patients.doc(documentId).get();
    final patientData = result.data();
    print(patientData);

    try{
      DocumentReference newPatient = FirebaseFirestore.instance.collection('patients').doc();
      await newPatient.set({
        'first name': patientData['first name'],
        'second name' : patientData['second name'],
        'age' : patientData['age'],
        'has sugar' : patientData['has sugar'],
        'has pressure' : patientData['has pressure'],
        'height' : height,
        'weight' : weight,
        'gender' : gender.toString(),
      }).then((value) => print("Patient Added"))
          .catchError((error) => print("Failed to add Patient: $error"));
    } catch(e){
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Something went wrong'),
      ));
    }

    _animationController.forward();
  }
  _goToResultPage() async {
    final docId = ModalRoute.of(context).settings.arguments;
    return Navigator.of(context).push(
      FadeRoute(
        //use the FadeRoute
        builder: (context) => WaitingPage(),
        settings: RouteSettings(
          arguments: docId,
        ),
      ),
    );
  }
  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }
}
