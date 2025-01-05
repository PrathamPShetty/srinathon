import 'package:farm_link_ai/consts/assets.dart' as consts;
import 'package:farm_link_ai/consts/text.dart';
import 'package:flutter/material.dart';
import 'package:farm_link_ai/ui/commons/nav_bar/NavBar.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return NavBar(
      bodyContent: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Stack(
              children: [
                Container(
                  height: isSmallScreen ? 200 : 300,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(consts.car1),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 16,
                  child: Text(
                    AppConstants.ourservices,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 28 : 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: const [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black54,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // About Us Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                   AppConstants.whoweare,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 22 : 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF404A3D),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                  AppConstants.about,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // Services Section
            Container(
              color: const Color(0xFFF8F8F8),
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      AppConstants.ourservices,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 22 : 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF404A3D),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isSmallScreen ? 1 : 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 3 / 2,
                    ),
                    itemCount: 3, // Adding 3 services for Plumbing, Electricians, etc.
                    itemBuilder: (context, index) {
                      return _buildServiceCard(index);
                    },
                  ),
                ],
              ),
            ),

            // Gallery Section

          ],
        ),
      ),
    );
  }

  // Build service card with a background image
  Widget _buildServiceCard(int index) {
    List<Map<String, String>> services = [
      {
        "title": AppConstants.plumbingService,
        "description": AppConstants.plumbingDescription,
        "image": consts.car2,
      },
      {
        "title": AppConstants.electricalDescription,
        "description": AppConstants.electricalDescription,
        "image": consts.car3,
      },
      {
        "title": AppConstants.carpentryService,
        "description": AppConstants.carpentryDescription,
        "image": consts.car1,
      },
    ];

    final service = services[index];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(service['image']!),
          fit: BoxFit.cover,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            service['title']!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 4,
                  color: Colors.black54,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            service['description']!,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              height: 1.4,
              shadows: [
                Shadow(
                  blurRadius: 4,
                  color: Colors.black54,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Gallery image for showcasing services
  Widget _buildGalleryImage(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
      ),
    );
  }
}
