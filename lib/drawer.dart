import 'package:blind_spot/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text("Blind Test"),
          ),
          ListTile(
            title: const Text("Device Camera"),
            onTap: () {
              Provider.of<StateManagement>(context, listen: false)
                  .changeView(0);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: const Text("IP Cam Address"),
            onTap: () {
              Provider.of<StateManagement>(context, listen: false)
                  .changeView(1);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: const Text("RTSP"),
            onTap: () {
              Provider.of<StateManagement>(context, listen: false)
                  .changeView(2);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
