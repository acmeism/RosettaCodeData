puts <<EOS
---------- Ice and Fire ------------

fire, in end will world the say Some
ice. in say Some
desire of tasted I've what From
fire. favor who those with hold I

... elided paragraph last ...

Frost Robert -----------------------
EOS
  .each_line.map {|line| line.split.reverse.join(' ')}
