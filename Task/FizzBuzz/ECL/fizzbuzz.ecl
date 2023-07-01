DataRec := RECORD
    STRING  s;
END;

DataRec MakeDataRec(UNSIGNED c) := TRANSFORM
    SELF.s := MAP
        (
            c % 15 = 0  =>  'FizzBuzz',
            c % 3 = 0   =>  'Fizz',
            c % 5 = 0   =>  'Buzz',
            (STRING)c
        );
END;

d := DATASET(100,MakeDataRec(COUNTER));

OUTPUT(d);
