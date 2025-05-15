import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:portfolio_website/models/episode.dart';
import 'package:portfolio_website/utils/dimens.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

Logger log = Logger();

class PodcastPage extends StatefulWidget {
  const PodcastPage({super.key, required this.title});

  final String title;

  @override
  State<PodcastPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<PodcastPage> {
  final Xml2Json xml2json = Xml2Json();
  late Future<List<Episode>> futureEpisodes;
  late String imageUrl;

  @override
  void initState() {
    super.initState();
    futureEpisodes = getEpisodes();
  }

  Future<List<Episode>> getEpisodes() async {
    final url = Uri.parse('https://anchor.fm/s/104a3b45c/podcast/rss');
    log.d("fetching episodes from $url ...");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      xml2json.parse(response.body);
      var jsonString = xml2json.toGData();
      var json = jsonDecode(jsonString);
      var items = json['rss']['channel']['item'];
      imageUrl = json['rss']['channel']['image']['url']['\$t'];
      List<Episode> episodes = [];
      for (var item in items) {
        var episode = Episode.fromJson(item);
        episodes.add(episode);
      }
      log.d("fetched ${episodes.length} episodes");
      return episodes;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load episodes');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Uri homeUrl = Uri.parse('https://jmainzy.github.io');
    final TextStyle headerLinkStyle =
        Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          automaticallyImplyLeading: false,
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
            const SizedBox(width: Dimens.marginLarge)
          ],
        ),
        body: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          bool wide = viewportConstraints.maxWidth > 800;
          return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
                minWidth: viewportConstraints.maxWidth,
              ),
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: wide
                          ? min(100 + viewportConstraints.maxWidth * .25,
                              viewportConstraints.maxWidth * .2)
                          : Dimens.marginLarge),
                  child: FutureBuilder(
                      future: futureEpisodes,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        final List<Episode>? episodes = snapshot.data;
                        return snapshot.hasData &&
                                episodes != null &&
                                episodes.isNotEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    const SizedBox(
                                      height: Dimens.marginLarge,
                                    ),
                                    Text(
                                        'Mvskoke Vmvhayepvs: Teach Me Muscogee',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge!
                                            .copyWith(color: Colors.black)),
                                    const SizedBox(
                                      height: Dimens.marginLarge,
                                    ),
                                    Image.asset(
                                      'assets/podcast-cover.png',
                                      height: 400,
                                    ),
                                    const SizedBox(
                                      height: Dimens.marginLarge,
                                    ),
                                    Text('Episodes',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall!
                                            .copyWith(color: Colors.black)),
                                    const SizedBox(
                                      height: Dimens.marginShort,
                                    ),
                                    Expanded(
                                        child: ListView.builder(
                                      itemCount: episodes.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: PodcastCard(
                                              episode: episodes[index]),
                                        );
                                      },
                                    ))
                                  ])
                            : snapshot.hasError
                                ? Center(
                                    child: Text(
                                      "Error fetching episodes: ${snapshot.error}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  )
                                : const Center(
                                    child: CircularProgressIndicator());
                      })));
        }));
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url, webOnlyWindowName: "_self")) {
      throw Exception('Could not launch $url');
    }
  }
}

class PodcastCard extends StatelessWidget {
  const PodcastCard({
    super.key,
    required this.episode,
  });

  final Episode episode;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.marginLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(episode.title,
                style: Theme.of(context).textTheme.headlineSmall!),
            const SizedBox(
              height: Dimens.marginLarge,
            ),
            ElevatedButton(
                onPressed: () => {launchUrl(Uri.parse(episode.audioUrl))},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Listen')),
            const SizedBox(
              height: Dimens.marginShort,
            ),
            Html(
              data: episode.description,
              style: {
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
            ),
            const SizedBox(
              height: Dimens.marginShort,
            ),
          ],
        ),
      ),
    );
  }
}
