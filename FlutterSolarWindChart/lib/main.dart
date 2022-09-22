import 'package:chart/screens/blot_map_screen.dart';
import 'package:chart/screens/kIndexChartPage.dart';
import 'package:chart/screens/magnetoChartPage.dart';
import 'package:chart/screens/solarWindChartPage.dart';
import 'package:chart/screens/solar_feeds_screen.dart';
import 'package:chart/screens/xRayChartPage.dart';
import 'package:chart/services/kIndexService.dart';
import 'package:chart/services/magnetoFLService.dart';
import 'package:chart/services/magnetoService.dart';
import 'package:chart/services/solarWindFLService.dart';
import 'package:chart/services/solarWindService.dart';
import 'package:chart/services/xRayFLService.dart';
import 'package:chart/services/xRayService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider<SolarWindService>(create: (context) => SolarWindService()),
          ChangeNotifierProvider<SolarWindFlService>(create: (context) => SolarWindFlService()),
          ChangeNotifierProvider<XrayService>(create: (context) => XrayService()),
          ChangeNotifierProvider<XrayFLService>(create: (context) => XrayFLService()),
          ChangeNotifierProvider<MagnetoService>(create: (context) => MagnetoService()),
          ChangeNotifierProvider<MagnetoFLService>(create: (context) => MagnetoFLService()),
          ChangeNotifierProvider<KIndexService>(create: (context) => KIndexService()),
        ],
        child: MyApp(),
      ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MenuWidget()
    );
  }
}

class MenuWidget extends StatelessWidget {
  const MenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "REAL TIME SOLAR WIND"
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    image: AssetImage('assets/images/rese.png',),
                    scale: 1.8,
                  )
              ),
              child: Text(
                "9 RESE'",
                style: TextStyle(
                  color: Color(0xFFe06100),
                  fontSize: 25,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: ListTile(
                title: const Text(
                  'REAL TIME SOLAR WIND',
                ),
                onTap: () {

                },
              ),
            ),
            ListTile(
              title: const Text('GOES X-Ray Flux'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => XRayChartPage()
                ));
              },
            ),
            ListTile(
              title: const Text('Goes Magnetometers'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => MagnetoChartPage()
                ));
              },
            ),
            ListTile(
              title: const Text('Planetary K-Index'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => KIndexChartPage()
                ));
              },
            ),
            ListTile(
              title: const Text('BlotMap'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const BlotMap()
                ));
              },
            ),
            ListTile(
              title: const Text('Solar Feeds'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const SolarFeedsScreen()
                ));
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              title: Text('Feedback'),
              onTap: () => {Navigator.of(context).pop()},
            ),
          ],
        ),
      ),
      body: SolarWindChartPage(),
    );
  }
}


