import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:love/app/core/common/constants/constants.dart';
import 'package:love/app/features/home/view/controller/content_controller.dart';
import 'package:love/app/features/home/view/screens/content_page.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class SubjectPage extends StatelessWidget {
  const SubjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ContentController contentController = Get.find<ContentController>();
    return Obx(
      () => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {
                contentController.searchQuery.value = value;
              },
              decoration: InputDecoration(
                labelText: 'بحث',
                labelStyle: TextStyle(color: Colors.black45),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.black45, width: 1),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onPrimary,
                    width: 2,
                  ),
                ),
              ),
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),

          // 🧾 Filtered List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: contentController.filteredGroups.length,
              itemBuilder: (context, index) {
                final item = contentController.filteredGroups[index];
                final title = (item["title"] ?? '')
                    .replaceAll('&nbsp;', ' ')
                    .trim();

                return ZoomTapAnimation(
                  child: Card(
                    color: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      leading: SvgPicture.asset(
                        'assets/svgs/books.icon.svg',
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.onPrimary,
                          BlendMode.srcIn,
                        ),
                      ),

                      // 🟡 Highlight search text in title
                      title: _buildHighlightedText(
                        title,
                        contentController.searchQuery.value,
                      ),

                      trailing: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: Constants.containerBoxDecoration(context),
                        child: Text(
                          item["page"].toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContentPage(
                              bookId: 1,
                              bookName: 'الحبوة في مناسك الحجّ والعمرة',
                              scrollPosetion:
                                  (double.tryParse(item["page"].toString())! -
                                  1),
                              searchWord: '',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildHighlightedText(String text, String query) {
  if (query.isEmpty) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        color: Colors.black,
        fontFamily: 'dijlah',
      ),
    );
  }

  final lowerText = text.toLowerCase();
  final lowerQuery = query.toLowerCase();
  final startIndex = lowerText.indexOf(lowerQuery);

  if (startIndex == -1) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        color: Colors.black,
        fontFamily: 'dijlah',
      ),
    );
  }

  final endIndex = startIndex + query.length;

  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: text.substring(0, startIndex),
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontFamily: 'dijlah',
          ),
        ),
        TextSpan(
          text: text.substring(startIndex, endIndex),
          style: const TextStyle(
            fontSize: 12,
            color: Colors.red, // Highlight color
            fontFamily: 'dijlah',
            fontWeight: FontWeight.w700,
          ),
        ),
        TextSpan(
          text: text.substring(endIndex),
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontFamily: 'dijlah',
          ),
        ),
      ],
    ),
  );
}
