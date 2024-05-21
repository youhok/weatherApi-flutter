import 'package:intl/intl.dart';


class KhmerDateFormatter {
  static const List<String> _khmerWeekdays = [
    'អាទិត្យ',  // Sunday
    'ច័ន្ទ',    // Monday
    'អង្គារ',   // Tuesday
    'ពុធ',     // Wednesday
    'ព្រហស្បតិ៍', // Thursday
    'សុក្រ',    // Friday
    'សៅរ៍'    // Saturday
  ];

  static const List<String> _khmerMonths = [
    'មករា',    // January
    'កុម្ភៈ',   // February
    'មិនា',    // March
    'មេសា',    // April
    'ឧសភា',   // May
    'មិថុនា',  // June
    'កក្កដា',   // July
    'សីហា',    // August
    'កញ្ញា',   // September
    'តុលា',    // October
    'វិច្ឆិកា', // November
    'ធ្នូ'     // December
  ];

  String convert(int timestamp) {
    // Convert Unix timestamp to DateTime
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

    // Get Khmer weekday, month, and day of the month
    String khmerWeekday = _khmerWeekdays[dateTime.weekday % 7];
    String khmerMonth = _khmerMonths[dateTime.month - 1];
    String dayOfMonth = dateTime.day.toString();

    // Format the date as "ថ្ងៃព្រហស្បតិ៍ ១៨ កុម្ភៈ"
    return 'ថ្ងៃ$khmerWeekday $dayOfMonth $khmerMonth';
  }
}



//convert to Time for sunset and sunrise
String convertUnixToTime(int unixTimestamp) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);
  String formattedTime = DateFormat.jm().format(dateTime); // Format to AM/PM time format
  return formattedTime;
}

//convert only Time
String convertUnixTimestampToTime(int timestamp) {
  // Convert Unix timestamp to DateTime
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  
  // Determine if it's AM or PM
  String period = dateTime.hour >= 12 ? 'PM' : 'AM';
  
  // Convert the hour to 12-hour format
  int hour = dateTime.hour % 12;
  hour = hour == 0 ? 12 : hour; // Adjust for 0-hour being 12 in 12-hour format

  // Format the time string with hours and minutes
  String time = '$hour:${dateTime.minute.toString().padLeft(2, '0')} $period';

  return time;
}


//convert english to khmer

String convertWeatherToKhmer(String weatherDescription) {
  switch (weatherDescription) {
    case 'Clouds':
      return 'ពពក';
     case 'Rain':
     return  'ភ្លៀង';
    // Add more cases for other weather descriptions if needed
    default:
      return weatherDescription; // Return the same description if no match found
  }
}

//function convert date
String convertUnixTimestampToDate(int timestamp) {
  // Convert Unix timestamp to DateTime
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

  // Format the date as desired (e.g., "MM-DD")
  String formattedDate = DateFormat('MM-dd').format(dateTime);

  // Return the formatted date
  return formattedDate;
}