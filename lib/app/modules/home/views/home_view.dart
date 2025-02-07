import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pari_testapp/app/core/utils/app_colors.dart';
import 'package:pari_testapp/app/data/models/item_model.dart';
import 'package:pari_testapp/app/routes/app_pages.dart';
import 'package:skeletons/skeletons.dart';
import '../controllers/home_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loading_indicator/loading_indicator.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'PARI',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
            ),
            child: searchBar(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              controller: ScrollController(),
              child: Container(
                height: MediaQuery.of(context).size.height - 210,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0),
                  ),
                ),
                child: Obx(
                  () {
                    if (controller.isLoading.value) {
                      return loadingState();
                    }
                    return listItem();
                  },
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.CREATE_UPDATE),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget searchBar() {
    return TextField(
      controller: controller.searchController,
      keyboardType: TextInputType.text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: "Search in Laptops",
        hintStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        contentPadding: const EdgeInsets.all(12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 2,
          ),
        ),
      ),
      onChanged: (value) => controller.searchItems(value),
    );
  }

  Widget loadingState() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: 0.7,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return const SkeletonAvatar(
          style: SkeletonAvatarStyle(
            width: double.infinity,
            height: double.maxFinite,
          ),
        );
      },
    );
  }

  Widget listItem() {
    return SmartRefresher(
      physics: const BouncingScrollPhysics(),
      enablePullDown: true,
      dragStartBehavior: DragStartBehavior.down,
      header: const WaterDropHeader(
        waterDropColor: AppColors.primaryColor,
        refresh: Center(
          child: SizedBox(
            height: 40,
            child: LoadingIndicator(
              indicatorType: Indicator.ballBeat,
              colors: [AppColors.primaryColor],
            ),
          ),
        ),
        complete: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle,
                  size: 24.0, color: AppColors.successColor),
              SizedBox(width: 4),
              Text(
                "Completed",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
      controller: controller.refreshController,
      onRefresh: controller.onRefresh,
      onLoading: () {},
      child: controller.filteredItems.isEmpty
          ? emptyState()
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              itemCount: controller.filteredItems.length,
              itemBuilder: (context, index) {
                final item = controller.filteredItems[index];
                return buildItemCard(item);
              },
            ),
    );
  }

  Widget emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.hourglass_empty, size: 100, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            "Tidak ada data tersedia",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Coba segarkan kembali atau ubah pencarian.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.fetchItems,
            child: const Text("Muat Ulang"),
          ),
        ],
      ),
    );
  }

  Widget buildItemCard(ItemModel item) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.DETAIL, arguments: item.id),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
              child: Icon(Icons.laptop, size: 50, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  Text(
                    item.name ?? "Unknown",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "\$${item.data?.price ?? 'N/A'}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${item.data?.year ?? 'Unknown'} • ${item.data?.color ?? 'Unknown'}",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.black),
                          onPressed: () => Get.toNamed(Routes.CREATE_UPDATE, arguments: item.id),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => controller.confirmDeleteItem(item.id!, item.name!),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
