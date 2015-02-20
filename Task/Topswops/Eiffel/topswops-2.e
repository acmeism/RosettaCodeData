class
	APPLICATION
inherit
	ARGUMENTS
create
    make
feature
	make
	do
	create ts.make (10)
	across ts.solution as t  loop io.put_string (t.item.out+"%N")  end
	end
	ts: TOPSWOPS
end
