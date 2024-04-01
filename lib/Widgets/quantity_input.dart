import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:input_quantity/input_quantity.dart';

class QunatityInput extends ConsumerStatefulWidget {
  final num minvalue;
  const QunatityInput({
    Key? key,
    required this.minvalue,
  }) : super(key: key);

  @override
  QunatityInputState createState() => QunatityInputState();
}

class QunatityInputState extends ConsumerState<QunatityInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF4C95EF), width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: InputQty(
        maxVal: 50,
        initVal: 10,
        steps: 1,
        minVal: widget.minvalue,
        onQtyChanged: (value) {
          print(value);
        },
        qtyFormProps: const QtyFormProps(
          enableTyping: false,
          style: TextStyle(
            fontSize: 14,
            height: 1,
            fontWeight: FontWeight.normal,
            color: Color(0xFF4C95EF),
          ),
        ),
        decoration: QtyDecorationProps(
          width: 8,
          iconColor: const Color.fromRGBO(255, 0, 0, 1),
          isBordered: false,
          fillColor: const Color(0xFFF7FCFF),
          minusBtn: SizedBox(
            height: 26,
            width: 20,
            child: Center(
              child: SvgPicture.asset('assets/minus.svg'),
            ),
          ),
          plusBtn: SizedBox(
            height: 26,
            width: 20,
            child: Center(
              child: SvgPicture.asset('assets/plus.svg'),
            ),
          ),
        ),
      ),
    );
  }
}
