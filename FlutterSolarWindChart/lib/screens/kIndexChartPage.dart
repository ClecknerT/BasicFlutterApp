import 'package:chart/services/kIndexService.dart';
import 'package:flutter/material.dart';
import 'package:high_chart/high_chart.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import 'package:provider/provider.dart';

// ignore: must_be_immutable
class KIndexChartPage extends StatefulWidget {

  KIndexChartPage({Key? key}) : super(key: key);

  @override
  State<KIndexChartPage> createState() => _KIndexChartPageState();
}

class _KIndexChartPageState extends State<KIndexChartPage> {

  late KIndexService _KIndexService;

  final LinkedScrollControllerGroup _scrollControllers = LinkedScrollControllerGroup();
  ScrollController _scrollController1 = ScrollController();
  ScrollController _scrollController2 = ScrollController();
  ScrollController _scrollController3 = ScrollController();
  ScrollController _scrollController4 = ScrollController();
  ScrollController _scrollController5 = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    _KIndexService = Provider.of<KIndexService>(context, listen: false);
    _KIndexService.initData();
    _scrollController1 = _scrollControllers.addAndGet();
    _scrollController2 = _scrollControllers.addAndGet();
    _scrollController3 = _scrollControllers.addAndGet();
    _scrollController4 = _scrollControllers.addAndGet();
    _scrollController5 = _scrollControllers.addAndGet();

  }

  @override
  Widget build(BuildContext context) {
    Provider.of<KIndexService>(context);
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Estimated Planetary K-Index (3 hour data)"
        ),
      ),
      body:
      _KIndexService.loading?
      const Center(
        child: CircularProgressIndicator(),
      ):
      ListView(
        children: [
          const SizedBox(height: 10,),
          // Bt, Bz GSM (nT) chart
          SizedBox(
            height: MediaQuery.of(context).size.height - 200,
            child: ListView(
              controller: _scrollController1,
              scrollDirection: Axis.horizontal,
              children: [
                HighCharts(
                            key: const Key('kpcharts'),
                            loader: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: const Center(child: CircularProgressIndicator()),
                            ),
                            size: Size(1920, MediaQuery.of(context).size.height - 200),
                            data: _KIndexService.xRayChartString(MediaQuery.of(context).size.height - 200),
                            scripts: KIndexService.scripts
                          ),
              ],
            )
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Text(
                'K<4',
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'K=4',
                style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'K>4',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
