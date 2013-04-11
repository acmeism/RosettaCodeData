sub rot13 { $^s.trans: 'A..Za..z' => 'N..ZA..Mn..za..m' }

multi MAIN ()        { print rot13 slurp }
multi MAIN (*@files) { print rot13 [~] map &slurp, @files }
