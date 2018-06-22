USING: io sequences splitting ;
IN: rosetta-code.reverse-words

"---------- Ice and Fire ------------

fire, in end will world the say Some
ice. in say Some
desire of tasted I've what From
fire. favor who those with hold I

... elided paragraph last ...

Frost Robert -----------------------"

"\n" split [ " " split reverse " " join ] map [ print ] each
