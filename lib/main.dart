import 'package:flutter/material.dart';

import 'package:amazon_clone_flutter/route.dart';
import 'package:amazon_clone_flutter/constants/global_variables.dart';
import 'package:amazon_clone_flutter/features/auth/screens/auth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          )
        ),
      ),
      //onGenerateRoute will run the callback--> whatever is present on it and the filtering of the route where to go is determined by the the switch cases in router.dart

      //generateRoute(settings) --> will check the route and transit to the correct page accordingly that is performed in the router.dart file
      onGenerateRoute: ((settings) => generateRoute(settings)),
      home: const AuthScreen(),  
      // Scaffold(
      //   appBar: AppBar(
      //     title:const Center(child: Text('Hello')),
      //   ),
      //   body:Column(
      //     children: [
      //       const Center(
      //         child: Text('Flutter Demo Home Page')
      //         ),
      //         Builder(
      //           builder: (context) {
      //             return ElevatedButton(
      //               onPressed: (){
      //                 // Here the pushNamed takes the context and route name that will be used to select the route among all the routes present in the application
      //                 Navigator.pushNamed(context, AuthScreen.routeName);
      //               }, 
      //               child: const Text('Click Here!')
      //             );
      //           }
      //         ),
      //     ],
      //   ),
      // ),
    );
  }
}
