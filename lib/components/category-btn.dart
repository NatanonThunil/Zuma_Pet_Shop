import 'package:flutter/material.dart';

class CategoryBTN extends StatelessWidget {
  final Function(String) onCategorySelected;

  CategoryBTN({required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCategoryButton('Pet', Icons.pets, 'Pet', context),
          _buildCategoryButton('Toys', Icons.shopping_bag, 'Toys', context),
          _buildCategoryButton(
              'Pet Foods', Icons.food_bank, 'Pet Foods', context),
          _buildCategoryButton('All', Icons.apps_rounded, 'All', context),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(
      String label, IconData icon, String category, BuildContext context) {
    return GestureDetector(
      onTap: () {
        onCategorySelected(category);
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(50)),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Icon(
                  icon, color: Colors.white,
                  size: 40.0, // Set the size of the icon
                ),
              ),
            ),
          ),
          Container(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: const Color.fromARGB(255, 53, 53, 53),
                    fontSize: 16,
                  ),
            ),
          )
        ],
      ),
    );
  }
}
