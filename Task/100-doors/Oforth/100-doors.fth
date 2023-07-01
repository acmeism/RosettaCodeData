: doors
| i j l |
   100 false Array newWith dup ->l
   100 loop: i [
      i 100 i step: j [ l put ( j , j l at not ) ]
      ]
;
