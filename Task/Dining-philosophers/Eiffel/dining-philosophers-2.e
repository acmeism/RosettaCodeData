class
    PHILOSOPHER

create
    make

feature -- Initialization

    make (philosopher: INTEGER; left, right: separate FORK; rounds: INTEGER)
            -- Initialize with ID of `philosopher', forks `left' and `right', and for `rounds' times to eat.
        require
            valid_id: philosopher >= 1
            valid_times_to_eat: rounds >= 1
        do
            id := philosopher
            left_fork := left
            right_fork := right
            round_count := rounds
            report ("announced")
        ensure
            id_set: id = philosopher
            left_fork_set: left_fork = left
            right_fork_set: right_fork = right
            rounds_set: round_count = rounds
        end

feature -- Access

    id: INTEGER
            -- Philosopher's id.

feature -- Basic operations

    live
            -- Model philosopher's life.
        do
            from
                report ("joined")
                has_eaten_count := 0
            until
                has_eaten_count >= round_count
            loop
                think
                eat (left_fork, right_fork)
            end
            report ("done")
        end

    eat (left, right: separate FORK)
            -- Eat, having acquired `left' and `right' forks.
        do
                -- Take forks.
            report ("taking forks")
            left.pick (Current)
            right.pick (Current)
                -- Eat.
            report ("eating")
            delay (200)
                -- Put forks back.
            report ("putting forks back")
            left.put (Current)
            right.put (Current)
                -- Report statistics.
            has_eaten_count := has_eaten_count + 1
            report ("has eaten " + has_eaten_count.out + " times")
        end

    think
            -- Think ... for a short time.
        do
            report ("thinking")
            delay (400)
        end

feature {NONE} -- Output

    report (task: STRING)
            -- Report about execution of the specified `task'.
        do
            print ("Philosopher " + id.out + ": " + task + ".%N")
        end

feature {NONE} -- Timing

    delay (milliseconds: INTEGER_64)
            -- Delay execution by `milliseconds'.
        do
            (create {EXECUTION_ENVIRONMENT}).sleep (milliseconds * 1_000_000)
        end

feature {NONE} -- Status

    round_count: INTEGER
            -- Number of times philosopher should eat.

    has_eaten_count: INTEGER
            -- Number of times philosopher has eaten so far.

    left_fork: separate FORK
            -- Left fork used for eating.	

    right_fork: separate FORK
            -- Right fork used for eating.

invariant
    valid_id: id >= 1
    valid_round_count: round_count >= 1
    valid_has_eaten_count: has_eaten_count <= round_count

end -- class PHILOSOPHER
