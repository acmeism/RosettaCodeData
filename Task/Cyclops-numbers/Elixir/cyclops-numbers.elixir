defmodule Rosetta do
  def cy n do
    require Integer
    lc1=for cl <- 100..999, d=Integer.digits(cl),[q,y,z]=d,Integer.is_odd(length(d)) and y==0 and q>0 and z>0, do: cl
    lc2=for cl <- 10000..99999, d=Integer.digits(cl),[q1,q2,y,z1,z2]=d,Integer.is_odd(length(d)) and y==0 and q1>0 and q2>0 and z1>0 and z2>0, do: cl
    lc3=for cl <- 1000000..9999999, d=Integer.digits(cl),[q1,q2,q3,y,z1,z2,z3]=d,Integer.is_odd(length(d)) and y==0 and q1>0 and q2>0 and q3>0 and z1>0 and z2>0 and z3>0, do: cl
    lc4=for cl <- 100000000..999999999, d=Integer.digits(cl),[q1,q2,q3,q4,y,z1,z2,z3,z4]=d,Integer.is_odd(length(d)) and y==0 and q1>0 and q2>0 and q3>0 and q4>0 and z1>0 and z2>0 and z3>0 and z4>0, do: cl
    lc5=lc1++lc2++lc3++lc4
    lc6=[0|lc5]
    Enum.take(lc6,n)
  end

  "50 cyclops num"

  iex(8)> cn=Rosetta.cy 50
[0, 101, 102, 103, 104, 105, 106, 107, 108, 109, 201, 202, 203, 204, 205, 206,
 207, 208, 209, 301, 302, 303, 304, 305, 306, 307, 308, 309, 401, 402, 403, 404,
 405, 406, 407, 408, 409, 501, 502, 503, 504, 505, 506, 507, 508, 509, 601, 602,
 603, 604]

  def cyp cn,n do
    cnp=for x <- cn,x>0,length(Enum.filter(1..x,fn y -> Integer.mod(x,y)==0 end))==2, do: x
    Enum.take(cnp,n)
  end

 "50 cyclops primes"

iex(11)> Rosetta.cyp(Rosetta.cy(1000),50)
[101, 103, 107, 109, 307, 401, 409, 503, 509, 601, 607, 701, 709, 809, 907,
11027, 11047, 11057, 11059, 11069, 11071, 11083, 11087, 11093, 12011, 12037,
12041, 12043, 12049, 12071, 12073, 12097, 13033, 13037, 13043, 13049, 13063,
13093, 13099, 14011, 14029, 14033, 14051, 14057, 14071, 14081, 14083, 14087,
15013, 15017]

  def cyz cn,n do
    czn=for x <- cn, x>0,do: String.to_integer(String.replace(Integer.to_string(x),"0",""))
    Enum.take(czn,n)
  end

  "50 blind cyclops prime"

iex(13)> Rosetta.cyp(Rosetta.cyz(Rosetta.cy(5000),1000),50)
[11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89,
97, 1117, 1123, 1129, 1151, 1153, 1163, 1171, 1181, 1187, 1193, 1213, 1217,
1223, 1229, 1231, 1237, 1249, 1259, 1277, 1279, 1283, 1289, 1291, 1297, 1319,
1321, 1327, 1361, 1367]

 def cypa cn,n do
    czp=for x <- cn,Integer.to_string(x)==String.reverse(Integer.to_string(x)), do: x
    Enum.take(czp,n)
  end
end

  "50 palindrome prime cyclops"

iex(2)> Rosetta.cyp(Rosetta.cypa(Rosetta.cy(3000000),3000),50)
[101, 16061, 31013, 35053, 38083, 73037, 74047, 91019, 94049, 1120211, 1150511,
1160611, 1180811, 1190911, 1250521, 1280821, 1360631, 1390931, 1490941,
1520251, 1550551, 1580851, 1630361, 1640461, 1660661, 1670761, 1730371,
1820281, 1880881, 1930391, 1970791, 3140413, 3160613, 3260623, 3310133,
3380833, 3460643, 3470743, 3590953, 3670763, 3680863, 3970793, 7190917,
7250527, 7310137, 7540457, 7630367, 7690967, 7750577, 7820287]
