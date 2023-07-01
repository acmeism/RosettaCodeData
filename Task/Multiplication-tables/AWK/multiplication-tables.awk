BEGIN {
  for(i=1;i<=12;i++){
    for(j=1;j<=12;j++){
      if(j>=i||j==1){printf "%4d",i*j}
      else          {printf "    "}
  }
  print
 }
}
