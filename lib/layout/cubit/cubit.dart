import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/layout/cubit/states.dart';
import 'package:news_app/modules/business/business_screen.dart';
import 'package:news_app/modules/science/science_screen.dart';
import 'package:news_app/modules/sports/sports_screen.dart';
import 'package:news_app/modules/technology/technology_screen.dart';
import 'package:news_app/shared/network/local/cache_helper.dart';
import 'package:news_app/shared/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates> {
  NewsCubit() : super(NewsInitState());

  static NewsCubit get(context) => BlocProvider.of(context);

  int currentIdex = 0;

  List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.business),
      label: 'Business',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.science,
      ),
      label: 'Science',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.sports_baseball,
      ),
      label: 'Sports',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.computer_outlined,
      ),
      label: 'Tech',
    ),
  ];

  List<Widget> screens = [
    BusinessScreen(),
    ScienceScreen(),
    SportsScreen(),
    TechnologyScreen(),
  ];

  void changeIndex(int index) {
    currentIdex = index;
    if (index == 0)
      getBusiness();
    else if (index == 1)
      getScience();
    else if (index == 2)
      getSports();
    else {
      getTechnology();
    }
    emit(NewsBottomNavBar());
  }

  List<dynamic> business = [];

  void getBusiness() {
    emit(NewsGetBusinessLoadingState());

    if (business.length == 0) {
      DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country': 'eg',
          'category': 'business',
          'apiKey': '664ca626faef4d009cd82dc4449fcd96',
        },
      ).then((value) {
        business = value.data['articles'];
        print(business[0]['title']);
        emit(NewsGetBusinessSuccessState());
      }).catchError((onError) {
        print(onError.toString());
        emit(NewsGetBusinessErrorState(onError));
      });
    } else {
      emit(NewsGetBusinessSuccessState());
    }
  }

  List<dynamic> science = [];

  void getScience() {
    emit(NewsGetScienceLoadingState());
    if (science.length == 0) {
      DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country': 'eg',
          'category': 'science',
          'apiKey': '664ca626faef4d009cd82dc4449fcd96',
        },
      ).then((value) {
        science = value.data['articles'];
        print(science[0]['title']);
        emit(NewsGetScienceSuccessState());
      }).catchError((onError) {
        print(onError.toString());
        emit(NewsGetScienceErrorState(onError));
      });
    } else {
      emit(NewsGetScienceSuccessState());
    }
  }

  List<dynamic> sports = [];

  void getSports() {
    emit(NewsGetSportsLoadingState());

    if (sports.length == 0) {
      DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country': 'eg',
          'category': 'sports',
          'apiKey': '664ca626faef4d009cd82dc4449fcd96',
        },
      ).then((value) {
        sports = value.data['articles'];
        print(sports[0]['title']);
        emit(NewsGetSportsSuccessState());
      }).catchError((onError) {
        print(onError.toString());
        emit(NewsGetSportsErrorState(onError));
      });
    } else {
      emit(NewsGetSportsSuccessState());
    }
  }

  List<dynamic> technology = [];

  void getTechnology() {
    emit(NewsGetTechnologyLoadingState());

    if (technology.length == 0) {
      DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country': 'eg',
          'category': 'technology',
          'apiKey': '664ca626faef4d009cd82dc4449fcd96',
        },
      ).then((value) {
        technology = value.data['articles'];
        print(technology[0]['title']);
        emit(NewsGetTechnologySuccessState());
      }).catchError((onError) {
        print(onError.toString());
        emit(NewsGetTechnologyErrorState(onError));
      });
    } else {
      emit(NewsGetTechnologySuccessState());
    }
  }

  List<dynamic> search = [];

  void getSearch({
    @required String searchWord,
  }) {
    emit(NewsGetSearchLoadingState());

    DioHelper.getData(
      url: 'v2/everything',
      query: {
        'q': '$searchWord',
        'apiKey': '664ca626faef4d009cd82dc4449fcd96',
      },
    ).then((value) {
      search = value.data['articles'];
      print(search[0]['title']);
      emit(NewsGetSearchSuccessState());
    }).catchError((onError) {
      print(onError.toString());
      emit(NewsGetSearchErrorState(onError));
    });
  }

  bool isDark = false;

  void changeThemeMode({bool fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(NewsThemeModeChaneState());
    } else {
      isDark = !isDark;
      CasheHelper().putData(key: 'isDark', value: isDark).then((value) {
        emit(NewsThemeModeChaneState());
      });
    }
  }
}
