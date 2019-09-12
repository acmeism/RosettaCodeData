class MY_CLASS

create                      -- Here we are declaring ...
   make,                    -- In the Feature group (below) we are coding
   make_this_way,           -- each of these declared creation procedures.
   make_that_way,           -- We can have as many constructors as we need.
   make_another_way,
   a_name_other_than_make

feature {NONE} -- Initialization

   make
       -- This is a creation procedure or "Constructor".
    do
       -- Initialization code goes here ...
    end

   make_this_way
       -- Make this way, rather than a plain ole "make".
    do
       -- Initialization code goes here ...
    end

   make_that_way
       -- Create that way rather than this way (above).
    do
       -- Initialization code goes here ...
    end

   make_another_way
       -- And still another way to create MY_CLASS.
    do
       -- Initialization code goes here ...
    end

   a_name_other_than_make
       -- There is no requirement to use the word "make".
       -- The word "make" is just a naming convention.
    do
       -- Initialization code goes here ...
    end

end
