import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:btrlyfe/appcolors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

Widget _colorButton(
  BuildContext context,
  Color color1,
  Color color2,
  Color color3,
  String name,
) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color1, color3],
          ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
        child: ElevatedButton(
          onPressed: () {
            context.read<AppColors>().setColors(
              primary: color1,
              secondary: color2,
              tertiary: color3,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.zero,
          ),
          child: const SizedBox(),
        ),
      ),

      const SizedBox(height: 6),

      Text(
        name,
        style: TextStyle(
          color: color2,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    ],
  );
}

class _SettingsPageState extends State<SettingsPage> {
  TextStyle mainfont ( value){
    return GoogleFonts.titanOne(textStyle: value);
  }


  @override
  Widget build(BuildContext context) {
    final colors = context.watch<AppColors>();
    Color primarycolor = colors.primaryColor;
    Color secondarycolor = colors.secondaryColor;
    Color tertiarycolor = colors.tertiaryColor;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
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
        child:Column(
          children: [
            Align(
              alignment: Alignment.center,
              child:Text(
                "Settings",
                style: mainfont(
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 55,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40,),
            const Text(
              "Theme Options",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _colorButton(
                  context,
                  const Color(0xFF4A90E2),
                  const Color(0xFF6FCF97),
                  const Color(0xFF9B8AFB),
                  "Default"
                ),

                _colorButton(
                  context,
                  Colors.yellow,
                  Colors.red,
                  Colors.orange,
                  "Warm"
                ),

                _colorButton(
                  context,
                  const Color.fromARGB(255, 225, 255, 192),
                  Colors.brown,
                  const Color.fromARGB(255, 241, 155, 184),
                  "Blossom"
                ),

                _colorButton(
                  context,
                  const Color.fromARGB(255, 56, 56, 56),
                  const Color.fromARGB(255, 126, 126, 126),
                  const Color.fromARGB(255, 56, 56, 56),
                  "Dark"
                ),
              ],
            ),
            
          ]
        )
      )
    );
  }
}
