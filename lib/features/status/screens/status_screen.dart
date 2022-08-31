import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';

import 'package:whatsapp_ui/features/status/models/status_model.dart';

// get status from constructor and show view, do not use provider as no need
class StatusScreen extends StatefulWidget {
  static const String routeName = '/status-screen';
  final StatusModel status; // contains the photoUrl list mainly

  const StatusScreen({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  StoryController storyController = StoryController(); // controller for story view
  List<StoryItem> storyItems = []; // store the story items from status model with initStoryPageItems method

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initStoryPageItems(); // put all the photo urls in storyItems before showing the story view
  }

  void initStoryPageItems() {
    // iterate the photoUrl list items
    for (int i = 0; i < widget.status.photoUrlList.length; i++) {
      storyItems.add(StoryItem.pageImage(
        url: widget.status.photoUrlList[i],
        controller: storyController,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: storyItems.isEmpty // should not be empty unled initStoryPage method wrong so show loader
          ? const Loader()
          : StoryView(
              storyItems: storyItems,
              controller: storyController,
              onComplete: () => Navigator.pop(context),
              onVerticalSwipeComplete: (direction) {
                Navigator.pop(context);
              },
            ),
    );
  }
}
