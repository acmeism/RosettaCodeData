# syntax: GAWK -f DETERMINE_SENTENCE_TYPE.AWK
BEGIN {
    str = "hi there, how are you today? I'd like to present to you the washing machine 9001. You have been nominated to win one of these! Just make sure you don't break it"
    main(str)
    main("Exclamation! Question? Serious. Neutral")
    exit(0)
}
function main(str,  c) {
    while (length(str) > 0) {
      c = substr(str,1,1)
      sentence = sentence c
      if (c == "!") {
        prn("E")
      }
      else if (c == ".") {
        prn("S")
      }
      else if (c == "?") {
        prn("Q")
      }
      str = substr(str,2)
    }
    prn("N")
    print("")
}
function prn(type) {
    gsub(/^ +/,"",sentence)
    printf("%s %s\n",type,sentence)
    sentence = ""
}
