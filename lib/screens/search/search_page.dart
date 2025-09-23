import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lapinve/screens/search/widgets/explore_cars.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  final double _maxScrollForAnimation = 80.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate animation progress (0.0 to 1.0)
    double animationProgress = (_scrollOffset / _maxScrollForAnimation).clamp(
      0.0,
      1.0,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main scrollable content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Transparent app bar for spacing
              SliverAppBar(
                expandedHeight: 130.0,
                backgroundColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: false,
                flexibleSpace: Container(color: Colors.transparent),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExploreCars(),

                      SizedBox(height: 30),
                      // Categories Section
                      const Text(
                        'Popular Categories',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            final categories = [
                              {
                                'name': 'Hotels',
                                'icon': Icons.hotel,
                                'color': Colors.blue,
                              },
                              {
                                'name': 'Flights',
                                'icon': Icons.flight,
                                'color': Colors.orange,
                              },
                              {
                                'name': 'Cars',
                                'icon': Icons.directions_car,
                                'color': Colors.green,
                              },
                              {
                                'name': 'Tours',
                                'icon': Icons.tour,
                                'color': Colors.purple,
                              },
                              {
                                'name': 'Food',
                                'icon': Icons.restaurant,
                                'color': Colors.red,
                              },
                            ];

                            final category = categories[index];
                            return Container(
                              width: 100,
                              margin: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                color: (category['color'] as Color).withOpacity(
                                  0.1,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: (category['color'] as Color)
                                      .withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: category['color'] as Color,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      category['icon'] as IconData,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    category['name'] as String,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: category['color'] as Color,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Popular Destinations
                      const Text(
                        'Popular Destinations',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // Grid of destinations
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final destinations = [
                      {
                        'name': 'Paris',
                        'country': 'France',
                        'gradient': [Colors.pink, Colors.purple],
                      },
                      {
                        'name': 'Tokyo',
                        'country': 'Japan',
                        'gradient': [Colors.blue, Colors.cyan],
                      },
                      {
                        'name': 'New York',
                        'country': 'USA',
                        'gradient': [Colors.orange, Colors.red],
                      },
                      {
                        'name': 'London',
                        'country': 'UK',
                        'gradient': [Colors.green, Colors.teal],
                      },
                      {
                        'name': 'Sydney',
                        'country': 'Australia',
                        'gradient': [Colors.purple, Colors.blue],
                      },
                      {
                        'name': 'Dubai',
                        'country': 'UAE',
                        'gradient': [Colors.amber, Colors.orange],
                      },
                    ];

                    if (index >= destinations.length) return null;

                    final destination = destinations[index];
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: destination['gradient'] as List<Color>,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: (destination['gradient'] as List<Color>)[0]
                                .withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 20,
                            left: 16,
                            right: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  destination['name'] as String,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  destination['country'] as String,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 16,
                            right: 16,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }, childCount: 6),
                ),
              ),

              // Bottom spacing
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),

          // Fixed header with title and search field
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: animationProgress > 0.1
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Animated Title
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: animationProgress < 0.5 ? 40 : 0,
                        child: AnimatedOpacity(
                          opacity: animationProgress < 0.5 ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            'Skip the rental counter',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: animationProgress < 0.5 ? 40 : 0,
                        child: AnimatedOpacity(
                          opacity: animationProgress < 0.5 ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            'Find the perfect car',
                            style: TextStyle(
                              fontSize: 17,

                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),

                      // Static spacing (reduces when title is hidden)
                      // AnimatedContainer(
                      //   duration: const Duration(milliseconds: 200),
                      //   height: animationProgress < 0.5 ? 15 : 5,
                      // ),

                      // Fixed Search Field
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'City, airport, address or train station',
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                            prefixIcon: Icon(
                              FontAwesomeIcons.magnifyingGlass,
                              color: Colors.grey[600],
                              size: 20,
                            ),
                            suffixIcon: Icon(
                              Icons.tune,
                              color: Colors.grey[600],
                              size: 22,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 13,
                              horizontal: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
