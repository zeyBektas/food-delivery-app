import 'package:collection/collection.dart';
import 'package:delivery_app/models/cart_item.dart';
import 'package:delivery_app/models/food.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Restaurant extends ChangeNotifier {
  final List<Food> _menu = [

    // burgers
    Food(
      name: "Classic Cheeseburger",
      description: "A juicy beef patty with melted cheddar, lettuce",
      imagePath: "lib/images/burgers/burger.jpg",
      price: 9.99,
      category: FoodCategory.burgers,
      availableAddons: [
        Addon(name: "Extra cheese",  price: 0.99),
        Addon(name: "Bacon",  price: 0.99),
      ],
    ),
    Food(
      name: "Hamburger",
      description: "Classic hamburger",
      imagePath: "lib/images/burgers/hamburger.jpg",
      price: 9.99,
      category: FoodCategory.burgers,
      availableAddons: [
        Addon(name: "Lettuce",  price: 0.99),
      ],
    ),
    Food(
      name: "Chicken Burger",
      description: "A chicken burger with french fries",
      imagePath: "lib/images/burgers/chicken-burger.jpg",
      price: 9.99,
      category: FoodCategory.burgers,
      availableAddons: [
        Addon(name: "Condiments",  price: 0.99),
      ],
    ),

    //desserts
    Food(
      name: "Strawberry Shortcake",
      description: "Delicious summer dessert",
      imagePath: "lib/images/desserts/summer-dessert.jpg",
      price: 9.99,
      category: FoodCategory.desserts,
      availableAddons: [Addon(name: "Extra sauce", price: 0.99)],
    ),

    //drinks
    Food(
      name: "Coca Cola",
      description: "Beverage",
      imagePath: "lib/images/drinks/coca-cola.jpg",
      price: 9.99,
      category: FoodCategory.drinks,
      availableAddons: [Addon(name: "Lemon", price: 0.99)],
    ),

    //salads
    Food(
      name: "Caesar Salad",
      description: "Salad",
      imagePath: "lib/images/salads/salad.jpg",
      price: 9.99,
      category: FoodCategory.salads,
      availableAddons: [
        Addon(name: "Egg",  price: 0.99),
        Addon(name: "Avocado",  price: 0.99),
      ],
    ),

    //sides
    Food(
      name: "Broccoli",
      description: "Caramelized broccoli with garlic",
      imagePath: "lib/images/sides/Caramelized-Broccoli.jpg",
      price: 9.99,
      category: FoodCategory.sides,
      availableAddons: [],
    ),
  ];

  final List<CartItem> _cart = [];

  String _deliveryAddress = '99 Hollywood Blv';
  // getters
  List<Food> get menu => _menu;
  List<CartItem> get cart => _cart;
  String get deliveryAddress => _deliveryAddress;

  //operations
  void addToCart(Food food, List<Addon> selectedAddons) {
    CartItem? cartItem = _cart.firstWhereOrNull((item) {
      bool isSameFood = item.food == food;
      bool isSameAddons = ListEquality(). equals(item.selectedAddons, selectedAddons);

      return isSameFood && isSameAddons;
    });

    if(cartItem != null) {
      cartItem.quantity++;
    } else {
      _cart.add(
        CartItem(
          food: food,
          selectedAddons: selectedAddons
        )
      );
    }

    notifyListeners();
  }

  void removeFromCart(CartItem cartItem) {
    int cartIndex = _cart.indexOf(cartItem);

    if (cartIndex != -1) {
      if (_cart[cartIndex].quantity > 1) {
        _cart[cartIndex].quantity--;
      } else {
        _cart.removeAt(cartIndex);
      }
    }

    notifyListeners();
  }

  double getTotalPrice() {
    double total = 0.0;

    for (CartItem cartItem in _cart) {
      double itemTotal = cartItem.food.price;

      for (Addon addon in cartItem.selectedAddons) {
        itemTotal += addon.price;
      }

      total += itemTotal * cartItem.quantity;
    }

    return total;
  }

  int getTotalItemCount() {
    int totalItemCount = 0;

    for (CartItem cartItem in _cart) {
      totalItemCount += cartItem.quantity;
    }
    return totalItemCount;
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void updateDeliveryAddress (String newAddress) {
    _deliveryAddress = newAddress;
    notifyListeners();
  }

  //helpers

  String displayCartReceipt() {
    final receipt = StringBuffer();
    receipt.writeln("Here's your receipt.");
    receipt.writeln();

    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    receipt.writeln(formattedDate);
    receipt.writeln();
    receipt.writeln("----------");

    for (final cartItem in _cart) {
      receipt.writeln("${cartItem.quantity} x ${cartItem.food.name} - ${_formatPrice(cartItem.food.price)}");
      if (cartItem.selectedAddons.isNotEmpty) {
        receipt.writeln("   Add-ons: ${_formatAddons(cartItem.selectedAddons)}");
      }
      receipt.writeln();
    }

    receipt.writeln("----------");
    receipt.writeln();
    receipt.writeln("Total Items: ${getTotalItemCount()}");
    receipt.writeln("Total Price: ${_formatPrice(getTotalPrice())}");
    receipt.writeln();
    receipt.writeln("Delivering to: $deliveryAddress");

    return receipt.toString();
  }

  String _formatPrice(double price) {
    return "\$${price.toStringAsFixed(2)}";
  }

  String _formatAddons(List<Addon> addons) {
    return addons
        .map((addon) => "${addon.name} (${_formatPrice(addon.price)})")
        .join(", ");
  }

}