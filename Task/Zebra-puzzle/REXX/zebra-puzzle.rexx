/* REXX ---------------------------------------------------------------
* Solve the Zebra Puzzle
*--------------------------------------------------------------------*/
  Call mk_perm    /* compute all permutations                        */
  Call encode     /* encode the elements of the specifications       */
  /* ex2 .. eg16     the formalized specifications                   */
  solutions=0
  Call time 'R'
  Do nation_i = 1 TO 120
    Nations = perm.nation_i
    IF ex10() Then Do
      Do color_i = 1 TO 120
        Colors = perm.color_i
        IF ex5() & ex2() & ex15() Then Do
          Do drink_i = 1 TO 120
            Drinks = perm.drink_i
            IF ex9() & ex4() & ex6() Then Do
              Do smoke_i = 1 TO 120
                Smokes = perm.smoke_i
                IF ex14() & ex13() & ex16() & ex8() Then Do
                   Do animal_i = 1 TO 120
                    Animals = perm.animal_i
                    IF ex3() & ex7() & ex11() & ex12() Then Do
                      /* Call out 'Drinks =' Drinks  54321 Wat Tea Mil Cof Bee */
                      /* Call out 'Nations=' Nations 41235 Nor Den Eng Ger Swe */
                      /* Call out 'Colors =' Colors  51324 Yel Blu Red Gre Whi */
                      /* Call out 'Smokes =' Smokes  31452 Dun Ble Pal Pri Blu */
                      /* Call out 'Animals=' Animals 24153 Cat Hor Bir Zeb Dog */
                      Call out 'House   Drink      Nation     Colour'||,
                                                         '     Smoke      Animal'
                      Do i=1 To 5
                        di=substr(drinks,i,1)
                        ni=substr(nations,i,1)
                        ci=substr(colors,i,1)
                        si=substr(smokes,i,1)
                        ai=substr(animals,i,1)
                        ol.i=right(i,3)'     '||left(drink.di,11),
                                              ||left(nation.ni,11),
                                              ||left(color.ci,11),
                                              ||left(smoke.si,11),
                                              ||left(animal.ai,11)
                        Call out ol.i
                        End
                      solutions=solutions+1
                      End
                    End /* animal_i */
                  End
                End /* smoke_i */
              End
            End /* drink_i */
          End
        End /* color_i */
      End
    End /* nation_i */
  Say 'Number of solutions =' solutions
  Say 'Solved in' time('E') 'seconds'
Exit

/*------------------------------------------------------------------------------
      #There are five houses.
ex2:  #The English man lives in the red house.
ex3:  #The Swede has a dog.
ex4:  #The Dane drinks tea.
ex5:  #The green house is immediately to the left of the white house.
ex6:  #They drink coffee in the green house.
ex7:  #The man who smokes Pall Mall has birds.
ex8:  #In the yellow house they smoke Dunhill.
ex9:  #In the middle house they drink milk.
ex10: #The Norwegian lives in the first house.
ex11: #The man who smokes Blend lives in the house next to the house with cats.
ex12: #In a house next to the house where they have a horse, they smoke Dunhill.
ex13: #The man who smokes Blue Master drinks beer.
ex14: #The German smokes Prince.
ex15: #The Norwegian lives next to the blue house.
ex16: #They drink water in a house next to the house where they smoke Blend.
------------------------------------------------------------------------------*/
ex2:  Return pos(England,Nations)=pos(Red,Colors)
ex3:  Return pos(Sweden,Nations)=pos(Dog,Animals)
ex4:  Return pos(Denmark,Nations)=pos(Tea,Drinks)
ex5:  Return pos(Green,Colors)=pos(White,Colors)-1
ex6:  Return pos(Coffee,Drinks)=pos(Green,Colors)
ex7:  Return pos(PallMall,Smokes)=pos(Birds,Animals)
ex8:  Return pos(Dunhill,Smokes)=pos(Yellow,Colors)
ex9:  Return substr(Drinks,3,1)=Milk
ex10: Return left(Nations,1)=Norway
ex11: Return abs(pos(Blend,Smokes)-pos(Cats,Animals))=1
ex12: Return abs(pos(Dunhill,Smokes)-pos(Horse,Animals))=1
ex13: Return pos(BlueMaster,Smokes)=pos(Beer,Drinks)
ex14: Return pos(Germany,Nations)=pos(Prince,Smokes)
ex15: Return abs(pos(Norway,Nations)-pos(Blue,Colors))=1
ex16: Return abs(pos(Blend,Smokes)-pos(Water,Drinks))=1

mk_perm: Procedure Expose perm.
/*---------------------------------------------------------------------
* Make all permutations of 12345 in perm.*
*--------------------------------------------------------------------*/
perm.=0
n=5
Do pop=1 For n
  p.pop=pop
  End
Call store
Do While nextperm(n,0)
  Call store
  End
Return

nextperm: Procedure Expose p. perm.
  Parse Arg n,i
  nm=n-1
  Do k=nm By-1 For nm
    kp=k+1
    If p.k<p.kp Then Do
      i=k
      Leave
      End
    End
  Do j=i+1 While j<n
    Parse Value p.j p.n With p.n p.j
    n=n-1
    End
  If i>0 Then Do
    Do j=i+1 While p.j<p.i
      End
    Parse Value p.j p.i With p.i p.j
    End
  Return i>0

store: Procedure Expose p. perm.
  z=perm.0+1
    _=''
    Do j=1 To 5
      _=_||p.j
      End
  perm.z=_
  perm.0=z
  Return

encode:
  Beer=1         ; Drink.1='Beer'
  Coffee=2       ; Drink.2='Coffee'
  Milk=3         ; Drink.3='Milk'
  Tea=4          ; Drink.4='Tea'
  Water=5        ; Drink.5='Water'
  Denmark=1      ; Nation.1='Denmark'
  England=2      ; Nation.2='England'
  Germany=3      ; Nation.3='Germany'
  Norway=4       ; Nation.4='Norway'
  Sweden=5       ; Nation.5='Sweden'
  Blue=1         ; Color.1='Blue'
  Green=2        ; Color.2='Green'
  Red=3          ; Color.3='Red'
  White=4        ; Color.4='White'
  Yellow=5       ; Color.5='Yellow'
  Blend=1        ; Smoke.1='Blend'
  BlueMaster=2   ; Smoke.2='BlueMaster'
  Dunhill=3      ; Smoke.3='Dunhill'
  PallMall=4     ; Smoke.4='PallMall'
  Prince=5       ; Smoke.5='Prince'
  Birds=1        ; Animal.1='Birds'
  Cats=2         ; Animal.2='Cats'
  Dog=3          ; Animal.3='Dog'
  Horse=4        ; Animal.4='Horse'
  Zebra=5        ; Animal.5='Zebra'
  Return

out:
  Say arg(1)
  Return
