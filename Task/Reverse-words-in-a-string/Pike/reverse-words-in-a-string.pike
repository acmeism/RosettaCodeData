string story = #"---------- Ice and Fire ------------

fire, in end will world the say Some
ice. in say Some
desire of tasted I've what From
fire. favor who those with hold I

... elided paragraph last ...

Frost Robert -----------------------";

foreach(story/"\n", string line)
    write("%s\n", reverse(line/" ")*" ");
