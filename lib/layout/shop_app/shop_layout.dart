import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_app/cubit/cubit.dart';
import 'package:shop_app/layout/shop_app/cubit/states.dart';
import 'package:shop_app/modules/shop_app/login/shop_login_screen.dart';
import 'package:shop_app/modules/shop_app/search/search_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

class ShopLayout extends StatelessWidget {
  const ShopLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit , ShopStates>(
      listener: (context , state){},
      builder: (context , state)
      {
        var cubit = ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Salla',
            ),
            actions: [
              IconButton(
                  onPressed: ()
                  {
                    navigateTo(context, SearchScreen(),);
                  },
                  icon: Icon(Icons.search),
              ),
            ],
          ),
          body: cubit.BottomScreens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index)
            {
              cubit.changeBottom(index);
            },
            items: [
              BottomNavigationBarItem(
                icon:Icon(Icons.home,) ,
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon:Icon(Icons.apps,) ,
                label: 'Categories',
              ),
              BottomNavigationBarItem(
                icon:Icon(Icons.favorite,) ,
                label: 'Favorite',
              ),
              BottomNavigationBarItem(
                icon:Icon(Icons.settings,) ,
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}
