MODULE Arithmetic;
IMPORT CPmain,Console,RTS;

VAR
   x,y	  : INTEGER;
   arg	  : ARRAY 128 OF CHAR;
   status : BOOLEAN;


PROCEDURE Error(IN str : ARRAY OF CHAR);
BEGIN
   Console.WriteString(str);Console.WriteLn;
   HALT(1)
END Error;


BEGIN
   IF CPmain.ArgNumber() < 2 THEN Error("Give me two integers!") END;
   CPmain.GetArg(0,arg); RTS.StrToInt(arg,x,status);
   IF ~status THEN Error("Can't convert 	'"+arg+"' to Integer") END;
   CPmain.GetArg(1,arg); RTS.StrToInt(arg,y,status);
   IF ~status THEN Error("Can't convert '"+arg+"' to Integer") END;
   Console.WriteString("x + y >");Console.WriteInt(x + y,6);Console.WriteLn;
   Console.WriteString("x - y >");Console.WriteInt(x - y,6);Console.WriteLn;
   Console.WriteString("x * y >");Console.WriteInt(x * y,6);Console.WriteLn;
   Console.WriteString("x / y >");Console.WriteInt(x DIV y,6);Console.WriteLn;
   Console.WriteString("x MOD y >");Console.WriteInt(x MOD y,6);Console.WriteLn;
END Arithmetic.
