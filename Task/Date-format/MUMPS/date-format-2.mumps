DTM(H)
 ;You can pass an integer, but the default is to use today's value
 SET:$DATA(H)=0 H=$HOROLOG
 NEW Y,YR,RD,MC,MO,DA,MN,DN,DOW
 SET MN="January,February,March,April,May,June,July,August,September,October,November,December"
 SET DN="Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday"
 SET MC="31,28,31,30,31,30,31,31,30,31,30,31"
 SET Y=+H\365.25 ;This shouldn't be an approximation in production code
 SET YR=Y+1841 ;Y is the offset from the epoch in years
 SET RD=((+H-(Y*365.25))+1)\1 ;How far are we into the year?
 SET $P(MC,",",2)=$S(((YR#4=0)&(YR#100'=0))!((YR#100=0)&(YR#400=0))=0:28,1:29) ;leap year correction
 SET MO=1,RE=RD FOR  QUIT:RE<=$P(MC,",",MO)  SET RE=RE-$P(MC,",",MO),MO=MO+1
 SET DA=RE+1
 SET DOW=(H#7)+5 ;Fencepost issue - the first piece is 1
 ;add padding as needed
 SET:$L(MO)<2 MO="0"_MO
 SET:$L(DA)<2 DA="0"_DA
 WRITE !,YR,"-",MO,"-",DA
 WRITE !,$P(DN,",",DOW),", ",$P(MN,",",MO)," ",DA,", ",YR
 KILL Y,YR,RD,MC,MO,DA,MN,DN,DOW
 QUIT
