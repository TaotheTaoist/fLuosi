import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:learn1/calendar/Lunar.dart' as lunar;
import 'new_member.dart'; // Import NewMember class

class BaziPage extends StatefulWidget {
  final DateTime? birthday;
  final String? time;

  const BaziPage({
    Key? key,
    required this.birthday,
    this.time,
  }) : super(key: key);

  @override
  _BaziPageState createState() => _BaziPageState();
}

class _BaziPageState extends State<BaziPage> {
  String selectedValue = '1'; // Initial selected value
  List<String> dropDownOptions = ['1', '2', '3']; // Drop-down options

  @override
  Widget build(BuildContext context) {
    if (widget.birthday == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('八字'),
        ),
        body: const Center(
          child: Text('No birthday data available.'),
        ),
      );
    }

    // Parse the time if available
    TimeOfDay? parsedTime = NewMember.stringToTimeOfDay(widget.time);

    // Combine date and time for Lunar calculation
    DateTime combinedDateTime = DateTime(
      widget.birthday!.year,
      widget.birthday!.month,
      widget.birthday!.day,
      parsedTime?.hour ?? 0,
      parsedTime?.minute ?? 0,
    );

    lunar.Lunar lunarDate = lunar.Lunar.fromDate(combinedDateTime);

    // Helper function to build table rows
    TableRow buildRow(List<Widget> cells) {
      return TableRow(
        children: cells.map((cell) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(child: cell),
          );
        }).toList(),
      );
    }

    Widget buildCell(String text) {
      return AutoSizeText(
        text,
        maxLines: 1,
        minFontSize: 8,
        maxFontSize: 14,
        overflow: TextOverflow.ellipsis,
      );
    }

    Widget buildDropdownCell() {
      return DropdownButton<String>(
        value: selectedValue,
        onChanged: (String? newValue) {
          setState(() {
            selectedValue = newValue!;
          });
        },
        items: dropDownOptions.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('八字'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Table(
                  border: TableBorder.all(color: Colors.black),
                  children: [
                    buildRow([
                      buildCell('日期'),
                      buildCell('時柱'),
                      buildCell('日柱'),
                      buildCell('月柱'),
                      buildCell('年柱'),
                      buildCell('大運'),
                      buildCell('流年'),
                      buildCell('流月'),
                      buildDropdownCell(),
                    ]),
                    buildRow([
                      buildCell('26岁'),
                      buildCell('27岁'),
                      buildCell('7月'),
                      buildCell('3日'),
                      buildCell(''),
                      buildCell(''),
                      buildCell(''),
                      buildCell(''),
                      buildCell(''),
                    ]),
                    buildRow([
                      buildCell('天干'),
                      buildCell(lunarDate.getDayGan()),
                      buildCell(lunarDate.getDayGan()),
                      buildCell(lunarDate.getMonthGan()),
                      buildCell(lunarDate.getYearGan()),
                      buildCell(''),
                      buildCell(''),
                      buildCell(''),
                      buildCell(''),
                    ]),
                    buildRow([
                      buildCell('地支'),
                      buildCell(lunarDate.getDayZhi()),
                      buildCell(lunarDate.getDayZhi()),
                      buildCell(lunarDate.getMonthZhi()),
                      buildCell(lunarDate.getYearZhi()),
                      buildCell(''),
                      buildCell(''),
                      buildCell(''),
                      buildCell(''),
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Table(
                  border: TableBorder.all(color: Colors.black),
                  children: [
                    buildRow([
                      buildCell('流年'),
                      buildCell('天干'),
                      buildCell('地支'),
                      buildCell(''),
                      buildCell(''),
                      buildCell(''),
                      buildCell(''),
                      buildCell(''),
                      buildCell(''),
                    ]),
                    buildRow([
                      buildCell(''),
                      buildCell(lunarDate.getYearGan()),
                      buildCell(lunarDate.getYearZhi()),
                      buildCell(''),
                      buildCell(''),
                      buildCell(''),
                      buildCell(''),
                      buildCell(''),
                      buildCell(''),
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Table(
                  border: TableBorder.all(color: Colors.black),
                  children: [
                    buildRow([
                      buildCell('神煞'),
                      buildCell(''),
                      buildCell(''),
                      buildCell(''),
                      buildCell(''),
                      buildCell(''),
                      buildCell(''),
                      buildCell(''),
                      buildCell(''),
                    ]),
                    buildRow([
                      buildCell(''),
                      buildCell(''),
                      buildCell(''),
                      buildCell(''),
                      buildCell(''),
                      buildCell(''),
                      buildCell(''),
                      buildCell(''),
                      buildCell(''),
                    ]),
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
