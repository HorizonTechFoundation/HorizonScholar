import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final Function(int)? onNavigate;
  HomeScreen({this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F1F1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hello Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hello Alice !",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                      color: Color(0xFF146C94),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      print("Profile Pressed");
                    },
                    icon: CircleAvatar(
                      backgroundColor: Color(0xFFafd3e2),
                      radius: 16,
                      child: Icon(Icons.person, color: Color(0xFF146C94), size: 22),
                    ),
                    splashRadius: 24,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                "Horizon is hte gysnhsgb next dog us tyo toy hes no red mederios ferik. Horizon is hte gysnhsgb next dog us tyo toy hes no red mederios ferik.",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              SizedBox(height: 35),

              Text(
                "Your Info",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              SizedBox(height: 18),

              // CGPA Card
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFafd3e2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                ),
                onPressed: () {
                  onNavigate?.call(1); // navigate to CGPA Tab
                },
                child:Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFFafd3e2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  
                  child: Row(
                    children: [
                      Container(
                        child: Image.asset(
                          'assets/Illustrations/HomeImg.png',
                        ),
                      ),
                      SizedBox(width: 18),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "7.94",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 40,
                              color: Color(0xFF146C94),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "CGPA Upto Sem 6",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Course and Documents Row
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFafd3e2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: EdgeInsets.symmetric(vertical: 25),
                      ),
                      onPressed: () {
                        onNavigate?.call(2); // navigate to CGPA Tab
                      },
                      child:Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFafd3e2),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "28",
                              style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 35,
                              color: Color(0xFF146C94),
                            ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Course\nCompleted",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFafd3e2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: EdgeInsets.symmetric(vertical: 25),
                      ),
                      onPressed: () {
                        onNavigate?.call(3);
                      },
                      child:Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFafd3e2),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "67",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 35,
                                color: Color(0xFF146C94),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Documents\nSaved",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
