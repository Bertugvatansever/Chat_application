
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CallHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
       
        title: const Text(
          'Arama Geçmişi',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: const Color.fromARGB(255, 231, 225, 225),
        child: ListView.builder(
          itemCount: 10, // Örnek için 10 arama listeleniyor
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 231, 225, 225),
                  ),
                  child:  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 25.w,
                        backgroundImage: const AssetImage("assets/profil.jpg"),
                      ),
                      SizedBox(width: 16.0.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "+905447761877",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0.sp,
                                color: Colors.indigo
                              ),
                            ),
                            SizedBox(height: 4.0.h),
                            const Text(
                              "Konuşulan Süre: 30 dakika",
                              style: TextStyle(color: Colors.black),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "20 Şubat",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(height: 4.0.h),
                          Text(
                            "20:00",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.black,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
