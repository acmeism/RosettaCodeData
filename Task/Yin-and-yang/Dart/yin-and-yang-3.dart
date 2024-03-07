import 'package:flutter/material.dart';

const color = [Colors.black, Colors.white];

Widget cR(int iColor, double r, {Widget? child}) => DecoratedBox(
    decoration: BoxDecoration(color: color[iColor], shape: BoxShape.circle),
    child: SizedBox.square(dimension: r * 2, child: Center(child: child)));

Widget yinYang(double r, [double th = 1.0]) => Padding(
    padding: const EdgeInsets.all(5),
    child: ClipOval(
        child: cR(0, r + th,
            child: cR(1, r,
                child: Stack(alignment: Alignment.center, children: [
                  Container(color: color[0], margin: EdgeInsets.only(left: r)),
                  Column(children: List.generate(2, (i) => cR(1 - i, r / 2, child: cR(i, r / 6))))
                ])))));

void main() => runApp(MaterialApp(
    home: ColoredBox(color: color[1], child: Wrap(children: [yinYang(50), yinYang(20)]))));
