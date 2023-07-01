main:
     { { iter 1 + dup

        15 %
            { "FizzBuzz" <<
                zap }
            { dup
            3 %
                { "Fizz" <<
                    zap }
                { dup
                5 %
                    { "Buzz" <<
                        zap}
                    { %d << }
                if }
            if }
        if

        "\n" << }

    100 times }
