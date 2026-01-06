import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class FirestoreService {
  final CollectionReference _db = FirebaseFirestore.instance.collection('products');

  Stream<List<Product>> getProducts() {
    return _db.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Product.fromFirestore(doc.data() as Map<String, dynamic>, doc.id)).toList());
  }

  Future<void> addProduct(String name, String price, String url) {
    return _db.add({'name': name, 'price': price, 'imageUrl': url, 'category': 'Premium'});
  }

  Future<void> deleteProduct(String id) => _db.doc(id).delete();

  Future<void> updateProduct(String id, String n, String p) => _db.doc(id).update({'name': n, 'price': p});
}