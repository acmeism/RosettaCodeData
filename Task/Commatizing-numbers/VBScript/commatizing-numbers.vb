function commatize( s , sep, start , stp  )

  if sep ="" then sep   = ","
  if start  ="" then start = 1
  if stp    ="" then stp   = 3

 Dim i, j, k, l
 l = len(s)

  for i = start to l
    if ( asc( mid( s, i, 1 ) ) >= asc("1") and asc( mid( s, i, 1) ) <= asc("9") ) then
      for j = i + 1 to l + 1
        if ( j > l ) then
          for k = j - 1 - stp to i step -stp
            s = mid( s, 1, k ) + sep + mid( s, k + 1, l - k + 1 )
            l = len(s)
          next 'k
          exit for
        else
          if ( asc( mid( s, j, 1 ) ) < asc("0") or asc( mid( s, j, 1 ) ) > asc("9") ) then
            for k = j - 1 - stp to i step -stp
              s = mid( s, 1, k ) + sep + mid( s, k + 1, l - k + 1 )
              l = len(s)
            Next ' k
            exit for
          end if
        end if
      next 'j
      exit for
    end if
  next '
  commatize=S
end function

wscript.echo commatize("pi=3.14159265358979323846264338327950288419716939937510582097494459231"   , " " , 6, 5 )
wscript.echo commatize("The author has two Z$100000000000000 Zimbabwe notes (100 trillion)."      , "." , "", "" )
wscript.echo commatize("\'-in Aus$+1411.8millions\'"                                              , "," , "", "" )
wscript.echo commatize("===US$0017440 millions=== (in 2000 dollars)"                              , ""  , "", "" )
wscript.echo commatize("123.e8000 is pretty big."                                                 , ""  , "", "" )
wscript.echo commatize("The land area of the earth is 57268900(29% of the surface) square miles." , ""  , "", "" )
wscript.echo commatize("Ain't no numbers in this here words, nohow, no way, Jose."                , ""  , "", "" )
wscript.echo commatize("James was never known as 0000000007"                                      , ""  , "", "" )
wscript.echo commatize("Arthur Eddington wrote: I believe there are 15747724136275002577605653961181555468044717914527116709366231425076185631031296 protons in the universe.", ",", "", "" )
wscript.echo commatize("   $-140000±100 millions."                                                , ""  , "", "" )
wscript.echo commatize("6/9/1946 was a good year for some."                                       , ""  , "", "" )
