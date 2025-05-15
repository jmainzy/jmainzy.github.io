import 'package:portfolio_website/pages/home_page.dart';
import 'package:portfolio_website/pages/podcast_page.dart';

class Routes {
  static const home = '/';
  static const podcast = '/podcast';

  final routes = {
    home: (context) => const HomePage(
          title: '',
        ),
    podcast: (context) => const PodcastPage(
          title: 'Podcast',
        ),
  };
}
