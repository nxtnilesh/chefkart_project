import 'package:flutter/material.dart';
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

  // A fixed URL for the appliance image, as the API gives empty strings
  final String applianceImageUrl = 'https://img.freepik.com/free-icon/refrigerator_318-795325.jpg'; 

  @override
  void initState() {
    super.initState();
    _dishDetails = _apiService.fetchDishDetails(widget.dishId);
  }

  // --- Widgets ---

  Widget _buildIngredientList(String title, List<IngredientItem> items, int itemCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                '($itemCount)',
                style: GoogleFonts.poppins(
                    fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        const Divider(color: Colors.grey, height: 1),
        const SizedBox(height: 8),
        ...items.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.name,
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
                Text(
                  item.quantity,
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildApplianceList(List<Appliance> appliances) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
          child: Text(
            'Appliances',
            style: GoogleFonts.poppins(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: appliances.length,
            itemBuilder: (context, index) {
              final appliance = appliances[index];
              
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                        color: Colors.grey.shade50,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              applianceImageUrl, // Using a fixed URL for a generic appliance image
                              height: 30,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.kitchen, size: 30, color: Colors.black),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              appliance.name,
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
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

  // --- Main Build Method ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<DishDetails>(
        future: _dishDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final dish = snapshot.data!;
            return CustomScrollView(
              slivers: [
                // --- Top Image and Title Header (SliverAppBar) ---
                SliverAppBar(
                  expandedHeight: 280.0,
                  floating: false,
                  pinned: true,
                  leading: const BackButton(color: Colors.black),
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.white,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
                    centerTitle: false,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          dish.name,
                          style: GoogleFonts.poppins(
                              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        // Rating (Matching the green background/white text style from the image)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '4.2⭐', 
                            style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Background image area (using a specific food image to match the look)
                        Image.network(
                          'https://picsum.photos/400/300?random=1',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade200),
                        ),
                        // Overlay with gradient for text visibility and general UI look
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.white.withOpacity(0.0), Colors.white],
                              stops: const [0.5, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // --- Main Content (SliverList) ---
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Time to prepare
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  dish.timeToPrepare,
                                  style: GoogleFonts.poppins(fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Dish Description 
                            Text(
                              'Mughlai Masala is a style of cookery developed in the Indian Subcontinent by the imperial kitchens of the Mughal Empire.',
                              style: GoogleFonts.poppins(
                                  fontSize: 14, color: Colors.grey.shade600),
                            ),
                            const Divider(height: 32),

                            // --- Ingredients Section ---
                            Text(
                              'Ingredients',
                              style: GoogleFonts.poppins(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'For 2 people',
                              style: GoogleFonts.poppins(
                                  fontSize: 14, color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 16),

                            // Vegetables List (Using fixed count from JSON for UI match)
                            _buildIngredientList('Vegetables', dish.vegetables, 5),
                            const Divider(height: 24),

                            // Spices List (Using fixed count from JSON for UI match)
                            _buildIngredientList('Spices', dish.spices, 10),
                            const Divider(height: 24),

                            // --- Appliances Section ---
                            _buildApplianceList(dish.appliances),
                            const SizedBox(height: 50),
                            
                            // Bottom Action Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {},
                                child: Text(
                                  'Add to Cart',
                                  style: GoogleFonts.poppins(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
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
}