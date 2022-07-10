import 'package:flutter/material.dart';
import 'package:latesttutorapp/favouritescreen.dart';
import 'package:latesttutorapp/loginscreen.dart';
import 'package:latesttutorapp/models/user.dart';
import 'package:latesttutorapp/profilescreen.dart';
import 'package:latesttutorapp/subjectscreen.dart';
import 'package:latesttutorapp/subsribescreen.dart';
import 'package:latesttutorapp/tutorsscreen.dart';

//void main() => runApp(const MyApp());

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late double screenHeight, screenWidth, resWidth;
  late List<Widget> _tabChildren;

  @override
  void initState() {
    super.initState();
    _tabChildren = <Widget>[
      SubjectScreen(user: widget.user),
      const TutorScreen(),
      const SubscribeScreen(),
      const FavouriteScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      //rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      //rowcount = 3;
    }
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            child: const Icon(Icons.arrow_back_ios),
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LoginScreen()))),
        title: const Text('My Tutor',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Colors.cyan,
      ),
      body: /*Center(child: _tabChildren.elementAt(_selectedIndex),),*/
          //_tabChildren[_selectedIndex],
          IndexedStack(
        index: _selectedIndex,
        children: _tabChildren,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.cyan,
        selectedItemColor: Colors.redAccent[700],
        unselectedIconTheme: const IconThemeData(
          color: Colors.white,
        ),
        unselectedItemColor: Colors.white,
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        onTap: _onTabTapped,
        currentIndex: _selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.subject),
            label: 'Subjects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            label: 'Tutors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Subscribe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
