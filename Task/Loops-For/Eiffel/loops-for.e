class APPLICATION
create make
feature
    make local
        i, j: INTEGER
    do  from i := 1
    	until i > 5 loop
    	    from j := 1
    	    until j > i loop
    	        print("*")
    	        j := j + 1
    	    end
    	    print("%N")
    	    i := i + 1
    	end
    end
end
