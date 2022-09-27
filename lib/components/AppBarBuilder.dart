import 'package:flutter/material.dart';

import '../utils/Env.dart';

class AppBarBuilder extends StatelessWidget with PreferredSizeWidget {
  bool padding;
  bool search;

  Function? filter;
  AppBarBuilder(
      {super.key, this.padding = true, this.search = true, this.filter});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AppBar(
      title: search
          ? TextField(
              onChanged: (val) => filter != null ? filter!(val) : null,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 30, color: Colors.black),
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                prefixIcon: const Icon(
                  size: 40,
                  Icons.search,
                  color: Colors.black,
                ),
                hintStyle: const TextStyle(color: Colors.black),
                hintText: 'Search',
                contentPadding: const EdgeInsets.only(top: 15, right: 40),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            )
          : Text("TSMU ATLAS"),
      centerTitle: true,
      actions: [SunMoon()],
    );
  }
}

class SunMoon extends StatefulWidget {
  const SunMoon({
    Key? key,
  }) : super(key: key);

  @override
  State<SunMoon> createState() => _SunMoonState();
}

class _SunMoonState extends State<SunMoon> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Env.themeState.mode = Theme.of(context).primaryColor == Colors.black
              ? ThemeMode.light
              : ThemeMode.dark;
          setState(() => {});
        },
        icon: Theme.of(context).primaryColor == Colors.black
            ? const Icon(Icons.dark_mode)
            : const Icon(Icons.sunny));
  }
}
