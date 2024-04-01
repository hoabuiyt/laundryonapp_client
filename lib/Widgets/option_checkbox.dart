import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

enum LaundryOption { wash, washFold, washIronFold }

class LaundryButton extends StatelessWidget {
  final LaundryOption option;
  final LaundryOption selectedOption;
  final ValueChanged<LaundryOption> onSelected;
  final String imagePath;
  final String text;
  final EdgeInsets padding;

  const LaundryButton({
    Key? key,
    required this.option,
    required this.selectedOption,
    required this.onSelected,
    required this.imagePath,
    required this.text,
    required this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onSelected(option),
      style: ButtonStyle(
        side: MaterialStateProperty.resolveWith<BorderSide>(
          (Set<MaterialState> states) {
            return BorderSide(
              color: option == selectedOption
                  ? const Color.fromRGBO(76, 149, 239, 1)
                  : const Color.fromRGBO(76, 149, 239, 0),
            );
          },
        ),
        elevation: MaterialStateProperty.all(0),
        splashFactory: NoSplash.splashFactory,
        backgroundColor: MaterialStateProperty.all(
          const Color(0xFFF9F9F9),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        padding: MaterialStateProperty.all(
          padding,
        ),
      ),
      child: Center(
        child: Column(
          children: [
            SvgPicture.asset('assets/$imagePath'),
            const Gap(18),
            Text(
              text,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: const Color(0xFF1C2649),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
