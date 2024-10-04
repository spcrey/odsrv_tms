import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "data.dart";

void main() {
  runApp(const MyApp());
}

class AppState extends ChangeNotifier {
  String? token;
  User? user;
  List<Task> tasks = [
    Task("task1", 
      status: TaskStatus.queueing, 
      dateTime: DateTime(2002), 
      type: TaskType.training, 
    ),
    Task("task2", 
      status: TaskStatus.inProgress, 
      dateTime: DateTime(2005), 
      type: TaskType.evaluation, 
    ),
    Task("task3", 
      status: TaskStatus.completed, 
      dateTime: DateTime(2008), 
      type: TaskType.visualation, 
    ),
  ];

  setToken(String token) {
    this.token = token;
    notifyListeners();
  }

  clearToken() {
    token = null;
    notifyListeners();
  }

  setUser(User user) {
    this.user = user;
    notifyListeners();
  }

  clearUser() {
    user = null;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: "Ocean Data Super-Resolution Visualization Task Management System",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Scaffold(
          body: MenuPage(),
        ),
      ),
    );
  }
}

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  var selectedIndex = 0;

  Widget selectPageByIndex(int selectedIndex) {
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
        throw UnimplementedError("no widget for $selectedIndex");
    }
    return page;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SafeArea(
            child: NavigationRail(
              backgroundColor: const Color.fromARGB(255, 117, 180, 231),
              extended: true,
              minWidth: 72,
              minExtendedWidth: 192,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text("Home",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.format_list_bulleted),
                  label: Text("Task List",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person),
                  label: Text("User",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
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
              child: selectPageByIndex(selectedIndex),
            ),
          )
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: const Placeholder(),
    );
  }
}

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task List Page"),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewTaskPage()),
              );
            }, 
            child: const Text("add"),
          ),
          const ListPage(),
        ],
      ),
    );
  }
}

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return SizedBox(
      height: 320,
      child: ListView(
      children: [
        for (var task in appState.tasks)
          ListTile(
            title: TaskItem(task: task),
          )
      ],
    ),
    );
  }
}

class TaskItem extends StatelessWidget {
  const TaskItem({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(task.name),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailPage(
                  task: task,
                )
              ),
            );
        }, 
          child: const Text("detail")
        ),
      ],
    );
  }
}

class TaskDetailPage extends StatelessWidget {
  final Task task;

  const TaskDetailPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.name),
      ),
      body: TextButton(
        onPressed: () {
          Navigator.pop(context);
        }, 
        child: const Text("back")
      ),
    ); 
  }
  
}

class NewTaskPage extends StatefulWidget {
  const NewTaskPage({super.key});

  @override
  State<NewTaskPage> createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  Future<bool> submit() async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Task Page"),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () async {
              if (await submit()) {
                setState(() {
                  Navigator.pop(context);
                });
              }
            }, 
            child: const Text("submit")
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            }, 
            child: const Text("cancel")
          ),
        ],
      ),
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
    var appState = context.watch<AppState>();
    if (appState.token == null) {
      return const UserLoginPage();
    } else {
      return const UserInfoPage();
    }
  }
}

class UserLoginPage extends StatelessWidget {
  const UserLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Login Page"),
      ),
      body: const UserLoginForm(),
    );
  }
}

class UserLoginForm extends StatefulWidget {
  const UserLoginForm({super.key});

  @override
  State<UserLoginForm> createState() => _UserLoginFormState();
}

class _UserLoginFormState extends State<UserLoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<User?> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (username == "spcrey" && password == "crey199854") {
      return User("Crey",
        phoneNumber: "18243280995"
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return Column(
      children: [
        Row(
          children: [
            const Card(
              child: Text("username"),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 240,
              child: TextFormField(
                controller: _usernameController,
              ),
            )
          ],
        ),
        Row(
          children: [
            const Text("password"),
            const SizedBox(width: 10),
            SizedBox(
              width: 240,
              child: TextFormField(
                controller: _passwordController,
              ),
            )
          ],
        ),
        TextButton(
          onPressed: () async {
            User? user = await login(_usernameController.text, _passwordController.text);
            if (user != null) {
              appState.setToken("token");
              appState.setUser(user);
            }
          }, 
          child: const Text("login")
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserRegisterPage()),
            );
          }, 
          child: const Text("register"),
        ),
      ]
    );
  }
}

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({super.key});

  Future<bool> logout() async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Info Page"),
      ),
      body: Column(
        children: [
          const Text("user"),
          TextButton(
            onPressed: () async {
              if (await logout()) {
                appState.clearToken();
                appState.clearUser();
              }
            }, 
            child: const Text("logout"),
          ),
        ],
      ),
    );
  }
}

class UserRegisterPage extends StatefulWidget {
  const UserRegisterPage({super.key});

  @override
  State<UserRegisterPage> createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends State<UserRegisterPage> {
  final _usernameController = TextEditingController();
  final _firstPasswordController = TextEditingController();
  final _secondPasswordController = TextEditingController();

  Future<bool> register(String username, String firstPassword, String secondPassword) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Register Page"),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: _usernameController,
          ),
          TextFormField(
            controller: _firstPasswordController,
          ),
          TextFormField(
            controller: _secondPasswordController,
          ),
          TextButton(
            onPressed: () async {
              if (await register(_usernameController.text, _firstPasswordController.text, _secondPasswordController.text)) {
                setState(() {
                  Navigator.pop(context);
                });
              }
            }, 
            child: const Text("register")
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            }, 
            child: const Text("back")
          ),
        ],
      ),
    );
  }
}
