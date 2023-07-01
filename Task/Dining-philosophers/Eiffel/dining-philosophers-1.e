class
    DINING_PHILOSOPHERS

create
    make

feature -- Initialization

    make
            -- Create philosophers and forks.
        local
            first_fork: separate FORK
            left_fork: separate FORK
            right_fork: separate FORK
            philosopher: separate PHILOSOPHER
            i: INTEGER
        do
            print ("Dining Philosophers%N" + philosopher_count.out + " philosophers, " + round_count.out + " rounds%N%N")
            create philosophers.make
            from
                i := 1
                create first_fork.make (philosopher_count, 1)
                left_fork := first_fork
            until
                i > philosopher_count
            loop
                if i < philosopher_count then
                    create right_fork.make (i, i + 1)
                else
                    right_fork := first_fork
                end
                create philosopher.make (i, left_fork, right_fork, round_count)
                philosophers.extend (philosopher)
                left_fork := right_fork
                i := i + 1
            end
            philosophers.do_all (agent launch_philosopher)
            print ("Make Done!%N")
        end

feature {NONE} -- Implementation

    philosopher_count: INTEGER = 5
            -- Number of philosophers.

    round_count: INTEGER = 30
            -- Number of times each philosopher should eat.

    philosophers: LINKED_LIST [separate PHILOSOPHER]
            -- List of philosophers.

    launch_philosopher (a_philosopher: separate PHILOSOPHER)
            -- Launch a_philosopher.
        do
            a_philosopher.live
        end

end -- class DINING_PHILOSOPHERS
