    def pow: reduce .[1:] as $i (.[0]; pow(.;$i))

    [5,3,2] | pow
