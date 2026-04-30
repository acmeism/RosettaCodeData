(
// Usage: ~catalan.(n)
// Return a list of all Catalan numbers C(0), ..., C(n),
// where n is a positive or null integer.
~catalan = {
  arg n; var out = [1], x;

  if(n == 0){}{
    for(1, n){
      arg i;
      x = (2*(2*i - 1)/(i + 1))*out[i - 1];
      out = out ++ [x];
  };};
  out;
};

~catalan.(14).do{arg item; item.postln};
)
