// Cart models for Flutter
import 'dart:convert';

// Main Cart Model
class CartModel {
  final String id;
  final String currencyCode;
  final String? email;
  final String regionId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;
  final int total;
  final double subtotal;
  final double taxTotal;
  final int discountTotal;
  final int discountSubtotal;
  final int discountTaxTotal;
  final int originalTotal;
  final double originalTaxTotal;
  final int itemTotal;
  final double itemSubtotal;
  final double itemTaxTotal;
  final int originalItemTotal;
  final double originalItemSubtotal;
  final double originalItemTaxTotal;
  final int shippingTotal;
  final int shippingSubtotal;
  final int shippingTaxTotal;
  final int originalShippingTaxTotal;
  final int originalShippingSubtotal;
  final int originalShippingTotal;
  final Map<String, dynamic>? metadata;
  final String salesChannelId;
  final String shippingAddressId;
  final String? customerId;
  final List<CartItem> items;
  final List<dynamic> shippingMethods;
  final ShippingAddress shippingAddress;
  final dynamic billingAddress;

  final List<dynamic> promotions;

  CartModel({
    required this.id,
    required this.currencyCode,
    this.email,
    required this.regionId,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
    required this.total,
    required this.subtotal,
    required this.taxTotal,
    required this.discountTotal,
    required this.discountSubtotal,
    required this.discountTaxTotal,
    required this.originalTotal,
    required this.originalTaxTotal,
    required this.itemTotal,
    required this.itemSubtotal,
    required this.itemTaxTotal,
    required this.originalItemTotal,
    required this.originalItemSubtotal,
    required this.originalItemTaxTotal,
    required this.shippingTotal,
    required this.shippingSubtotal,
    required this.shippingTaxTotal,
    required this.originalShippingTaxTotal,
    required this.originalShippingSubtotal,
    required this.originalShippingTotal,
    this.metadata,
    required this.salesChannelId,
    this.customerId,
    required this.items,
    required this.shippingMethods,
    required this.shippingAddress,
    required this.shippingAddressId,
    this.billingAddress,
    required this.promotions,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] ?? '',
      currencyCode: json['currency_code'] ?? '',
      email: json['email'] ?? '',
      regionId: json['region_id'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      total: json['total'] ?? 0,
      subtotal: double.parse((json['subtotal'] ?? "0").toString()),
      taxTotal: double.parse((json['tax_total'] ?? "0").toString()),
      discountTotal: json['discount_total'] ?? 0,
      discountSubtotal: json['discount_subtotal'] ?? 0,
      discountTaxTotal: json['discount_tax_total'] ?? 0,
      originalTotal: json['original_total'] ?? 0,
      originalTaxTotal:double.parse((json['original_tax_total'] ?? "0").toString()) ,
      itemTotal: json['item_total'] ?? 0,
      itemSubtotal: double.parse((json['item_subtotal'] ?? "0").toString()),
      itemTaxTotal: double.parse((json['item_tax_total'] ?? "0").toString()),
      originalItemTotal: json['original_item_total'] ?? 0,
      originalItemSubtotal: double.parse((json['original_item_subtotal'] ?? "0").toString()) ,
      originalItemTaxTotal: double.parse((json['original_item_tax_total'] ?? "0").toString()),
      shippingTotal: json['shipping_total'] ?? 0,
      shippingSubtotal: json['shipping_subtotal'] ?? 0,
      shippingTaxTotal: json['shipping_tax_total'] ?? 0,
      originalShippingTaxTotal: json['original_shipping_tax_total'] ?? 0,
      originalShippingSubtotal: json['original_shipping_subtotal'] ?? 0,
      originalShippingTotal: json['original_shipping_total'] ?? 0,
      metadata: json['metadata'],
      salesChannelId: json['sales_channel_id'] ?? '',
      shippingAddressId: json['shipping_address_id'] ?? '',
      customerId: json['customer_id'] ?? '',
      items: (json['items'] != null)
          ? (json['items'] as List)
              .map((item) => CartItem.fromJson(item))
              .toList()
          : [],
      shippingMethods: json['shipping_methods'] ?? [],
      shippingAddress: (json['shipping_address'] != null)
          ? ShippingAddress.fromJson(json['shipping_address'])
          : ShippingAddress(
              id: '',
              address1: '',
              address2: '',
              city: '',
              countryCode: '',
              province: '',
            ),
      promotions: json['promotions'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'currency_code': currencyCode,
      'email': email,
      'region_id': regionId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'total': total,
      'subtotal': subtotal,
      'tax_total': taxTotal,
      'discount_total': discountTotal,
      'discount_subtotal': discountSubtotal,
      'discount_tax_total': discountTaxTotal,
      'original_total': originalTotal,
      'original_tax_total': originalTaxTotal,
      'item_total': itemTotal,
      'item_subtotal': itemSubtotal,
      'item_tax_total': itemTaxTotal,
      'original_item_total': originalItemTotal,
      'original_item_subtotal': originalItemSubtotal,
      'original_item_tax_total': originalItemTaxTotal,
      'shipping_total': shippingTotal,
      'shipping_subtotal': shippingSubtotal,
      'shipping_tax_total': shippingTaxTotal,
      'original_shipping_tax_total': originalShippingTaxTotal,
      'original_shipping_subtotal': originalShippingSubtotal,
      'original_shipping_total': originalShippingTotal,
      'metadata': metadata,
      'sales_channel_id': salesChannelId,
      'shipping_address_id': shippingAddressId,
      'customer_id': customerId,
      'items': items.map((item) => item.toJson()).toList(),
      'shipping_methods': shippingMethods,
      'shipping_address': shippingAddress.toJson(),
      'billing_address': billingAddress,
      'promotions': promotions,
    };
  }
}

// CartItem Model
class CartItem {
  final String id;
  final String thumbnail;
  final String variantId;
  final String productId;
  final String? productTypeId;
  final String productTitle;
  final String productDescription;
  final String productSubtitle;
  final dynamic productType;
  final dynamic productCollection;
  final String productHandle;
  final String? variantSku;
  final String? variantBarcode;
  final String variantTitle;
  final bool requiresShipping;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String title;
  int quantity;
  final int unitPrice;
  final int? compareAtUnitPrice;
  final bool isTaxInclusive;
  final List<dynamic> taxLines;
  final List<dynamic> adjustments;
  final Product product;

  CartItem({
    required this.id,
    required this.thumbnail,
    required this.variantId,
    required this.productId,
    this.productTypeId,
    required this.productTitle,
    required this.productDescription,
    required this.productSubtitle,
    this.productType,
    this.productCollection,
    required this.productHandle,
    this.variantSku,
    this.variantBarcode,
    required this.variantTitle,
    required this.requiresShipping,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.quantity,
    required this.unitPrice,
    this.compareAtUnitPrice,
    required this.isTaxInclusive,
    required this.taxLines,
    required this.adjustments,
    required this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      thumbnail: json['thumbnail'] ??
          'https://static.asianpaints.com/content/dam/asian_paints/home/webp-images/paints-and-textures/interior-walls-lp-thumbnail.webp',
      variantId: json['variant_id'],
      productId: json['product_id'],
      productTypeId: json['product_type_id'],
      productTitle: json['product_title'],
      productDescription: json['product_description'],
      productSubtitle: json['product_subtitle'],
      productType: json['product_type'],
      productCollection: json['product_collection'],
      productHandle: json['product_handle'],
      variantSku: json['variant_sku'],
      variantBarcode: json['variant_barcode'],
      variantTitle: json['variant_title'],
      requiresShipping: json['requires_shipping'],
      metadata: json['metadata'] ?? {},
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      title: json['title'],
      quantity: json['quantity'],
      unitPrice: json['unit_price'],
      compareAtUnitPrice: json['compare_at_unit_price'],
      isTaxInclusive: json['is_tax_inclusive'],
      taxLines: json['tax_lines'] ?? [],
      adjustments: json['adjustments'] ?? [],
      product: Product.fromJson(json['product']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'thumbnail': thumbnail,
      'variant_id': variantId,
      'product_id': productId,
      'product_type_id': productTypeId,
      'product_title': productTitle,
      'product_description': productDescription,
      'product_subtitle': productSubtitle,
      'product_type': productType,
      'product_collection': productCollection,
      'product_handle': productHandle,
      'variant_sku': variantSku,
      'variant_barcode': variantBarcode,
      'variant_title': variantTitle,
      'requires_shipping': requiresShipping,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'title': title,
      'quantity': quantity,
      'unit_price': unitPrice,
      'compare_at_unit_price': compareAtUnitPrice,
      'is_tax_inclusive': isTaxInclusive,
      'tax_lines': taxLines,
      'adjustments': adjustments,
      'product': product.toJson(),
    };
  }
}

// Product Model
class Product {
  final String id;
  final String? collectionId;
  final String? typeId;
  final List<Category> categories;
  final List<dynamic> tags;

  Product({
    required this.id,
    this.collectionId,
    this.typeId,
    required this.categories,
    required this.tags,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      collectionId: json['collection_id'],
      typeId: json['type_id'],
      categories: (json['categories'] as List)
          .map((category) => Category.fromJson(category))
          .toList(),
      tags: json['tags'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'collection_id': collectionId,
      'type_id': typeId,
      'categories': categories.map((category) => category.toJson()).toList(),
      'tags': tags,
    };
  }
}

// Category Model
class Category {
  final String id;

  Category({
    required this.id,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}

// ShippingAddress Model
class ShippingAddress {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? company;
  final String? address1;
  final String? address2;
  final String? city;
  final String? postalCode;
  final String countryCode;
  final String? province;
  final String? phone;

  ShippingAddress({
    required this.id,
    this.firstName,
    this.lastName,
    this.company,
    this.address1,
    this.address2,
    this.city,
    this.postalCode,
    required this.countryCode,
    this.province,
    this.phone,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      company: json['company'],
      address1: json['address_1'],
      address2: json['address_2'],
      city: json['city'],
      postalCode: json['postal_code'],
      countryCode: json['country_code'],
      province: json['province'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'company': company,
      'address_1': address1,
      'address_2': address2,
      'city': city,
      'postal_code': postalCode,
      'country_code': countryCode,
      'province': province,
      'phone': phone,
    };
  }
}

// Region Model
class Region {
  final String id;
  final String name;
  final String currencyCode;
  final bool automaticTaxes;
  final List<Country> countries;

  Region({
    required this.id,
    required this.name,
    required this.currencyCode,
    required this.automaticTaxes,
    required this.countries,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['id'],
      name: json['name'],
      currencyCode: json['currency_code'],
      automaticTaxes: json['automatic_taxes'],
      countries: (json['countries'] as List)
          .map((country) => Country.fromJson(country))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'currency_code': currencyCode,
      'automatic_taxes': automaticTaxes,
      'countries': countries.map((country) => country.toJson()).toList(),
    };
  }
}

// Country Model
class Country {
  final String iso2;
  final String iso3;
  final String numCode;
  final String name;
  final String displayName;
  final String regionId;
  final dynamic metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;

  Country({
    required this.iso2,
    required this.iso3,
    required this.numCode,
    required this.name,
    required this.displayName,
    required this.regionId,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      iso2: json['iso_2'],
      iso3: json['iso_3'],
      numCode: json['num_code'],
      name: json['name'],
      displayName: json['display_name'],
      regionId: json['region_id'],
      metadata: json['metadata'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iso_2': iso2,
      'iso_3': iso3,
      'num_code': numCode,
      'name': name,
      'display_name': displayName,
      'region_id': regionId,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}

// Example usage of the model with the provided JSON data
CartResponse parseCartResponse(String jsonString) {
  final Map<String, dynamic> jsonData = json.decode(jsonString);
  return CartResponse.fromJson(jsonData);
}

class CartResponse {
  final CartModel cart;

  CartResponse({required this.cart});

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      cart: CartModel.fromJson(json['cart']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart': cart.toJson(),
    };
  }
}
