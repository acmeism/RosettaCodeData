BEGIN {
  mystring="knights"
  print substr(mystring,2)                       # remove the first letter
  print substr(mystring,1,length(mystring)-1)    # remove the last character
  print substr(mystring,2,length(mystring)-2)    # remove both the first and last character
}
