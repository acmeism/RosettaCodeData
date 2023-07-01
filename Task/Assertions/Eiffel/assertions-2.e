class TEST
    feature assert(val: INTEGER) is
        require
            val = 42;
        do
            print("Thanks for the 42!%N");
        end
end
