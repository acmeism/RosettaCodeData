class MAIN
    creation main
    feature main is
        local
            test: TEST;
        do
            create test;

            io.read_integer;
            test.assert(io.last_integer);
        end
end
