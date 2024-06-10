import "dart:io";

class cars {
  File updatedImage = null;
  String id;
  String image;
  String name;
  double price;
  String description;
  String phone;
  cars(
      {this.id,
      this.image,
      this.name,
      this.price,
      this.description,
      this.phone,
      this.updatedImage});
}
