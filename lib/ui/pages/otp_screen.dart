import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:sunshine_laundry_driver_app/ui/pages/dashboard_screen.dart';
import 'package:sunshine_laundry_driver_app/ui/widgets/header_widget.dart';
import 'package:sunshine_laundry_driver_app/utils/styles.dart';
import 'package:sunshine_laundry_driver_app/utils/colors.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  OTPScreen(this.phone);
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _verificationId;
  final TextEditingController _smsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    final FocusNode _pinPutFocusNode = FocusNode();
    final BoxDecoration pinPutDecoration = BoxDecoration(
      color: Color(ThemeColors.themeSecondaryColor),
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(
        color: Color(ThemeColors.themePrimaryColor),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(ThemeColors.themeMainBackgroundColor),
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              HeaderWidget(height: mediaQuery.height * 0.5),
              Positioned(
                top: 20.0,
                left: 0.0,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: Colors.white,
                  textColor: Color(ThemeColors.themePrimaryColor),
                  child: Icon(
                    Icons.arrow_back,
                    size: 15,
                  ),
                  padding: EdgeInsets.all(6),
                  shape: CircleBorder(),
                ),
              )
            ],
          ),
          SizedBox(
            height: mediaQuery.height * 0.03,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text("Phone Verification", style: CustomStyles.smallTextStyle),
                SizedBox(height: mediaQuery.height * 0.01),
                Text(
                  "Enter your OTP code below",
                  style: CustomStyles.mediumTextStyle,
                ),
              ],
            ),
          ),
          SizedBox(
            height: mediaQuery.height * 0.05,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: PinPut(
                        fieldsCount: 6,
                        textStyle: const TextStyle(fontSize: 15.0, color: Colors.white),
                        eachFieldWidth: 10.0,
                        eachFieldHeight: 20.0,
                        focusNode: _pinPutFocusNode,
                        controller: _smsController,
                        submittedFieldDecoration: pinPutDecoration,
                        selectedFieldDecoration: pinPutDecoration,
                        followingFieldDecoration: pinPutDecoration,
                        pinAnimationType: PinAnimationType.fade,
                        onSubmit: (pin) async {
                          try {
                            await FirebaseAuth.instance
                                .signInWithCredential(PhoneAuthProvider.credential(
                                verificationId: _verificationId, smsCode: pin))
                                .then((value) async {
                              if (value.user != null) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                                        (route) => false);
                              }
                            });
                          } catch (e) {
                            FocusScope.of(context).unfocus();
                            _scaffoldKey.currentState
                                .showSnackBar(SnackBar(content: Text('invalid OTP')));
                          }
                        },
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: MaterialButton(
                          onPressed: ()  async {
                            try {
                              await FirebaseAuth.instance
                                  .signInWithCredential(PhoneAuthProvider.credential(
                                  verificationId: _verificationId, smsCode: _smsController.text.trim()))
                                  .then((value) async {
                                if (value.user != null) {
                                  Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => DashboardScreen()),(route) => false);
                                }
                              });
                            } catch (e) {
                              FocusScope.of(context).unfocus();
                              _scaffoldKey.currentState
                                  .showSnackBar(SnackBar(content: Text('invalid OTP')));
                            }
                          },
                          color: Color(ThemeColors.themePrimaryColor),
                          textColor: Colors.white,
                          child: Icon(
                            Icons.arrow_forward,
                            size: 15,
                          ),
                          padding: EdgeInsets.all(6),
                          shape: CircleBorder(),
                        ))
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: mediaQuery.height * 0.1,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Resend Code in',
                    style: TextStyle(
                      color: Color(ThemeColors.themeMainTextColor),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  TextSpan(
                    text: ' 10 Seconds',
                    style: TextStyle(
                      color: Color(ThemeColors.themeSecondaryColor),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    verifyPhone(widget.phone);
  }

  Future<void> verifyPhone(phoneNumber) async{
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final PhoneVerificationCompleted verificationCompleted = (PhoneAuthCredential phoneAuthCredential) async {
      // AuthService().signIn(phoneAuthCredential);
      await _auth.signInWithCredential(phoneAuthCredential).then((UserCredential result) {
        // Sign in is successful
        User user = result.user;
        if(user != null){
          print("Phone number automatically verified and user signed in: ${_auth.currentUser.uid}");
          Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => DashboardScreen()),(route) => false);
        }
      }).catchError((e) {
        print(e);
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      print('Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      print('Please check your phone for the verification code.');
      _verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      print("verification code: " + verificationId);
      _verificationId = verificationId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }
}
