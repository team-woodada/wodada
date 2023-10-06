import 'package:flutter/material.dart';
import 'package:wodada/common/colors.dart';
import 'package:wodada/common/texts.dart';
import 'package:wodada/components/custom_text_form_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  static String id = 'signup_screen';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  String selectedGender = 'Male'; // Default gender
  DateTime selectedDate = DateTime.now(); // Default date
  String selectedAgeGroup = '10대'; // Default age group

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> ageGroups = [
      '10대',
      '20대',
      '30대',
      '40대',
      '50대',
      '60대',
      '70대',
      '기타',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '정보입력',
          style: TextStyle(
            color: TITLE_COLOR,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      bottomNavigationBar: const BottomAppBar(
        color: GREY_COLOR,
        elevation: 3,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // "보호자 정보 입력" 텍스트 추가
              const BoldText(
                text: '보호자 정보 입력',
                fontSize: 24,
              ),
              const SizedBox(
                height: 24,
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    // 프로필 사진을 표시하는 CircleAvatar
                    const CircleAvatar(
                      radius: 40, // 동그라미 크기 조절
                      backgroundImage:
                          NetworkImage('프로필 사진 URL'), // 프로필 사진 URL로 변경
                    ),
                    const SizedBox(height: 10), // 간격 조절
                    ElevatedButton(
                      onPressed: () {
                        // 프로필 사진 등록 버튼 클릭 시 이벤트 처리
                        // 프로필 사진 업로드 기능을 구현할 수 있습니다.
                      },
                      child: const Text('프로필 사진 등록'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const BoldText(
                text: '*닉네임(필수)',
              ),
              const SizedBox(
                height: 5,
              ),
              CustomTextFormField(
                hintText: '닉네임을 입력해주세요',
                onChanged: (String value) {},
              ),
              const SizedBox(height: 20),
              const BoldText(
                text: '*연령대',
              ),
              const SizedBox(
                height: 5,
              ),
              DropdownButton<String>(
                value: selectedAgeGroup,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedAgeGroup = newValue ?? '10대'; // Handle null case
                  });
                },
                items: ageGroups.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16, // 폰트 크기 조절
                        color: Colors.black, // 폰트 색상
                      ),
                    ),
                  );
                }).toList(),
              ),
              ListTile(
                title: const Text('성별'),
                trailing: DropdownButton<String>(
                  value: selectedGender,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGender = newValue ?? 'Male'; // Handle null case
                    });
                  },
                  items: <String>['Male', 'Female', 'Other']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              ListTile(
                title: const Text('생년월일'),
                subtitle: Text(
                  "${selectedDate.toLocal()}".split(' ')[0],
                  style: const TextStyle(
                      fontSize: 55, fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(
                  Icons.calendar_today,
                  size: 80,
                  color: Colors.blue,
                ),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 20),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // 회원가입 버튼 클릭 시 이벤트 처리
                  String name = nameController.text;
                  String nickname = nicknameController.text;
                  // 성별과 생년월일은 각각 selectedGender와 selectedDate에서 가져올 수 있습니다.
                  // 이 정보를 서버로 보내거나 다른 작업을 수행할 수 있습니다.

                  // 예를 들어, 정보 출력
                  print('이름: $name');
                  print('닉네임: $nickname');
                  print('성별: $selectedGender');
                  print('생년월일: $selectedDate');
                  print('연령대: $selectedAgeGroup');
                },
                child: const Text('회원가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
