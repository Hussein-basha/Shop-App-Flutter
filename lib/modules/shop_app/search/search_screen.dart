import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/shop_app/search/search_cubit/cubit.dart';
import 'package:shop_app/modules/shop_app/search/search_cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  var formkey = GlobalKey<FormState>();
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: formkey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    defaultFormField(
                      controller: searchController,
                      type: TextInputType.text,
                      label: 'Search',
                      hint: 'Search',
                      onChange: (String? text) {},
                      onSubmit: (String? text)
                      {
                        SearchCubit.get(context).Search(text);
                      },
                      onTap: () {},
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Your Text to Search';
                        }
                        return null;
                      },
                      prefix: Icons.search,
                    ),
                    const SizedBox(height: 10.0,),
                    if(state is SearchLoadingState)
                      const LinearProgressIndicator(),
                    const SizedBox(height: 10.0,),
                    if(state is SearchSuccessState)
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context , index) => buildListProduct(SearchCubit.get(context).searchModel!.data!.data![index] , context  , isOldPrice: false,),
                        separatorBuilder: (context , index) => myDivider(),
                        itemCount:SearchCubit.get(context).searchModel!.data!.data!.length ,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
