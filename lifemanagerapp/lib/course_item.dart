class CourseItem {
  final String category;
  final String name;
  final String price;
  final String categorie_id;
  final String id;
  final String quantite;

  CourseItem(
      {required this.name,
      required this.price,
      required this.category,
      required this.categorie_id,
      required this.id,
      required this.quantite});
}
