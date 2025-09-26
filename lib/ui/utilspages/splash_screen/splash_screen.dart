import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simpleapp/ui/utilspages/splash_screen/sun_loader.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SunLoader(),
            SizedBox(height: 20),
            Text(
              'Oscillation\nEnergy LLP',
              style: 
                GoogleFonts.alegreya(
                  fontSize: 35,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              
            ),
          ],
        ),
      ),
    );
  }
}