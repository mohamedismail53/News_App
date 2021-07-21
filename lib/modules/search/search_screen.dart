import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/layout/cubit/cubit.dart';
import 'package:news_app/layout/cubit/states.dart';
import 'package:news_app/shared/component/component.dart';

class SearchScreen extends StatelessWidget {
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, state) {
        var list = NewsCubit.get(context).search;
        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Container(
                color: NewsCubit.get(context).isDark
                    ? Colors.grey.shade600
                    : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: defaultFormField(
                      onChange: (String value) {
                        NewsCubit.get(context).getSearch(searchWord: value);
                      },
                      controller: searchController,
                      type: TextInputType.text,
                      validate: (String value) {
                        if (value.isEmpty) {
                          return 'Search must not be empty';
                        }
                        return null;
                      },
                      label: 'Search',
                      prefix: Icons.search),
                ),
              ),
              Expanded(
                child: articleBuilder(list),
              ),
            ],
          ),
        );
      },
    );
  }
}
