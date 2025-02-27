{ wrd = $0
  rwrd = ""
  for (i=length(wrd); i>0; --i)
     rwrd = rwrd substr(wrd,i,1)
  if (rwrd == wrd)
    palindromes += 1
  else if ( seen[rwrd] ) {
    if (++pairs < 7)
      print wrd " " rwrd
  } else
    seen[wrd] = wrd
}
END {
  print pairs " pairs, " palindromes " palindromes."
}
