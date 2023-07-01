//Reverse words in a string. Nigel Galloway: July 14th., 2021
["  ---------- Ice and Fire ------------  ";
 "                                        ";
 "  fire, in end will world the say Some  ";
 "  ice. in say Some                      ";
 "  desire of tasted I've what From       ";
 "  fire. favour who those with hold I    ";
 "                                        ";
 "  ... elided paragraph last ...         ";
 "                                        ";
 "  Frost Robert -----------------------  "]|>List.map(fun n->n.Split " "|>Array.filter((<>)"")|>Array.rev|>String.concat " ")|>List.iter(printfn "%s")
