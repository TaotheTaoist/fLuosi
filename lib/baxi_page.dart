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

    // First table buildCell
    Widget buildCell(String text) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8.0),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(fontSize: 14),
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    Widget buildDropdownCell() {
      return Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Container(
          width: 40, // Adjust the width as needed
          child: DropdownButton<String>(
            value: selectedValue,
            isExpanded: true, // Ensures the dropdown takes the width of its container
            onChanged: (String? newValue) {
              setState(() {
                selectedValue = newValue!;
              });
            },
            items: dropDownOptions.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 12), // Adjust the font size as needed
                ),
              );
            }).toList(),
          ),
        ),
      );
    }

    TableRow buildRow(List<Widget> cells) {
      return TableRow(
        children: cells,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black),
          ),
        ),
      );
    }

    // Custom cell widget for complex string layout
    Widget buildCustomCell(String mainText, List<String> sideTexts) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8.0),
        alignment: Alignment.center,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                mainText,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: sideTexts.map((text) {
                  return Text(
                    text,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    }

    List<TableRow> tableRows = [
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
        buildCustomCell(lunarDate.getDayGan(), ['傷', '官', '財']),
        buildCustomCell(lunarDate.getDayGan(), ['傷', '官', '財']),
        buildCustomCell(lunarDate.getMonthGan(), ['傷', '官', '財']),
        buildCustomCell(lunarDate.getYearGan(), ['傷', '官', '財']),
        buildCell(''),
        buildCell(''),
        buildCell(''),
        buildCell(''),
      ]),
      buildRow([
        buildCell('地支'),
        buildCustomCell(lunarDate.getDayZhi(), ['傷', '官', '財']),
        buildCustomCell(lunarDate.getDayZhi(), ['傷', '官', '財']),
        buildCustomCell(lunarDate.getMonthZhi(), ['傷', '官', '財']),
        buildCustomCell(lunarDate.getYearZhi(), ['傷', '官', '財']),
        buildCell(''),
        buildCell(''),
        buildCell(''),
        buildCell(''),
      ]),
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
        buildCustomCell(lunarDate.getYearGan(), ['傷', '官', '財']),
        buildCustomCell(lunarDate.getYearZhi(), ['傷', '官', '財']),
        buildCell(''),
        buildCell(''),
        buildCell(''),
        buildCell(''),
        buildCell(''),
        buildCell(''),
      ]),
    ];

    // Second table buildCell
    Widget buildLongCell(String mainText, List<String> sideTexts) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8.0),
        alignment: Alignment.center,
        constraints: const BoxConstraints(minWidth: 30.0), // Adjust minWidth as needed
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            children: [
              Text(
                mainText,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: sideTexts.map((text) {
                  return Text(
                    text,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      );
    }

    TableRow buildLongRow(List<Widget> cells) {
      return TableRow(
        children: cells,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black),
          ),
        ),
      );
    }

    List<TableRow> longTableRows = [
      buildLongRow([
        buildLongCell('月干', ['k', '官', '財']),
        buildLongCell('k', ['官', '財']),
        buildLongCell('/', ['官', '財']),
        buildLongCell('/', ['官', '財']),
        buildLongCell('/', ['官', '財']),
        buildLongCell('/', ['官', '財']),
        buildLongCell('?', ['官', '財']),
        buildLongCell('?', ['官', '財']),
        buildLongCell('/', ['官', '財']),
        buildLongCell('/', ['官', '財']),
        buildLongCell('?', ['官', '財']),
        buildLongCell('?', ['官', '財']),
        buildLongCell('?', ['官', '財']),
      ]),
      buildLongRow([
        buildLongCell('月支', ['k', '官', '財']),
        buildLongCell('k', ['官', '財']),
        buildLongCell('/', ['官', '財']),
        buildLongCell('/', ['官', '財']),
        buildLongCell('/', ['官', '財']),
        buildLongCell('/', ['官', '財']),
        buildLongCell('?', ['官', '財']),
        buildLongCell('?', ['官', '財']),
        buildLongCell('/', ['官', '財']),
        buildLongCell('/', ['官', '財']),
        buildLongCell('?', ['官', '財']),
        buildLongCell('?', ['官', '財']),
        buildLongCell('?', ['官', '財']),
      ]),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('八字'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Table(
                border: TableBorder.all(color: Colors.black),
                children: tableRows,
              ),
              const SizedBox(height: 5),
              Divider(),
              Table(
                border: TableBorder.all(color: Colors.black),
                children: longTableRows,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
