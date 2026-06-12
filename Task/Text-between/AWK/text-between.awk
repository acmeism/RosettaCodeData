# syntax: GAWK -f TEXT_BETWEEN.AWK
BEGIN {
    main("Hello Rosetta Code world","Hello "," world","1. Both delimiters set")
    main("Hello Rosetta Code world","start"," world","2. Start delimiter is the start of the string")
    main("Hello Rosetta Code world","Hello","end","3. End delimiter is the end of the string")
    main("</div><div style=\"chinese\">???</div>","<div style=\"chinese\">","</div>",
    "4. End delimiter appears before and after start delimiter")
    main("<text>Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">","<text>","<table>",
    "5. End delimiter not present")
    main("<table style=\"myTable\"><tr><td>hello world</td></tr></table>","<table>","</table>",
    "6. Start delimiter not present")
    main("The quick brown fox jumps over the lazy other fox","quick "," fox",
    "7. Multiple instances of end delimiter after start delimiter (match until the first one)")
    main("One fish two fish red fish blue fish","fish "," red",
    "8. Multiple instances of the start delimiter (start matching at the first one)")
    main("FooBarBazFooBuxQuux","Foo","Foo","9. Start delimiter is end delimiter")
    main("Hello Rosetta Code world","start","end","10. Start and end delimiters use special values")
    main("Hello Rosetta Code world","","x","11. Null start delimiter")
    main("Hello Rosetta Code world","x","","12. Null end delimiter")
    exit(0)
}
function main(text,sdelim,edelim,example,  pos,str) {
    printf("Example %s\n",example)
    printf("Text: '%s'\n",text)
    printf("sDelim: '%s'\n",sdelim)
    printf("eDelim: '%s'\n",edelim)
    if (sdelim == "" || edelim == "") {
      printf("error: null delimiter\n\n")
      return
    }
    if (sdelim == "start") {
      str = text
    }
    else {
      pos = index(text,sdelim)
      if (pos > 0) {
        str = substr(text,pos+length(sdelim))
      }
    }
    if (edelim == "end") {
    }
    else {
      pos = index(str,edelim)
      if (pos > 0) {
        str = substr(str,1,pos-1)
      }
    }
    printf("Output: '%s'\n\n",str)
}
