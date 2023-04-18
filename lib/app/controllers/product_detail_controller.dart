//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2023, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/cart.dart';
import 'package:flutter_app/app/models/cart_line_item.dart';
import 'package:flutter_app/bootstrap/enums/wishlist_action_enums.dart';
import 'package:flutter_app/bootstrap/helpers.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:woocommerce_api/woocommerce_api.dart';
import '../models/core/products.dart';
import '../models/core/product_variation.dart' as ws_product_variation;
// ignore: depend_on_referenced_packages
import 'controller.dart';

class ProductDetailController extends Controller {
  int quantity = 1;
  Product? product;

  @override
  construct(BuildContext context) {
    super.construct(context);

    //product = data() as Product?;
    product = getProducts() as Product?;
  }

  Future getProducts() async {
    // Initialize the API
    WooCommerceAPI wooCommerceAPI = WooCommerceAPI(
        url: "https://magicskin.com.vn",
        consumerKey: "ck_f57ead1743b7b24757aa19b6918ab9f32920a353",
        consumerSecret: "cs_0a56873b3a8b0279d26382223adc427168f551c2");

    // Get data using the "products" endpoint
    var products = await wooCommerceAPI.getAsync("products/4673");
    return products;
  }

  viewExternalProduct() {
    if (product!.externalUrl != null && product!.externalUrl!.isNotEmpty) {
      openBrowserTab(url: product!.externalUrl!);
    }
  }

  itemAddToCart(
      {required CartLineItem cartLineItem, required Function onSuccess}) async {
    await Cart.getInstance.addToCart(cartLineItem: cartLineItem);
    showStatusAlert(
      context,
      title: trans("Success"),
      subtitle: trans("Added to cart"),
      duration: 1,
      icon: Icons.add_shopping_cart,
    );
    onSuccess();
  }

  addQuantityTapped({required Function onSuccess}) {
    if (product!.manageStock != null && product!.manageStock == true) {
      if (quantity >= product!.stockQuantity!) {
        showToastNotification(context!,
            title: trans("Maximum quantity reached"),
            description:
                "${trans("Sorry, only")} ${product!.stockQuantity} ${trans("left")}",
            style: ToastNotificationStyleType.INFO);
        return;
      }
    }
    if (quantity != 0) {
      quantity++;
      onSuccess();
    }
  }

  removeQuantityTapped({required Function onSuccess}) {
    if ((quantity - 1) >= 1) {
      quantity--;
      onSuccess();
    }
  }

  toggleWishList(
      {required Function onSuccess,
      required WishlistAction wishlistAction}) async {
    String subtitleMsg;
    if (wishlistAction == WishlistAction.remove) {
      await removeWishlistProduct(product: product);
      subtitleMsg = trans("This product has been removed from your wishlist");
    } else {
      await saveWishlistProduct(product: product);
      subtitleMsg = trans("This product has been added to your wishlist");
    }
    showStatusAlert(
      context,
      title: trans("Success"),
      subtitle: subtitleMsg,
      icon: Icons.favorite,
      duration: 1,
    );

    onSuccess();
  }

  ws_product_variation.ProductVariation? findProductVariation(
      {required Map<int, dynamic> tmpAttributeObj,
      required List<ws_product_variation.ProductVariation> productVariations}) {
    ws_product_variation.ProductVariation? tmpProductVariation;

    Map<String?, dynamic> tmpSelectedObj = {};
    for (var attributeObj in tmpAttributeObj.values) {
      tmpSelectedObj[attributeObj["name"]] = attributeObj["value"];
    }

    for (var productVariation in productVariations) {
      Map<String?, dynamic> tmpVariations = {};

      for (var attr in productVariation.attributes) {
        tmpVariations[attr.name] = attr.option;
      }

      if (tmpVariations.toString() == tmpSelectedObj.toString()) {
        tmpProductVariation = productVariation;
      }
    }

    return tmpProductVariation;
  }
}
