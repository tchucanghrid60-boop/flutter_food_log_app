import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_food_log_app/models/food.dart';

class SupbaseServices {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Food>> getAllFood() async {
    //ดึงข้อมูลจากตาราง food_tb ใน supabase
    final data = await supabase
        .from('food_tb')
        .select('*')
        .order('foodDate', ascending: false);
//แปลงข้อมูลที่ได้จาก supabase ซึ่งเป็น json มาใช้ในแอปๆแล้วส่งกลับไป ณ จุดเรียกใช้เมธอดน
    return data.map<Food>((e) => Food.fromJson(e)).toList();
  }

  Future insertFood(Food food) async {
    await supabase.from('food_tb').insert(food.toJson());
  }
}
