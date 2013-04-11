def prettytri(n:Int) = (1 to n) foreach {i=>print(" "*(n-i)); tri(i) map (c=>print(c+" ")); println}
prettytri(5)
