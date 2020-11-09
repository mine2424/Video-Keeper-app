// import 'package:flutter/material.dart';
// import 'package:numberpicker/numberpicker.dart';
// 
// class AlermFormPage extends StatefulWidget {
//   var hour, min, sec;
//   AlermFormPage({Key key, this.hour, this.min, this.sec}) : super(key: key);
//   @override
//   _AlermFormPageState createState() => _AlermFormPageState();
// }
// 
// class _AlermFormPageState extends State<AlermFormPage> {
//   @override
//   Widget build(BuildContext context) {
//     return RaisedButton(
//       child: Text('時間設定'),
//       onPressed: () {
//         showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return StatefulBuilder(
//                 builder: (context, setState) {
//                   return AlertDialog(
//                     title: Text('時間を設定してください'),
//                     content: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.only(bottom: 10),
//                               child: Text("時間"),
//                             ),
//                             NumberPicker.integer(
//                               initialValue: widget.hour,
//                               minValue: 0,
//                               maxValue: 2,
//                               listViewWidth: 60.0,
//                               onChanged: (value) {
//                                 setState(() {
//                                   widget.hour = value;
//                                 });
//                               },
//                             )
//                           ],
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.only(bottom: 10),
//                               child: Text("分"),
//                             ),
//                             NumberPicker.integer(
//                               initialValue: widget.min,
//                               minValue: 0,
//                               maxValue: 59,
//                               listViewWidth: 60.0,
//                               onChanged: (value) {
//                                 setState(() {
//                                   widget.min = value;
//                                 });
//                               },
//                             )
//                           ],
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.only(bottom: 10),
//                               child: Text("秒"),
//                             ),
//                             NumberPicker.integer(
//                               initialValue: widget.sec,
//                               minValue: 0,
//                               maxValue: 59,
//                               listViewWidth: 60.0,
//                               onChanged: (value) {
//                                 setState(() {
//                                   widget.sec = value;
//                                 });
//                               },
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                     actions: [
//                       FlatButton(
//                         child: Text("OK"),
//                         onPressed: () => Navigator.pop(context),
//                       ),
//                     ],
//                   );
//                 },
//               );
//             });
//       },
//     );
//   }
// }
