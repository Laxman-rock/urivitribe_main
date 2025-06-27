class Product {
  //define id int, qty int 
  int id;
  int title;
  String category;
  double price;
  String description;
  List<String> images;
  String thumbnail;
  //CartItem constructor
  Product({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.description,
    required this.images,
    required this.thumbnail,
  });
}