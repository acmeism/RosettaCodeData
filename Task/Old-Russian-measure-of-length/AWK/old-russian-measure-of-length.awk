# syntax: GAWK -f OLD_RUSSIAN_MEASURE_OF_LENGTH.AWK
BEGIN {
    units = "kilometer meter centimeter tochka liniya diuym vershok piad fut arshin sazhen versta milia"
    values = "1000.0 1.0 0.01 0.000254 0.00254 0.0254 0.04445 0.1778 0.3048 0.7112 2.1336 1066.8 7467.6"
    u_leng = split(units,u_arr," ")
    v_leng = split(values,v_arr," ")
    if (u_leng != v_leng) {
      print("error: lengths of units & values are unequal")
      exit(1)
    }
    print("enter length & measure or C/R to exit")
}
{   if ($0 == "") {
      exit(0)
    }
    measure = tolower($2)
    sub(/s$/,"",measure)
    for (i=1; i<=u_leng; i++) {
      if (u_arr[i] == measure) {
        for (j=1; j<=u_leng; j++) {
          str = sprintf("%.8f",$1*v_arr[i]/v_arr[j])
          sub(/0+$/,"",str)
          printf("%10s %s\n",u_arr[j],str)
        }
        print("")
        next
      }
    }
    printf("error: invalid measure; choose from: %s\n\n",units)
}
