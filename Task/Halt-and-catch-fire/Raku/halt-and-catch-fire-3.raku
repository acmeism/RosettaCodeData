use Test;

dies-ok { ++8 };
dies-ok { die };
dies-ok {  …  };

eval-dies-ok '++8';
eval-dies-ok 'die';
eval-dies-ok  '…' ;
