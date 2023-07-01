/*REXX program (when using criteria) locates values (indices)  from an associate array. */
$="Lagos=21,  Cairo=15.2,  Kinshasa-Brazzaville=11.3, Greater Johannesburg=7.55, Mogadishu=5.85,",
  "Khartoum-Omdurman=4.98, Dar Es Salaam=4.7,  Alexandria=4.58,   Abidjan=4.4,  Casablanca=3.98"
@.= '(city not found)';    city.= "(no city)"       /*city search results for not found.*/
                                                    /* [↓]  construct associate arrays. */
    do #=0  while $\='';  parse var $ c '=' p "," $;  c=space(c);  parse var c a 2;  @.c=#
    city.#=c;  pop.#=p;  pop.c=#;  if @.a==@.  then @.a=c;  /*assign city, pop, indices.*/
    end   /*#*/                                     /* [↑]  city array starts at 0 index*/
                        /*▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ task 1:  show the  INDEX  of a city.*/
town= 'Dar Es Salaam'                               /*the name of a city for the search.*/
say 'The city of ' town " has an index of: " @.town /*show (zero─based) index of a city.*/
say                     /*▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ task 2:  show 1st city whose pop<5 M*/
many=5                                              /*size of a city's pop in millions. */
      do k=0  for #  until pop.k<many; end          /*find a city's pop from an index.  */
say '1st city that has a population less than '     many     " million is: "    city.k
say                     /*▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ task 3:  show 1st city with A* name.*/
c1= 'A'                                             /*1st character of a city for search*/
say '1st city that starts with the letter' c1 "is: " @.c1 /*stick a fork in it, all done*/
