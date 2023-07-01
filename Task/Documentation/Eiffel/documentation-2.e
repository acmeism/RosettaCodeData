note
	description: "Objects that model Times of Day: 00:00:00 - 23:59:59"
	author: "Eiffel Software Construction Students"

class interface
    TIME_OF_DAY

create
    make

feature -- Initialization

    make
            -- Initialize to 00:00:00
        ensure
            initialized: hour = 0 and minute = 0 and second = 0
	
feature -- Access

    hour: INTEGER_32
            -- Hour expressed as 24-hour value

    minute: INTEGER_32
            -- Minutes past the hour

    second: INTEGER_32
            -- Seconds past the minute
	
feature -- Element change

    set_hour (h: INTEGER_32)
            -- Set the hour from `h'
        require
            argument_hour_valid: 0 <= h and h <= 23
        ensure
            hour_set: hour = h
            minute_unchanged: minute = old minute
            second_unchanged: second = old second

    set_minute (m: INTEGER_32)
            -- Set the minute from `m'
        require
            argument_minute_valid: 0 <= m and m <= 59
        ensure
            minute_set: minute = m
            hour_unchanged: hour = old hour
            second_unchanged: second = old second

    set_second (s: INTEGER_32)
            -- Set the second from `s'
        require
            argument_second_valid: 0 <= s and s <= 59
        ensure
            second_set: second = s
            hour_unchanged: hour = old hour
            minute_unchanged: minute = old minute
	
invariant
    hour_valid: 0 <= hour and hour <= 23
    minute_valid: 0 <= minute and minute <= 59
    second_valid: 0 <= second and second <= 59

end -- class TIME_OF_DAY
