//Express an Integer in English Language. Nigel Galloway: September 19th., 2018
let fN=[|[|"";"one";"two";"three";"four";"five";"six";"seven";"eight";"nine"|];
         [|"ten";"eleven";"twelve";"thirteen";"fourteen";"fifteen";"sixteen";"seventeen";"eighteen";"nineteen"|];
         [|"";"";"twenty";"thirty";"fourty";"fifty";"sixty";"seventy";"eighty";"ninety"|]|]
let rec I2α α β=match α with |α when α<20     ->β+fN.[α/10].[α%10]
                             |α when α<100    ->I2α (α%10) (β+fN.[2].[α/10]+if α%10>0 then " " else "")
                             |α when α<1000   ->I2α (α-(α/100)*100) (β+fN.[0].[α/100]+" hunred"+if α%100>0 then " and " else "")
                             |α when α<1000000->I2α (α%1000) (β+(I2α (α/1000) "")+" thousand"+if α%100=0 then "" else if (α-(α/1000)*1000)<100 then " and " else " ")
