import 'package:flutter/material.dart';
import 'package:foddyy/notifier/products_notifier.dart';
import 'package:foddyy/notifier/restaurant_notifier.dart';
import 'package:foddyy/screens/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => RestaurantNotifier(),
      ),
      ChangeNotifierProvider(
        create: (context) => ProductNotifier(),
      )
    ], child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
