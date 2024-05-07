import 'package:flutter/material.dart';
import 'package:zumas_pet_shop/pages/likePage.dart';
import 'package:zumas_pet_shop/pages/mycart.dart';
import '../pages/setting.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<IconData> icons = [
      Icons.thumb_up,
      Icons.sell,
      Icons.home,
      Icons.alarm,
      Icons.shopping_cart,
    ];

    List<String> labels = [
      "Like",
      "Discount",
      "Home",
      "Alarm",
      "Cart",
    ];

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 4:
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyCart()));
            break;
          case 3: // Handle navigation for "Alarm" (index 3)
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ZumaSetting()));
            break;
          case 0: // Handle navigation for "Like" (index 0)
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LikePage()));
            break;
          case 1: // Handle navigation for "Discount" (index 1)
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ZumaSetting()));
            break;
          case 2: // Implicitly handled by default case (Home)
            break;
          default:
            // Handle unexpected index or potential errors
            print("Warning: Tapped on unexpected index: $index");
        }
      },
      items: List.generate(
        icons.length,
        (index) => BottomNavigationBarItem(
          icon: Icon(
            icons[index],
            color: index == currentIndex ? Colors.black : Colors.grey,
          ),
          label: labels[index],
        ),
      ),
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
    );
  }
}
