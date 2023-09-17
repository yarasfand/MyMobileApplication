import 'package:flutter/material.dart';

class EmpSalaryReportDetail extends StatefulWidget {
  const EmpSalaryReportDetail({super.key});

  @override
  State<EmpSalaryReportDetail> createState() => _EmpSalaryReportDetailState();
}

class _EmpSalaryReportDetailState extends State<EmpSalaryReportDetail> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:AppBar(
        title: const Text(
          'Salary Report',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor:
        const Color(0xFFE26142), // Match the GPS Tracker Page's theme
      ),
      body: Center(child: Text("This is salary reports page")),
    );
  }
}
