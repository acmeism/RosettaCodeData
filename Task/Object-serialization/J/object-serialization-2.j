   print__R''
room size small
   print__K''
kitchen size medium
   print__S''
kitchen with sink size large


   (;<@serializeObject"0 R,K,S) 1!:2 <'objects.dat'

   'r1 k1 s1'=: <"0 deserializeObject 1!:1<'objects.dat'
   print__r1''
room size small
   print__k1''
kitchen size medium
   print__s1''
kitchen with sink size large
