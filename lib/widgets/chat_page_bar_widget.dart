import 'package:chat_application/models/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatPageBarWidget extends StatefulWidget {
  const ChatPageBarWidget({super.key, required this.user});
  final User user;

  @override
  State<ChatPageBarWidget> createState() => _ChatPageBarWidgetState();
}

class _ChatPageBarWidgetState extends State<ChatPageBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().screenWidth,
      height: 105.h,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.w, top: 10.h),
            child: IconButton(
              onPressed: () {
                // playClickSound();
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
              iconSize: 35,
            ),
          ),
          SizedBox(
            width: 25.w,
          ),
          widget.user.imageUrl != null
              ? CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(widget.user.imageUrl),
                )
              : CircleAvatar(
                  radius: 30,
                  child: Icon(
                    Icons.person,
                    size: 40,
                  ),
                  backgroundColor: Colors.indigo.withOpacity(0.2),
                ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    widget.user.nickName,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                  ),
                  Text(
                    "Online",
                    style: TextStyle(color: Colors.green),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: 45.w,
          ),
          Padding(
            padding: EdgeInsets.only(right: 10.w, bottom: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.videocam),
                SizedBox(
                  width: 20.w,
                ),
                Icon(Icons.call)
              ],
            ),
          )
        ],
      ),
    );
  }
}
