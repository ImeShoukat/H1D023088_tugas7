import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'sidemenu.dart'; 

class MusicPage extends StatefulWidget {
  const MusicPage({super.key});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {

  final player = AudioPlayer();
  
  bool isPlaying = false;
  Duration duration = Duration.zero; 
  Duration position = Duration.zero; 
  @override
  void initState() {
    super.initState();
    
    player.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    player.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    player.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });

    _playMusic();
  }

  void _playMusic() async {
    await player.play(AssetSource('Multo - Cup of Joe (Official Lyric Video) - Cup of Joe.mp3'));
  }

  @override
  void dispose() {
    player.stop();
    player.dispose(); 
    super.dispose();
  }

  
  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    
    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], 
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0,
        title: const Text('Music Player', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white), // Icon back putih
      ),
      drawer: const Sidemenu(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
                image: const DecorationImage(
                  image: AssetImage('assets/multo-cover.jpg'), 
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              'Multo', 
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Cup of Joe', 
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 30),

            Slider(
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              activeColor: Color(0xFF1DB954), 
              inactiveColor: Colors.grey[800], 
              onChanged: (value) async {
                final position = Duration(seconds: value.toInt());
                await player.seek(position);
                
              },
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatTime(position), style: const TextStyle(color: Colors.white)),
                  Text(_formatTime(duration), style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            CircleAvatar(
              radius: 35,
              backgroundColor: Color(0xFF1DB954),
              child: IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                iconSize: 40,
                onPressed: () async {
                  if (isPlaying) {
                    await player.pause();
                  } else {
                    await player.resume();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}