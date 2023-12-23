import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:proxyapp/auth/application/auth_notifier.dart';
import 'package:proxyapp/auth/shared/providers.dart';
import 'package:proxyapp/core/presentation/routes/app_router.dart';

final initializationProvider = FutureProvider((ref) async {
  final authNotifier = ref.read(authNotifierProvider.notifier);
  await authNotifier.checkAndUpdateAuthStatus();
});

class AppWidget extends ConsumerWidget {
  AppWidget({super.key});

  final appRouter = AppRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(initializationProvider, (_, __) {});
    ref.listen<AuthState>(
      authNotifierProvider,
      (previous, state) {
        state.maybeMap(
          orElse: () {},
          unauthenticated: (_) {
            print("object is unauthenticated");
            appRouter.pushAndPopUntil(
              const ChooseLoginRoute(),
              predicate: (route) => false,
            );
          },
          authenticated: (_) {
            print("object is authenticated");
            appRouter.pushAndPopUntil(
              const GreenHomeRoute(),
              predicate: (route) => false,
            );
          },
        );
      },
    );

    return MaterialApp.router(
      title: 'Sms Reader',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xff006E1C),
          primary: Color(0xff5ABD8C),
          primaryContainer: Color(0xff006E1C),
          secondary: Color(0xff52634F),
          secondaryContainer: Color(0xff006E1C),
          // ···
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'special',
      ),
      debugShowCheckedModeBanner: false,
      routerDelegate: appRouter.delegate(),
      routeInformationParser: appRouter.defaultRouteParser(),
    );
  }
}
