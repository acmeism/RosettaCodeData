sub rot13 { $^s.trans: 'a..mn..z' => 'n..za..m', :ii }

multi MAIN ()        { print rot13 slurp }
multi MAIN (*@files) { print rot13 [~] map &slurp, @files }
