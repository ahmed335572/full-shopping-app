// Part 1 - super.key
// الـ super.key اختصار بيمرر الـ key اللي جاي في الـ constructor للـ constructor
// بتاع الكلاس الأب (StatefulWidget -> Widget). يعني بدل ما أكتب
// LoginPage({Key? key}) : super(key: key) بكتب LoginPage({super.key}) وخلاص.
// الـ key بيروح على الـ Widget نفسه مش على الـ State، وFlutter بيستخدمه عشان
// يعرف widget مين هي مين في الـ tree لما الـ widgets تتغير أو تتبدل أماكنها.
// الفرق بينه وبين _keyForm: الـ Key? key ده هوية الـ widget جوا الـ widget tree
// وFlutter هو اللي بيشتغل بيه. أما GlobalKey<FormState> فأنا اللي بعمله وبمسك بيه
// الـ FormState من بره الـ Form عشان أنادي validate()، ولازم يكون unique في الـ app كله.
//
// Part 2 - const
// أي widget معمول const بيتعمل مرة واحدة وقت الـ compile والـ instance بتاعه بتتشارك.
// لما الـ parent يعمل rebuild وFlutter يلاقي نفس الـ instance بالظبط بيعدّي عليه
// ومبيعيدش بناء الـ subtree بتاعه. وكمان مفيش objects جديدة بتتعمل في كل build
// فالـ garbage collector بيشتغل أقل.
//
// Part 3 - الـ underscore
// الـ _ قبل أي اسم في Dart معناها private على مستوى الـ library يعني الملف كله مش الـ class بس.
// الـ State لازم يبقى private لأن Flutter هو اللي بيعمله من خلال createState()
// ومحدش من ملف تاني المفروض يعمل LoginPageState() أو يمسك فيه. كده الـ widget هو
// الواجهة الوحيدة اللي بتتشاف والـ State يفضل تفصيلة داخلية.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'test.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final _keyForm = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _inputCheck() {
    if (_keyForm.currentState!.validate()) {
      final username = _usernameController.text;
      final password = _passwordController.text;
      if (username == Database.username && password == Database.password) {
        Database.isLoggedIn = true;
        context.go("/home");
      } else {
        _usernameController.clear();
        _passwordController.clear();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Wrong info")));
      }
    }
  }

  @override
  void initState() {
    print(" start Login");
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    print(" finish Login");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _keyForm,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.shopping_bag_outlined, size: 72),
                  const SizedBox(height: 12),
                  const Text(
                    "Shopping App",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Login to continue",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: "Username",
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "please enter valid username ";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (((value?.length) ?? 0) < 6) {
                        return "please enter valid password";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _inputCheck,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text("Login"),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      context.push("/signup");
                    },
                    child: const Text("Don't have an account? Sign up"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
