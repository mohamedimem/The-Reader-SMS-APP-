import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:proxyapp/auth/presentation/login_page.dart';
import 'package:proxyapp/auth/presentation/pin_page.dart';

@RoutePage()
class ChooseLoginPage extends StatefulWidget {
  @override
  ChooseLoginPageState createState() => ChooseLoginPageState();
}

class ChooseLoginPageState extends State<ChooseLoginPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.1)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height / 12,
                      child: Image.asset(
                        'assets/sms.png',
                      )),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      child: Column(
                        children: [
                          Text(
                            'Read SMS',
                            style: TextStyle(
                                fontSize: 28,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: [
                              Text(
                                'by',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                ' Iproxy.online',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: AppBar(
                  bottom: TabBar(
                    tabs: [
                      Tab(
                        text: "USE EMAIL",
                      ),
                      Tab(
                        text: "USE PIN",
                      ),
                    ],
                  ),
                ),
              ),

              // create widgets for each tab bar here
              Expanded(
                child: TabBarView(
                  children: [
                    // first tab bar view widget
                    LoginPage(),
                    // second tab bar viiew widget
                    PinPage()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
