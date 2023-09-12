import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:wodada/components/login_platform.dart';

import 'package:wodada/layout/default_layout.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  bool _isLogin = false;
  final LoginPlatform _loginPlatform = LoginPlatform.none;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  // void signUserIn() {
  //   print("button is tapped");
  // }

  void signInWithKakao() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();

      OAuthToken token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      final url = Uri.https('kapi.kakao.com', '/v2/user/me');

      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
        },
      );

      final profileInfo = json.decode(response.body);
      print(profileInfo.toString());

      setState(() {
        _isLogin = true;
      });
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
    }
  }

  void signOut() async {
    switch (_loginPlatform) {
      case LoginPlatform.facebook:
        break;
      case LoginPlatform.google:
        break;
      case LoginPlatform.kakao:
        signInWithKakao();
        break;
      case LoginPlatform.naver:
        break;
      case LoginPlatform.apple:
        break;
      case LoginPlatform.none:
        break;
    }

    setState(() {
      _isLogin = false;
    });
  }

  void singOut() async {
    await UserApi.instance.logout();

    setState(() {
      _isLogin = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'loginScreen',
      body: SingleChildScrollView(
        child: _isLogin == true
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: signOut,
                      child: const Text("로그아웃"),
                    ),
                  ],
                ),
              )
            // ? ElevatedButton(onPressed: signOut, child: const Text("로그아웃"),)
            : SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),

                      // const SizedBox(height: 50),

                      // // welcome back, you've been missed!
                      // Text(
                      //   'Welcome back you\'ve been missed!',
                      //   style: TextStyle(
                      //     color: Colors.grey[700],
                      //     fontSize: 16,
                      //   ),
                      // ),

                      // const SizedBox(height: 25),

                      // // username textfield
                      // MyTextField(
                      //   controller: usernameController,
                      //   hintText: 'Username',
                      //   obscureText: false,
                      // ),

                      // const SizedBox(height: 10),

                      // // password textfield
                      // MyTextField(
                      //   controller: passwordController,
                      //   hintText: 'Password',
                      //   obscureText: true,
                      // ),

                      // const SizedBox(height: 10),

                      // // forgot password?
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.end,
                      //     children: [
                      //       Text(
                      //         'Forgot Password?',
                      //         style: TextStyle(color: Colors.grey[600]),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      // // const SizedBox(height: 25),

                      // // // sign in button
                      // // MyButton(
                      // //   onTap: signUserIn,
                      // // ),

                      // const SizedBox(height: 50),

                      // // or continue with
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      //   child: Row(
                      //     children: [
                      //       Expanded(
                      //         child: Divider(
                      //           thickness: 0.5,
                      //           color: Colors.grey[400],
                      //         ),
                      //       ),
                      //       Padding(
                      //         padding:
                      //             const EdgeInsets.symmetric(horizontal: 10.0),
                      //         child: Text(
                      //           'Or continue with',
                      //           style: TextStyle(color: Colors.grey[700]),
                      //         ),
                      //       ),
                      //       Expanded(
                      //         child: Divider(
                      //           thickness: 0.5,
                      //           color: Colors.grey[400],
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      const SizedBox(height: 200),

                      // google + apple sign in buttons
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // google button
                          InkWell(
                            onTap: signInWithKakao,
                            child: Image.asset(
                              'assets/images/icons/kakao_login.png',
                              height: 75,
                            ),
                          ),

                          const SizedBox(width: 15),

                          // // apple button
                          // InkWell(
                          //   onTap: signInWithGoogle,
                          //   child: Image.asset(
                          //     'lib/images/btn_google_signin_light_pressed_web@2x.png',
                          //     height: 75,
                          //   ),
                          // ),
                        ],
                      ),

                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
