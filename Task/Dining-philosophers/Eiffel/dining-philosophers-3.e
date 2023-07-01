class
    FORK

create
    make

feature -- Initialization

    make (left, right: INTEGER)
            -- Initialize between philosophers `left' and `right'.
        do
            id := left.out + "F" + right.out
        end

feature -- Access

    id: STRING
            -- Identification: `F' enclosed by adjacent philosopher id's.

feature -- Basic operations

    pick (philosopher: separate PHILOSOPHER)
            -- Report fork picked up.
        do
            print ("Fork " + id + " picked up by Philosopher " + philosopher.id.out + ".%N")
        end

    put (philosopher: separate PHILOSOPHER)
            -- Report fork put back.
        do
            print ("Fork " + id + " put back by Philosopher " + philosopher.id.out + ".%N")
        end

end -- class FORK
