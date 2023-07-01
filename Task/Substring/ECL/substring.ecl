/* In this task display a substring:

1.       starting from n characters in and of m length;
2.       starting from n characters in, up to the end of the string;
3.       whole string minus last character;
4.       starting from a known character within the string and of m length;
5.       starting from a known substring within the string and of m length.
*/

IMPORT STD; //imports a standard string library	
	
TheString := 'abcdefghij';
CharIn    := 3; //n
StrLength := 4; //m
KnownChar := 'f';
KnownSub  := 'def'; 	
FindKnownChar := STD.Str.Find(TheString, KnownChar,1);
FindKnownSub  := STD.Str.Find(TheString, KnownSub,1);
	
OUTPUT(TheString[Charin..CharIn+StrLength-1]); //task1	
OUTPUT(TheString[Charin..]);                   //task2
OUTPUT(TheString[1..LENGTH(TheString)-1]);     //task3
OUTPUT(TheString[FindKnownChar..FindKnownChar+StrLength-1]);//task4
OUTPUT(TheString[FindKnownSub..FindKnownSub+StrLength-1]);  //task5	

/* OUTPUTS:
   defg
   cdefghij	
   abcdefghi
   fghi
   defg	
*/
