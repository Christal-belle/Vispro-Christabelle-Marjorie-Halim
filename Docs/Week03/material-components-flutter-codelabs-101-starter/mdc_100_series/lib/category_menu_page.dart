import 'package:flutter/material.dart';
import 'colors.dart';
import 'model/product.dart';

class CategoryMenuPage extends StatelessWidget {
  final Category currentCategory;
  final ValueChanged<Category> onCategoryTap;

  const CategoryMenuPage({
    Key? key,
    required this.currentCategory,
    required this.onCategoryTap,
  }) : super(key: key);

  Widget _buildCategory(Category category, BuildContext context) {
    String categoryString =
        category.toString().toUpperCase().replaceAll('CATEGORY.', '');
    bool isSelected = category == currentCategory;

    ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: () => onCategoryTap(category),
      child: categoryString == 'ALL'
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  categoryString,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  categoryString,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isSelected
                        ? kShrineBrown900
                        : kShrineBrown900.withAlpha(153),
                  ),
                ),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(top: 40.0),
        color: kShrinePink100,
        child: ListView(
          children: Category.values
              .map((Category c) => _buildCategory(c, context))
              .toList(),
        ),
      ),
    );
  }
}