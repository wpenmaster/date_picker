import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DatePickerScreen(),
    );
  }
}

class DatePickerScreen extends StatefulWidget {
  @override
  _DatePickerScreenState createState() => _DatePickerScreenState();
}

class _DatePickerScreenState extends State<DatePickerScreen> {
  TextEditingController _dateController = TextEditingController();

  // Days to disable in your custom format (Sun=0, Mon=1, ..., Sat=6)
  final Map<String, int> disabledDays = {
    'day0': 0, // Sunday
    'day1': 1, // Monday
    'day2': 6, // Saturday
  };

  // Define the allowed date range
  final DateTime minDate = DateTime(2025, 1, 4); // January 4
  final DateTime maxDate = DateTime(2025, 1, 20); // January 20

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: minDate, // Restrict minimum date
      lastDate: maxDate, // Restrict maximum date
      selectableDayPredicate: (DateTime day) {
        // Convert Flutter's weekday format (1-7) to your custom format (0-6)
        int customWeekday = (day.weekday % 7); // Map Sun=7 to Sun=0

        // Disable the days specified in the disabledDays map
        if (disabledDays.values.contains(customWeekday)) {
          return false;
        }

        // Ensure the date falls within the allowed range
        if (day.isBefore(minDate) || day.isAfter(maxDate)) {
          return false;
        }

        return true; // Allow all other days
      },
    );

    if (selectedDate != null) {
      _dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Date Picker with Restrictions"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Select Date",
                suffixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
              onTap: () => _pickDate(context),
            ),
          ],
        ),
      ),
    );
  }
}
