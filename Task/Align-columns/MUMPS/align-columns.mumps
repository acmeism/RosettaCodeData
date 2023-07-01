columns(how)	; how = "Left", "Center" or "Right"
	New col,half,ii,max,spaces,word
	Set ii=0
	Set ii=ii+1,line(ii)="Given$a$text$file$of$many$lines,$where$fields$within$a$line$"
	Set ii=ii+1,line(ii)="are$delineated$by$a$single$'dollar'$character,$write$a$program"
	Set ii=ii+1,line(ii)="that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$"
	Set ii=ii+1,line(ii)="column$are$separated$by$at$least$one$space."
	Set ii=ii+1,line(ii)="Further,$allow$for$each$word$in$a$column$to$be$either$left$"
	Set ii=ii+1,line(ii)="justified,$right$justified,$or$center$justified$within$its$column."
	Set ii="" For  Set ii=$Order(line(ii)) Quit:ii=""  Do
	. For col=1:1:$Length(line(ii),"$") Do
	. . Set max=$Length($Piece(line(ii),"$",col))
	. . Set:max>$Get(max(col)) max(col)=max
	. . Quit
	. Quit
	Set ii="" For  Set ii=$Order(line(ii)) Quit:ii=""  Do
	. Write ! For col=1:1:$Length(line(ii),"$") Do:$Get(max(col))
	. . Set word=$Piece(line(ii),"$",col)
	. . Set spaces=$Justify("",max(col)-$Length(word))
	. . If how="Left" Write word,spaces," " Quit
	. . If how="Right" Write spaces,word," " Quit
	. . Set half=$Length(spaces)\2
	. . Write $Extract(spaces,1,half),word,$Extract(spaces,half+1,$Length(spaces))," "
	. . Quit
	. Quit
	Write !
	Quit
Do columns("Left")

Given      a          text       file   of     many      lines,     where    fields  within  a      line
are        delineated by         a      single 'dollar'  character, write    a       program
that       aligns     each       column of     fields    by         ensuring that    words   in     each
column     are        separated  by     at     least     one        space.
Further,   allow      for        each   word   in        a          column   to      be      either left
justified, right      justified, or     center justified within     its      column.

Do columns("Center")

  Given        a         text     file    of     many      lines,    where   fields  within    a    line
   are     delineated     by       a    single 'dollar'  character,  write      a    program
   that      aligns      each    column   of    fields       by     ensuring  that    words    in   each
  column      are     separated    by     at     least      one      space.
 Further,    allow       for      each   word     in         a       column    to      be    either left
justified,   right    justified,   or   center justified   within     its    column.

Do columns("Right")

     Given          a       text   file     of      many     lines,    where  fields  within      a line
       are delineated         by      a single  'dollar' character,    write       a program
      that     aligns       each column     of    fields         by ensuring    that   words     in each
    column        are  separated     by     at     least        one   space.
  Further,      allow        for   each   word        in          a   column      to      be either left
justified,      right justified,     or center justified     within      its column.
