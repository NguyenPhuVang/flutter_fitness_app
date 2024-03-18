import 'package:flutter/material.dart';
import 'package:animated_introduction/animated_introduction.dart';

import 'home_survey.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {

  @override
  void initState(){
    super.initState();
  }
  final List<SingleIntroScreen> pages = [
    const SingleIntroScreen(
      title: 'Chào Mừng Bạn Đến Với HealthFit App',
      description: 'Đây là ứng dụng tập luyện khoa học, giúp bạn có thể kết nối '
          'được với những chuyên gia. Họ là những người sẽ cung cấp cho bạn những'
          ' lời khuyên về chế độ tập luyên và dinh dưỡng.',
      imageAsset: 'assets/HeathFit.jpg',
      textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
    ),
    const SingleIntroScreen(
      title: 'Người Bạn Đồng Hành',
      description: 'Những PT sẽ đóng vài trò như một người bạn, đồng hành cùng '
          'bạn trong suốt chặng đường chinh phục một cơ thể khỏe mạnh, như ý.',
      imageAsset: 'assets/fitness.jpg',
      textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
    ),
    const SingleIntroScreen(
      title: 'Nổ Lực Và Thành Công',
      description: 'Không có thành công nào mà không có trở ngại, bạn phải cố gắng thì mới chinh phục được !'
          'Trước khi bắt đầu, hãy làm bảng khảo sát để chúng tôi nắm được nhu cầu của bạn. ',
      imageAsset: 'assets/nopainnogain.jpg',
      textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.normal),

    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedIntroduction(
        slides: pages,

        indicatorType: IndicatorType.circle,
        onDone: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomeSurvey()));
        },
      ),
    );
  }
}