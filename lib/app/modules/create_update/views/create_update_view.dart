// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pari_testapp/app/core/utils/app_colors.dart';

import '../controllers/create_update_controller.dart';

class CreateUpdateView extends GetView<CreateUpdateController> {
  const CreateUpdateView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.mode.value.toUpperCase(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => inputLabel(
                    controller: controller.nameController,
                    label: "Name",
                    hint: "Please input name",
                    error: controller.nameError.value,
                  ),
                ),
                inputLabel(
                  controller: controller.priceController,
                  label: "Price",
                  hint: "Please input price",
                  inputType: TextInputType.number,
                ),
                inputLabel(
                  controller: controller.yearController,
                  label: "Year",
                  hint: "Please input year",
                  inputType: TextInputType.number,
                ),
                inputLabel(
                  controller: controller.cpuModelController,
                  label: "CPU Model",
                  hint: "Please input CPU model",
                ),
                inputLabel(
                  controller: controller.hardDiskSizeController,
                  label: "Harddisk Size",
                  hint: "Please input harddisk size",
                ),
                inputLabel(
                  controller: controller.screenSizeController,
                  label: "Screen Size",
                  hint: "Please input screen size",
                  inputType: TextInputType.number,
                ),
                inputLabel(
                  controller: controller.capacityController,
                  label: "Capacity GB",
                  hint: "Please input capacity GB",
                  inputType: TextInputType.number,
                ),
                inputLabel(
                  controller: controller.colorController,
                  label: "Color",
                  hint: "Please input color",
                ),
                const SizedBox(
                  height: 24.0,
                ),
                SizedBox(
                  height: 48,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      controller.executeButton();
                    },
                    child: const Text("Save"),
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class inputLabel extends StatelessWidget {
  const inputLabel({
    super.key,
    required this.controller,
    required this.label,
    this.error,
    required this.hint,
    this.inputType,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final String? error;
  final TextInputType? inputType;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 6.0,
          ),
          TextField(
            controller: controller,
            keyboardType: inputType,
            style: const TextStyle(
              color: Colors.black45,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Colors.black45,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              errorText: error == "" ? null : error,
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.black45,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.black45,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
