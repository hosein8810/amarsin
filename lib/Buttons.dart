// import 'package:flutter/material.dart';

// Row buttons(String name, BuildContext context, String image,
//     MaterialPageRoute materialPageRoute) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       Column(
//         children: [
//           GestureDetector(
//             onTap: () {
//               //Future.delayed(Duration.zero, () {
//                 Navigator.push(context, materialPageRoute);
//               //});
//             },
//             child: Card(
//               semanticContainer: true,
//               clipBehavior: Clip.antiAliasWithSaveLayer,
//               //margin: EdgeInsets.all(60),
//               shape: RoundedRectangleBorder(
//                 side: const BorderSide(
//                   width: 1,
//                   color: Colors.blue,
//                 ),
//                 borderRadius: BorderRadius.circular(
//                   1000000,
//                 ), //<-- SEE HERE
//               ),
//               child: Center(
//                 child: Container(
//                   padding: const EdgeInsets.all(16),
//                   child: Expanded(
//                       child: Image.asset(
//                     image,
//                     height: 70,
//                     width: 70,
//                   )),
//                 ),
//               ),
//             ),
//           ),
//           Text(name,
//               style: const TextStyle(fontSize: 18, color: Color(0xFF4E4E4E))),
//         ],
//       ),
//       //Container(color: Colors.blue,width: 10,height: 10,)
//     ],
//   );
// }
