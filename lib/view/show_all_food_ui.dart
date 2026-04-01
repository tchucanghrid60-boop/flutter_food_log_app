// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_food_log_app/models/food.dart';
import 'package:flutter_food_log_app/view/add_food_ui.dart';
import 'package:flutter_food_log_app/services/supbase_services.dart';
import 'package:flutter_food_log_app/view/update_del_food_ui.dart';

class ShowAllFoodUi extends StatefulWidget {
  const ShowAllFoodUi({super.key});

  @override
  State<ShowAllFoodUi> createState() => _ShowAllFoodUiState();
}

class _ShowAllFoodUiState extends State<ShowAllFoodUi> {
  //สร้างตัวแปรเพื่อเก็บข้อมูลที่จะนำไปแสดงใน ListView ในส่วนของ body
  List<Food> foods = [];

  //สร้าง instance/object/ตัวแทน ของ SupabaseService
  final service = SupbaseServices();

  //สร้างเมธอดเพื่อดึงข้อมูลทั้งหมดจาก Supabase ผ่านทาง SupabaseService
  void loadAllFood() async {
    //สร้างตัวแปรเก็บข้อมุลท่ี่ได้จากการดึงผ่านทาง SupabaseService
    final data = await service.getAllFood();

    setState(() {
      //เก็บข้อมูลที่ได้จากการดึงผ่านทาง SupabaseService ไว้ในตัวแปร foods เพื่อเอาไปใช้กับ body
      foods = data;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAllFood();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'กินกัน LOG',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 40),
            // ส่วนแสดง Logo
            Image.asset(
              'assets/images/food_img.png',
              width: 180,
              height: 180,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            // ส่วนแสดงรายการกินทั้งหมดที่บันทึกไว้ที่ Supabase
            Expanded(
              child: ListView.builder(
                // จำนวนรายการที่แสดงใน ListView
                itemCount: foods.length,
                // สร้างหน้าตาของแต่ละรายการใน ListView
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: 30,
                      right: 30,
                      top: 5,
                      bottom: 5,
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateDelFoodUi(
                              food: foods[index],
                            ),
                          ),
                        ).then((velue) {
                          loadAllFood();
                        });
                        ;
                      },
                      leading: Image.asset(
                        'assets/images/food_img.png',
                      ),
                      trailing: Icon(
                        Icons.info,
                        color: Colors.red,
                      ),
                      title: Text(
                        'กิน ${foods[index].foodName}',
                      ),
                      subtitle: Text(
                        'วันที่: ${foods[index].foodDate} มื้อ: ${foods[index].foodMeal}',
                      ),
                      tileColor: index % 2 == 0
                          ? const Color.fromARGB(255, 0, 195, 255)
                          : const Color.fromARGB(255, 114, 234, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //เปิดไปหน้า AddFoodUi แบบย้อนกลับได้
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddFoodUi(),
            ),
          ).then((velue) {
            loadAllFood();
          });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
