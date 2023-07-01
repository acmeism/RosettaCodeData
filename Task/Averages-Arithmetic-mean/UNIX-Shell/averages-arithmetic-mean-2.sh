cat f
1
2
4
8
16
-200

echo "`cat f | paste -sd+ | bc -l`/`cat f | wc -l`" | bc -l
-28.16666666666666666666

cat f
1.109434
2
4.5
8.45
16
-200
400.56

echo "`cat f | paste -sd+ | bc -l`/`cat f | wc -l`" |bc -l
33.23134771428571428571
