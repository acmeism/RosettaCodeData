/* REXX ---------------------------------------------------------------
* 05.10.2014
*--------------------------------------------------------------------*/
x05='05'x
mydb='sidb.txt'
Say 'Enter your commands, ?, or end'
Do Forever
  Parse Pull l
  Parse Var l command text
  Select
    When command='?' Then
      Call help
    When command='add' Then Do
      Parse Var text item ',' category ',' date
      If date='' Then
        date=date('S') /*yyyymmdd*/
      Say 'adding item' item'/'category 'dated' date
      Call lineout mydb,date item x05 category
      End
    When command='latest' Then Do
      Call lineout mydb
      Parse Var text category
      hidt='00000000'
      ol=''
      Do While lines(mydb)>0
        l=linein(mydb)
        Parse Var l dt a (x05) b
        If category=''|,
           category='-' & b='' |,
           b=category Then Do
          If dt>>hidt Then Do
            ol=l
            hidt=dt
            End
          End
        End
        If ol>'' Then
          Call o ol
        Else
          Say 'no matching item found'
      End
    When command='all' Then Do
      Call lineout mydb
      Parse Var text category
      Do While lines(mydb)>0
        l=linein(mydb)
        Parse Var l a (x05) b
        If category=''|,
           category='-' & b=''|,
           b=category Then
          Call o l
        End
      End
    When command='end' Then
      Leave
    Otherwise Do
      Say 'invalid command ('command')'
      Call help
      End
    End
  End
Say 'Bye'
Exit

o: Parse Value arg(1) With dt text
   Say left(dt,8) text
   Return

help:
  Say 'add item[,[category][,date]] to add an item'
  Say 'latest category to list the latest item of a category'
  Say 'latest to list the latest item'
  Say 'all category to list all items of a category'
  Say 'all to list all items'
  Say 'end to end this program'
  Say 'Use category - to list items without category'
  Return
