import 'package:flutter/material.dart';
import '../service/auth_service.dart';
import '../models/product.dart';
import 'login_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String searchQuery = "";
  String userEmail = "Chargement..."; // Variable email

  final Color marronChocolat = const Color(0xFF8B4513);
  final Color vertOlive = const Color(0xFF556B2F);
  final Color grisFond = const Color(0xFFF5F5F5);

  @override
  void initState() {
    super.initState();
    _loadUserEmail(); // Shared Preferences
  }

  // Shared Preferences : Récupération
  void _loadUserEmail() async {
    String? email = await AuthService().getUserEmail();
    setState(() {
      userEmail = email ?? "Utilisateur";
    });
  }

  final List<Product> _allProducts = [
    Product(id: "1", name: "Aviateur Gold", price: "300 000", imageUrl: "http://googleusercontent.com/image_collection/image_retrieval/14987872930684551150_0", category: "Luxe"),
    Product(id: "2", name: "Wayfarer Black", price: "120 000", imageUrl: "http://googleusercontent.com/image_collection/image_retrieval/5669866401174180433_0", category: "Tendance"),
    Product(id: "3", name: "Vintage Round", price: "145 000", imageUrl: "http://googleusercontent.com/image_collection/image_retrieval/17263990132470096006_0", category: "Retro"),
    Product(id: "4", name: "Sport Edition", price: "89 000", imageUrl: "http://googleusercontent.com/image_collection/image_retrieval/18373648876101304277_0", category: "Sport"),
    Product(id: "5", name: "Cat-Eye Luxe", price: "199 000", imageUrl: "http://googleusercontent.com/image_collection/image_retrieval/11656751395619592042_0", category: "Femme"),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _allProducts
        .where((p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: grisFond,
      body: Column(
        children: [
          _buildStyledHeader(),
          _buildSearchBar(),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) => _buildProductCard(filteredProducts[index]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: marronChocolat,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {},
      ),
    );
  }

  Widget _buildStyledHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [marronChocolat, vertOlive],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("OptiLook",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              Text(userEmail, // Affichage email Shared Preferences
                  style: const TextStyle(color: Colors.white70, fontSize: 16)),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white, size: 28),
              onPressed: () async {
                await AuthService().signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Transform.translate(
      offset: const Offset(0, -25),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          child: TextField(
            onChanged: (v) => setState(() => searchQuery = v),
            decoration: InputDecoration(
              hintText: "Trouver vos lunettes...",
              prefixIcon: Icon(Icons.search, color: vertOlive),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Product p) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(p.imageUrl, fit: BoxFit.cover, width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, color: marronChocolat),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1),
                const SizedBox(height: 5),
                Text("${p.price}fc", style: TextStyle(color: marronChocolat, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
    );
  }
}