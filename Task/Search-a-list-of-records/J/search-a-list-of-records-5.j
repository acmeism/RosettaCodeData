   city=: <;._1 ';Lagos;Cairo;Kinshasa-Brazzaville;Greater Johannesburg;Mogadishu;Khartoum-Omdurman;Dar Es Salaam;Alexandria;Abidjan;Casablanca'
   popln=: 21 15.2 11.3 7.55 5.85 4.98 4.7 4.58 4.4 3.98
   city i. <'Dar Es Salaam'              NB. index of Dar Es Salaam
6
   (city i. boxopen) 'Dar Es Salaam'     NB. anonymous search function with city name as argument
6
   city {::~ (popln < 5) {.@# \: popln   NB. name of first city with population less than 5 million
Khartoum-Omdurman
   popln&(city {::~ \:@[ {.@#~ <) 5      NB. anonymous search function with popln limit as argument
Khartoum-Omdurman
   popln {~ 'A' i.~ {.&> city            NB. population of first city whose name starts with "A"
4.58
   (popln {~ ({.&> city)&i.) 'A'         NB. anonymous search function with first letter as argument
4.58
