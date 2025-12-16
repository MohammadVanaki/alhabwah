import 'package:flutter/material.dart';
import 'package:love/app/core/common/constants/constants.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key, required this.isDrawer});
  final bool isDrawer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isDrawer ? AppBar(title: Text(Constants.appTitle)) : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0), // padding around text
        child: SingleChildScrollView(
          child: Text(
            '''الحبوة في مناسك الحج والعمرة، عبارة عن مسيرة أكثر من واحد وعشرين عامًا في إرشاد الحجّاج والمعتمرين، ومتابعة وتحديث فتاوى المراجع لا سيما المقلّدين في منطقة الخليج، وقد أضيف إليها العديد من الفوائد والإرشادات في كيفية الإرشاد النظري والتطبيقي، مع التنبيه على مواطن يكثر فيها الاشتباه أو الأخطاء.

ابتدأت قصة الكتاب (مسودة شخصية لمرشد مبتدئ)، وتطوّر بشكل متصاعد إلى أن أصبح موطن اطمئنان وثقة كثير من المرشدين في بلدان ومناطق مختلفة، وأمسوا حريصين على مراجعته فيما يحتاجون من مسائل الحج والعمرة.

حرصك على متابعة الإصدار الأخير من الحبوة؛ يزيد في درجة إتقانك لفقه تلك الشعائر والمناسك العظيمة والممتعة، لا سيما إذا اقترن ذلك بقراءة الكتب الأخرى التي كتبها المؤلف في شؤون الحج المختلفة.''',
            textAlign: TextAlign.justify, // justify text
            style: const TextStyle(
              fontSize: 18, // text size
              height: 1.6, // line spacing
              letterSpacing: 0.5, // optional: space between letters
            ),
          ),
        ),
      ),
    );
  }
}
