\ The following is Forth code using iMops v2.23
\ Tested on all MacOS from High Sierra to Sonoma
\ using Intel based systems.
\ This code can be used to create a stand-alone application

: isdigit? ( char -- flag ) \ true if 0 thru 9, false otherwise
  48 58 within? ;

: >uinteger { addr len \ dec accum  -- n t | f }
  len NIF exit THEN
  1 -> dec 0 -> accum
  len 1+ 1 ?DO
   addr len + i - c@ dup isdigit?
     IF ( it's a digit 0 thru 9 )
        48 - dec * accum + -> accum
        dec 10 * -> dec
     ELSE  2drop false unloop exit
     THEN drop
  LOOP accum true ;

SYSCALL rand { -- int }

:class TextView' super{ TextView }
:m put: ( addr len -- )
   0 #ofChars: self SetSelect: self
   insert: self ;m
;class

Window+ w
  View wview
    Button incButton
      100 30 90 20 ( x0 y0 wid hi ) setFrame: incButton
    Button randButton
      190 30 70 20 ( x0 y0 wid hi ) setFrame: randButton
    TextView' val
      180 100 100 15 setFrame: val
    FixedText valLabel
       110 98 80 18 setframe: valLabel

Window+ okW
  view  okView
    Button yesButton
      100 20 80 18 setframe: yesButton
    Button cancelButton
      10 20 80 18 setframe: cancelButton
    FixedText okText
      5 40 200 18 setframe: okText

:noname
 getText: val >uinteger
  IF 1+ deciNumstr
  ELSE " 0"
  THEN put: val ;  setAction: incButton

:noname
  show: okW  ;  setAction: randButton

:noname
  rand deciNumstr put: val
  show: w ; setAction: yesButton

:noname
  getText: val >uinteger
  NIF " 0" put: val
  THEN  show: w ; setAction: cancelButton

: main
   incButton  addview: wview
   randButton addview: wview
   val        addview: wview
   valLabel   addview: wview
   " value:" SetText: valLabel
   300 30 430 230 put: frameRect
    frameRect " GUI component interaction" docWindow
   wview new: w  show: w
     " 0" put: val  \ must be done after window is new:
   " increment" setTitle: incButton
   " random" setTitle: randButton

   yesButton    addview: okView
   cancelButton addview: okView
   okText       addview: okView
   " Set value to random number?" SetText: okText
   310 40 200 60 put: frameRect
    frameRect "  " noCloseStyle
   okView new: okW
   " yes" setTitle: yesButton
   " cancel" setTitle: cancelButton
  ;

main  \ if creating installed app, startup word must be commented out
