import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:proxyapp/auth/presentation/choose_login_page.dart';
import 'package:proxyapp/auth/presentation/login_page.dart';
import 'package:proxyapp/auth/presentation/pin_page.dart';
import 'package:proxyapp/core/splash/presentation/splash.dart';
import 'package:proxyapp/page/page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: PinRoute.page, path: '/register'),
        AutoRoute(page: LoginRoute.page, path: '/sign-in'),
        AutoRoute(page: ChooseLoginRoute.page, path: '/welcome'),
        AutoRoute(page: SplashRoute.page, path: '/splash', initial: true),
        AutoRoute(page: GreenHomeRoute.page, path: '/home'),

        //Spalash
      ];
}
