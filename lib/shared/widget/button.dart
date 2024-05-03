import 'package:flutter/material.dart';
import 'package:todo_app/shared/const/dimensions.dart';
import 'package:todo_app/shared/theme/themes.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;
  const MyButton({Key? key,required this.label,required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Dimensions.width120,
        height: Dimensions.height60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius20),
          color: primaryClr
        ),
        child: Center(
          child: Text(
              label,
              style: const TextStyle(
                  color: Colors.white,
              ),
          ),
        ),
      ),
    );
  }
}
//
// class MyButton extends StatelessWidget {
//   String label;
//   final Function()? onTap;
//    MyButton({Key? key,required this.label,required this.onTap}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: Dimensions.height60,
//       width: Dimensions.width100,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(Dimensions.radius20),
//           color: primaryClr
//         ),
//       child: MaterialButton(
//          onPressed: null,
//          color: primaryClr,
//          elevation: 0,
//          child: Text(
//           label,
//           style: const TextStyle(
//             color: Colors.white,
//           ),
//         ),
//          shape: OutlineInputBorder(
//            borderSide: BorderSide.none,
//            borderRadius:  BorderRadius.circular(Dimensions.radius20),
//          ),
//       ),
//     );
//   }
// }

