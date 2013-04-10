class
    APPLICATION

create
    make

feature {NONE} -- Initialization

    make
            -- Run application.
        do
            create my_apple_box.make (10)
            create one_apple
            create one_pear
            my_apple_box.extend (one_apple)
--          my_apple_box.extend (one_pear)
            across
                my_apple_box as ic
            loop
                ic.item.eat
            end
        end

feature -- Access

    my_apple_box: FOOD_BOX [APPLE]
            -- My apple box

    one_apple: APPLE
            -- An apple

    one_pear: PEAR
            -- A pear
end
