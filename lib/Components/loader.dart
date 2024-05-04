import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final bool loading;

  const Loader({Key? key, required this.loading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white54,
      child: const Center(child: CircularProgressIndicator()),
    )
        : Container();
  }
}