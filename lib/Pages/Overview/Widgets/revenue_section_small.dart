// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:inventory/Constants/style.dart';
import 'StockoutColumnChart.dart';
import 'StockoutSplineChart.dart';
import 'stockin_pie.dart';
import 'stockout_pie.dart';

class RevenueSectionSmall extends StatelessWidget {
  // final RevenueService revenueService = Get.find<RevenueService>();

  @override
  Widget build(BuildContext context) {
    return
        // GetX<RevenueService>(
        //   init: revenueService,
        //   initState: (state) {
        //     WidgetsBinding.instance.addPostFrameCallback((_) {
        //       revenueService.fetchAndCalculateRevenue();
        //     });
        //   },
        //   builder: (revenueService) {
        //     if (revenueService.isLoading.value) {
        //       return const Center(child: CircularProgressIndicator());
        //     } else {
        //       return
        Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 6),
            color: lightGray.withOpacity(.1),
            blurRadius: 12,
          ),
        ],
        border: Border.all(color: lightGray, width: .5),
      ),
      child: Column(
        children: [
          StockinCategoryPie(),
          StockoutCategoryPie(),
          StockoutSplineChart(),
          StockoutColumnChart(),

          // SizedBox(
          //   height: 260,
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       Row(
          //         children: [
          //           RevenueInfo(
          //             title: "Today's revenue",
          //             amount:
          //                 revenueService.revenue.value.today.toStringAsFixed(2),
          //           ),
          //           RevenueInfo(
          //             title: "Last 7 days",
          //             amount: revenueService.revenue.value.last7Days
          //                 .toStringAsFixed(2),
          //           ),
          //         ],
          //       ),
          //       const SizedBox(
          //         height: 30,
          //       ),
          //       Row(
          //         children: [
          //           RevenueInfo(
          //             title: "Last 30 days",
          //             amount: revenueService.revenue.value.last30Days
          //                 .toStringAsFixed(2),
          //           ),
          //           RevenueInfo(
          //             title: "Last 12 months",
          //             amount: revenueService.revenue.value.last12Months
          //                 .toStringAsFixed(2),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
//     );
//   }
// }
