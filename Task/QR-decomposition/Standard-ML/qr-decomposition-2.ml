structure RealRadicalCategoryField : RADCATFIELD = struct
open Real
val one = 1.0
val zero = 0.0
val sign = real o Real.sign
val sqrt = Real.Math.sqrt
end

structure Q = QR(RealRadicalCategoryField);

let
    val mat = Array2.fromList [[12.0, ~51.0, 4.0], [6.0, 167.0, ~68.0], [~4.0, 24.0, ~41.0]]
    val {q,r} = Q.qr(mat)
in
    {q=Q.toList q; r=Q.toList r}
end;
(* output *)
val it =
  {q=[[~0.857142857143,0.394285714286,0.331428571429],
      [~0.428571428571,~0.902857142857,~0.0342857142857],
      [0.285714285714,~0.171428571429,0.942857142857]],
   r=[[~14.0,~21.0,14.0],[5.97812397875E~18,~175.0,70.0],
      [4.47505280695E~16,0.0,~35.0]]} : {q:real list list, r:real list list}

let open Array
    val x = fromList [0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
    val y = fromList [1.0, 6.0, 17.0, 34.0, 57.0, 86.0, 121.0, 162.0, 209.0, 262.0, 321.0]
in
    Q.polyfit(x, y, 2)
end;

(* output *)
val it = [|1.0,2.0,3.0|] : real array
