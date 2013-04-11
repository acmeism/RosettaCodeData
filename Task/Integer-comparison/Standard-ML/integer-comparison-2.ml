fun myCompare (a, b) = case Int.compare (a, b) of
                  LESS    => "A is less than B"
                | GREATER => "A is greater than B"
                | EQUAL   => "A equals B"
