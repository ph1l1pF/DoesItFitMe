enum ClothingCategory {
  top('Top', '👕'),
  pants('Pants', '👖'),
  skirt('Skirt', '👚'),
  shoes('Shoes', '👟'),
  jacket('Jacket', '🧥'),
  dress('Dress', '👗');

  const ClothingCategory(this.label, this.emoji);

  final String label;
  final String emoji;

  String get promptName {
    switch (this) {
      case ClothingCategory.top:
        return 'top/shirt';
      case ClothingCategory.pants:
        return 'pants/trousers';
      case ClothingCategory.skirt:
        return 'skirt';
      case ClothingCategory.shoes:
        return 'shoes';
      case ClothingCategory.jacket:
        return 'jacket/coat';
      case ClothingCategory.dress:
        return 'dress';
    }
  }
}
