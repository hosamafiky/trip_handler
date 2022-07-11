import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../business_logic/phone_auth/cubit/phone_auth_cubit.dart';
import '../../constants/palette.dart';
import '../../constants/strings.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  Widget _buildDrawerHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 100.0,
          margin: const EdgeInsets.symmetric(
            horizontal: 70.0,
            vertical: 10.0,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[100],
            image: const DecorationImage(
              image: NetworkImage(
                  'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const Text(
          'Hussam Abed',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5.0),
        BlocProvider(
          create: (context) => PhoneAuthCubit(),
          child: Text(PhoneAuthCubit().getUserData().phoneNumber!),
        ),
      ],
    );
  }

  Widget _buildDrawerListItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    Color? color,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? Palette.blue,
      ),
      title: Text(title),
      trailing: trailing ??
          const Icon(
            Icons.arrow_right,
            color: Palette.blue,
          ),
      onTap: onTap,
    );
  }

  Widget _buildDrawerListDivider() {
    return const Divider(
      height: 0.0,
      thickness: 1.0,
      indent: 18.0,
      endIndent: 24.0,
    );
  }

  Widget _buildLogOutBlocItem(BuildContext context) {
    return BlocProvider(
      create: (context) => PhoneAuthCubit(),
      child: _buildDrawerListItem(
        icon: Icons.logout,
        title: 'Logout',
        onTap: () async {
          await PhoneAuthCubit().logOut().then((value) {
            Navigator.pushReplacementNamed(context, loginRoute);
          });
        },
        trailing: const SizedBox.shrink(),
        color: Colors.red,
      ),
    );
  }

  void _lauchUrl(String url) async {
    await canLaunchUrl(Uri.parse(url))
        ? launchUrl(Uri.parse(url))
        : throw 'Connot launch url $url';
  }

  Widget _buildIcon(IconData icon, String url) {
    return IconButton(
      onPressed: () => _lauchUrl(url),
      icon: Icon(
        icon,
        size: 35.0,
        color: Palette.blue,
      ),
    );
  }

  Widget _buildSocialMediaIcons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 15.0),
      child: Row(
        children: [
          _buildIcon(
            FontAwesomeIcons.facebook,
            'https://www.facebook.com/hussamafiky/',
          ),
          const SizedBox(width: 15.0),
          _buildIcon(
            FontAwesomeIcons.telegram,
            'https://t.me/hosamafiky',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 220.0,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue[100]),
              child: _buildDrawerHeader(context),
            ),
          ),
          _buildDrawerListItem(icon: Icons.person, title: 'MyProfile'),
          _buildDrawerListDivider(),
          _buildDrawerListItem(
            icon: Icons.history,
            title: 'Places History',
            onTap: () {},
          ),
          _buildDrawerListDivider(),
          _buildDrawerListItem(icon: Icons.settings, title: 'Settings'),
          _buildDrawerListDivider(),
          _buildDrawerListItem(icon: Icons.help, title: 'Help'),
          _buildDrawerListDivider(),
          _buildLogOutBlocItem(context),
          const Spacer(),
          ListTile(
            title: Text(
              'Follow Us',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          _buildSocialMediaIcons(),
        ],
      ),
    );
  }
}
