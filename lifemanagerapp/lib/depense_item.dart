class DepenseItem {
  final String name;
  final String montant;
  final String date;
  final String description;
  final String sousCategorieId;

  DepenseItem(
    {required this.name,
    required this.montant,
    required this.date,
    required this.description,
    required this.sousCategorieId,
    }
  );
}

