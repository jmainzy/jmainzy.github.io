import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:markdown/markdown.dart' hide Text;
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

Logger log = Logger();

class MarkdownWidget extends StatelessWidget {
  final String data;
  final Map<String, String>? links;
  const MarkdownWidget({super.key, required this.data, this.links});

  @override
  Widget build(BuildContext context) {
    final htmlData = markdownToHtml(data);
    log.d("MarkdownWidget: $htmlData");
    return Column(
      children: [
        Html(
          data: markdownToHtml(htmlData),
          extensions: [
            TagWrapExtension(
              tagsToWrap: {'a'},
              builder: (child) {
                return child;
              },
            ),
          ],
          style: {
            "a": Style(
              color: Colors.blue,
              textDecoration: TextDecoration.none,
            ),
            'p': Style(
              margin: Margins.symmetric(vertical: 8),
              padding: HtmlPaddings.zero,
            ),
            'body': Style.fromTextStyle(
              Theme.of(context).textTheme.bodyMedium!,
            ).copyWith(
              margin: Margins.symmetric(vertical: 8),
              padding: HtmlPaddings.zero,
            ),
          },
          onLinkTap: (url, _, __) async {
            if (url != null && await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url),
                  mode: LaunchMode.externalApplication);
            }
          },
        ),
        links != null
            ? Row(
                children: links!.entries.map((entry) {
                  return ElevatedButton(
                    onPressed: () => launchUrl(Uri.parse(entry.value)),
                    child: Text(
                      entry.key,
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  );
                }).toList(),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
