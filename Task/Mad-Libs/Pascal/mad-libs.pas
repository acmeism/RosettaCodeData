Program Madlib; Uses DOS, crt; {See, for example, https://en.wikipedia.org/wiki/Mad_Libs}
{Reads the lines of a story but which also contain <xxx> sequences. For each value of xxx,
 found as the lines of the story are read, a request is made for a replacement text.
 The story is then written out with the corresponding replacements made.}
{Concocted by R.N.McLean (whom God preserve), Victoria university, NZ.}
 Procedure Croak(gasp: string); {A dying message.}
  Begin
   Writeln(' Eurghfff...');
   Writeln(Gasp);
   HALT;
  End;
 var inf: text; {Drivelstuff.}
 const StoryLimit = 66;TableLimit = 65;		{Big enough.}
 var Story: array[1..StoryLimit] of string;	{Otherwise, use a temporary disc file.}
 var Target,Replacement: array[1..TableLimit] of string;
 var StoryLines,TableCount: integer;		{Usage.}

 Function Reading(var inf: text;var Aline: string): boolean;
  Begin
   Aline:='';
   Reading:=true;
   if eoln(inf) then Reading:=false	{Agh! Why can't the read statement return true/false?}
    else ReadLn(inf,Aline);
   if Aline = '' then Reading:=false;	{Specified that a blank line ends the story.}
  End;

 Procedure Inspect(text: string); Forward;{I'd rather have multi-pass compilation than deal with this.}

 Procedure Table(it: string);	{Check it as a target, and obtain its replacement.}
  var i: integer;	{A stepper.}
  Begin
   for i:=1 to TableCount do if it = Target[i] then exit;	{Already in the table?}
   if TableCount >= TableLimit then Croak('Too many table entries!');	{No. Room for another?}
   inc(TableCount);				{Yes.}
   Target[TableCount]:=it;			{Include the < and > to preclude partial matches.}
   write('Enter your text for ',it,': ');	{Pretty please?}
   readln(Replacement[TableCount]);		{Thus.}
   Inspect(Replacement[TableCount]);		{Enable full utilisation.}
  End; {of Table.}

 var InDeep: integer;	{Counts inspection recursion.}
 Procedure Inspect(text: string);		{Look for <...> in text.}
  var i: integer;	{A stepper.}
  var mark: integer;	{Fingers the latest < in Aline.}
  Begin
   inc(InDeep);		{Supply an opportunity, and fear the possibilities.}
   if InDeep > 28 then Croak('Excessive recursion! Inspecting ' + text);
   for i:=1 to Length(text) do	{Now scan the line for trouble.}
    if text[i] = '<' then mark:=i	{Trouble starts here? Just mark its place.}
     else if text[i] = '>' then	{Trouble ends here?}
      Table(copy(text,mark,i - mark + 1));	{Deal with it.}
   dec(InDeep);		{I'm done.}
  End; {of Inspect.}

 Procedure Swallow(Aline: string);	{Add a line to the story, and inspect it for <...>.}
  Begin
   if StoryLines >= StoryLimit then Croak('Too many lines in the story!');	{Suspicion forever.}
   inc(StoryLines);		{Otherwise, this is safe.}
   Story[StoryLines]:=Aline;	{So save another line.}
   Inspect(Aline);		{Look for any <...> inclusions.}
  End; {of Swallow.}

 var Rolling: integer;		{Counts rolling rolls.}
 Procedure Roll(bumf: string);	{Write a line, with amendments.}
  var last,mark: integer;	{Fingers for the scan.}
  var hit: string;		{Copied once.}
  var i,it: integer;		{Steppers.}
  label hic;	{Oh dear.}
  Begin
   inc(Rolling);	{Here I go.}
   if Rolling > 28 then Croak('Excessive recursion! Rolling ' + bumf);	{Self-expansion is out.}
   last:=0;			{Where the previous text ended.}
   for i:=1 to Length(bumf) do	{Scan the text.}
    if bumf[i] = '<' then mark:=i	{Remember where a <...> starts.}
     else if bumf[i] = '>' then		{So that when the stopper is found,}
      begin				{It can be recognised.}
       Write(copy(bumf,last + 1,mark - last - 1));	{Text up to the <.}
       hit:=copy(bumf,mark,i - mark + 1);	{Grab this once.}
       for it:=1 to TableCount do	{Search my table.}
        if Target[it] = hit then	{A match?}
         begin				{Yes!}
          Roll(Replacement[it]);	{Write this instead.}
          goto hic;			{There is no "exit loop" style statement.}
         end;				{"Exit" exits the procedure or function.}
   hic:last:=i;		{Advance the trailing finger.}
      end;	{On to the next character.}
   Write(copy(bumf,last + 1,Length(bumf) - last));	{Text after the last >, possibly null.}
   dec(Rolling);			{I'm done.}
   if Rolling <= 0 then WriteLn;	{And if this is the first level, add a end-of-line.}
  End;	{of Roll.}

 var inname: string;	{For a file name.}
 var Aline: string;	{A scratchpad.}
 var i: integer;	{A stepper.}
 BEGIN
  InDeep:=0;		{No inspections yet.}
  Rolling:=0;		{No output.}
  inname:=ParamStr(1);	{Perhaps the file name is specified as a run-time parameter.}
  if inname = '' then inname:='Madlib.txt';	{If not, this will do.}
  Assign(inf,inname); Reset(inf);		{Open the input file.}
  StoryLines:=0; TableCount:=0;			{Prepare the counters.}
  while reading(inf,Aline) do Swallow(Aline);	{Read and inspect the story.}
  close(inf);					{Finished with input.}
  for i:=1 to StoryLines do Roll(Story[i]);	{Write the amended story.}
 END.
