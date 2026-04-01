import 'package:flutter/material.dart';
import 'package:flutter_food_log_app/models/food.dart';
import 'package:flutter_food_log_app/services/supbase_services.dart';
import 'package:intl/intl.dart';

class UpdateDelFoodUi extends StatefulWidget {
  //สร้างตัวแปรรับข้อมูลจากหน้า ShowAllFoodUi
  Food? food;
  //เอาตัวแปรที่สร้างมารับค่าที่ส่งมา
  UpdateDelFoodUi({super.key, this.food});

  @override
  State<UpdateDelFoodUi> createState() => _UpdateDelFoodUiState();
}

class _UpdateDelFoodUiState extends State<UpdateDelFoodUi> {
  TextEditingController foodNameCtrl = TextEditingController();
  TextEditingController foodPriceCtrl = TextEditingController();
  TextEditingController foodPersonCtrl = TextEditingController();
  TextEditingController foodDateCtrl = TextEditingController();
//ตัวแปรสำหรับเมื้ออาหารที่เลือก
  String foodMeal = 'เช้า';

//ตัวแปรสำหรับเก็บวันที่กิน
  DateTime? foodDate;

//เมธอดเปิดปฏิทินให้ผู้ใช้เลือก แล้วกำหนดวันที่เลือก
  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        //กำหนดค่าให้กับตัวแปร
        foodDate = picked;

        foodDateCtrl.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //กำหนดค่าเริ่มต้นให้กับ TextEditingController
    foodNameCtrl.text = widget.food!.foodName;
    foodPriceCtrl.text = widget.food!.foodPrice.toString();
    foodPersonCtrl.text = widget.food!.foodPerson.toString();
    foodDateCtrl.text = widget.food!.foodDate;
    foodMeal = widget.food!.foodMeal;

    foodDate = DateTime.parse(widget.food!.foodDate);
  }

  //เมธอดสำหรับบันทึกการแก้ไขข้อมูล
  void editFood() async {
    //Validate UI
    // validate UI ตรวจสอบหน้าจอเบื้องต้น
    if (foodNameCtrl.text.isEmpty ||
        foodMeal.isEmpty ||
        foodPriceCtrl.text.isEmpty ||
        foodPersonCtrl.text.isEmpty ||
        foodDateCtrl.text.isEmpty) {
      //แจ้งเตือนผู้ใช้ให้กรอกข้อมูลให้ครบถ้วน
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    //แพ็กเกจข้อมูลที่จะแก้ไขส่งไปยัง supabase
    // แพ็กข้อมูล
    Food food = Food(
      foodName: foodNameCtrl.text,
      foodMeal: foodMeal,
      foodPrice: double.parse(foodPriceCtrl.text),
      foodPerson: int.parse(foodPersonCtrl.text),
      foodDate: foodDate!.toIso8601String(),
    );

    //เรียกใช้เมธอดแก้ไขข้อมูลใน Supabase ผ่าน supabaseservice
    //ส่งไปบันทึกที่ supabase ผ่าน supabase service
    final Service = SupbaseServices();
    await Service.UpdaFood(widget.food!.id!, food);

    //แจ้งผลการทำงาน

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('แก้ไขข้อมูลเรียบร้อย'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
    //ย้อนกลับไปหน้า ShowAllFoodUi หลังแก้ไขข้อมูลเสร็จ
    Navigator.pop(context);
  }

  //เมธอดสำหรับลบข้อมูล
  Future<void> deleteFood() async {
    //เรียกใช้เมธอดลบข้อมูลใน Supabase ผ่าน supabaseservice
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ยืนยันการลบข้อมูล'),
        content: Text('คุณต้องการลบข้อมูลนี้หรือไม่?'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('ยกเลิก'),
          ),
          //ปุ่มยืนยันการลบ และทำการลบข้อมูลจริงออกจาก Supabase ผ่านทาง supabaseservice
          ElevatedButton(
            onPressed: () async {
              //ลบข้อมูลจริงออกจาก Supabase
              final Service = SupbaseServices();
              await Service.deleteFood(widget.food!.id!);
              //แจ้งผลการทำงาน
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('ลบข้อมูลเรียบร้อยแล้ว'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
              //ย้อนกลับไปหน้า ShowAllFoodUi หลังลบข้อมูลเสร็จ
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: Text(
              'ยืนยัน',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(
            'กินกัน LOG (แก้ไข้และลบข้อมูล)',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
          ),
        ),
        //ส่วนของ body
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 40, bottom: 50, left: 40, right: 40),
            child: Column(
              children: [
                // ส่วนแสดง Logo
                Image.asset(
                  'assets/images/logo.png',
                  width: 180,
                  height: 180,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 20),
                // ป้อนกินอะไร
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินอะไร',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                TextField(
                  controller: foodNameCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: 'เช่น KFC, Pizza',
                  ),
                ),
                SizedBox(height: 20),
                // เลือกกินมื้อไหน
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินมื้อไหน',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          foodMeal = 'เช้า';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            foodMeal == 'เช้า' ? Colors.red : Colors.grey,
                      ),
                      child: Text(
                        'เช้า',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          foodMeal = 'กลางวัน';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            foodMeal == 'กลางวัน' ? Colors.red : Colors.grey,
                      ),
                      child: Text(
                        'กลางวัน',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          foodMeal = 'เย็น';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            foodMeal == 'เย็น' ? Colors.red : Colors.grey,
                      ),
                      child: Text(
                        'เย็น',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          foodMeal = 'ว่าง';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            foodMeal == 'ว่าง' ? Colors.red : Colors.grey,
                      ),
                      child: Text(
                        'ว่าง',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // ป้อนกินไปเท่าไหร่
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินไปเท่าไหร่',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                TextField(
                  controller: foodPriceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: 'เช่น 299.50',
                  ),
                ),
                SizedBox(height: 20),
                // ป้อนกินกันกี่คน
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินกันกี่คน',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                TextField(
                  controller: foodPersonCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: 'เช่น 3',
                  ),
                ),
                SizedBox(height: 20),
                // เลือกกินไปวันไหน
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินไปวันไหน',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                TextField(
                  controller: foodDateCtrl,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: 'เช่น 2020-01-31',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () {
                    // เปิดปฏิทินให้เลือกวแล้ว
                    pickDate();
                  },
                ),
                SizedBox(height: 20),
                // ปุ่มบันทึกแก้ไข
                ElevatedButton(
                  onPressed: () {
                    editFood();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    fixedSize: Size(
                      MediaQuery.of(context).size.width,
                      50,
                    ),
                  ),
                  child: Text("บันทึกแก้ไข",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ),
                SizedBox(height: 10),
                // ปุ่มลบข้อมูล

                ElevatedButton(
                  onPressed: () {
                    deleteFood().then((value) {
                      Navigator.pop(context);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    fixedSize: Size(
                      MediaQuery.of(context).size.width,
                      50,
                    ),
                  ),
                  child: Text(
                    "ลบข้อมูล",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
