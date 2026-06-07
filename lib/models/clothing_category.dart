enum ClothingCategory {
  top('Oberteil', '👕'),
  pants('Hose', '👖'),
  shoes('Schuhe', '👟'),
  jacket('Jacke', '🧥'),
  dress('Kleid', '👗');

  const ClothingCategory(this.label, this.emoji);

  final String label;
  final String emoji;

  String get promptName {
    switch (this) {
      case ClothingCategory.top:
        return 'top/shirt';
      case ClothingCategory.pants:
        return 'pants/trousers';
      case ClothingCategory.shoes:
        return 'shoes';
      case ClothingCategory.jacket:
        return 'jacket/coat';
      case ClothingCategory.dress:
        return 'dress';
    }
  }
}
