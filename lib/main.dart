import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_timer/timer_hook.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const HomePage(title: 'Flutter Demo Home Page'),
      // home: const HomePageHook(),
      // home: const HomePageCustomHook(),
      home: const TextEditingHook(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer _timer;
  int number = 0;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        number = timer.tick;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(number.toString()),
      ),
    );
  }
}

class HomePageHook extends HookWidget {
  const HomePageHook({super.key});

  @override
  Widget build(BuildContext context) {
    final _numberNotifier = useState(0);

    useEffect(() {
      final timer = Timer.periodic(Duration(seconds: 1), (time) {
        _numberNotifier.value = time.tick;
      });
      return timer.cancel;
    }, const []);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Simple Hook"),
      ),
      body: Center(
        child: Text(_numberNotifier.value.toString()),
      ),
    );
  }
}

class HomePageCustomHook extends HookWidget {
  const HomePageCustomHook({super.key});

  @override
  Widget build(BuildContext context) {
    final number = useInfiniteTimer(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Simple Custom Hook"),
      ),
      body: Center(
        child: Text(number.toString()),
      ),
    );
  }
}

class TextEditingHook extends HookWidget {
  const TextEditingHook({super.key});

  void makeLogin(email, password) {
    print("Making login  email:$email, password: $password");
  }

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController(text: "");
    final passwordController = useTextEditingController(text: "");

    final _areFieldsEmpty = useState<bool>(true);

    bool areFieldsEmpty() {
      return emailController.text.isEmpty || passwordController.text.isEmpty;
    }

    useEffect(() {
      emailController.addListener(() {
        _areFieldsEmpty.value = areFieldsEmpty();
      });
      passwordController.addListener(() {
        _areFieldsEmpty.value = areFieldsEmpty();
      });
    }, [emailController]);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Simple Hook"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: passwordController,
              keyboardType: TextInputType.text,
              obscureText: true,
            ),
            _areFieldsEmpty.value
                ? const ElevatedButton(
                    onPressed: null,
                    child: Text('Login disabled'),
                  )
                : ElevatedButton(
                    child: const Text('Login enabled'),
                    onPressed: () {
                      makeLogin(emailController.text, passwordController.text);
                    }),
          ],
        ),
      ),
    );
  }
}
