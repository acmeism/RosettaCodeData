import 'package:flutter/material.dart';

const colors = [Colors.black, Colors.white];

Container cR(int iClr, double r, {Widget? child, Clip clip = Clip.none}) => Container(
    width: r * 2,
    height: r * 2,
    decoration: ShapeDecoration(color: colors[iClr], shape: const CircleBorder()),
    clipBehavior: clip,
    child: Center(child: child));

Container yinYang(double r, [double th = 1.0]) => cR(0, r + th,
    clip: Clip.hardEdge,
    child: cR(1, r,
        child: Stack(alignment: Alignment.center, children: [
          Container(color: colors[0], margin: EdgeInsets.only(left: r)),
          Column(children: List.generate(2, (i) => cR(1 - i, r / 2, child: cR(i, r / 6))))
        ])));

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
      home: Container(
          color: colors[1],
          padding: const EdgeInsets.all(10),
          child: Wrap(children: [yinYang(50), yinYang(20)])));
}
