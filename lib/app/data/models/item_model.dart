// To parse this JSON data, do
//
//     final itemModel = itemModelFromJson(jsonString);

import 'dart:convert';

ItemModel itemModelFromJson(String str) => ItemModel.fromJson(json.decode(str));

String itemModelToJson(ItemModel data) => json.encode(data.toJson());

class ItemModel {
    String? id;
    String? name;
    ItemData? data;

    ItemModel({
        this.id,
        this.name,
        this.data,
    });

    factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
        id: json["id"],
        name: json["name"],
        data: json["data"] == null ? null : ItemData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "data": data?.toJson(),
    };
}

class ItemData {
    int? year;
    double? price;
    String? cpuModel;
    String? hardDiskSize;
    double? screenSize;
    int? capacityGb;
    String? capacity;
    String? color;

    ItemData({
        this.year,
        this.price,
        this.cpuModel,
        this.hardDiskSize,
        this.screenSize,
        this.capacityGb,
        this.capacity,
        this.color,
    });

    factory ItemData.fromJson(Map<String, dynamic> json) => ItemData(
        year: json["year"],
        price: json["price"]?.toDouble(),
        cpuModel: json["CPU model"],
        hardDiskSize: json["Hard disk size"],
        screenSize: json["Screen size"]?.toDouble(),
        capacityGb: json["capacity GB"],
        capacity: json["Capacity"],
        color: json["color"],
    );

    Map<String, dynamic> toJson() => {
        "year": year,
        "price": price,
        "CPU model": cpuModel,
        "Hard disk size": hardDiskSize,
        "Screen size": screenSize,
        "capacity GB": capacityGb,
        "Capacity": capacity,
        "color": color,
    };
}
