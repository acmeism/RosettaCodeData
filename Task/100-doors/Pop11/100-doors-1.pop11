lvars i;
lvars doors = {% for i from 1 to 100 do false endfor %};
for i from 1 to 100 do
   for j from i by i to 100 do
      not(doors(j)) -> doors(j);
   endfor;
endfor;
;;; Print state
for i from 1 to 100 do
   printf('Door ' >< i >< ' is ' ><
            if doors(i) then 'open' else 'closed' endif, '%s\n');
endfor;
