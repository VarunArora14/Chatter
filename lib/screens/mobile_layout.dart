import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/constants/colors.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_ui/features/select_contacts/screens/select_contact_screen.dart';
import 'package:whatsapp_ui/features/chat/widgets/contacts_list.dart';
import 'dart:io';

import 'package:whatsapp_ui/features/status/screens/confirm_status.dart';

// ConsumerStatefulWidget have ref property in them without specifying in build() method
class MobileLayout extends ConsumerStatefulWidget {
  const MobileLayout({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayout> createState() => _MobileLayoutState();
}

// using WidgetsBindingObserver as a mixin
class _MobileLayoutState extends ConsumerState<MobileLayout>
    with WidgetsBindingObserver, TickerProviderStateMixin {
// above mixin for appLifecycleState and vsync for tabController(hover vsync)

  late TabController tabController; // for managin which tab we are on
  void floatingActionButtonPressed(int tabIndex) async {
    // first tab floating button is to choose chat to talk to
    if (tabIndex == 0) {
      Navigator.pushNamed(context, SelectContactScreen.routeName);
    } else if (tabIndex == 1) {
      File? pickedImage = await pickImageFromGallery(context);
      if (pickedImage != null) {
        // post this as status by first sending it to confirmation screen
        Navigator.pushNamed(context, ConfirmStatusScreen.routeName, arguments: pickedImage);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    // make the WidgetsBinding.instance listen to the widget
    WidgetsBinding.instance.addObserver(this); // add this to listen to the widget, hover 'this' to see widget
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // easily allows us to know where our app state is, click above to know more about the 4 states
    // it keeps looking for change in AppLifeCycleState
    // this method will only be called if there is change in the app state
    super.didChangeAppLifecycleState(state);
    // add switch case for handling states to show whether user offline or online
    if (state == AppLifecycleState.resumed) {
      ref.read(authControllerProvider).setUserState(true); // mark the user as online when resumed
    } else {
      ref.read(authControllerProvider).setUserState(false); // for inactive, paused and detached cases
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: const Text(
              'Chatter',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.grey,
                  ))
            ],
            bottom: const TabBar(
                indicatorColor: tabColor,
                indicatorWeight: 4,
                labelColor: tabColor,
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: 'CHATS'),
                  Tab(text: 'STATUS'),
                  Tab(text: 'CALLS'),
                ]),
          ),
          body: TabBarView(controller: tabController, children: const [
            ContactsList(),
            SelectContactScreen(),
            Text('CALLS'),
          ]),
          floatingActionButton: FloatingActionButton(
            onPressed: () => floatingActionButtonPressed(tabController.index),
            backgroundColor: tabColor,
            child: const Icon(
              Icons.comment,
              color: Colors.white,
            ),
          )),
    );
  }
}
/*
we create tabs for chats, status and calls, we have tabController at top of scaffold
whose child appBar having tabbar as bottom for viewing the tabBar and data and inside the body,
we have the TabBarView for viewing data for each tab
*/