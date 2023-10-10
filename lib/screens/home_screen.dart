import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:wodada/common/login_platform.dart';
import 'package:wodada/components/components.dart';

var dio = Dio();

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String id = 'home_screen';

  @override
  State<HomeScreen> createState() => _LoginState();
}

class _LoginState extends State<HomeScreen> {
  bool _isLogin = false;
  String nickName = "";
  String email = "";
  String ageRange = "";
  String gender = "";
  LoginPlatform _loginPlatform = LoginPlatform.none;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> Login() async {
    // 두 번째 API 호출

    try {
      Map<String, dynamic> requestData;

      switch (_loginPlatform) {
        case LoginPlatform.kakao:
          requestData = {
            'email': email,
            'nickname': nickName,
            'ageRange': ageRange.replaceAll('~', '-'),
            'gender': gender == 'female' ? 'F' : 'M',
            'provider': _loginPlatform.toString().split('.').last,
          };
          break;
        case LoginPlatform.naver:
          requestData = {
            'email': email,
            'nickname': nickName,
            'ageRange': ageRange,
            'gender': gender,
            'provider': _loginPlatform.toString().split('.').last,
          };
          break;
        case LoginPlatform.none:
          requestData = {
            'a': 1,
          };
          break;
      }

      // 두 번째 API 호출
      final secondApiResponse = await http.post(
        Uri.parse('http://10.0.2.2:8080/auth/token'), // API 엔드포인트
        body: jsonEncode(requestData), // 데이터를 JSON 형식으로 인코딩하여 요청 바디에 전달
        headers: {
          'Content-Type': 'application/json', // 요청 헤더 설정
        },
      );

      // if (secondApiResponse.statusCode == 200) {
      // 두 번째 API 응답을 처리
      final secondApiData = jsonDecode(secondApiResponse.body);

      final accessToken = secondApiData['accessToken'];
      final refreshToken = secondApiData['refreshToken'];

      print('AccessToken: $accessToken');
      print('RefreshToken: $refreshToken');
      print('request Data: $requestData');
      // 여기에서 두 번째 API 응답을 처리할 수 있음
      // } else {
      //   // 두 번째 API 호출이 실패한 경우 오류 처리
      //   print('API 실패');
      //   throw Exception('Failed to load second API data');
      // }
    } catch (error) {
      print('API 실패 $error');
    }
  }

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

      print(profileInfo['kakao_account']['age_range']);
      print(profileInfo['kakao_account']['gender']);

      setState(() {
        _loginPlatform = LoginPlatform.kakao;
        _isLogin = true;
        email = profileInfo['kakao_account']['email'];
        nickName = profileInfo['properties']['nickname'];
        ageRange = profileInfo['kakao_account']['age_range'];
        gender = profileInfo['kakao_account']['gender'];
      });

      await Login();
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
    }
  }

  void signInWithNaver() async {
    final NaverLoginResult result = await FlutterNaverLogin.logIn().timeout(
        const Duration(seconds: 10),
        onTimeout: () => null as NaverLoginResult);

    if (result.status == NaverLoginStatus.loggedIn) {
      setState(() {
        _loginPlatform = LoginPlatform.naver;
        _isLogin = true;
        email = result.account.email;
        nickName = result.account.nickname;
        ageRange = result.account.age;
        gender = result.account.gender;
      });

      await Login();
    }
  }

  void signOut() async {
    switch (_loginPlatform) {
      case LoginPlatform.kakao:
        signInWithKakao();
        break;
      case LoginPlatform.naver:
        await FlutterNaverLogin.logOut();
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
                      const EdgeInsets.only(right: 10.0, left: 10, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: Alignment.topLeft, // 화면 상단 좌측으로 정렬
                        child: Text(
                          '꽃길만 걷자, 우리!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 32,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        '우다다',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
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
                            onTap: signInWithNaver,
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
