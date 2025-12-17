import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/dish_details.dart';
import '../services/api_service.dart';

class DishDetailsScreen extends StatefulWidget {
  final int dishId;
  const DishDetailsScreen({super.key, required this.dishId});

  @override
  State<DishDetailsScreen> createState() => _DishDetailsScreenState();
}

class _DishDetailsScreenState extends State<DishDetailsScreen> {
  late Future<DishDetails> _dishDetails;
  final ApiService _apiService = ApiService();

  bool vegOpen = true;
  bool spiceOpen = true;

  @override
  void initState() {
    super.initState();
    _dishDetails = _apiService.fetchDishDetails(widget.dishId);
  }

  // ───────────────── Header ─────────────────
 Widget _header(DishDetails dish) {
  return SizedBox(
    height: 100,
    child: Stack(
      children: [
        // 🔵 Background circular image (Group 17)
        Positioned(
          right: -380,
          top: 80,
          child: Image.asset(
            'assets/icons/Mask Group 17@2x.png',
           
            fit: BoxFit.contain,
          ),
        ),

        // 📄 Text content (LEFT)
        Positioned(
          left: 16,
          right: 160, // leaves space for image
          bottom: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dish.name,
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),

              // ⭐ Rating
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '4.2★',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Mughlai Masala is a style of cookery developed in the Indian Subcontinent by the imperial kitchens of the Mughal Empire.',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 12),

              // ⏱ Time
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/Group 359.svg',
                    width: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    dish.timeToPrepare,
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  // ───────────────── Ingredient Block ─────────────────
  Widget _ingredientSection(
    String title,
    List<IngredientItem> items,
    bool isOpen,
    VoidCallback onTap,
  ) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$title (${items.length.toString().padLeft(2, '0')})',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(
                isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (isOpen)
          ...items.map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e.name, style: GoogleFonts.poppins(fontSize: 14)),
                  Text(
                    e.quantity,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // ───────────────── Appliances ─────────────────
  Widget _appliances(List<Appliance> appliances) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Appliances',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: appliances.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (_, i) {
              return Container(
                width: 90,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/Group 508.svg',
                      width: 17,
                      height: 28,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      appliances[i].name,
                      style: GoogleFonts.poppins(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ───────────────── Build ─────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<DishDetails>(
        future: _dishDetails,
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final dish = snapshot.data!;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: Colors.white,
                leading: const BackButton(color: Colors.black),
                flexibleSpace: FlexibleSpaceBar(background: _header(dish)),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ingredients',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'For 2 people',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _ingredientSection(
                        'Vegetables',
                        dish.vegetables,
                        vegOpen,
                        () => setState(() => vegOpen = !vegOpen),
                      ),
                      const Divider(height: 32),
                      _ingredientSection(
                        'Spices',
                        dish.spices,
                        spiceOpen,
                        () => setState(() => spiceOpen = !spiceOpen),
                      ),
                      const Divider(height: 32),
                      _appliances(dish.appliances),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
