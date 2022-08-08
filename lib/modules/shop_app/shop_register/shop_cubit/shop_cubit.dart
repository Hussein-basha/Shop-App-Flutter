import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/shop_app/login_model.dart';
import 'package:shop_app/modules/shop_app/shop_cubit/shop_states.dart';
import 'package:shop_app/modules/shop_app/shop_register/shop_cubit/shop_states.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates>{
  ShopRegisterCubit() : super(ShopRegisterInitialStates());

  bool isLast = false;
  ShopLoginModel? loginModel;
  IconData suffix = Icons.visibility_outlined;
  bool isPass = true;
  static ShopRegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
  required String name,
    required String phone,
    required String email,
    required String password,
})
  {
    emit(ShopRegisterLoadingStates());
    DioHelper.postData(
        url: REGISTER,
        data:
        {
          'name':name,
          'phone':phone,
          'email':email,
          'password':password,
        },
    ).then((value)
    {
      print(value.data);
      loginModel = ShopLoginModel.fromJson(value.data);
      emit(ShopRegisterSuccessStates(loginModel!));
    }).catchError((error)
    {
      print(error.toString());
      emit(ShopRegisterErrorStates(error.toString()));
    });
}

void changeRegisterPasswordVisibility()
{
  isPass = !isPass;
  suffix = isPass ? Icons.visibility_outlined : Icons.visibility_off_outlined;
  emit(ShopRegisterChangePasswordVisibilityStates());
}

  void changeShopMode({bool? fromShared}) {
    if (fromShared != null) {
      isLast = fromShared;
      emit(ShopRegisterChangeModeState());
    }
    else {
      isLast = !isLast;
      CacheHelper.putBoolean(key: 'isLast', value: isLast).then((value)
      {
        emit(ShopRegisterChangeModeState());
      });
    }
  }

}