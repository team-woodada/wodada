import 'package:flutter/material.dart';
import 'package:wodada/common/colors.dart';

class CustomTextFormField extends StatelessWidget {
  //null값일 경우를 대비
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autoFocus;
  final ValueChanged<String>? onChanged;
  final double? height; // 높이 파라미터 추가

  const CustomTextFormField({
    required this.onChanged,
    this.obscureText = false,
    this.autoFocus = false,
    this.hintText,
    this.errorText,
    this.height, // 높이 파라미터 추가
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: GREY_COLOR,
        width: 1.0,
      ),
    );

    return SizedBox(
      // 높이 조절을 위해 SizedBox로 감싸기
      height: height ?? 50, // 높이 파라미터 사용 또는 기본값인 60 사용
      child: TextFormField(
        cursorColor: PRIMARY_COLOR,
        //pwd 입력시 자동 필터링
        obscureText: obscureText,
        autofocus: autoFocus,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          hintText: hintText,
          errorText: errorText,
          hintStyle: const TextStyle(
            color: BODY_TEXT_COLOR,
            fontSize: 14,
          ),
          fillColor: Colors.white,
          //false - 배경색 있음 , true - 배경색 없음
          filled: true,
          //모든 input 상태의 기본 스타일 세팅
          border: baseBorder, // 여기서 baseBorder를 사용합니다.
          focusedBorder: baseBorder.copyWith(
            borderSide: baseBorder.borderSide.copyWith(
              color: PRIMARY_COLOR,
            ),
          ),
        ),
      ),
    );
  }
}

// 💡사용법
// CustomTextFormField(
//   hintText : '사용하고 싶은 말 (placeholder와 같이 사용)',
//   onChanged : (String value) {},
//   obscureText : true
// )