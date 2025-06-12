xprecision:3
yprecision:5
x: 1 2 3 1e11
y:  1 1.412135627930951 1.7320508075688772 316227.76601683791
// for truncuating, see "Learning K Programming, Idiom by Idiom" 460
xx:{ {1%(*/y#x)}[10;-xprecision] * _x*{*/y#x}[10;xprecision] } x
yy:{ {1%(*/y#x)}[10;-yprecision] * _x*{*/y#x}[10;yprecision] } y
// reshaping and transposing with +
result: +2 4#xx,yy

// add to string res
res::""
dummy: {res::res,$x[0];res::res," ";res::res,$x[1];res::res,"\n" }'result

// output to txt file with 0:
`floatarray.txt 0:res
