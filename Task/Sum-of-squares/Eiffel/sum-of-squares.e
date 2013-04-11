class    SUMSQUARES
creation make
feature
    make is
      local
          numbers: ARRAY[DOUBLE];
          sum    : DOUBLE;
          i      : INTEGER;
      do
          numbers := <<1, 2, 3, 4, 5>>;
          from i := numbers.lower until i > numbers.upper loop
              sum := sum + numbers.item(i).pow(2);
              i := i + 1;
          end
          io.put_string(sum.to_string_format(2) + "%N");
      end
end
