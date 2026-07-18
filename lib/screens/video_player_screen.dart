import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../main.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;
  VideoPlayerScreen(this.videoUrl, this.title);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController videoController;
  ChewieController? chewieController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    videoController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    videoController.initialize().then((_) {
      setState(() {
        chewieController = ChewieController(
          videoPlayerController: videoController,
          autoPlay: true,
          looping: false,
          materialProgressColors: ChewieProgressColors(playedColor: AppColors.primary, handleColor: AppColors.primary, bufferedColor: Colors.white24),
        );
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    videoController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, foregroundColor: Colors.white, elevation: 0, title: Text(widget.title, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600))),
      body: Center(
        child: isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator(color: AppColors.primary), SizedBox(height: 16), Text("Loading video...", style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13))],
              )
            : Chewie(controller: chewieController!),
      ),
    );
  }
}