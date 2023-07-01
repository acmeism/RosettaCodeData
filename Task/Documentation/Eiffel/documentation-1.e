note
	description: "Objects that model Times of Day: 00:00:00 - 23:59:59"
	author: "Eiffel Software Construction Students"

class
    TIME_OF_DAY
create
    make

feature -- Initialization

    make
            -- Initialize to 00:00:00
        do
            hour := 0
            minute := 0
            second := 0
        ensure
            initialized: hour   = 0 and
                    minute = 0 and
                    second = 0
        end

feature -- Access

    hour:   INTEGER
            -- Hour expressed as 24-hour value

    minute: INTEGER
            -- Minutes past the hour

    second: INTEGER
            -- Seconds past the minute

feature -- Element change

    set_hour (h: INTEGER)
            -- Set the hour from `h'
        require
            argument_hour_valid: 0 <= h and h <= 23
        do
            hour := h
        ensure
            hour_set: hour = h
            minute_unchanged: minute = old minute
            second_unchanged: second = old second
        end

    set_minute (m: INTEGER)
            -- Set the minute from `m'
        require
            argument_minute_valid: 0 <= m and m <= 59
        do
            minute := m
        ensure
            minute_set: minute = m
            hour_unchanged: hour = old hour
            second_unchanged: second = old second
        end

    set_second (s: INTEGER)
            -- Set the second from `s'
        require
            argument_second_valid: 0 <= s and s <= 59
        do
            second := s
        ensure
            second_set: second = s
            hour_unchanged: hour = old hour
            minute_unchanged: minute = old minute
        end

feature {NONE} -- Implementation

    protected_routine
            -- A protected routine (not available to client classes)
            -- Will not be present in documentation (Contract) view
        do

        end

invariant

    hour_valid:   0 <= hour   and hour   <= 23
    minute_valid: 0 <= minute and minute <= 59
    second_valid: 0 <= second and second <= 59

end -- class TIME_OF_DAY
