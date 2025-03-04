// ignore_for_file: unused_local_variable, depend_on_referenced_packages, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:inventory/Constants/toaster.dart';
import 'dart:convert';
import 'api_config.dart';

class InventoryController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController serialController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController itemRemarksController = TextEditingController();

  final TextEditingController pNameController = TextEditingController();
  final TextEditingController pNoController = TextEditingController();
  final TextEditingController pPoController = TextEditingController();
  final TextEditingController pInvoiceController = TextEditingController();

  final TextEditingController vendorNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController receiversController = TextEditingController();
  final TextEditingController vendorRemarksController = TextEditingController();

  RxString selectedMainCategory = "GeoScience".obs;
  List<String> mainCategoriesList = [
    "GeoScience",
    "GeoInformatics",
    "GeoEngineering",
    "ESS"
  ];

  RxString selectedCategory = "Electrical".obs;
  List<String> categoriesList = [
    "Electrical",
    "Mechanical",
    "IT",
    "Accounts",
    "Admin",
    "General"
  ];

  RxString selectedType = "Rental".obs;
  List<String> typeList = [
    "Rental",
    "Assets",
    "Stock",
    "Consumables",
    "Repair/Services"
  ];

  RxString selectedLocation = "Inhouse".obs;
  List<String> locationList = ["Inhouse", "Warehouse", "Onfield"];

  RxString selectedReturnable = "NonReturnable".obs;
  List<String> returnableList = ["NonReturnable", "Returnable"];

  String selectedMos = "ByRoad";
  List<String> mosList = ["ByRoad", "ByAir", "ByTrain", "ByShip"];

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen for changes in selectedMainCategory
    selectedMainCategory.listen((newCategory) {
      updateCategoriesList(newCategory);
    });
  }

  void updateCategoriesList(String mainCategory) {
    if (mainCategory == "ESS") {
      categoriesList = ["Accounts", "Admin", "General"];
      selectedCategory.value = categoriesList.first;
    } else {
      categoriesList = ["Electrical", "Mechanical", "IT", "General"];
      selectedCategory.value = categoriesList.first;
    }
    // Trigger UI update by setting the value again
    selectedCategory.refresh();
  }

  @override
  void onClose() {
    nameController.dispose();
    modelController.dispose();
    serialController.dispose();
    qtyController.dispose();
    priceController.dispose();
    itemRemarksController.dispose();
    pNameController.dispose();
    pNoController.dispose();
    pPoController.dispose();
    pInvoiceController.dispose();
    vendorNameController.dispose();
    dateController.dispose();
    placeController.dispose();
    // mosController.dispose();
    receiversController.dispose();
    vendorRemarksController.dispose();
    super.onClose();
  }

  Future<String> saveData() async {
    try {
      double qty = double.parse(qtyController.text);
      double price = double.parse(priceController.text);
      double totalPrice = qty * price;

      isLoading.value = true;

      var response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.addInventory}'),
        headers: {
          "content-type": "application/x-www-form-urlencoded",
        },
        body: {
          "name": nameController.text,
          "model_no": modelController.text,
          "serial_no": serialController.text,
          "qty": qtyController.text,
          "price": priceController.text,
          "total_price": totalPrice.toString(),
          "main_category": selectedMainCategory.value,
          "category": selectedCategory.value,
          "type": selectedType.value,
          "location": selectedLocation.value,
          "returnable": selectedReturnable.value,
          "item_remarks": itemRemarksController.text,
          "project_name": pNameController.text,
          "project_no": pNoController.text,
          "purchase_order": pPoController.text,
          "invoice_no": pInvoiceController.text,
          "vendor_name": vendorNameController.text,
          "date": dateController.text,
          "place": placeController.text,
          "mos": selectedMos,
          "receiver_name": receiversController.text,
          "vendor_remarks": vendorRemarksController.text,
          "Stock_in_out": 'Stock In',
        },
      );

      if (response.statusCode == 200) {
        print('response body : ${response.body}');
        Map<String, dynamic> data = json.decode(response.body);
        // print("Response: $data");
        print(data['status']);
        if (data['status'] == 'success') {
          final String remark = data['remark'];
          Toaster().showsToast(remark, Colors.green, Colors.white);

          await addVendor();
          await addReceiver();
          clearFields();
          print("ok");
          return "ok";
        } else {
          final String message = data['remark'];
          Toaster().showsToast(message, Colors.red, Colors.white);

          isLoading.value = false;
        }
      } else {
        print("Failed to save data. Status code: ${response.statusCode}");
        print('Response body: ${response.body}');
        isLoading.value = false;
        return "bad";
      }
    } catch (e) {
      print('Error: $e');
      return "bad";
    } finally {
      isLoading.value = false;
    }
    return "bad";
  }

  void clearFields() {
    nameController.clear();
    modelController.clear();
    serialController.clear();
    qtyController.clear();
    priceController.clear();
    itemRemarksController.clear();
    pNameController.clear();
    pPoController.clear();
    pNoController.clear();
    pInvoiceController.clear();
    vendorNameController.clear();
    dateController.clear();
    placeController.clear();
    receiversController.clear();
    vendorRemarksController.clear();
  }

  Future<void> addVendor() async {
    try {
      isLoading.value = true;
      var response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.addVendor}'),
        headers: {
          "content-type": "application/x-www-form-urlencoded",
        },
        body: {
          "vendorName": vendorNameController.text,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Vendor added: $data");
        isLoading.value = false;
      } else {
        print("Failed to add vendor. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print('Error adding vendor: $e');
      isLoading.value = false;
    }
  }

  Future<void> addReceiver() async {
    try {
      isLoading.value = true;
      var response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.addReceiver}'),
        headers: {
          "content-type": "application/x-www-form-urlencoded",
        },
        body: {
          "receiverName": receiversController.text,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("receiver added: $data");
        isLoading.value = false;
      } else {
        print("Failed to add receiver. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print('Error adding receiver: $e');
      isLoading.value = false;
    }
  }
}
