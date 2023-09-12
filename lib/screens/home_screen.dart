import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:wodada/components/login_platform.dart';

import 'package:wodada/layout/default_layout.dart';
import 'package:wodada/components/components.dart';

import 'package:wodada/screens/login_screen.dart';
import 'package:wodada/screens/signup_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String id = 'home_screen';

  @override
  State<HomeScreen> createState() => _LoginState();
}

class _LoginState extends State<HomeScreen> {
  bool _isLogin = false;
  final LoginPlatform _loginPlatform = LoginPlatform.none;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // const TopScreenImage(screenImageName: 'home.jpg'),
              const SizedBox(
                height: 100,
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 15.0, left: 15, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: Alignment.topLeft, // 화면 상단 좌측으로 정렬
                        child: ScreenTitle(title: '꽃길만 걷자'),
                      ),
                      const Text(
                        '우다다',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 32,
                        ),
                      ),
                      const SizedBox(
                        height: 200,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // google button
                          InkWell(
                            onTap: signInWithKakao,
                            child: Image.asset(
                              'assets/images/icons/kakao_btn.png',
                              height: 65,
                            ),
                          ),

                          const SizedBox(width: 15),

                          // // apple button
                          InkWell(
                            onTap: signInWithKakao,
                            child: Image.asset(
                              'assets/images/icons/naver_btn.png',
                              height: 65,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 25,
                      ),

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     IconButton(
                      //       onPressed: () {},
                      //       icon: CircleAvatar(
                      //         radius: 25,
                      //         child: Image.asset(
                      //             'assets/images/icons/facebook.png'),
                      //       ),
                      //     ),
                      //     IconButton(
                      //       onPressed: () {},
                      //       icon: CircleAvatar(
                      //         radius: 25,
                      //         backgroundColor: Colors.transparent,
                      //         child:
                      //             Image.asset('assets/images/icons/google.png'),
                      //       ),
                      //     ),
                      //     IconButton(
                      //       onPressed: () {},
                      //       icon: CircleAvatar(
                      //         radius: 25,
                      //         child: Image.asset(
                      //             'assets/images/icons/linkedin.png'),
                      //       ),
                      //     ),
                      //   ],
                      // )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
