import 'package:btrlyfe/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextStyle mainfont ( value){
    return GoogleFonts.openSans(textStyle: value);
  }


  @override
  Widget build(BuildContext context) {
    final colors = context.watch<AppColors>();
    Color primarycolor = colors.primaryColor;
    Color secondarycolor = colors.secondaryColor;
    Color tertiarycolor = colors.tertiaryColor;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primarycolor,
            tertiarycolor,
          ],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 30),
      child: Column(
        children: [
          const SizedBox(height: 60),
          //BtrLyfe______________________________________________________________________________________
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset('assets/BtrLyfeLogo.png')
          ),
          const SizedBox(height: 10),
          Text(
            textAlign: TextAlign.center,
            "BtrLyfe aims to help student users live a healthier lifestyle. This is achieved through the three sections displayed in the app: SLEEP, STRESS, and STUDY, all specialized in improving their designated field of wellness. ",
            style:mainfont(const TextStyle(color: Colors.white, fontSize: 24,))
          ) 
        ]
      )
    );
  }
}