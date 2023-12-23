// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    ChooseLoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ChooseLoginPage(),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },
    GreenHomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: GreenHomePage(),
      );
    },
    PinRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PinPage(),
      );
    },
    SplashRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashPage(),
      );
    },
  };
}

/// generated route for
/// [BookDetailsPage]
class BookDetailsRoute extends PageRouteInfo<BookDetailsRouteArgs> {
  BookDetailsRoute({
    Key? key,
    required String bookIdArg,
    required Map<dynamic, dynamic> bObj,
    List<PageRouteInfo>? children,
  }) : super(
          BookDetailsRoute.name,
          args: BookDetailsRouteArgs(
            key: key,
            bookIdArg: bookIdArg,
            bObj: bObj,
          ),
          initialChildren: children,
        );

  static const String name = 'BookDetailsRoute';

  static const PageInfo<BookDetailsRouteArgs> page =
      PageInfo<BookDetailsRouteArgs>(name);
}

class BookDetailsRouteArgs {
  const BookDetailsRouteArgs({
    this.key,
    required this.bookIdArg,
    required this.bObj,
  });

  final Key? key;

  final String bookIdArg;

  final Map<dynamic, dynamic> bObj;

  @override
  String toString() {
    return 'BookDetailsRouteArgs{key: $key, bookIdArg: $bookIdArg, bObj: $bObj}';
  }
}

/// generated route for
/// [BookReadingViewPage]
class BookReadingViewRoute extends PageRouteInfo<BookReadingViewRouteArgs> {
  BookReadingViewRoute({
    Key? key,
    required Map<dynamic, dynamic> bObj,
    required String bookIdArg,
    List<PageRouteInfo>? children,
  }) : super(
          BookReadingViewRoute.name,
          args: BookReadingViewRouteArgs(
            key: key,
            bObj: bObj,
            bookIdArg: bookIdArg,
          ),
          initialChildren: children,
        );

  static const String name = 'BookReadingViewRoute';

  static const PageInfo<BookReadingViewRouteArgs> page =
      PageInfo<BookReadingViewRouteArgs>(name);
}

class BookReadingViewRouteArgs {
  const BookReadingViewRouteArgs({
    this.key,
    required this.bObj,
    required this.bookIdArg,
  });

  final Key? key;

  final Map<dynamic, dynamic> bObj;

  final String bookIdArg;

  @override
  String toString() {
    return 'BookReadingViewRouteArgs{key: $key, bObj: $bObj, bookIdArg: $bookIdArg}';
  }
}

/// generated route for
/// [ChooseLoginPage]
class ChooseLoginRoute extends PageRouteInfo<void> {
  const ChooseLoginRoute({List<PageRouteInfo>? children})
      : super(
          ChooseLoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChooseLoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<HomeRouteArgs> {
  HomeRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          HomeRoute.name,
          args: HomeRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<HomeRouteArgs> page = PageInfo<HomeRouteArgs>(name);
}

class HomeRouteArgs {
  const HomeRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'HomeRouteArgs{key: $key}';
  }
}

/// generated route for
/// [LeaderboardPage]
class LeaderboardRoute extends PageRouteInfo<void> {
  const LeaderboardRoute({List<PageRouteInfo>? children})
      : super(
          LeaderboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'LeaderboardRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MainBookPage]
class GreenHomeRoute extends PageRouteInfo<void> {
  const GreenHomeRoute({List<PageRouteInfo>? children})
      : super(
          GreenHomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'GreenHomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [PodcastPage]
class PodcastRoute extends PageRouteInfo<void> {
  const PodcastRoute({List<PageRouteInfo>? children})
      : super(
          PodcastRoute.name,
          initialChildren: children,
        );

  static const String name = 'PodcastRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<ProfileRouteArgs> {
  ProfileRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ProfileRoute.name,
          args: ProfileRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const PageInfo<ProfileRouteArgs> page =
      PageInfo<ProfileRouteArgs>(name);
}

class ProfileRouteArgs {
  const ProfileRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'ProfileRouteArgs{key: $key}';
  }
}

/// generated route for
/// [PinPage]
class PinRoute extends PageRouteInfo<void> {
  const PinRoute({List<PageRouteInfo>? children})
      : super(
          PinRoute.name,
          initialChildren: children,
        );

  static const String name = 'PinRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
