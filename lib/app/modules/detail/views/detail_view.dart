// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pari_testapp/app/core/utils/app_colors.dart';
import 'package:skeletons/skeletons.dart';

import '../controllers/detail_controller.dart';

class DetailView extends GetView<DetailController> {
  const DetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DETAIL PRODUCT',
          style: TextStyle(
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
      body: Column(
        children: [
          Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
            ),
            child: const Center(
                child: Icon(Icons.laptop, size: 200, color: Colors.white)),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(6),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.all(
                Radius.circular(6.0),
              ),
            ),
            child: Obx(
              () {
                if (controller.isLoading.value) {
                  return loadingState();
                }
                return specificationView();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget loadingState() {
    return const SkeletonAvatar(
      style: SkeletonAvatarStyle(
        width: 100,
        height: 250,
      ),
    );
  }

  Widget specificationView() {
    return Column(
      children: [
        const Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(
              Icons.equalizer_sharp,
              size: 24.0,
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              'SPECIFICATION',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
        Obx(
          () => ProductInfoField(
            label: "Product Name",
            value: controller.item.value.name,
          ),
        ),
        Obx(
          () => ProductInfoField(
            label: "Price",
            value: controller.item.value.data?.price.toString(),
          ),
        ),
        Obx(
          () => ProductInfoField(
            label: "Year",
            value: controller.item.value.data?.year.toString(),
          ),
        ),
        Obx(
          () => ProductInfoField(
            label: "Color",
            value: controller.item.value.data?.color.toString(),
          ),
        ),
        Obx(
          () => ProductInfoField(
            label: "CPU Model",
            value: controller.item.value.data?.cpuModel.toString(),
          ),
        ),
        Obx(
          () => ProductInfoField(
            label: "Screen Size",
            value: controller.item.value.data?.screenSize.toString(),
          ),
        ),
        Obx(
          () => ProductInfoField(
            label: "Capacity",
            value: controller.item.value.data?.capacity.toString(),
          ),
        ),
        Obx(
          () => ProductInfoField(
            label: "Capacity GB",
            value: controller.item.value.data?.capacityGb.toString(),
          ),
        ),
        Obx(
          () => ProductInfoField(
            label: "Hard Disk Size",
            value: controller.item.value.data?.hardDiskSize.toString(),
          ),
        ),
      ],
    );
  }
}

class ProductInfoField extends StatelessWidget {
  final String label;
  final String? value;

  const ProductInfoField({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (value == null || value == "null") return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.only(top: 4),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value ?? '',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
        ],
      ),
    );
  }
}
