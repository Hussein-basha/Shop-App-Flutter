import 'package:bloc/bloc.dart';
import 'package:conditional_builder_null_safety/example/example.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_app/cubit/cubit.dart';
import 'package:shop_app/layout/shop_app/cubit/states.dart';
import 'package:shop_app/layout/shop_app/shop_layout.dart';
import 'package:shop_app/modules/shop_app/login/shop_login_screen.dart';
import 'package:shop_app/modules/shop_app/on_boarding/on_boarding_screen.dart';
import 'package:shop_app/modules/shop_app/search/search_cubit/cubit.dart';
import 'package:shop_app/modules/shop_app/shop_cubit/shop_cubit.dart';
import 'package:shop_app/modules/shop_app/shop_cubit/shop_states.dart';
import 'package:shop_app/modules/shop_app/shop_register/shop_cubit/shop_cubit.dart';
import 'package:shop_app/shared/blocobserver/bloc_observer.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/styles/themes/themes.dart';
import 'package:hexcolor/hexcolor.dart';

//Map<int , Color>? swatch = [];
void main() async {
  // بيتاكد ان كل حاجة هنا فى الميثود خلصت وبعدين يفتح الابليكيشن
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  await CacheHelper.init();
  bool? isLast = CacheHelper.getData(key: 'isLast',);
  Widget? widget;
  bool? onBoarding = CacheHelper.getData(key: 'OnBoarding',);
  token = CacheHelper.getData(key: 'token',);
  print(token);
  if(onBoarding != null)
  {
    if(token != null) widget = ShopLayout();
    else widget = ShopLoginScreen();
  }else{
    widget = OnBoardingScreen();
  }
  print(onBoarding);
  BlocOverrides.runZoned(
        ()  {
      runApp(MyApp(startWidget: widget,));
    },
    blocObserver: MyBlocObserver(),
  );

}

class MyApp extends StatelessWidget{
  final bool? isLast;
  final Widget? startWidget;

  const MyApp({Key? key, this.isLast , this.startWidget}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => ShopCubit()..getHomeData()..getCategories()..getFavorites()..getUserData(),
        ),
        BlocProvider(
          create: (BuildContext context) => ShopLoginCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => ShopRegisterCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => SearchCubit(),
        ),
      ],
      child: BlocConsumer<ShopCubit , ShopStates>(
        listener: (context , state){},
        builder: (context , state)
        {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            //themeMode:NewsCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }

}