class Category {
  final String id;
  final String name;
  final String? parentId;
  final String slug;
  final int itemCount;
  final List<Category> children;

  const Category({
    required this.id,
    required this.name,
    this.parentId,
    required this.slug,
    this.itemCount = 0,
    this.children = const [],
  });
}

// Mock top categories from PRD 3.2.1
const List<Category> mockCategories = [
  Category(
    id: '1',
    name: 'Uniforms & Clothing',
    slug: 'uniforms',
    itemCount: 45,
  ),
  Category(id: '2', name: 'Safety Equipment', slug: 'safety', itemCount: 23),
  Category(id: '3', name: 'Electronics', slug: 'electronics', itemCount: 18),
  Category(id: '4', name: 'Yacht Gear', slug: 'gear', itemCount: 34),
  Category(id: '5', name: 'Services', slug: 'services', itemCount: 12),
];
