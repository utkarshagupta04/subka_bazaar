import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NumericStepButton extends StatefulWidget {
  final int minValue;
  final int maxValue;
  int counter;

  final ValueChanged<int> onChanged;

  NumericStepButton(
      {Key? key,
      this.minValue = 0,
      this.maxValue = 10,
      this.counter = 1,
      required this.onChanged})
      : super(key: key);

  @override
  State<NumericStepButton> createState() {
    return _NumericStepButtonState();
  }
}

class _NumericStepButtonState extends State<NumericStepButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: Icon(
            Icons.remove,
            color: Theme.of(context).colorScheme.secondary,
          ),
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
          iconSize: 24.0,
          color: Theme.of(context).primaryColor,
          onPressed: () {
            setState(() {
              if (widget.counter > widget.minValue) {
                widget.counter--;
              }
              widget.onChanged(widget.counter);
            });
          },
        ),
        Text(
          widget.counter.toString(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.secondary,
          ),
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
          iconSize: 24.0,
          color: Theme.of(context).primaryColor,
          onPressed: () {
            setState(() {
              if (widget.counter < widget.maxValue) {
                widget.counter++;
              }
              widget.onChanged(widget.counter);
            });
          },
        ),
      ],
    );
  }
}
