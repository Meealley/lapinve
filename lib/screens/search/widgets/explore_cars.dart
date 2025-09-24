import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ExploreCars extends StatelessWidget {
  const ExploreCars({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset("assets/images/vintage-car.png", height: 180),
        Text(
          "Rent car for any occasion",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
        Text(
          "Browse an incredible selection of cars, from the everyday to the extraodinary",
          style: TextStyle(fontSize: 16),
        ),

        SizedBox(height: 2.h),

        TextButton(
          onPressed: () {},

          style: TextButton.styleFrom(
            minimumSize: Size(double.infinity, 45),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(10),
            ),
          ),
          child: Text("Explore Cars"),
        ),
      ],
    );
  }
}
