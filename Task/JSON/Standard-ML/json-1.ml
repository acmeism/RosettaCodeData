JSONParser.parse(JSONParser.openString("{\"fruit\":\"apple\", \"numbers\": [2,7,1,8,2,8], \"tau\": 6.28318530718}"));
(* val it =
   OBJECT
    [("fruit", STRING "apple"),
     ("numbers", ARRAY [INT 2, INT 7, INT 1, INT 8, INT 2, INT 8]),
     ("tau", FLOAT 6.283185307)]: JSON.value
*)


JSONPrinter.print(TextIO.stdOut, it);
(* {"fruit":"apple","numbers":[2,7,1,8,2,8],"tau":6.28319} *)


JSONPrinter.print' {strm=TextIO.stdOut, pretty=true} it;
(*
{
    "fruit" : "apple",
    "numbers" : [
        2,
        7,
        1,
        8,
        2,
        8
      ],
    "tau" : 6.28319
  }
*)
