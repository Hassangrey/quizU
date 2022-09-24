import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/quiz_app_provider.dart';
import 'package:quiz_app/screens/enter_name_screen.dart';
import 'package:quiz_app/screens/loading_screen.dart';
import 'package:quiz_app/screens/navgation_bar_holder.dart';
import 'package:quiz_app/util/constants.dart';
import 'package:quiz_app/widgets/snack_bar_widget.dart';

class OtpScreen extends StatefulWidget {
  static const String id = '/OtpScreen';

  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  Future<void> checkLogin(String phone_number, String otp) async {
    var provider = Provider.of<QuizAppProvider>(context, listen: false);
    await provider.postLogin(phone_number, otp);
    if (provider.hasError) {
      showActionSnackBar(context, 'OTP number is wrong! (Hint: Try: 0000).');
    } else if (provider.isNewAccount) {
      Navigator.pushNamedAndRemoveUntil(
          context, EnterYourNameScreen.id, (route) => false);
      showActionSnackBar(context, 'New Account!!');
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, MyNavigationBar.id, (route) => false);
    }
  }

  TextEditingController otpController = TextEditingController();
  bool allowNext = false;
  void initState() {
    otpController.addListener(() {
      final isButtonActive = otpController.text.length == 4;
      setState(() => allowNext = isButtonActive);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidgth = MediaQuery.of(context).size.width;
    var provider = Provider.of<QuizAppProvider>(context);

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
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: provider.isLoading
            ? LoadingWidget()
            : Center(
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
                          'OTP',
                          style: TextStyle(
                              color: COLOR_WHIEE,
                              fontSize: 24,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'OTP Number',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                            controller: otpController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                hintText: 'XXXX',
                                hintStyle: const TextStyle(color: COLOR_BEIGE),
                                fillColor: COLOR_BEIGE),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(4),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (value) {
                              if (value.length == 4) {
                                // allowNext = true;
                                FocusScope.of(context).unfocus();
                              }
                            }),
                        const SizedBox(height: 50),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: allowNext
                                ? () => checkLogin(
                                    provider.phone_number, otpController.text)
                                : null,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'Login',
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
