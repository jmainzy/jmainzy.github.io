import 'dart:math';

import 'package:flutter/material.dart';
import 'package:portfolio_website/utils/dimens.dart';
import 'package:portfolio_website/utils/markdown_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final Uri githubUrl = Uri.parse('https://github.com/jmainzy');
    final Uri cvUrl = Uri.parse('assets/cv_juliamainzinger.pdf');
    final Uri homeUrl = Uri.parse('https://jmainzy.github.io');
    final TextStyle headerLinkStyle =
        Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          titleTextStyle: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          centerTitle: false,
          actions: [
            TextButton(
                onPressed: () => _launchUrl(homeUrl),
                child: Text(
                  "Home",
                  style: headerLinkStyle,
                )),
            // TODO: Finish podcast page
            // TextButton(
            //     onPressed: () => Navigator.pushNamed(context, '/podcast'),
            //     child: Text(
            //       "Podcast",
            //       style: headerLinkStyle,
            //     )),
            const SizedBox(width: Dimens.marginLarge)
          ],
        ),
        body: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          bool wide = viewportConstraints.maxWidth > 800;
          return SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                  minWidth: viewportConstraints.maxWidth,
                ),
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: wide
                            ? min(100 + viewportConstraints.maxWidth * .25,
                                viewportConstraints.maxWidth * .2)
                            : Dimens.marginLarge,
                        vertical: Dimens.marginLarge * 2),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: wide
                                  ? CrossAxisAlignment.center
                                  : CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      !wide
                                          ? const SizedBox(
                                              height: Dimens.marginLarge * 2,
                                            )
                                          : Container(),
                                      !wide
                                          ? Center(
                                              child: avatar(
                                                  viewportConstraints.maxWidth))
                                          : Container(),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: Dimens.marginShort),
                                          child: Text(
                                            "Hi, I'm Julia",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge,
                                            textAlign: TextAlign.start,
                                          )),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: Dimens.marginShort),
                                          child: Text(
                                            "Mobile App Developer | Computational Linguist",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                            textAlign: TextAlign.start,
                                          )),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: Dimens.marginLarge),
                                          child: Text(
                                            "I’m passionate about language revitalization, speech technology, "
                                            "and great mobile apps.  ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                            textAlign: TextAlign.start,
                                          )),
                                      Row(children: [
                                        ElevatedButton(
                                            onPressed: () =>
                                                {_launchUrl(githubUrl)},
                                            child: const Text("Github")),
                                        const SizedBox(
                                          width: Dimens.marginLarge,
                                        ),
                                        ElevatedButton(
                                            onPressed: () =>
                                                {_launchUrl(cvUrl)},
                                            child: const Text("CV")),
                                        const SizedBox(
                                          width: Dimens.marginLarge,
                                        ),
                                        ElevatedButton(
                                            onPressed: () => {
                                                  _launchUrl(
                                                      "https://medium.com/@juliamainzinger")
                                                },
                                            child: const Text("Blog"))
                                      ])
                                    ])),
                                wide
                                    ? avatar(viewportConstraints.maxWidth)
                                    : Container()
                              ]),
                          const SizedBox(
                            height: Dimens.marginLarge * 2,
                          ),
                          Text('Publications',
                              style: Theme.of(context).textTheme.headlineLarge),
                          const MarkdownWidget(
                            data:
                                '''**Fine-Tuning ASR models for Very Low-Resource Languages: 
                                A Study on Mvskoke.**  
                                Julia Mainzinger and Gina-Anne Levow. 2024. 
                                In *Proceedings of the 62nd Annual Meeting of the Association for Computational Linguistics (Volume 4: Student Research Workshop)*, 
                                pages 76–82, Bangkok, Thailand. Association for Computational Linguistics.
                                ''',
                            links: {
                              'Paper':
                                  'https://aclanthology.org/2024.acl-srw.16/'
                            },
                          ),
                          const MarkdownWidget(
                            data:
                                '''**Technology and Language Revitalization: A Roadmap for the Mvskoke Language.**   
                                Julia Mainzinger. 2024. 
                                In Proceedings of the Seventh Workshop on the Use of Computational Methods in 
                                the Study of Endangered Languages, pages 7–12, St. Julians, Malta. 
                                Association for Computational Linguistics.
                                ''',
                            links: {
                              'Paper':
                                  'https://aclanthology.org/2024.computel-1.2/'
                            },
                          ),
                          const SizedBox(
                            height: Dimens.marginLarge * 2,
                          ),
                          Text('Projects',
                              style: Theme.of(context).textTheme.headlineLarge),
                          const MarkdownWidget(
                            data: '''**Hymnal App**   
                                A cross-platform mobile app built with Flutter. The app includes audio recordings of songs, with lyrics in Mvskoke and English.
                                ''',
                            links: {
                              'View':
                                  'https://apps.apple.com/us/app/mvskoke-hymnal/id6744351706'
                            },
                          ),
                          const MarkdownWidget(
                            data: '''**Dictionary Apps**   
                                I have built several dictionary apps for endangered languages. These apps include search, definition, and audio recordings.
                                ''',
                            links: {
                              'View':
                                  'https://apps.apple.com/us/app/muscogee-language-dictionary/id6478943862'
                            },
                          ),
                          const MarkdownWidget(
                            data: '''**Podcast**   
                                A podcast for Mvskoke language learning using recordings from fluent speakers. For the production of this podcast, I have developed various tools 
                                for audio editing and speech enhancement.
                                ''',
                            links: {
                              'Listen':
                                  'https://creators.spotify.com/pod/profile/julia-mainzinger'
                            },
                          ),
                          const MarkdownWidget(
                            data: '''**Language Technology Research**   
                                I research technology for Indigenous language revitalization, with the goal of 
                                designing practical tools alongside the Mvskoke community. Checkout my blog
                                for the most up-to-date details.
                                ''',
                            links: {
                              'Read More': 'https://medium.com/@juliamainzinger'
                            },
                          ),
                          const SizedBox(
                            height: Dimens.marginLarge * 2,
                          ),
                          Text('Contact',
                              style: Theme.of(context).textTheme.headlineLarge),
                          const MarkdownWidget(
                            data:
                                '''I am always interested in hearing about new opportunities.  
                                My research is focused on technology for 
                                language revitalization. My practical skills include Flutter and 
                                Android app development, Python, AI model usage and training, 
                                and more. If you would like to get in touch, please reach out!
                                ''',
                            links: {
                              'Email': 'mailto: juliamainzinger@gmail.com'
                            },
                          ),
                          const SizedBox(
                            height: Dimens.marginLarge * 2,
                          ),
                        ]))),
          );
        }));
  }

  Widget avatar(double width) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: width * .05),
        child: CircleAvatar(
            radius: min(width * .14, 120),
            backgroundImage: const AssetImage('assets/headshot.jpg')));
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url, webOnlyWindowName: "_self")) {
      throw Exception('Could not launch $url');
    }
  }
}
