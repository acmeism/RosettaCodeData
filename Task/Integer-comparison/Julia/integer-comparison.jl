function compare()
    int1 = readline(stdin)
    int2 = readline(stdin)
    print(int1, " is ",
       int1 <  int2 ? "less than "    :
       int1 == int2 ? "equal to "     :
       int1 >  int2 ? "greater than " :
       "uncomparable to",
      int2)
end
