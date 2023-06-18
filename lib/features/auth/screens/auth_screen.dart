import 'package:amazon_clone_flutter/common/widgets/custom_button.dart';
import 'package:amazon_clone_flutter/common/widgets/custom_textfield.dart';
import 'package:amazon_clone_flutter/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:amazon_clone_flutter/constants/global_variables.dart';


enum Auth{
  signup,
  signin
}

class AuthScreen extends StatefulWidget{
  // this routeName will be used to navigate to one page to another in the switch case in the router.dart file which will have all the routes and control the routes between the pages of the application
  static const String routeName = '/auth-screen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState(){
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen>{
   Auth _auth = Auth.signup;

   //form is used to get the current state of the field that is used to validate the input for form validation
   final _signUpFormKey = GlobalKey<FormState>();
   final _signInFormKey = GlobalKey<FormState>();
  
  final AuthService authService = AuthService();


   //controllers for the Form
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();


  @override
  void dispose(){
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
  }

  void signUpUser(){
    authService.signUpUser(
      context: context, 
      name: _nameController.text, 
      email: _emailController.text, 
      password: _passwordController.text,
      formKey: _signUpFormKey,
      );
  }

  @override
  Widget build(BuildContext context){

    return  Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundCOlor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                'Welcome',style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
               ),
               ),
             
              ListTile(
                  tileColor: _auth == Auth.signup ? GlobalVariables.backgroundColor: GlobalVariables.greyBackgroundCOlor,
                  title:const Text(
                    'Create Account',
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  leading: Radio(
                    activeColor: GlobalVariables.secondaryColor,
                    // for the value we create an enum --> Auth {signin and signup}
                    value: Auth.signup,
                    groupValue: _auth,
                    //value type is Auth as we value and groupValue is of Auth type if changes value type will also change
                    onChanged: (Auth? value){
                      setState(() {
                      _auth = value!;
                      });
                    },
                    ),
                ),
              
              //Form for create account if _auth == Auth.signup
              if(_auth == Auth.signup)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: GlobalVariables.backgroundColor,
                  child: Form(
                    //using the GolbalKey to generate key in the form 
                    key: _signUpFormKey,
                    child: Column(
                      children: [
                        // we create custom textFormField --> so that we could use validator in the field
                        CustomTextField(
                          controller: _nameController,
                          // hintText is the placeholder for the input text field
                          hintText: 'Name',
                          ),
                          const SizedBox(height: 5,),
                          CustomTextField(
                          controller: _emailController,
                          // hintText is the placeholder for the input text field
                          hintText: 'Email',
                          ),
                          const SizedBox(height: 5,),
                          CustomTextField(
                          controller: _passwordController,
                          // hintText is the placeholder for the input text field
                          hintText: 'Password',
                          ),
                          const SizedBox(height: 5,),
                          CustomButton(
                            text: 'Sign Up',
                            onTap: (){
                               if(_signUpFormKey.currentState!.validate()){
                                signUpUser();
                              }
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              
               ListTile(
                  tileColor: _auth == Auth.signin ? GlobalVariables.backgroundColor: GlobalVariables.greyBackgroundCOlor,
                  title:const Text(
                    'Sign In',
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  leading: Radio(
                    activeColor: GlobalVariables.secondaryColor,
                    // for the value we create an enum --> Auth {signin and signup}
                    value: Auth.signin,
                    groupValue: _auth,
                    //value type is Auth as we value and groupValue is of Auth type if changes value type will also change
                    onChanged: (Auth? value){
                      setState(() {
                      _auth = value!;
                      });
                    },
                    ),
                ),
              
              //Form for create account if _auth == Auth.signup
              if(_auth == Auth.signin)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: GlobalVariables.backgroundColor,
                  child: Form(
                    //using the GolbalKey to generate key in the form 
                    key: _signInFormKey,
                    child: Column(
                      children: [
                        // we create custom textFormField --> so that we could use validator in the field
                        CustomTextField(
                          controller: _emailController,
                          // hintText is the placeholder for the input text field
                          hintText: 'Email',
                          ),
                          const SizedBox(height: 10,),
                          CustomTextField(
                          controller: _passwordController,
                          // hintText is the placeholder for the input text field
                          hintText: 'Password',
                          ),
                          const SizedBox(height: 10,),
                          CustomButton(
                            text: 'Sign In',
                            onTap: (){
                            },
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        ),
    );
  }
}