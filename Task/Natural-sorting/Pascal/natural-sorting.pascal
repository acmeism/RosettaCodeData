Program Natural; Uses DOS, crt;	{Simple selection.}
{Demonstrates a "natural" order of sorting text with nameish parts.}

 Const null=#0; BS=#8; HT=#9; LF=#10{0A}; VT=#11{0B}; FF=#12{0C}; CR=#13{0D};

 Procedure Croak(gasp: string);
  Begin
   WriteLn(Gasp);
   HALT;
  End;

 Function Space(n: integer): string;	{Can't use n*" " either.}
  var text: string;	{A scratchpad.}
  var i: integer;	{A stepper.}
  Begin
   if n > 255 then n:=255	{A value parameter,}
    else if n < 0 then n:=0;	{So this just messes with my copy.}
   for i:=1 to n do text[i]:=' ';	{Place some spaces.}
   text[0]:=char(n);			{Place the length thereof.}
   Space:=text;		{Take that.}
  End; {of Space.}

 Function DeFang(x: string): string;	{Certain character codes cause action.}
  var text: string;	{A scratchpad, as using DeFang directly might imply recursion.}
  var i: integer;	{A stepper.}
  var c: char;		{Reduce repetition.}
  Begin			{I hope that appending is recognised by the compiler...}
   text:='';			{Scrub the scratchpad.}
   for i:=1 to Length(x) do	{Step through the source text.}
    begin			{Inspecting each character.}
     c:=char(x[i]);		{Grab it.}
     if c > CR then text:=text + c	{Deemed not troublesome.}
      else if c < BS then text:=text + c	{Lacks an agreed alternative, and may not cause trouble.}
       else text:=text + '!' + copy('btnvfr',ord(c) - ord(BS) + 1,1);	{The alternative codes.}
    end;			{On to the next.}
   DeFang:=text;	{Alas, the "escape" convention lengthens the text.}
  End; {of DeFang.}	{But that only mars the layout, rather than ruining it.}

 Const mEntry = 66;	{Sufficient for demonstrations.}
 Type EntryList = array[0..mEntry] of integer;	{Identifies texts by their index.}
 var  EntryText: array[1..mEntry] of string;	{Inbto this array.}
 var nEntry: integer;				{The current number.}
 Function AddEntry(x: string): integer;	{Add another text to the collection.}
  Begin	 {Could extend to checking for duplicates via a sorted list...}
   if nEntry >= mEntry then Croak('Too many entries!');	{Perhaps not!}
   inc(nEntry);			{So, another.}
   EntryText[nEntry]:=x;	{Placed.}
   AddEntry:=nEntry;		{The caller will want to know where.}
  End; {of AddEntry.}

 Function TextOrder(i,j: integer): boolean;	{This is easy.}
  Begin						{But despite being only one statement, and simple at that,}
   TextOrder:=EntryText[i] <= EntryText[j];	{Begin...End is insisted upon.}
  End;	{of TextOrder.}

 Function NaturalOrder(e1,e2: integer): boolean;{Not so easy.}
  const Article: array[1..3] of string[4] = ('A ','AN ','THE ');	{Each with its trailing space.}
  Function Crush(var c: char): char;	{Suppresses divergence.}
   Begin				{To simplify comparisons.}
    if c <= ' ' then Crush:=' '		{Crush the fancy control characters.}
     else Crush:=UpCase(c);		{Also crush a < A or a > A or a = A questions.}
   End; {of Crush.}
  var Wot: array[1..2] of integer;	{Which text is being fingered.}
  var Tail: array[1..2] of integer;	{Which article has been found at the start.}
  var l,lst: array[1..2] of integer;	{Finger to the current point, and last character.}
  Procedure Librarian;		{Initial inspection of the texts.}
   var Blocked: boolean;	{Further progress may be obstructed.}
   var a,is,i: integer;		{Odds and ends.}
   label Hic;			{For escaping the search when a match is complete.}
   Begin		{There are two texts to inspect.}
    for is:=1 to 2 do	{Treat them alike.}
     begin			{This is the first encounter.}
      l[is]:=1;			{So start the scan with the first character.}
      Tail[is]:=0;		{No articles found.}
      while (l[is] <= lst[is]) and (EntryText[wot[is]][l[is]] <= ' ') do inc(l[is]);	{Leading spaceish.}
      for a:=1 to 3 do		{Try to match an article at the start of the text.}
       begin				{Each article's text has a trailing space to be matched also.}
        i:=0;				{Start a for-loop, but with early escape in mind.}
        Repeat 				{Compare successive characters, for i:=0 to a...}
         if l[is] + i > lst[is] then Blocked:=true	{Probed past the end of text?}
          else Blocked:=Crush(EntryText[wot[is]][l[is] + i]) <> Article[a][i + 1];	{No. Compare capitals.}
         inc(i);			{Stepping on to the next character.}
        Until Blocked or (i > a);	{Conveniently, Length(Article[a]) = a.}
        if not Blocked then	{Was a mismatch found?}
         begin			{No!}
          Tail[is]:=a;		{So, identify the discovery.}
          l[is]:=l[is] + i;	{And advance the scan to whatever follows.}
          goto Hic;		{Escape so as to consider the other text.}
         end;			{Since two texts are being considered separately.}
      end;		{Sigh. no "Next a" or similar syntax.}
 Hic:dec(l[is]);	{Backstep one, ready to advance later.}
     end;	{Likewise, no "for is:=1 to 2 do ... Next is" syntax.}
   End; {of Librarian.}
  var c: array[1..2] of string[1];	{Selected by Advance for comparison.}
  var d: integer;		{Their difference.}
  type moody = (Done,Bored,Grist,Numeric);	{Might as well have some mnemonics.}
  var Mood: array[1..2] of moody;		{As the scan proceeds, moods vary.}
  var depth: array[1..2] of integer;	{Digit depth.}
  Procedure Another;	{Choose a pair of characters to compare.}
  {Digit sequences are special! But periods are ignored, also signs, avoiding confusion over "+6" and " 6".}
   var is: integer;	{Selects from one text or the other.}
   var ll: integer;	{Looks past the text into any Article.}
   var d: char;		{Possibly a digit.}
   Begin
    for is:=1 to 2 do	{Same treatment for both texts.}
     begin			{Find the next character, and taste it.}
      repeat			{If already bored, slog through any following spaces.}
       inc(l[is]);			{So, advance one character onwards.}
       ll:=l[is] - lst[is];		{Compare to the end of the normal text.}
       if ll <= 0 then c[is]:=Crush(EntryText[wot[is]][l[is]])	{Still in the normal text.}
        else if Tail[is] <= 0 then c[is]:=''		{Perhaps there is no tail.}
         else if ll <= 2 then c[is]:=copy(', ',ll,1)	{If there is, this is the junction.}
          else if ll <= 2 + Tail[is] then c[is]:=copy(Article[Tail[is]],ll - 2,1)	{And this the tail.}
           else c[is]:='';				{Actually, the copy would do this.}
      until not ((c[is] = ' ') and (Mood[is] = Bored));	{Thus pass multiple enclosed spaces, but not the first.}
      if length(c[is]) <= 0 then Mood[is]:=Done 	{Perhaps we ran off the end, even of the tail.}
       else if c[is] = ' ' then Mood[is]:=Bored		{The first taste of a space induces boredom.}
        else if ('0' <= c[is]) and (c[is] <= '9') then Mood[is]:=Numeric	{Paired, evokes special attention.}
         else Mood[is]:=Grist;		{All else is grist for my comparisons.}
     end;		{Switch to the next text.}
{Comparing digit sequences is to be done as if numbers. "007" vs "70" is to become vs. "070" by length matching.}
    if (Mood[1] = Numeric) and (Mood[2] = Numeric) then	{Are both texts yielding a digit?}
     begin					{Yes. Special treatment impends.}
      if (Depth[1] = 0) and (Depth[2] = 0) then	{Do I already know how many digits impend?}
       for is:=1 to 2 do				{No. So for each text,}
         repeat						{Keep looking until I stop seeing digits.}
          inc(Depth[is]);				{I am seeing a digit, so there will be one to count.}
          ll:=l[is] + Depth[is];			{Finger the next position.}
          if ll > lst[is] then d:=null			{And if not off the end,}
           else d:=EntryText[wot[is]][ll];		{Grab a potential digit.}
         until (d < '0') or (d > '9');			{If it is one, probe again.}
      if Depth[1] < Depth[2] then	{Righto, if the first sequence has fewer digits,}
       begin					{Supply a free zero.}
        dec(Depth[2]);				{The second's digit will be consumed.}
        dec(l[1]);				{The first's will be re-encountered.}
        c[1]:='0';				{Here is the zero}
       end					{For the comparison.}
       else if Depth[2] < Depth[1] then	{But if the second has fewer digits to come,}
        begin					{Don't dig into them yet.}
         dec(Depth[1]);				{The first's digit will be used.}
         dec(l[2]);				{But the second's seen again.}
         c[2]:='0';				{After this has been used}
        end					{In the comparison.}
        else				{But if both have the same number of digits remaining,}
         begin					{Then the comparison is aligned.}
          dec(Depth[1]);			{So this digit will be used.}
          dec(Depth[2]);			{As will this.}
         end;					{In the comparison.}
     end;			{Thus, arbitrary-size numbers are allowed, as they're never numbers.}
   End; {of Another.}	{Possibly, the two characters will be the same, and another pair will be requested.}
  Begin {of NaturalOrder.}
   Wot[1]:=e1; Wot[2]:=e2;		{Make the two texts accessible via indexing.}
   lst[1]:=Length(EntryText[e1]);	{The last character of the first text.}
   lst[2]:=Length(EntryText[e2]);	{And of the second. Saves on repetition.}
   Mood[1]:=Bored; Mood[2]:=Bored;	{Behave as if we have already seen a space.}
   depth[1]:=0;     depth[2]:=0;	{And, no digits in concert have been seen.}
   Librarian;		{Start the inspection.}
   repeat		{Chug along, until a difference is found.}
    Another;			{To do so, choose another pair of characters to compare.}
    d:=Length(c[2]) - Length(c[1]);	{If one text has run out, favour the shorter.}
    if (d = 0) and (Length(c[1]) > 0) then d:=ord(c[2][1]) - ord(c[1][1]);	{Otherwise, their difference.}
   until (d <> 0) or ((Mood[1] = Done) and (Mood[2] = Done));	{Well? Are we there yet?}
   NaturalOrder:=d >= 0;	{And so, does e1's text precede e2's?}
  End; {of NatualOrder.}

 var TextSort: boolean;		{Because I can't pass a function as a parameter,}
 Function InOrder(i,j: integer): boolean;	{I can only use one function.}
  Begin						{Which messes with a selector.}
   if TextSort then InOrder:=TextOrder(i,j)	{So then,}
    else InOrder:=NaturalOrder(i,j);		{Which is it to be?}
  End; {of InOrder.}
 Procedure OrderEntry(var List: EntryList);	{Passing a ordinary array is not Pascalish, damnit.}
{Crank up a Comb sort of the entries fingered by List. Working backwards, just for fun.}
{Caution: the H*10/13 means that H ought not be INTEGER*2. Otherwise, use H/1.3.}
  var t: integer;	{Same type as the elements of List.}
  var N,i,h: integer;	{Odds and ends.}
  var happy: boolean;	{To be attained.}
  Begin
   N:=List[0];		{Extract the count.}
   h:=N - 1;		{"Last" - "First", and not +1.}
   if h <= 0 then exit;	{Ha ha.}
   Repeat		{Start the pounding.}
    h:=LongInt(h)*10 div 13;	{Beware overflow, or, use /1.3.}
    if h <= 0 then h:=1;	{No "max" function, damnit.}
    if (h = 9) or (h = 10) then h:=11;	{A fiddle.}
    happy:=true;		{No disorder seen.}
    for i:=N - h downto 1 do	{So, go looking. If h = 1, this is a Bubblesort.}
     if not InOrder(List[i],List[i + h]) then	{How about this pair?}
      begin						{Alas.}
       t:=List[i]; List[i]:=List[i + h]; List[i + h]:=t;{No Swap(a,b), damnit.}
       happy:=false;				{Disorder has been discovered.}
      end;				{On to the next comparison.}
   Until happy and (h = 1);	{No suspicion remains?}
  End; {of OrderEntry.}

 var Item,Fancy: EntryList;	{Two lists of entry indices.}
 var i: integer;	{A stepper.}
 var t1: string;	{A scratchpad.}
 BEGIN
  nEntry:=0;	{No entries are stored.}
  i:=0;		{Start a stepper.}
  inc(i);Item[i]:=AddEntry('ignore leading spaces: 2-2');
  inc(i);Item[i]:=AddEntry(' ignore leading spaces: 2-1');
  inc(i);Item[i]:=AddEntry('  ignore leading spaces: 2+0');
  inc(i);Item[i]:=AddEntry('   ignore leading spaces: 2+1');
  inc(i);Item[i]:=AddEntry('ignore m.a.s spaces: 2-2');
  inc(i);Item[i]:=AddEntry('ignore m.a.s  spaces: 2-1');
  inc(i);Item[i]:=AddEntry('ignore m.a.s   spaces: 2+0');
  inc(i);Item[i]:=AddEntry('ignore m.a.s    spaces: 2+1');
  inc(i);Item[i]:=AddEntry('Equiv.'+' '+'spaces: 3-3');
  inc(i);Item[i]:=AddEntry('Equiv.'+CR+'spaces: 3-2');	{CR can't appear as itself.}
  inc(i);Item[i]:=AddEntry('Equiv.'+FF+'spaces: 3-1');	{As it is used to mark line endings.}
  inc(i);Item[i]:=AddEntry('Equiv.'+VT+'spaces: 3+0');	{And if typed in an editor,}
  inc(i);Item[i]:=AddEntry('Equiv.'+LF+'spaces: 3+1');	{It is acted upon there and then.}
  inc(i);Item[i]:=AddEntry('Equiv.'+HT+'spaces: 3+2');	{So, name instead of value.}
  inc(i);Item[i]:=AddEntry('cASE INDEPENDENT: 3-2');
  inc(i);Item[i]:=AddEntry('caSE INDEPENDENT: 3-1');
  inc(i);Item[i]:=AddEntry('casE INDEPENDENT: 3+0');
  inc(i);Item[i]:=AddEntry('case INDEPENDENT: 3+1');
  inc(i);Item[i]:=AddEntry('foo100bar99baz0.txt');
  inc(i);Item[i]:=AddEntry('foo100bar10baz0.txt');
  inc(i);Item[i]:=AddEntry('foo1000bar99baz10.txt');
  inc(i);Item[i]:=AddEntry('foo1000bar99baz9.txt');
  inc(i);Item[i]:=AddEntry('The Wind in the Willows');
  inc(i);Item[i]:=AddEntry('The 40th step more');
  inc(i);Item[i]:=AddEntry('The 39 steps');
  inc(i);Item[i]:=AddEntry('Wanda');
  {inc(i);Item[i]:=AddEntry('The Worth of Wirth''s Way');}
  Item[0]:=nEntry;	{Complete the EntryList protocol.}
  for i:=0 to nEntry do Fancy[i]:=Item[i];	{Sigh. Fancy:=Item.}

  TextSort:=true; OrderEntry(Item);	{Plain text ordering.}

  TextSort:=false; OrderEntry(Fancy);	{Natural order.}

  WriteLn('    Text order                         Natural order');
  for i:=1 to nEntry do
   begin
    t1:=DeFang(EntryText[Item[i]]);
    WriteLn(Item[i]:3,'|',t1,Space(30 - length(t1)),' ',
           Fancy[i]:3,'|',DeFang(EntryText[Fancy[i]]));
   end;

 END.
