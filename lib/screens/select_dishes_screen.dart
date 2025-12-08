import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/dish.dart';
import '../services/api_service.dart';
import 'dish_details_screen.dart';

class SelectDishesScreen extends StatefulWidget {
  const SelectDishesScreen({super.key});

  @override
  State<SelectDishesScreen> createState() => _SelectDishesScreenState();
}

class _SelectDishesScreenState extends State<SelectDishesScreen> {
  late Future<Map<String, dynamic>> _dishData;
  final List<int> _selectedDishIds = []; 
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _dishData = _apiService.fetchAllDishes();
  }

  void _toggleDishSelection(int dishId) {
    setState(() {
      if (_selectedDishIds.contains(dishId)) {
        _selectedDishIds.remove(dishId);
      } else {
        if (_selectedDishIds.length < 3) { 
           _selectedDishIds.add(dishId);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Maximum 3 items allowed.')),
          );
        }
      }
    });
  }

  void _navigateToDishDetails(int dishId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DishDetailsScreen(dishId: dishId),
      ),
    );
  }

  // --- Widgets ---

  Widget _buildPopularDishes(List<PopularDish> popularDishes) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: popularDishes.length,
        itemBuilder: (context, index) {
          final dish = popularDishes[index];
          // Use a random placeholder image URL for popular dishes
          final imageUrl = 'https://picsum.photos/80/80?random=${dish.id}'; 

          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: ClipOval(
                    child: Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: [
                        Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.fastfood, size: 40)),
                        ),
                        // Dark overlay and dish name text (from API)
                        Container(
                          color: Colors.black.withOpacity(0.4),
                          alignment: Alignment.center,
                          child: Text(
                            dish.name,
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  dish.name,
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecommendedDishCard(Dish dish) {
    final bool isSelected = _selectedDishIds.contains(dish.id);
    // Use the API image URL for recommended dishes
    final imageUrl = dish.image;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dish Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          dish.name,
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 4),
                        // Vegetarian Indicator (Green Square)
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green, width: 2),
                          ),
                          alignment: Alignment.center,
                          child: Container(
                            width: 5,
                            height: 5,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          dish.rating.toString(),
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.green),
                        ),
                        const Icon(Icons.star, color: Colors.green, size: 14),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Equipment and Ingredients Link
                    Row(
                      children: [
                        // Equipment Icons 
                        ...dish.equipments.take(3).map((e) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(
                            e.toLowerCase().contains('microwave') ? Icons.microwave : Icons.kitchen, 
                            size: 16, 
                            color: Colors.black,
                          ),
                        )).toList(),
                        
                        const Spacer(),
                        GestureDetector(
                          onTap: () => _navigateToDishDetails(dish.id),
                          child: Padding(
                             padding: const EdgeInsets.only(right: 12.0),
                            child: Text(
                              'View Ingredients',
                              style: GoogleFonts.poppins(
                                fontSize: 12, 
                                color: Colors.green, 
                                decoration: TextDecoration.underline
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      dish.description,
                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Dish Image and Add Button
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey.shade200,
                          alignment: Alignment.center,
                          child: const Icon(Icons.image_not_supported, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: -10, 
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.red), 
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () => _toggleDishSelection(dish.id),
                        child: Text(
                          isSelected ? 'Added' : 'Add', 
                          style: GoogleFonts.poppins(
                            color: isSelected ? Colors.red : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 30),
        ],
      ),
    );
  }

  // --- Main Build Method ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 56, 
        leading: const BackButton(color: Colors.black),
        title: Text(
          'Select Dishes',
          style: GoogleFonts.poppins(
              color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {},
          )
        ],
        // The bottom part of the header (Calendar/Time and Tags)
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100.0), 
          child: Container(
            color: Colors.grey.shade50, 
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date and Time Row
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 18, color: Colors.black), 
                          const SizedBox(width: 8),
                          Text(
                            '21 May 2021',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 18, color: Colors.black), 
                          const SizedBox(width: 8),
                          Text(
                            '10:30 Pm-12:30 Pm',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Tags
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildTag('Italian', isSelected: true),
                      _buildTag('Indian'),
                      _buildTag('Indian'),
                      _buildTag('Indian'),
                      _buildTag('Chinese'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dishData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final List<Dish> originalDishes = snapshot.data!['dishes'];
            final List<PopularDish> popularDishes = snapshot.data!['popularDishes'];
            
            // --- FIX: Duplicating data to show a longer list in Recommended section ---
            // This creates a list of 6 dishes based on the 2 available from the API.
            final List<Dish> recommendedDishes = [
              // Use IDs multiplied by powers of 10 to ensure unique keys for Flutter
              ...originalDishes.map((e) => Dish(id: e.id * 10, name: e.name, rating: e.rating, description: e.description, equipments: e.equipments, image: e.image)),
              ...originalDishes.map((e) => Dish(id: e.id * 100, name: e.name, rating: e.rating, description: e.description, equipments: e.equipments, image: e.image)),
              ...originalDishes.map((e) => Dish(id: e.id * 1000, name: e.name, rating: e.rating, description: e.description, equipments: e.equipments, image: e.image)),
            ];
            // --- END DUPLICATION ---
            
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Popular Dishes Section ---
                      Text(
                        'Popular Dishes',
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _buildPopularDishes(popularDishes),
                      const Divider(height: 30),

                      // --- Recommended Section ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recommended',
                            style: GoogleFonts.poppins(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Menu',
                              style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Recommended Dishes List - Now showing 6 items
                      ...recommendedDishes.map((dish) {
                        return _buildRecommendedDishCard(dish);
                      }).toList(),
                      const SizedBox(height: 120), 
                    ],
                  ),
                ),
                // --- Bottom Navigation Bar (Floating View List) ---
                if (_selectedDishIds.isNotEmpty)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: InkWell(
                        onTap: () {
                          // Navigates to the first selected item's details (ID 1 for the mock data)
                          _navigateToDishDetails(_selectedDishIds.first);
                        },
                        child: Container(
                          height: 60, 
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '  ${_selectedDishIds.length} food items selected  ',
                                  style: GoogleFonts.poppins(
                                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const Icon(Icons.arrow_forward, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildTag(String text, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.orange.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Colors.orange : Colors.grey.shade300,
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
            color: isSelected ? Colors.orange : Colors.black, fontSize: 12),
      ),
    );
  }
}