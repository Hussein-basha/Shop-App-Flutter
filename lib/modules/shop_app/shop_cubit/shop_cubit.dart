import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/shop_app/login_model.dart';
import 'package:shop_app/modules/shop_app/shop_cubit/shop_states.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates>{
  ShopLoginCubit() : super(ShopLoginInitialStates());

  bool isLast = false;
  ShopLoginModel? loginModel;
  IconData suffix = Icons.visibility_outlined;
  bool isPass = true;
  static ShopLoginCubit get(context) => BlocProvider.of(context);

  void userLogin({
  //required String name,
    required String email,
    //required String phone,
    required String password,
})
  {
    emit(ShopLoginLoadingStates());
    DioHelper.postData(
        url: LOGIN,
        data:
        {
          //'name':name,
          'email':email,
          //'phone':phone,
          'password':password,
        },
    ).then((value)
    {
      print(value.data);
      loginModel = ShopLoginModel.fromJson(value.data);
      emit(ShopLoginSuccessStates(loginModel!));
    }).catchError((error)
    {
      print(error.toString());
      emit(ShopLoginErrorStates(error.toString()));
    });
}

void changePasswordVisibility()
{
  isPass = !isPass;
  suffix = isPass ? Icons.visibility_outlined : Icons.visibility_off_outlined;
  emit(ShopChangePasswordVisibilityStates());
}

  void changeShopMode({bool? fromShared}) {
    if (fromShared != null) {
      isLast = fromShared;
      emit(ShopChangeModeState());
    }
    else {
      isLast = !isLast;
      CacheHelper.putBoolean(key: 'isLast', value: isLast).then((value)
      {
        emit(ShopChangeModeState());
      });
    }
  }

}