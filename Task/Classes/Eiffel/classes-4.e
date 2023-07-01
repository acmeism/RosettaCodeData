class MY_CLASS

create
   make

feature {NONE} -- Initialization

   make
       -- This is a creation procedure or "Constructor".
    do
       create my_string.make_empty
    end

feature -- Access (Properties)

   my_string: STRING
         -- This is a comment about `my_string', which is a "Property".

   my_integer: INTEGER
         -- Unlike `my_string' (above), the INTEGER type is an "Expanded Type".
         -- This means INTEGER objects know how to self-initialize.

   my_date: DATE
         -- This attribute (or "Property") will need to be initialized.
         -- One way to do that is to make a self-initializing attribute, thus ...
      attribute
         create Result.make_now
      end

feature -- Basic Operations (Methods)

   do_something
         -- Loop over and print the numbers 1 to 100 to the console.
     do
        across 1 |..| 100 as i loop print (i.out) end
     end

   do_something_else
         -- Set a and b and print the result.
     local
        a, b, c: INTEGER
     do
        a := 1
        b := 2
        c := a + b
     end

end
