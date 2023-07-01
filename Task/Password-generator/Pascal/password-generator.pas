program passwords (input,output);

{$mode objfpc}
{$H+} { We will need ansi strings instead of short strings
        to hold passwords longer than 255 characters.
        We need to assemble a string to check that each
        password contains an upper, lower, numeral and symbol }

{ This is a random password generater in PASCAL
  Copyright Englebert Finklestien on this day which is
  Setting Orange day 48 of The Aftermath YOLD 3184.
  It is distributed under the terms of the GNU GPL (v3)
  As published by the free software foundation.

  Usage :-
  Without any command line arguments this program
  will display 8 8-character long completely random passwords using
  all 96 available character glyphs from the basic ascii set.

  With a single integer numerical argument it will
  produce eight passwords of the chosen length.

  With a second integer numerical argument between 1 and 65536 it
  will produce that number of passwords.

  With two integer arguments the first is taken as the length of password
  and the second as the number of passwords to produce.

  The length of passwords can also be specified using -l or --length options

  The number of passwords can also be specified using -n or --number options

  It is also possible to exclude those glyphs which are simmilar enough to be
  confused (e.g. O and 0) using the -e or --exclude option

  There are also the standard -a --about and -h --help options

  Other options will produce an error message and the program will halt without
  producing any passwords at all.

 }

uses sysutils, getopts;



var c : char;
    optionindex : Longint;
    theopts : array[1..5] of TOption;
    numpass, lenpass, count,j : integer;
    i : longint; { used to get a random number }
    strength : byte; {  check inclusion of different character groups }
    password : string; { To hold a password as we generate it }
    exc : boolean;
    ex : set of char;

procedure about;
begin
     writeln('Engleberts random password generator');
     writeln('Writen in FreePascal on Linux');
     writeln('This is free software distributed under the GNU GPL v3');
     writeln;
end;

procedure help;
begin
    writeln('Useage:-');
    writeln('passwords   produce 8 passwords each 8 characters long.');
    writeln('Use one or more of the following switches to control the output.');
    writeln('passwords --number=xx -nxx --length=xx -lxx --exclude -e --about -a --help -h');
    writeln('passwords ll nn produce nn passwords of length ll');
    writeln('The exclude option excludes easily confused characters such as `0` and `O` from');
    writeln('the generated passwords.');
    writeln;
end;


begin
  numpass := 8;
  lenpass := 8;
  exc := False;
  ex := ['1','!','l','|','i','I','J','0','O','S','$','5',';',':',',','.','\']; { Set of ambiguous characters }
  OptErr := True;
  Randomize;  {initialise the random number generator}
  {set up to handle the command line options}
  with theopts[1] do
   begin
    name:='length';
    has_arg:=1;
    flag:=nil;
    value:=#0;
   end;
  with theopts[2] do
   begin
    name:='number';
    has_arg:=1;
    flag:=nil;
    value:=#0;
   end;
  with theopts[3] do
   begin
    name:='help';
    has_arg:=0;
    flag:=nil;
    value:=#0;
   end;
  with theopts[4] do
   begin
    name:='about';
    has_arg:=0;
    flag:=nil;
    value:=#0;
   end;
  with theopts[5] do
   begin
    name:='exclude';
    has_arg:=0;
    flag:=nil;
    value:=#0;
   end;

{ Get and process long and short versions of command line args. }
  c:=#0;
  repeat
    c:=getlongopts('ahel:n:t:',@theopts[1],optionindex);
    case c of
      #0 : begin
               if (theopts[optionindex].name = 'exclude') then exc := True;
               if (theopts[optionindex].name = 'length') then lenpass := StrtoInt(optarg);
               if (theopts[optionindex].name = 'number') then numpass := StrtoInt(optarg);
	       if (theopts[optionindex].name = 'about') then about;
	       if (theopts[optionindex].name = 'help') then help;
           end;
      'a' : about;
      'h' : help;
      'e' : exc := True;
      'l' : lenpass := StrtoInt(optarg);
      'n' : numpass := StrtoInt(optarg);
      '?',':' : writeln ('Error with opt : ',optopt);
    end; { case }
  until c=endofoptions;
  { deal with any remaining command line parameters (two integers)}
  if optind<=paramcount then
    begin
       count:=1;
       while optind<=paramcount do
         begin
	    if (count=1) then lenpass := StrtoInt(paramstr(optind)) else numpass := StrtoInt(paramstr(optind));
            inc(optind);
	    inc(count);
         end;
    end;
	if not (exc) then ex :=['\']; { if we are not going to exclude characters set the exclusion set to almost empty }
	{ This generates and displays the actual passwords  }
    for count := 1 to numpass do begin
       strength := $00;
       repeat
          password :='';
          for j:= 1 to lenpass do begin
             repeat
                i:=Random(130);
             until (i>32) and (i<127) and (not(chr(i) in ex)) ;
             AppendStr(password,chr(i));
             if (CHR(i) in ['0'..'9']) then strength := strength or $01;
             if (chr(i) in ['a'..'z']) then strength := strength or $02;
             if (chr(i) in ['A'..'Z']) then strength := strength or $04;
             if (chr(i) in ['!'..'/']) then strength := strength or $08;
             if (chr(i) in [':'..'@']) then strength := strength or $08;
             if (chr(i) in ['['..'`']) then strength := strength or $08;
             if (chr(i) in ['{'..'~']) then strength := strength or $08;
         end;	
       until strength = $0f;
    writeln(password);
    end;
end.
