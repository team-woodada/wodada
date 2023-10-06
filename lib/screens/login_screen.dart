import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:wodada/components/components.dart';
import 'package:wodada/constants.dart';
import 'package:wodada/screens/home_screen.dart';
import 'package:wodada/screens/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  late String _email;
  late String _password;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 뒤로 가기 버튼을 누르면 HomeScreen으로 이동합니다.
        Navigator.popAndPushNamed(context, HomeScreen.id);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LoadingOverlay(
          isLoading: _saving,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const TopScreenImage(screenImageName: 'welcome.png'),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const ScreenTitle(title: '카카오'),
                        CustomTextField(
                          textField: TextField(
                              onChanged: (value) {
                                _email = value;
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: kTextInputDecoration.copyWith(
                                  hintText: 'Email')),
                        ),
                        CustomTextField(
                          textField: TextField(
                            obscureText: true,
                            onChanged: (value) {
                              _password = value;
                            },
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                            decoration: kTextInputDecoration.copyWith(
                                hintText: 'Password'),
                          ),
                        ),
                        CustomBottomScreen(
                          textButton: 'Login',
                          heroTag: 'login_btn',
                          question: '비밀번호를 잊으셨나요?',
                          buttonPressed: () async {
                            // 키보드 닫기
                            FocusManager.instance.primaryFocus?.unfocus();
                            setState(() {
                              _saving = true; // 로딩 오버레이 표시
                            });
                            try {
                              // 제공된 자격 증명으로 로그인을 시도합니다.
                              await _auth.signInWithEmailAndPassword(
                                  email: _email, password: _password);

                              if (context.mounted) {
                                setState(() {
                                  _saving = false; // 로딩 오버레이 숨김
                                  Navigator.popAndPushNamed(
                                      context, LoginScreen.id);
                                });
                                Navigator.pushNamed(context, WelcomeScreen.id);
                              }
                            } catch (e) {
                              // 로그인 오류 처리
                              signUpAlert(
                                context: context,
                                onPressed: () {
                                  setState(() {
                                    _saving = false; // 로딩 오버레이 숨김
                                  });
                                  Navigator.popAndPushNamed(
                                      context, LoginScreen.id);
                                },
                                title: '잘못된 비밀번호 또는 이메일',
                                desc: '이메일과 비밀번호를 확인하고 다시 시도하세요',
                                btnText: '다시 시도',
                              ).show();
                            }
                          },
                          questionPressed: () {
                            signUpAlert(
                              onPressed: () async {
                                await FirebaseAuth.instance
                                    .sendPasswordResetEmail(email: _email);
                              },
                              title: '비밀번호 재설정',
                              desc: '비밀번호를 재설정하려면 버튼을 클릭하세요',
                              btnText: '지금 재설정',
                              context: context,
                            ).show();
                          },
                        ),
                      ],
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
