import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/dish.dart';
import '../services/api_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      height: 70, // tight height like design
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: popularDishes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final dish = popularDishes[index];

          return SizedBox(
            width: 57,
            height: 57,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Dish Image
                ClipOval(
                  child: Image.network(
                    dish.image,
                    width: 57,
                    height: 57,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => Container(
                          width: 57,
                          height: 57,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.fastfood),
                        ),
                  ),
                ),

                // Dark overlay (#1C1C1C9A)
                Container(
                  width: 57,
                  height: 57,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x9A1C1C1C),
                  ),
                ),

                // Dish Name inside circle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    dish.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LEFT CONTENT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // NAME + VEG + RATING
                    Row(
                      children: [
                        Text(
                          dish.name,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(2),
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${dish.rating}★',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // EQUIPMENT + INGREDIENTS
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/Group 508.svg',
                          width: 17,
                          height: 28,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 14),
                        SvgPicture.asset(
                          'assets/icons/Group 508.svg',
                          width: 17,
                          height: 28,
                          fit: BoxFit.cover,
                        ),

                        const SizedBox(width: 12),
                        Container(
                          height: 20,
                          width: 1,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(width: 22),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ingredients',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _navigateToDishDetails(dish.id),
                              child: const Text(
                                'View list >',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // DESCRIPTION
                    Text(
                      dish.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // RIGHT IMAGE + ADD BUTTON
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Dish image from assets
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/icons/Mask Group 19.png',
                      width: 92,
                      height: 68,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // ADD button ON image (front)
                  Positioned(
                    bottom: -8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => _toggleDishSelection(dish.id),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.orange),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 4),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(
                              isSelected ? 'Added' : 'Add',
                              style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (!isSelected) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.add,
                                size: 14,
                                color: Colors.orange,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 32),
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
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,

        // The bottom part of the header (Calendar/Time and Tags)
     
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
            final List<PopularDish> popularDishes =
                snapshot.data!['popularDishes'];

            final List<Dish> recommendedDishes = [
              // Use IDs multiplied by powers of 10 to ensure unique keys for Flutter
              ...originalDishes.map(
                (e) => Dish(
                  id: e.id * 10,
                  name: e.name,
                  rating: e.rating,
                  description: e.description,
                  equipments: e.equipments,
                  image: e.image,
                ),
              ),
              ...originalDishes.map(
                (e) => Dish(
                  id: e.id * 100,
                  name: e.name,
                  rating: e.rating,
                  description: e.description,
                  equipments: e.equipments,
                  image: e.image,
                ),
              ),
              ...originalDishes.map(
                (e) => Dish(
                  id: e.id * 1000,
                  name: e.name,
                  rating: e.rating,
                  description: e.description,
                  equipments: e.equipments,
                  image: e.image,
                ),
              ),
            ];
            // --- END DUPLICATION ---

            return Stack(
  clipBehavior: Clip.none,
  children: [
    // ───────── Scrollable Content ─────────
    SingleChildScrollView(
      padding: const EdgeInsets.only(
        top: 120, // space for black bar + overlap
        left: 16,
        right: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ───── Cuisine Tags ─────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTag('Italian', isSelected: true),
                _buildTag('Indian'),
                _buildTag('Chinese'),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ───── BIRYANI / POPULAR DISHES SECTION ─────
          const Text(
            'Popular Dishes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          _buildPopularBiryaniSection(),

          const Divider(height: 30),

          // ───── Recommended Section ─────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recommended',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Menu',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          ...recommendedDishes.map(_buildRecommendedDishCard).toList(),

          const SizedBox(height: 140),
        ],
      ),
    ),

    // ───────── Black Background Bar ─────────
    Container(
      width: double.infinity,
      height: 60,
      color: Colors.black,
    ),

    // ───────── Calendar Card (Overlapping) ─────────
    Positioned(
      top: 30, // half overlap
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/Select_date-01.svg',
                  width: 18,
                ),
                const SizedBox(width: 8),
                const Text(
                  '21 May 2021',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            Container(height: 16, width: 1, color: Colors.grey),

            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/Set_time-01.svg',
                  width: 16,
                ),
                const SizedBox(width: 8),
                const Text(
                  '10:30 PM - 12:30 PM',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),

    // ───────── Bottom Floating Bar ─────────
    if (_selectedDishIds.isNotEmpty)
      Positioned(
        left: 16,
        right: 16,
        bottom: 16,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              '${_selectedDishIds.length} food items selected',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
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

  Widget _buildPopularBiryaniSection() {
  return SizedBox(
    height: 70,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: 8,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (context, index) {
        return SizedBox(
          width: 57,
          height: 57,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Biryani Image
              ClipOval(
                child: Image.asset(
                  'assets/icons/Mask Group 19.png',
                  width: 57,
                  height: 57,
                  fit: BoxFit.cover,
                ),
              ),

              // Dark Overlay
              Container(
                width: 57,
                height: 57,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0x9A1C1C1C),
                ),
              ),

              // Text
              const Text(
                'Biryani',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              // Orange Border (skip first)
              if (index != 0)
                Container(
                  width: 57,
                  height: 57,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color(0xFFFF941A),
                      width: 2,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    ),
  );
}

  Widget _buildTag(String text, {bool isSelected = false}) {
    return Container(
      width: 76,
      height: 24,
      margin: const EdgeInsets.only(right: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFFF9F2) : Colors.transparent,
        borderRadius: BorderRadius.circular(17),
        border:
            isSelected
                ? Border.all(color: const Color(0xFFFF941A), width: 0.5)
                : Border.all(color: const Color(0xFF8A8A8A), width: 0.5),
        boxShadow:
            isSelected
                ? const [
                  BoxShadow(
                    color: Color(0xFFFFF9F2),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                  ),
                ]
                : [],
      ),
      child: Text(
        text,
        style:
            isSelected
                ? TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFF941A),
                )
                : TextStyle(color: const Color(0xFF8A8A8A)),
      ),
    );
  }
}
