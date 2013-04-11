CM.make "$/regexp-lib.cm";
structure RE = RegExpFn (
      structure P = AwkSyntax
      structure E = BackTrackEngine);
val re = RE.compileString "string$";
val string = "I am a string";
case StringCvt.scanString (RE.find re) string
 of NONE => print "match failed\n"
  | SOME match =>
      let
        val {pos, len} = MatchTree.root match
      in
        print ("matched at position " ^ Int.toString pos ^ "\n")
      end;
