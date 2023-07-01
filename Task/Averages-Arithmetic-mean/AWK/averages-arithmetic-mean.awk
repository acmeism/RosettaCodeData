cat mean.awk
#!/usr/local/bin/gawk -f

# User defined function
function mean(v,      i,n,sum) {
  for (i in v) {
    n++
    sum += v[i]
  }
  if (n>0) {
    return(sum/n)
  } else {
    return("zero-length input !")
  }
}

BEGIN {
  # fill a vector with random numbers
  for(i=0; i < 10; i++) {
    vett[i] = rand()*10
  }
  print mean(vett)
  print mean(nothing)
}
