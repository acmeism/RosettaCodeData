function wordwrap_paragraph(p)
{
  if ( length(p) < 1 ) return

  split(p, words)
  spaceLeft = lineWidth
  line = words[1]
  delete words[1]

  for (i = 1; i <= length(words); i++) {
    word = words[i]
    if ( (length(word) + 1) > spaceLeft ) {
      print line
      line = word
      spaceLeft = lineWidth -  length(word)
    } else {
      spaceLeft -= length(word) + 1
      line = line " " word
    }
  }
  print line
}

BEGIN {
  lineWidth = width
  par = ""
}

/^[ \t]*$/ {
  wordwrap_paragraph(par)
  par = ""
}

!/^[ \t]*$/ {
  par = par " " $0
}

END {
  wordwrap_paragraph(par)
}
