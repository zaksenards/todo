import 'package:flutter/material.dart';
import 'package:todo/utils/persistence.dart';
import 'package:todo/routes/home/screens/router_home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Persistence().initialize();

  runApp(const TodoEntry());
}

class TodoEntry extends StatelessWidget {
  const TodoEntry({super.key});
  final String appName = "Todo";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: RouterHome(appName: appName),
    );
  }
}
