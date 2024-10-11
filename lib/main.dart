import 'package:cooksy/auth/login_or_register.dart';
import 'package:cooksy/recipe_menu_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // تهيئة Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainApp(), // الصفحة الرئيسية تعتمد على حالة المستخدم
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // مراقبة حالة المستخدم
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()), // عرض مؤشر تحميل أثناء الانتظار
          );
        }
        if (snapshot.hasData) {
          // المستخدم مسجل الدخول
          return const RecipeMenu(); // يمكنك هنا استبدال Register بالصفحة الرئيسية الفعلية (مثلاً صفحة الوصفات)
        } else {
          // المستخدم غير مسجل الدخول
          return const LogOrReg(); // عرض صفحة تسجيل الدخول أو التسجيل
        }
      },
    );
  }
}
