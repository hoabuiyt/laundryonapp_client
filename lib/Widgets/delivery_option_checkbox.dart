import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

enum DeliveryMethod { normalPickUpandDrop, leaveOutsideDoor, selfPickUpAndDrop }

class DeliveryCheckbox extends StatelessWidget {
  final DeliveryMethod option;
  final DeliveryMethod? selectedOption;
  final ValueChanged<DeliveryMethod> onSelected;
  final String imagePath;
  final String text;
  final EdgeInsets padding;
  final double gap;

  const DeliveryCheckbox(
      {Key? key,
      required this.option,
      required this.selectedOption,
      required this.onSelected,
      required this.imagePath,
      required this.text,
      required this.padding,
      required this.gap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: option == selectedOption
          ? const BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.08),
                    offset: Offset(2, 2),
                    blurRadius: 20)
              ],
            )
          : const BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0),
                    offset: Offset(0, 0),
                    blurRadius: 0)
              ],
            ),
      child: ElevatedButton(
        onPressed: () => onSelected(option),
        style: ButtonStyle(
          side: MaterialStateProperty.resolveWith<BorderSide>(
            (Set<MaterialState> states) {
              return BorderSide(
                color: option == selectedOption
                    ? const Color.fromRGBO(114, 60, 232, 1)
                    : const Color.fromRGBO(206, 206, 206, 1),
              );
            },
          ),
          elevation: MaterialStateProperty.all(0),
          splashFactory: NoSplash.splashFactory,
          backgroundColor: MaterialStateProperty.all(
            const Color(0xFFFFFFFF),
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
          child: Row(
            children: [
              SvgPicture.asset('assets/$imagePath'),
              Gap(gap),
              Text(
                text,
                maxLines: 2,
                overflow: TextOverflow.clip,
                softWrap: true,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: const Color(0xFF1C2649),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
