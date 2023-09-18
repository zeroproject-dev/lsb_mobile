import 'package:flutter/material.dart';
import 'package:lsb_translator/presentation/providers/user_prodivder.dart';
import 'package:lsb_translator/presentation/widgets/sidebar/sidebar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSidebarOpen = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    var user = context.watch<UserProvider>();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isSidebarOpen = !isSidebarOpen;
          });
        },
        child: Icon(isSidebarOpen ? Icons.close : Icons.menu),
      ),
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              Column(children: [
                const Spacer(),
                Center(
                  child: Text(
                    "Bolivia en señas",
                    style: theme.textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                Image.asset("assets/images/home_image.png"),
                const Spacer(),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        print("Traducir");
                      },
                      child: const Text("Traducir"),
                    ),
                    if (user.isAuth)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/record_video");
                        },
                        child: const Text("Grabar video"),
                      ),
                  ],
                ),
                const Spacer(),
              ]),
              if (isSidebarOpen)
                Container(
                  color: Colors.black.withOpacity(0.8),
                  width: size.width,
                  height: size.height,
                ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                top: 0,
                bottom: 0,
                left: isSidebarOpen ? 0 : -300,
                width: 300,
                child: const SideBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
