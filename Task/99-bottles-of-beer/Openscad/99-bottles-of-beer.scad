num_bottles = 99;
s1 = " of beer";
s2 = " on the wall";
s3 = "Take one down and pass it around, ";
s4 = "No more";
s5 = "no more";
s6 = "Go to the store and buy some more, ";
b1 = " bottle";
b2 = " bottles";
beer(n = num_bottles);
module beer(n, biere) {
  biere1 = str(n >= 1 ? n  : s4,n == 1 ? b1 :b2,s1, s2,", ",n >= 1 ? n : s5,n == 1 ? b1 :b2,s1,".");
  biere2 = str(n == 0 ? s6 : s3,n == 0 ? num_bottles : n == 1 ? s5 : n-1,n == 0 ? b2 : n-1 == 1 ? b1 : b2,s1,s2,".");
  biere3 = str(biere1," ",biere2);
  echo(biere3);
  if(n > 0) {
    beer(n = n-1);
  }
}
