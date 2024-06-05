import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'VendorManagement.dart';
import 'ProductManagement.dart';
import 'OrderManagement.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Institute Configuration Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(), // Start with the login page
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  late SharedPreferences _prefs; // Define _prefs variable
  bool _passwordVisible = false; // Define _passwordVisible variable
  bool _showRegister = false; // Track whether to show the register form

  @override
  void initState() {
    super.initState();
    _initPrefs(); // Initialize _prefs when the state is initialized
  }

  // Initialize SharedPreferences instance
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Simulate a login validation (replace with your authentication logic)
  bool _validateLogin(String username, String password) {
    final savedUsername = _prefs.getString('admin_username');
    final savedPassword = _prefs.getString('admin_password');
    return username == savedUsername && password == savedPassword;
  }

  // Simulate registration (replace with your backend logic)
  void _registerAdmin(String username, String password) {
    // Store username and password securely (e.g., using a database or secure storage)
    _prefs.setString('admin_username', username);
    _prefs.setString('admin_password', password);
    setState(() {
      _showRegister = false; // Hide register form after registration
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You are registered! Please login.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: _showRegister ? _buildRegisterForm(context) : _buildLoginForm(context),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SizeTransition(
              sizeFactor: animation,
              child: child,
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              prefixIcon: Icon(Icons.person), // Username icon
            ),
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: _passwordController,
            obscureText: !_passwordVisible,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock), // Password icon
              suffixIcon: IconButton(
                icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  String username = _usernameController.text;
                  String password = _passwordController.text;
                  if (_validateLogin(username, password)) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Dashboard(username: username)),
                    );
                  } else {
                    // Show an error message for invalid credentials
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Invalid username or password'),
                      ),
                    );
                  }
                },
                child: Text('Login'),
              ),
              SizedBox(width: 10.0),
              TextButton(
                onPressed: () {
                  setState(() {
                    _showRegister = true;
                  });
                },
                child: Text('No account? Register Here'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              prefixIcon: Icon(Icons.person), // Username icon
            ),
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: _passwordController,
            obscureText: !_passwordVisible,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock), // Password icon
              suffixIcon: IconButton(
                icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              String username = _usernameController.text;
              String password = _passwordController.text;
              _registerAdmin(username, password);
            },
            child: Text('Register'),
          ),
        ],
      ),
    );
  }
}


class RegisterAdmin extends StatefulWidget {
  @override
  _RegisterAdminState createState() => _RegisterAdminState();
}

class _RegisterAdminState extends State<RegisterAdmin> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  late SharedPreferences _prefs; // Define _prefs variable

  @override
  void initState() {
    super.initState();
    _initPrefs(); // Initialize _prefs when the state is initialized
  }

  // Initialize SharedPreferences instance
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Simulate registration (replace with your backend logic)
  Future<void> _registerAdmin(String username, String password) async {
    _prefs.setString('admin_username', username);
    _prefs.setString('admin_password', password);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You are registered'),
      ),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Registration'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person), // Username icon
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock), // Password icon
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                String username = _usernameController.text;
                String password = _passwordController.text;
                _registerAdmin(username, password);
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

class Dashboard extends StatelessWidget {
  final String username;

  const Dashboard(
      {Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Vendor Management System'),
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Text(
                    'Welcome, $username!',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ),
            // Replace with your actual dashboard content
            Text('Your vendor management dashboard goes here!'),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); // Close the drawer when back button is pressed
              },
            ),
            title: Text('Vendor Management'),
            automaticallyImplyLeading: false, // Disable the default back button in AppBar
            centerTitle: true,
            elevation: 0.0,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          ListTile(
            leading: Icon(Icons.store), // Vendor Management icon
            title: Text('Vendor Management'),
            onTap: () => _navigateToVendorManagement(context),
          ),
          ListTile(
            leading: Icon(Icons.production_quantity_limits), // Product Management icon
            title: Text('Product Management'),
            onTap: () => _navigateToProductManagement(context),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart), // Order Management icon
            title: Text('Order Management'),
            onTap: () => _navigateToOrderManagement(context),
          ),
          ListTile(
              leading: Icon(Icons.logout), // Logout icon
              title: Text('Logout'),
              onTap: () {
                _confirmLogout(context);
              }
          ),
        ],
      ),
    );
  }

  void _navigateToVendorManagement(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            VendorManagement(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          var tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  void _navigateToProductManagement(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProductManagement(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          var tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  void _navigateToOrderManagement(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            OrderManagement(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          var tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          var tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }
}
void _confirmLogout(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to log out?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _logout(context); // Perform logout action
            },
            child: Text('Logout'),
          ),
        ],
      );
    },
  );
}
void _logout(BuildContext context) {
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    ),
  );
}

