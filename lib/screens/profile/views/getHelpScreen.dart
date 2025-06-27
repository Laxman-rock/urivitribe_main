import 'package:flutter/material.dart';

class GetHelpScreen extends StatelessWidget {
  const GetHelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F8F8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Get Help',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {
              // Handle share action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 60),
            
            // Illustration
            SizedBox(
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Hand illustration
                  CustomPaint(
                    size: const Size(80, 100),
                    painter: HandPainter(),
                  ),
                  
                  // Hearts
                  const Positioned(
                    left: 20,
                    top: 10,
                    child: Icon(
                      Icons.favorite,
                      color: Colors.black,
                      size: 16,
                    ),
                  ),
                  const Positioned(
                    right: 15,
                    bottom: 20,
                    child: Icon(
                      Icons.favorite,
                      color: Colors.black,
                      size: 12,
                    ),
                  ),
                  
                  // Chat bubble
                  Positioned(
                    right: 10,
                    top: 5,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Container(
                        width: 16,
                        height: 12,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.purple, Colors.pink],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  
                  // Motion lines
                  Positioned(
                    left: 30,
                    child: CustomPaint(
                      size: const Size(20, 10),
                      painter: MotionLinesPainter(),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Main text
            const Text(
              'We are here to help so please get in touch with us.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            
            const SizedBox(height: 60),
            
            // Contact options
            _buildContactOption(
              icon: Icons.phone_outlined,
              title: 'Phone Number',
              subtitle: '+1-202-555-0162',
              onTap: () {
                // Handle phone call
              },
            ),
            
            const SizedBox(height: 20),
            
            _buildContactOption(
              icon: Icons.email_outlined,
              title: 'E-mail address',
              subtitle: 'theflutterway@gmail.com',
              onTap: () {
                // Handle email
              },
            ),
            
            const Spacer(),
            
            // Live chat button
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: () {
                  // Handle live chat
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B46F5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contact live chat',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'we are ready to answer you.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: Colors.grey.shade600,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for the hand illustration
class HandPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    
    // Draw hand outline
    path.moveTo(size.width * 0.3, size.height * 0.9);
    path.lineTo(size.width * 0.3, size.height * 0.7);
    path.lineTo(size.width * 0.25, size.height * 0.4);
    path.lineTo(size.width * 0.3, size.height * 0.2);
    path.lineTo(size.width * 0.35, size.height * 0.4);
    path.lineTo(size.width * 0.4, size.height * 0.15);
    path.lineTo(size.width * 0.45, size.height * 0.4);
    path.lineTo(size.width * 0.5, size.height * 0.2);
    path.lineTo(size.width * 0.55, size.height * 0.4);
    path.lineTo(size.width * 0.6, size.height * 0.25);
    path.lineTo(size.width * 0.65, size.height * 0.45);
    path.lineTo(size.width * 0.7, size.height * 0.7);
    path.lineTo(size.width * 0.7, size.height * 0.9);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Custom painter for motion lines
class MotionLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw motion lines
    canvas.drawLine(
      const Offset(0, 2),
      const Offset(8, 2),
      paint,
    );
    canvas.drawLine(
      const Offset(2, 5),
      const Offset(12, 5),
      paint,
    );
    canvas.drawLine(
      const Offset(0, 8),
      const Offset(10, 8),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}