import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cgpa_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class CGPAScreen extends StatelessWidget {
  final CgpaController cgpaController = Get.put(CgpaController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F1F1),
      body: SafeArea(
        child: Obx(() {
          if (cgpaController.cgpaList.isEmpty) {
            return Center(child: Text("No CGPA data found"));
          }

          final data = cgpaController.cgpaList[0];
          double cgpa = data.cgpa;
          int percentage = (cgpa / 10 * 100).round();

          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // TITLE
                Text(
                  "CGPA Calculator",
                  style: GoogleFonts.righteous(
                      fontSize: 20,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                ),
                SizedBox(height: 25),

                // TOP CARD
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                  decoration: BoxDecoration(
                    color: Color(0xffAFD3E2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$percentage%",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 50,
                              color: Color(0xFF146C94),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            cgpa.toStringAsFixed(2),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 35,
                              color: Color(0xFF146C94),
                            ),
                          ),
                          SizedBox(height: 0),
                          Text(
                            "CGPA Upto Sem ${data.currentSem}",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 25),

                // FEATURE GRID
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffAFD3E2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {print("IAT");},
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Color(0xffAFD3E2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.functions, color: Color(0xff146C94), size: 25),
                            SizedBox(height: 12),
                            Text(
                              "Predict GPA with\nInternal Marks",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffAFD3E2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {print("GPA");},
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Color(0xffAFD3E2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.auto_awesome, color: Color(0xff146C94), size: 25),
                            SizedBox(height: 12),
                            Text(
                              "Predict CGPA\nwith GPA",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffAFD3E2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {print("Virtualize");},
                      child:Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Color(0xffAFD3E2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bar_chart, color: Color(0xff146C94), size: 25),
                            SizedBox(height: 12),
                            Text(
                              "Virtualize\nPerformance",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Table(
                    border: TableBorder(
                      horizontalInside: BorderSide(
                        color: Colors.grey,   // line color
                        width: 1,             // line thickness
                      ),
                      // Remove all outer borders
                      top: BorderSide.none,
                      bottom: BorderSide.none,
                      left: BorderSide.none,
                      right: BorderSide.none,
                      verticalInside: BorderSide.none,
                    ),
                    
                    children: [
                      TableRow(children: [
                        Padding(padding: EdgeInsets.all(8), child: 
                        Text(
                          "Semester",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color:Color.fromARGB(255, 14, 68, 94),
                          ),
                        ),),
                        SizedBox(),
                        Padding(padding: EdgeInsets.all(8), child: 
                        Text(
                          "GPA",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color:Color.fromARGB(255, 14, 68, 94),
                          ),
                        ),),
                      ]),
                      TableRow(children: [
                        Padding(padding: EdgeInsets.all(8), child: 
                        Text(
                          "01",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color:Color(0xff146C94),
                          ),
                        ),),
                        SizedBox(),
                        Padding(padding: EdgeInsets.all(8), child: 
                        Text(
                          "9.78",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color:Color(0xff146C94),
                          ),
                        ),),
                      ]),
                      TableRow(children: [
                        Padding(padding: EdgeInsets.all(8), child: 
                        Text(
                          "02",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color:Color(0xff146C94),
                          ),
                        ),),
                        SizedBox(),
                        Padding(padding: EdgeInsets.all(8), child: 
                        Text(
                          "9.78",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color:Color(0xff146C94),
                          ),
                        ),),
                      ]),
                      TableRow(children: [
                        Padding(padding: EdgeInsets.all(8), child: 
                        Text(
                          "03",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color:Color(0xff146C94),
                          ),
                        ),),
                        SizedBox(),
                        Padding(padding: EdgeInsets.all(8), child: 
                        Text(
                          "9.78",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color:Color(0xff146C94),
                          ),
                        ),),
                      ]),
                      TableRow(children: [
                        Padding(padding: EdgeInsets.all(8), child: 
                        Text(
                          "04",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color:Color(0xff146C94),
                          ),
                        ),),
                        SizedBox(),
                        Padding(padding: EdgeInsets.all(8), child: 
                        Text(
                          "9.78",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color:Color(0xff146C94),
                          ),
                        ),),
                      ]),
                      TableRow(children: [
                        Padding(padding: EdgeInsets.all(8), child: 
                        Text(
                          "05",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color:Color(0xff146C94),
                          ),
                        ),),
                        SizedBox(),
                        Padding(padding: EdgeInsets.all(8), child: 
                        Text(
                          "9.78",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color:Color(0xff146C94),
                          ),
                        ),),
                      ]),
                      TableRow(children: [
                        Padding(padding: EdgeInsets.all(8), child: 
                        Text(
                          "06",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color:Color(0xff146C94),
                          ),
                        ),),
                        SizedBox(),
                        Padding(padding: EdgeInsets.all(8), child: 
                        Text(
                          "9.78",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color:Color(0xff146C94),
                          ),
                        ),),
                      ]),
                      TableRow(children: [
                        Padding(padding: EdgeInsets.all(8), child: 
                        Text(
                          "07",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color:Color(0xff146C94),
                          ),
                        ),),
                        SizedBox(),
                        Padding(padding: EdgeInsets.all(8), child: 
                        Text(
                          "9.78",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color:Color(0xff146C94),
                          ),
                        ),),
                      ]),
                      TableRow(children: [
                        Padding(padding: EdgeInsets.all(8), child: 
                        Text(
                          "08",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color:Color(0xff146C94),
                          ),
                        ),),
                        SizedBox(),
                        Padding(padding: EdgeInsets.all(8), child: 
                        Text(
                          "9.78",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color:Color(0xff146C94),
                          ),
                        ),),
                      ]),
                    ],
                  ),
                ),
                SizedBox(height: 40),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff146C94),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {print("Calculate");},
                  child:Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                  decoration: BoxDecoration(
                    color: Color(0xff146C94),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calculate, color: Color(0xffF6F1F1), size: 25),
                      SizedBox(width: 10),
                      Text(
                        "Calculate CGPA",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color:Color(0xffF6F1F1),
                        ),
                      ),
                    ],
                  ),
                ),
                ),

              ],
            ),
          );
        }),
      ),
    );
  }
}
