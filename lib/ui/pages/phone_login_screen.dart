import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sunshine_laundry_driver_app/ui/pages/otp_screen.dart';
import 'package:sunshine_laundry_driver_app/ui/widgets/header_widget.dart';
import 'package:sunshine_laundry_driver_app/utils/colors.dart';
import 'package:sunshine_laundry_driver_app/utils/common.dart';

class PhoneLoginScreen extends StatefulWidget {
  static final routeName = "phone-login-screen";
  @override
  _PhoneLoginScreenState createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  String _selectedCountryCode = "";
  @override
  Widget build(BuildContext context) {
    final CommonFunctions commonFunctions = new CommonFunctions(context);
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(ThemeColors.themeMainBackgroundColor),
      body: ListView(
        children: <Widget>[
          HeaderWidget(height: mediaQuery.height * 0.5),
          SizedBox(
            height: mediaQuery.height * 0.03,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  "Hello, nice to meet you!",
                  style: TextStyle(
                    color: Color(ThemeColors.themeMainTextColor),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: mediaQuery.height * 0.01),
                Text(
                  "Welcome to sunshine laundry",
                  style: TextStyle(
                    color: Color(ThemeColors.themeMainTextColor),
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: mediaQuery.height * 0.05,
          ),
          Card(
            margin: EdgeInsets.only(left: 10, right: 10),
            elevation: 6.0,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: CountryCodePicker(
                      // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                      initialSelection: 'LK',
                      favorite: ['+94'],
                      onChanged: (CountryCode countryCode) {
                        _selectedCountryCode = countryCode.toString();
                        print("New Country selected: " + countryCode.toString());
                      },
                      onInit: (CountryCode countryCode) {
                        _selectedCountryCode = countryCode.toString();
                        print("Init Country: " + countryCode.toString());
                      },
                      // optional. Shows only country name and flag
                      showCountryOnly: false,
                      // optional. Shows only country name and flag when popup is closed.
                      showOnlyCountryWhenClosed: false,
                      // optional. aligns the flag and the Text left
                      alignLeft: false,
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _phoneNumberController,
                        autofocus: true,
                        maxLength: 9,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(9),
                        ],
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Mobile phone number",
                          hintStyle: TextStyle(
                            color: Color(ThemeColors.themeMainTextColor),
                            fontSize: 12,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      )),
                  Expanded(
                      flex: 1,
                      child: MaterialButton(
                        onPressed: () {
                          if(_phoneNumberController.text.trim().isEmpty){
                            commonFunctions.showSnackBar("Please enter the mobile phone number");
                          }else if(_phoneNumberController.text.trim().length < 9 || _phoneNumberController.text.trim().length > 9){
                            commonFunctions.showSnackBar("Please enter the valid mobile phone number");
                          }else{
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => OTPScreen(_selectedCountryCode + _phoneNumberController.text.trim())));
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
          SizedBox(
            height: mediaQuery.height * 0.1,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'By creating an account, you agree to our',
                    style: TextStyle(
                      color: Color(ThemeColors.themeMainTextColor),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  TextSpan(
                    text: ' Terms of Service',
                    style: TextStyle(
                      color: Color(ThemeColors.themeMainTextColor),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: ' and ',
                    style: TextStyle(
                      color: Color(ThemeColors.themeMainTextColor),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      color: Color(ThemeColors.themeMainTextColor),
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
}
