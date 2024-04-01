enum GarmentCategory {
  Topwear,
  Bottomwear,
  Innerwear,
  Outerwear,
  Others,
}

class GarmentType {
  final String id;
  final String name;
  final String imagepath;
  final double weight;
  final GarmentCategory category;
  final dynamic quantity;
  final double price;

  const GarmentType({
    required this.id,
    required this.name,
    required this.imagepath,
    required this.weight,
    required this.category,
    this.quantity = 0,
    this.price = 1.0,
  });

  GarmentType copyWith({
    String? id,
    String? name,
    String? imagepath,
    double? weight,
    GarmentCategory? category,
    dynamic quantity,
  }) {
    return GarmentType(
      id: id ?? this.id,
      name: name ?? this.name,
      imagepath: imagepath ?? this.imagepath,
      weight: weight ?? this.weight,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      price: price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imagepath': imagepath,
      'weight': weight,
      'category': category.toString(),
      'quantity': quantity,
      'price': price,
    };
  }
}

List<GarmentType> garments = const [
  GarmentType(
      id: '1',
      name: 'Jeans',
      imagepath: 'assets/jeans.svg',
      weight: 1.5,
      category: GarmentCategory.Bottomwear),
  GarmentType(
      id: '2',
      name: 'Pants',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Bottomwear),
  GarmentType(
      id: '3',
      name: 'Shirts',
      imagepath: 'assets/jeans.svg',
      weight: 0.5,
      category: GarmentCategory.Topwear),
  GarmentType(
      id: '4',
      name: 'T-Shirts',
      imagepath: 'assets/jeans.svg',
      weight: 0.5,
      category: GarmentCategory.Topwear),
  GarmentType(
      id: '5',
      name: 'Sweaters',
      imagepath: 'assets/jeans.svg',
      weight: 0.6,
      category: GarmentCategory.Topwear),
  GarmentType(
      id: '6',
      name: 'Towels',
      imagepath: 'assets/jeans.svg',
      weight: 2,
      category: GarmentCategory.Others),
  GarmentType(
      id: '7',
      name: 'Socks',
      imagepath: 'assets/jeans.svg',
      weight: 0.3,
      category: GarmentCategory.Outerwear),
  GarmentType(
      id: '8',
      name: 'Bed Sheets',
      imagepath: 'assets/jeans.svg',
      weight: 1.5,
      category: GarmentCategory.Others),
  GarmentType(
      id: '9',
      name: 'Underwear',
      imagepath: 'assets/jeans.svg',
      weight: 0.3,
      category: GarmentCategory.Innerwear),
];

List<GarmentType> ironingGarments = const [
  GarmentType(
      id: '10',
      name: 'Duvet Cover',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Others,
      price: 19.99),
  GarmentType(
      id: '11',
      name: 'Pillow Cases',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Others,
      price: 9.99),
  GarmentType(
      id: '12',
      name: 'Shirt',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Topwear,
      price: 6.99),
  GarmentType(
      id: '13',
      name: 'Gowns',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Outerwear,
      price: 20.99),
  GarmentType(
      id: '14',
      name: 'Table Cloth 12ft',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Others,
      price: 16.99),
  GarmentType(
      id: '15',
      name: 'Table Cloth 8ft',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Others,
      price: 11.99),
  GarmentType(
      id: '16',
      name: 'Casual Dress',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Outerwear,
      price: 16.99),
  GarmentType(
      id: '17',
      name: '3 Pc Suit',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Outerwear,
      price: 24.99),
  GarmentType(
      id: '18',
      name: '2 Pc Suit',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Outerwear,
      price: 19.99),
  GarmentType(
      id: '19',
      name: 'Pant',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Bottomwear,
      price: 7.99),
  GarmentType(
      id: '20',
      name: 'Napkins',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Others,
      price: 9.99),
  GarmentType(
      id: '21',
      name: 'Bed and Fitted Sheet',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Others,
      price: 17.99),
];

List<GarmentType> dryCleaningGarments = const [
  GarmentType(
      id: '22',
      name: 'Table Runner',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Others,
      price: 11.99),
  GarmentType(
      id: '23',
      name: 'Hoodie',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Outerwear,
      price: 21.99),
  GarmentType(
      id: '24',
      name: 'Jumpsuit',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Outerwear,
      price: 31.99),
  GarmentType(
      id: '25',
      name: 'Punjabi Suit',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Outerwear,
      price: 26.99),
  GarmentType(
      id: '26',
      name: 'Silk Shirt/Blouse',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Topwear,
      price: 14.99),
  GarmentType(
      id: '27',
      name: 'Gowns/Long Dress',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Outerwear,
      price: 31.99),
  GarmentType(
      id: '28',
      name: 'Feather Pillow',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Others,
      price: 29.99),
  GarmentType(
      id: '29',
      name: 'Feather Blanket',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Others,
      price: 51.99),
  GarmentType(
      id: '30',
      name: 'Leather Dress',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Outerwear,
      price: 51.99),
  GarmentType(
      id: '31',
      name: 'Leather Skirt/Pant',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Bottomwear,
      price: 51.99),
  GarmentType(
      id: '32',
      name: 'Parka Jacket',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Outerwear,
      price: 66.99),
  GarmentType(
      id: '33',
      name: 'Single Comforter/Duvet',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Others,
      price: 24.99),
  GarmentType(
      id: '34',
      name: 'Single Blanket',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Others,
      price: 21.99),
  GarmentType(
      id: '35',
      name: 'Leather Jacket',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Outerwear,
      price: 101.00),
  GarmentType(
      id: '36',
      name: 'Bag',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Others,
      price: 26.99),
  GarmentType(
      id: '37',
      name: 'Hat',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Others,
      price: 11.99),
  GarmentType(
      id: '38',
      name: 'Vest',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Topwear,
      price: 14.99),
  GarmentType(
      id: '39',
      name: 'Long Coat/Winter Jacket',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Outerwear,
      price: 41.99),
  GarmentType(
      id: '40',
      name: 'Scarf',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Others,
      price: 17.99),
  GarmentType(
      id: '41',
      name: 'Sleeping Bag',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Others,
      price: 31.99),
  GarmentType(
      id: '42',
      name: 'Wedding Dress',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Others,
      price: 181.99),
  GarmentType(
      id: '43',
      name: 'Saree',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Others,
      price: 31.99),
  GarmentType(
      id: '44',
      name: 'King Comforter',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Others,
      price: 39.99),
  GarmentType(
      id: '45',
      name: 'Queen Comforter',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Others,
      price: 31.99),
  GarmentType(
      id: '46',
      name: 'King Blanket',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Others,
      price: 36.99),
  GarmentType(
      id: '47',
      name: 'Queen Blanket',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Others,
      price: 26.99),
  GarmentType(
      id: '48',
      name: '3 Pc Suit',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Outerwear,
      price: 36.99),
  GarmentType(
      id: '49',
      name: '2 Pc Suit',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Outerwear,
      price: 29.99),
  GarmentType(
      id: '50',
      name: 'Coat/Jacket',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Outerwear,
      price: 24.99),
  GarmentType(
      id: '51',
      name: 'Casual Dress',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Outerwear,
      price: 24.99),
  GarmentType(
      id: '52',
      name: 'Pant/Skirt',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Bottomwear,
      price: 11.99),
  GarmentType(
      id: '53',
      name: 'Shirt/Blouse',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Topwear,
      price: 8.99),
  GarmentType(
      id: '54',
      name: 'Sweater',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Topwear,
      price: 14.99),
  GarmentType(
      id: '55',
      name: 'Tie',
      imagepath: 'assets/jeans.svg',
      weight: 1,
      category: GarmentCategory.Others,
      price: 7.99),
];
