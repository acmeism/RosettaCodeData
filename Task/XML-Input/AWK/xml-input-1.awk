function parse_buf()
{
    if ( match(buffer, /<Student[ \t]+[^>]*Name[ \t]*=[ \t]*"([^"]*)"/, mt) != 0 ) {
      students[mt[1]] = 1
    }
    buffer = ""
}

BEGIN {
  FS=""
  mode = 0
  buffer = ""
  li = 1
}

mode==1 {
  for(i=1; i <= NF; i++) {
    buffer = buffer $i
    if ( $i == ">" ) {
      mode = 0;
      break;
    }
  }
  if ( mode == 0 ) {
    li = i
  } else {
    li = 1
  }
  # let us process the buffer if "complete"
  if ( mode == 0 ) {
    parse_buf()
  }
}

mode==0 {
  for(i=li; i <= NF; i++) {
    if ( $i == "<" ) {
      mode = 1
      break;
    }
  }
  for(j=i; i <= NF; i++) {
    buffer = buffer $i
    if ( $i == ">" ) {
      mode = 0
      parse_buf()
    }
  }
  li = 1
}

END {
  for(k in students) {
    print k
  }
}
