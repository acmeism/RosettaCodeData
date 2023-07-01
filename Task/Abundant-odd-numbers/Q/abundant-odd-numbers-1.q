s:{c where 0=x mod c:1+til x div 2}            / proper divisors
sd:sum s@                                      / sum of proper divisors
abundant:{x<sd x}
Filter:{y where x each y}
