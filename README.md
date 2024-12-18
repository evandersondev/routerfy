BrowserRoutes createBrowserRoutes() {
return BrowserRoutes(
children: [
Route(
path: '/',
builder: (context) => HomePage(),
),
Route(
path: '/login',
builder: (context) => LoginPage(),
),
Route(
path: '/settings',
builder: () => SettingsPage(),
children: [
Route(path: '/profile', builder: (context) => ProfilePage()),
Route(path: '/themes', builder: (context) => ThemesPage()),
]
),
]
);
}

void main() {
setPathUrlStrategy();

runApp(MyApp());
}

class MyApp extends StatelessWidget {
const MyApp({super.key});

@override
Widget build(BuildContext context) {
return RouterfyProvider(
routes: createBrowserRoutes(),
child: MaterialApp(
title: 'Routerfy Example',
initialRoute: '/',
),
);
}
}

class HomePage extends StatefulWidget {
const HomePage({super.key});

@override
State<HomePage> createState() => \_HomePageState();
}

class \_HomePageState extends State<HomePage> {
@override
Widget build(BuildContext context) {
return Scaffold(
body: Center(
child: Column(
spacing: 24,
mainAxisAlignment: MainAxisAlignment.center,
crossAxisAlignment: CrossAxisAlignment.center,
children: [
Text('HOME'),
TextButton(
onPressed: () {
Routerfy.of(context).push('/login');
},
child: Text('L O G I N')),
],
),
),
);
}
}

class SettingsPage extends StatefulWidget {
const SettingsPage({super.key});

@override
State<SettingsPage> createState() => \_SettingsPageState();
}

class \_SettingsPageState extends State<SettingsPage> {
@override
Widget build(BuildContext context) {
return Scaffold(
body: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
crossAxisAlignment: CrossAxisAlignment.center,
children: [
Text('SETTINGS'),
RouterfyOutlet(),
],
),
);
}
}
