import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:loomi_streaming/core/services/get_movies.dart';
import 'package:loomi_streaming/core/services/index.dart';
import 'package:share_plus/share_plus.dart';

import '../modules/model/movie_model.dart';
import 'movie_player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<MovieModel> listMovies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      var movies = await getMovies();
      setState(() {
        listMovies.addAll(movies);
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PopScope(
        canPop: false,
        child: /*isLoading
          ? const Center(child: CircularProgressIndicator())
          : */Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 60, 16, 0),
              child:  Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.person, color: Colors.transparent),
                      Image.asset('assets/images/splash.png', height: 32),
                      GestureDetector(
                        onTap: (){

                        },
                        child: ClipOval(
                          child: Image.network(
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/8/86/Woman_at_Lover%27s_Bridge_Tanjung_Sepat_%28cropped%29.jpg/1200px-Woman_at_Lover%27s_Bridge_Tanjung_Sepat_%28cropped%29.jpg',
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Now Showing',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
                child: PageView.builder(
                  itemCount: listMovies.length,
                  itemBuilder: (context, index) {
                    final movie = listMovies[index];
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.network(
                              movie.posterUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black87,
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(movie.genre,
                                    style: TextStyle(color: Colors.white70)),
                                Text(
                                  movie.name,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  movie.synopsis,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    OutlinedButton(
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) => MoviePlayerScreen(movieId: movie.id, movieTitle: movie.name, videoUrl: movie.streamLink,))
                                        );
                                      },
                                      style: OutlinedButton.styleFrom(
                                        fixedSize: const Size(207.77, 41.58),
                                        side: const BorderSide(
                                            color: Color(0xFFAA73F0)),
                                        backgroundColor: const Color(0x33BB86FC),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8)),
                                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                      ),
                                      child: const Text("Watch",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color((0xFFBB86FC)))),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      final like = await likeMovie(movie.id);

                                                    },
                                                    child: const Column(
                                                      children: [
                                                        Icon(Icons.thumb_up_alt_outlined, color: Colors.white, size: 20),
                                                        SizedBox(width: 16),
                                                        Text(
                                                          "Rate",
                                                          style: TextStyle(color: Colors.white, fontSize: 10),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(width: 27),
                                              Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Share.share(
                                                        'Check out this movie on our app! 🎬 ${movie.streamLink}',
                                                        subject: '${movie.name}',
                                                      );
                                                    },
                                                    child: const Column(
                                                      children:  [
                                                        Icon(Icons.send, size: 20, color: Colors.white),
                                                        SizedBox(width: 4),
                                                        Text(
                                                          "Gift to someone?",
                                                          style: TextStyle(color: Colors.white, fontSize: 10),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      const Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Available until",
                                            style: TextStyle(color: Colors.white54, fontSize: 12),
                                          ),
                                          Text(
                                            "Feb 29, 2023",
                                            style: TextStyle(
                                              color: Color(0xFFBB86FC),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }
}
