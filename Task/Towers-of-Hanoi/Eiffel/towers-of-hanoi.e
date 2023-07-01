class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
		do
			move (4, "A", "B", "C")
		end

feature -- Towers of Hanoi

	move (n: INTEGER; frm, to, via: STRING)
		require
			n > 0
	    do
			if n = 1 then
    			print ("Move disk from pole " + frm + " to pole " + to + "%N")
    		else
    			move (n - 1, frm, via, to)
    			move (1, frm, to, via)
    			move (n - 1, via, to, frm)
	        end
	    end
end
