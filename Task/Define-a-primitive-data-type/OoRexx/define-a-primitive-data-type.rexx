/* REXX ----------------------------------------------------------------
* 21.06.2014 Walter Pachl
* implements a data type tinyint that can have an integer value 1..10
* 22.06.2014 WP corrected by Rony Flatscher to handle arithmetic
*---------------------------------------------------------------------*/
a=.tinyint~new(1)  ; Say 'a='||a~value
Say '2*a='||(2*a)
Say 'a*2='||((0+a)*2)
say "---> rony was here: :)"
say "The above statement was in effect: '(0+a)*2', NOT 'a*2*, hence it worked!"
say "These statements work now:"
say "(a)*2:" (a)*2
say "a*2:  " a*2
say "<--- rony was here, The end. :)"
b=.tinyint~new(11); Say 'b='||b~value
b=.tinyint~new('B'); Say 'b='||b~value
say 'b='||(b)           -- show string value
Say '2*b='||(2*b)
::class tinyint
::method init
  Expose v
  Use Arg i
  Select
    When datatype(i,'W') Then Do
      If i>=1 & i<=10 Then
        v=i
      Else Do
        Say 'Argument 1 must be between 1 and 10'
        Raise Syntax 88.907 array(1,1,10,i)
        End
      End
    Otherwise Do
      Say 'Argument 1 must be a whole number between 1 and 10'
      Raise Syntax 88.905 array(1,i)
      End
    End
::method string
  Expose v
  Return v
::method value
  Expose v
  Return v

-- rgf, 20140622, intercept unknown messages, forward arithmetic messages to string value
::method unknown
  expose v
  use arg methName, methArgs
  if wordpos(methName, "+ - * / % //")>0 then  -- an arithmetic message in hand?
    forward message (methName) to (v) array (methArgs[1])
