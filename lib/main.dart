import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => TokenState(),
      child: MaterialApp(
        title: 'Ocean Data Super-Resolution Visualization Task Management System',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Scaffold(
          body: MyHomePage()
        ),
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("Home Page");
  }
  
}

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("Task List Page");
  }
  
}

class _MyHomePageState extends State<MyHomePage> {

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const HomePage();
        break;
      case 1:
        page = const TaskListPage();
        break;
      case 2:
        page = const UserPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Row(
      children: [
        SafeArea(
            child: NavigationRail(
              extended: true,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.format_list_bulleted),
                  label: Text('Task List'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person),
                  label: Text('user'),
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          ),
          Expanded(child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          )
      ],
    );
  }
}

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  @override
  Widget build(BuildContext context) {

    var tokenState = context.watch<TokenState>();

    if (tokenState.token == null) {
      return Column(
        children: [
          const Text("Not Login"),
          UserLoginPage(setTokenCallback: () { 
            setState(() {
                tokenState.token = "user";
              });
          },),
        ],
      );
    } else {
      return Column(
        children: [
          const Text("In Login"),
          TextButton(
            onPressed: () {
              setState(() {
                tokenState.token = null;
              });
            }, 
            child: const Text("Exit Login")
          )
        ],
      );
    }
  }
}

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({super.key, required this.setTokenCallback});

  final VoidCallback setTokenCallback;

  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
  
  void setToken() {
    setTokenCallback();
  }
}

class _UserLoginPageState extends State<UserLoginPage> {
  
  @override
  Widget build(BuildContext context) {
    return UserLoginForm(setTokenCallBack: () {
      widget.setToken();
    },);
  }
}

class UserLoginForm extends StatefulWidget {
  const UserLoginForm({super.key, required this.setTokenCallBack});

  final VoidCallback setTokenCallBack;

  @override
  State<UserLoginForm> createState() => _UserLoginFormState();
  
  void setToken() {
    setTokenCallBack();
  }
}

class TokenState extends ChangeNotifier {
  String? token;
}

class _UserLoginFormState extends State<UserLoginForm> {

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<bool> fetchData(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (password == "crey") {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        TextFormField(
          controller: _usernameController,
        ),
        TextFormField(
          controller: _passwordController,
        ),
        TextButton(
          onPressed: () async {
            bool status = await fetchData(_usernameController.text, _passwordController.text);
            if (status) {
              widget.setToken();
            }
          }, 
          child: const Text("login")
        ),
      ],
    );
  }
}
