import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_app/shop_layout.dart';
import 'package:shop_app/modules/shop_app/login/shop_login_screen.dart';
import 'package:shop_app/modules/shop_app/shop_cubit/shop_cubit.dart';
import 'package:shop_app/modules/shop_app/shop_cubit/shop_states.dart';
import 'package:shop_app/modules/shop_app/shop_register/shop_cubit/shop_cubit.dart';
import 'package:shop_app/modules/shop_app/shop_register/shop_cubit/shop_states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

class ShoeRegisterScreen extends StatelessWidget {
   ShoeRegisterScreen({Key? key}) : super(key: key);

  var formkey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit , ShopRegisterStates>(
        listener:(context, state)
        {
          if(state is ShopRegisterSuccessStates)
          {
            if(state.loginModel.status!)
            {
              print(state.loginModel.message);
              print(state.loginModel.data!.token);
              CacheHelper.saveData(
                key:'token' ,
                value: state.loginModel.data!.token ,
              ).then((value)
              {
                token = state.loginModel.data!.token!;
                navigateAndFinish(
                  context,
                  ShopLayout(),
                );
              });
              // Fluttertoast.showToast(
              //     msg: state.loginModel.message!,
              //     toastLength: Toast.LENGTH_LONG,
              //     gravity: ToastGravity.BOTTOM,
              //     timeInSecForIosWeb: 5,
              //     backgroundColor: Colors.green,
              //     textColor: Colors.white,
              //     fontSize: 16.0
              // );
            }
            else{
              print(state.loginModel.message);
              showToast(
                text: state.loginModel.message,
                state: ToastStates.ERROR,
              );
              // Fluttertoast.showToast(
              //     msg: state.loginModel.message!,
              //     toastLength: Toast.LENGTH_LONG,
              //     gravity: ToastGravity.BOTTOM,
              //     timeInSecForIosWeb: 5,
              //     backgroundColor: Colors.red,
              //     textColor: Colors.white,
              //     fontSize: 16.0
              // );
            }
          }
        },
        builder:(context , state)
        {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REGISTER',
                          style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Register Now To Browse Our Hot Offers',
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                          controller:nameController ,
                          type: TextInputType.name,
                          label:'User Name' ,
                          hint: 'User Name',
                          onSubmit: (String value){},
                          onChange: (String value){},
                          onTap: (){},
                          validate:(String value)
                          {
                            if(value.isEmpty){
                              return 'Please Enter Your Name';
                            }
                          } ,
                          prefix:Icons.person ,
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          controller:emailController ,
                          type: TextInputType.emailAddress,
                          label:'Email Address' ,
                          hint: 'Email Address',
                          onSubmit: (String value){},
                          onChange: (String value){},
                          onTap: (){},
                          validate:(String value)
                          {
                            if(value.isEmpty){
                              return 'Please Enter Your Email Address';
                            }
                          } ,
                          prefix:Icons.email ,
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultFormFieldpass(
                          controller:passController ,
                          type: TextInputType.visiblePassword,
                          suffix: ShopLoginCubit.get(context).suffix,
                          ispass: ShopLoginCubit.get(context).isPass,
                          suffixpressed: ()
                          {
                            ShopRegisterCubit.get(context).changeRegisterPasswordVisibility();
                          },
                          onSubmit: (String? value)
                          {
                            if(formkey.currentState!.validate())
                            {
                              ShopRegisterCubit.get(context).userRegister(
                                name: nameController.text,
                                phone: phoneController.text,
                                email:emailController.text ,
                                password: passController.text ,
                              );
                            }
                          },
                          onChange: (String? value){},
                          label:'Password' ,
                          hint: 'Password',
                          validate:(String? value)
                          {
                            if(value!.isEmpty){
                              return 'Password Is Too Short';
                            }
                          } ,
                          prefix:Icons.lock_outline,
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                          controller:phoneController ,
                          type: TextInputType.phone,
                          label:'Phone Number' ,
                          hint: 'Phone Number',
                          onSubmit: (String value){},
                          onChange: (String value){},
                          onTap: (){},
                          validate:(String value)
                          {
                            if(value.isEmpty){
                              return 'Please Enter Your Phone Number';
                            }
                          } ,
                          prefix:Icons.phone ,
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopRegisterLoadingStates,
                          builder: (context) => defaultButton(
                            function: ()
                            {
                              if(formkey.currentState!.validate())
                              {
                                ShopRegisterCubit.get(context).userRegister(
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  email:emailController.text ,
                                  password: passController.text ,
                                );
                              }
                            },
                            text: 'register',
                            isUpperCase: true,
                          ),
                          fallback: (context) => Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Have An Account?',),
                            defaultTextButton(
                              function: () {
                                navigateTo(
                                  context,
                                  ShopLoginScreen(),
                                );
                              },
                              text: 'Login',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }  ,
      ),
    );
  }
}
