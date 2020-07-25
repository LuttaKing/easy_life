import 'package:easy_life/services/cartItemModel.dart';
import 'package:flutter/material.dart';

class CartList extends ChangeNotifier{

  List<CartItem> _cartList=[];

  addItemToList(var name,var price,var picUrl,var quantity){
    CartItem cartItem = CartItem(name: name,price: price,picUrl: picUrl,qantity: quantity);

    _cartList.add(cartItem);

    notifyListeners();

  }
}