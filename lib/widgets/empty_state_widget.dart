import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 160.h),
          SvgPicture.asset(
            'assets/images/empty_state.svg',
            height: 220.h,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 22),
            child: Text(
              'No todos in the list. Try adding one from down below!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
