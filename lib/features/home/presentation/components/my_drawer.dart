import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_socia_media/features/profile/presentation/pages/profile_page.dart';
import 'package:project_socia_media/features/search/presentation/pages/search_page.dart';

import '../../../auth/presentation/cubits/auth_cubits.dart';
import '../../../settings/pages/settings_page.dart';
import 'my_drawer_tile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              // Logo
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Icon(
                  Icons.lock_open_rounded,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              // divider line
              Divider(color: Theme.of(context).colorScheme.secondary),

              // home tile
              MyDrawerTile(
                iconData: Icons.home,
                titleText: "H O M E",
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              // profile tile
              MyDrawerTile(
                iconData: Icons.person,
                titleText: "P R O F I L E",
                onTap: () {
                  Navigator.pop(context);

                  // Get current user .
                  String uid = context.read<AuthCubit>().currentUser!.uid;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        uid: uid,
                      ),
                    ),
                  );
                },
              ),

              // search tile
              MyDrawerTile(
                iconData: Icons.search,
                titleText: "S E A R C H",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchPage(),
                    ),
                  );
                },
              ),

              // settings tile
              MyDrawerTile(
                iconData: Icons.settings,
                titleText: "S E T T I N G S",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
              ),

              const Spacer(),
              // logout tile
              MyDrawerTile(
                iconData: Icons.logout,
                titleText: "L O G O U T",
                onTap: () {
                  context.read<AuthCubit>().logout();
                },
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
