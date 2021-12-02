import 'dart:async';

import 'package:flutter/material.dart';
import 'package:utweat/helpers/translate.dart';

class CountdownSnackBarComponent extends StatefulWidget {
  final int seconds;

  const CountdownSnackBarComponent({
    Key? key,
    required this.seconds,
  }) : super(key: key);

  @override
  _CountdownSnackBarState createState() => _CountdownSnackBarState();
}

class _CountdownSnackBarState extends State<CountdownSnackBarComponent> {
  late final Timer _timer;
  late int _seconds;

  @override
  void initState() {
    _seconds = widget.seconds;

    super.initState();

    _timer = Timer.periodic(
      const Duration(
        seconds: 1,
      ),
      (Timer timer) {
        setState(() => _seconds--);
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(t(context)!.deletionContentMessage(
      _seconds,
    ));
  }
}
