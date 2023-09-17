import 'package:amazon_clone_flutter/common/widgets/bottom_bar.dart';
import 'package:amazon_clone_flutter/features/admin/screens/admin_screen.dart';
// import 'package:amazon_clone_flutter/features/auth/home/screens/home_screen.dart';
import 'package:amazon_clone_flutter/features/auth/services/auth_service.dart';
import 'package:amazon_clone_flutter/providers/user_provider.dart';
import 'package:flutter/material.dart';

import 'package:amazon_clone_flutter/route.dart';
import 'package:amazon_clone_flutter/constants/global_variables.dart';
import 'package:amazon_clone_flutter/features/auth/screens/auth_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    // it will get that User data in that we have used sharedprefeences so that will help us to get the token we want to have
    super.initState();
    //if token is avaible then checking token if it is valid and if yes then showing homescreen directly no need to login again if the token is valid and user does exist

    //want to get data from api, before api we want to get the token --> we use sharedpreferences and key value pair
    authService.getUserData(context: context);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amazon Clone',
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        // useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: GlobalVariables.secondaryColor,
        ),

        //for the appBarThere
        appBarTheme: const AppBarTheme(
            elevation: 0,
            iconTheme: IconThemeData(
              color: Colors.black,
            )),
      ),
      //onGenerateRoute will run the callback--> whatever is present on it and the filtering of the route where to go is determined by the the switch cases in router.dart

      //generateRoute(settings) --> will check the route and transit to the correct page accordingly that is performed in the router.dart file
      onGenerateRoute: ((settings) => generateRoute(settings)),
      home: Provider.of<UserProvider>(context).user.token.isNotEmpty
          ? Provider.of<UserProvider>(context).user.type=="user" ?const BottomBar(): const AdminScreen()
          : const AuthScreen(),
    );
  }
}
