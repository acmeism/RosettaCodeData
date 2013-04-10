#!/usr/local/bin/a68g --script #

[6]STRING rows := []STRING(
    "Character,Speech",
    "The multitude,The messiah! Show us the messiah!",
    "Brians mother,<angry>Now you listen here! He's not the messiah; he's a very naughty boy! Now go away!</angry>",
    "The multitude,Who are you?",
    "Brians mother,I'm his mother; that's who!",
    "The multitude,Behold his mother! Behold his mother!"
);

[max abs char]STRING encoded; FOR i TO UPB encoded DO encoded[i]:=REPR i OD;
# encoded[ABS""""] := "&quot;"; optional #
  encoded[ABS "&"] := "&amp;";
  encoded[ABS "<"] := "&lt;";
# encoded[ABS ">"] := "&gt;"; optional #

OP ENCODE = (STRING s)STRING: (
  STRING out := "";
  FOR i TO UPB s DO out+:= encoded[ABS s[i]] OD;
  out
);

PROC head = (STRING title)VOID: (
  printf((
    $"<HEAD>"l$,
      $"<TITLE>"g"</TITLE>"l$, title,
      $"<STYLE type=""text/css"">"l$,
        $"TD {background-color:#ddddff; }"l$,
        $"thead TD {background-color:#ddffdd; text-align:center; }"l$,
      $"</STYLE>"l$,
    $"</HEAD>"l$
  ))
);

# define HTML tags using Algol68's "reverent" block structuring #
PROC html = VOID: print(("<HTML>", new line)),
       body = VOID: print(("<BODY>", new line)),
         table = VOID: print(("<TABLE>", new line)),
           table row = VOID: print(("<TR>")),
             th = (STRING s)VOID: printf(($"<TH>"g"</TH>"$, s)),
             td = (STRING s)VOID: printf(($"<TD>"g"</TD>"$, s)),
           elbat row = VOID: print(("</TR>", new line)),
         elbat = VOID: print(("</TABLE>", new line)),
       ydob = VOID: print(("</BODY>", new line)),
     lmth = VOID: print(("</HTML>", new line));

FILE row input; STRING row; CHAR ifs = ",";
associate(row input, row); make term(row input, ifs);

html;
  head("CSV to HTML translation - Extra Credit");
  body;
    table;
      FOR nr TO UPB rows DO
        row := rows[nr];
        table row;
          on logical file end(row input, (REF FILE row input)BOOL: row end);
          FOR nf DO
            STRING field; get(row input,field);
            (nr=1|th|td)(ENCODE field);
            get(row input, space)
          OD;
          row end: reset(row input);
        elbat row
      OD;
    elbat;
  ydob;
lmth
