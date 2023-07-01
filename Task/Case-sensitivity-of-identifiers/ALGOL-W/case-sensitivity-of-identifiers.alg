begin
    string(8) dog;
    dog := "Benjamin";
    begin
        string(8) Dog;
        Dog := "Samba";
        begin
            string(8) DOG;
            DOG := "Bernie";
            if DOG not = Dog
            or DOG not = dog
            then write( "The three dogs are named: ", dog, ", ", Dog, " and ", DOG )
            else write( "There is just one dog named: ", DOG )
        end
    end
end.
