import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class ServiceAppbar extends StatelessWidget {
  final String TextSvg;
  final String MainPng;

  const ServiceAppbar({
    Key? key,
    this.TextSvg = 'assets/Laundry-text.svg',
    this.MainPng = 'assets/Laundry-main.png',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFFC7B1F6),
          ),
        ),
        Positioned(
          top: 15,
          left: 31,
          child: SvgPicture.asset(
            'assets/bubbles-top-left.svg',
          ),
        ),
        Positioned(
          right: 22,
          bottom: 20,
          child: SvgPicture.asset(
            'assets/bubbles-bottom-right.svg',
          ),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          child: Image.asset(
            'assets/bottom-left-sprite.png',
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: TextButton(
                            style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                padding: const EdgeInsets.all(0),
                                splashFactory: NoSplash.splashFactory),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/Back-arrow.svg'),
                                const Gap(8),
                                Text(
                                  'Back',
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
                        Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child: SvgPicture.asset(TextSvg),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                    minimumSize: const Size(10, 10),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    padding: const EdgeInsets.all(0),
                                    splashFactory: NoSplash.splashFactory),
                                onPressed: () {},
                                child: SvgPicture.asset('assets/hamburger.svg'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(9),
                    Image.asset(
                      MainPng,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
