import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_number/phone_number.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/quiz_app_provider.dart';
import 'package:quiz_app/screens/otp_screen.dart';
import 'package:quiz_app/util/constants.dart';
import 'package:quiz_app/widgets/snack_bar_widget.dart';

class LoginScreen extends StatefulWidget {
  static const String id = '/LoginScreen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneNumberController = TextEditingController();
  bool allowNext = false;
  @override
  void initState() {
    phoneNumberController.addListener(() {
      final isButtonActive = phoneNumberController.text.length == 9;
      setState(() => allowNext = isButtonActive);
    });
    super.initState();
  }

  void formatPhoneNumber() async {
    String springFieldKSASimple = '+966502466666';
    PhoneNumber phoneNumber =
        await PhoneNumberUtil().parse(springFieldKSASimple);
    bool isValid = await PhoneNumberUtil().validate(springFieldKSASimple);
    RegionInfo region =
        RegionInfo(code: 'SA', name: 'Saudi Arabia', prefix: 966);
    String formatted = await PhoneNumberUtil()
        .format("+966" + phoneNumberController.text, region.code);
    var provider = Provider.of<QuizAppProvider>(context, listen: false);
    provider.phone_number = formatted;
    if (isValid) {
      Navigator.pushNamed(context, OtpScreen.id);
    } else
      showActionSnackBar(
          context, 'Error has occured! please re-type your number :)');

    // +1 (417) 555-5470
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidgth = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [COLOR_BEIGE, COLOR_DARK_BEIGE, COLOR_LIGHT_BROWN],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Container(
              width: screenWidgth / 1.2,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: COLOR_BROWN,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                        color: COLOR_WHIEE,
                        fontSize: 24,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Your phone number',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          hintText: '50xxxxxxxx',
                          hintStyle: const TextStyle(color: COLOR_BEIGE),
                          fillColor: COLOR_BEIGE),
                      controller: phoneNumberController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(9),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onChanged: (value) {
                        if (value.length == 9) {
                          FocusScope.of(context).unfocus();
                        }
                      }),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: allowNext ? () => formatPhoneNumber() : null,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'Next',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
