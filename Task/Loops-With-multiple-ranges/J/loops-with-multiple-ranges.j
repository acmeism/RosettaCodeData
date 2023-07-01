TO=: {{
  'N M'=. 2{.y,1
  x:x+M*i.>.(1+N-x)%M
}}

BY=: ,

{{
  PROD=:  1
   SUM=:  0
     X=: +5
     Y=: -5
     Z=: -2
   ONE=:  1
 THREE=:  3
 SEVEN=:  7

 for_J. ;do >cutLF {{)n
   < (-THREE) TO      (3^3)       BY THREE
   < (-SEVEN) TO   (+SEVEN)       BY   X
   <     555  TO       550-Y
   <      22  TO       _28        BY -THREE
   <    1927  TO      1939
   <       X  TO         Y        BY Z
   <   (11^X) TO     (11^X) + ONE
}} do.
   SUM=: SUM+|J
   if. ((|PROD)<2^27) * J~:0 do. PROD=: PROD*J end.
 end.
 echo ' SUM= ',":SUM
 echo 'PROD= ',":PROD
}}0
