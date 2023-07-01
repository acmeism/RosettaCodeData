   d:("N;Nbe;N-ne;Nebn;Ne;Nebe;E-ne;Ebn;")
   d,:("E;Ebs;E-se;Sebe;Se;Sebs;S-se;Sbe;")
   d,:("S;Sbw;S-sw;Swbs;Sw;Swbw;W-sw;Wbs;")
   d,:("W;Wbn;W-nw;Nwbw;Nw;Nwbn;N-nw;Nbw;N")

   split:{1_'(&x=y)_ x:y,x}
   dd:split[d;";"]

   / lookup table
   s1:"NEWSnewsb-"
   s2:("North";"East";"West";"South";"north";"east";"west";"south";" by ";"-")
   c:.({`$x}'s1),'{`$x}'s2   / create the dictionary
   cc:{,/{$c[`$$x]}'x}       / lookup function

   / calculate the degrees
   f:{m:x!3;(11.25*x)+:[1=m;+5.62;2=m;-5.62;0]}
