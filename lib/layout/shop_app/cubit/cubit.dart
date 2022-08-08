import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_app/cubit/states.dart';
import 'package:shop_app/models/shop_app/categories_model.dart';
import 'package:shop_app/models/shop_app/change_favorites_model.dart';
import 'package:shop_app/models/shop_app/favorites_model.dart';
import 'package:shop_app/models/shop_app/home_model.dart';
import 'package:shop_app/models/shop_app/login_model.dart';
import 'package:shop_app/modules/shop_app/categories/categories_screen.dart';
import 'package:shop_app/modules/shop_app/favorities/favourites_screen.dart';
import 'package:shop_app/modules/shop_app/products/products_screen.dart';
import 'package:shop_app/modules/shop_app/settings/settings_screen.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class ShopCubit extends Cubit<ShopStates>
{
  ShopCubit() :super(ShopInitialState());
  static ShopCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> BottomScreens = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];
  void changeBottom(int index)
  {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;
  Map<int , bool> favorites = {};
  void getHomeData()
  {
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(
      url:HOME ,
    token: token,
    ).then((value)
    {
      homeModel = HomeModel.fromjson(value.data);
      //printFullText(homeModel!.data!.banners[0].image!);
      //print(homeModel!.status);
      homeModel!.data!.products.forEach((element)
      {
        favorites.addAll({
          element['id'] : element['in_favorites'],
        });
      });
      print(favorites.toString());
      emit(ShopSuccessHomeDataState());
    }).catchError((error)
    {
      print(error.toString());
      emit(ShopErrorHomeDataState());
    });
  }

  CategoriesModel? categoriesModel;
  void getCategories()
  {
    DioHelper.getData(
      url:GET_CATEGORIES ,
      token: token,
    ).then((value)
    {
      categoriesModel = CategoriesModel.fromjson(value.data);

      emit(ShopSuccessCategoriesState());
    }).catchError((error)
    {
      print(error.toString());
      emit(ShopErrorCategoriesState());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;
  void changeFavorites(int productId)
  {
    favorites[productId] = !favorites[productId]!;

    emit(ShopChangeFavoritesStates());

    DioHelper.postData(
        url: FAVORITES ,
        data: {
          'product_id': productId,
        } ,
      token: token,
    ).then((value)
    {
      changeFavoritesModel = ChangeFavoritesModel.fromjson(value.data);
      print(value.data);
      if(!changeFavoritesModel!.status!)
        {
          favorites[productId] = !favorites[productId]!;
        }else
          {
            getFavorites();
          }
      emit(ShopSuccessChangeFavoritesStates(changeFavoritesModel!));
    }).catchError((error)
    {
      favorites[productId] = !favorites[productId]!;
      emit(ShopErrorChangeFavoritesStates());
    });
  }

  FavoritesModel? favoritesModel;
  ShopLoginModel? userModel;

  void getFavorites()
  {
    emit(ShopLoadingGetFavoritesStates());
    DioHelper.getData(
      url:FAVORITES ,
      token: token,
    ).then((value)
    {
      favoritesModel = FavoritesModel.fromJson(value.data);
      printFullText(value.data.toString());

      emit(ShopSuccessGetFavoritesStates());
    }).catchError((error)
    {
      print(error.toString());
      emit(ShopErrorGetFavoritesStates());
    });
  }
  void getUserData()
  {
    emit(ShopLoadingUserDataStates());
    DioHelper.getData(
      url:PROFILE ,
      token: token,
    ).then((value)
    {
      userModel = ShopLoginModel.fromJson(value.data);
      printFullText(userModel!.data!.name!);

      emit(ShopSuccessUserDataStates(userModel!));
    }).catchError((error)
    {
      print(error.toString());
      emit(ShopErrorUserDataStates());
    });
  }

  void UpdateUserData({
  required String name,
  required String email,
  required String phone,
})
  {
    emit(ShopLoadingUpdateUserStates());
    DioHelper.putData(
      url:UPDATE_PROFILE ,
      data: {
        'name' : name,
        'email' : email,
        'phone' : phone,
      },
      token: token,
    ).then((value)
    {
      userModel = ShopLoginModel.fromJson(value.data);
      printFullText(userModel!.data!.name!);

      emit(ShopSuccessUpdateUserStates(userModel!));
    }).catchError((error)
    {
      print(error.toString());
      emit(ShopErrorUpdateUserStates());
    });
  }


}