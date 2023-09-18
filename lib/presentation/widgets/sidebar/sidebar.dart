import 'package:flutter/material.dart';
import 'package:lsb_translator/presentation/providers/user_prodivder.dart';
import 'package:provider/provider.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    var user = context.watch<UserProvider>();

    var decorationRadius = const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          width: 300,
          height: double.infinity,
          decoration: decorationRadius,
          child: Column(children: [
            const SizedBox(height: 20),
            const Text(
              "Configuración",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.normal,
              ),
            ),
            if (user.isAuth)
              Column(
                children: [
                  _SidebarItem(
                    title: "Perfil",
                    icon: Icons.account_circle,
                    onTap: () {
                      Navigator.pushNamed(context, "/profile");
                    },
                  ),
                  _SidebarItem(
                    title: "Manual",
                    icon: Icons.menu_book,
                    onTap: () {
                      Navigator.pushNamed(context, "/manual");
                    },
                  ),
                  if (user.userConfiguration.isBiometricAvailible)
                    ListTile(
                      leading: const SizedBox(
                        height: 40,
                        width: 40,
                        child: Icon(
                          Icons.fingerprint,
                          color: Colors.black,
                        ),
                      ),
                      title: Row(
                        children: [
                          const Text(
                            "Activar biometrico",
                            style: TextStyle(color: Colors.black),
                          ),
                          Switch(
                            value: user.userConfiguration.isBiometricActive,
                            onChanged: (bool newValue) {
                              setState(() {
                                user.userConfiguration.isBiometricActive =
                                    newValue;
                                user.userConfiguration.save();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            const Spacer(),
            _SidebarItem(
              title: "Limpiar",
              icon: Icons.menu_book,
              onTap: () {
                user.reset();
              },
            ),
            if (!user.isAuth)
              _SidebarItem(
                  title: "Ingresar",
                  icon: Icons.login,
                  onTap: () {
                    Navigator.pushReplacementNamed(context, "/login");
                  }),
            if (user.isAuth)
              _SidebarItem(
                  title: "Salir",
                  icon: Icons.exit_to_app,
                  onTap: () {
                    user.logout();
                  }),
            const SizedBox(height: 30),
          ]),
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function()? onTap;
  final Color baseColor;

  const _SidebarItem({
    required this.title,
    required this.icon,
    required this.onTap,
    color,
  }) : baseColor = color ?? Colors.black;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListTile(
        leading: SizedBox(
          height: 40,
          width: 40,
          child: Icon(
            icon,
            color: baseColor,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(color: baseColor),
        ),
        onTap: onTap,
      ),
    );
  }
}
