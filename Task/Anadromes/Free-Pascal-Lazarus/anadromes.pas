program anadromes;
// Capitalized first letter is used only for type names, like "String"
uses
   classes,   // for TStringList
   strUtils;  // for reverseString

var
   words: TStringList;
   line, reverseWord: String;
   inFile: TextFile;

begin
   words := TStringList.create;
   //otherwise every new line would be immediately sorted.
   words.sorted := false;

   assign(inFile, 'words.txt');
   reset(inFile);
   while not eof(inFile) do
   begin
      readLn(inFile, line);
      if length(line) > 6 then words.add(line);
   end;
   close(inFile);

  //all lines are read, now sort
   words.caseSensitive := true;
   words.sorted := true;
   for line in words do
   begin
      reverseWord := reverseString(line);
      if (line > reverseWord) and (words.indexOf(reverseWord) > -1) then
         writeLn(line: 10, ' <-> ', reversestring(line));
   end;

   words.free;
end.
