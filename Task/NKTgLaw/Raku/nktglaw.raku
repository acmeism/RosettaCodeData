# 20260701 Raku programming solution

sub ($x           ,$v,$m,   $d){ my$p=$m*$v;my (\a,    \b)=($x,$d    ) X*$p;
 my @S =            "M"~    "oving toward stable "~    "state",      "Stab"
  ~"le e"             ~     ""~      ~"qu"      ~""     ~"il"        ~""
  ~"ibrium"           ,     "M"      ~"ov"      ~""     ~"in"       ~""
  ~"g awa"~           ''    ~        "y f"        ~     "rom"      ~""
  ~''   ~" st"        ~              "abl"              ~"e "  ~''~''               ~"state";
  my     @M=''        ~              "Mas"              ~"s varia"                 ~''    ~'tion'
  ~        " re"      ~              "sis"              ~"ts mov"                 ~'em'    ~'ent'
  ,         "No m"    ~              "ass"              ~ " variati"              ~''       ~''
  ~           "on "   ~              "eff"              ~"ect","Mass"             ~''       ~''
  ~            "varia"~              "tio"              ~"n s"   ~"up"             ~'p'    ~''
  ~             "prts"~              "mov"              ~"eme"     ~"t";             printf
  ''              ~"p"~              ": "~              "%g\n"     ~ "NKT"          ~
  ~                "g1"              ~": "              ~"%g"        ~"\nNK"      ~''
~"T"~               "g"             ~"2: "~            "%g\nT"~        "enden"    ~"cy1: %s\nTe"
                                                                                  ~"ndency2: %s\n",
                                                                                  $p,            a,b
                                                                                 ,@S[             a.
                                                                                  sign          +1],
                                                                                   @M[ b.sign +1]}(
                                                                                      2,3,4,-.5)
