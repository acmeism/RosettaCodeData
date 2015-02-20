class
	APPLICATION
inherit
	ARGUMENTS
create
    make
feature
	make
	do
	create se.make
	across se.solution.subarray (27, 32)as s loop io.put_string (s.item.out+"%T"); s.item.mirror; io.put_string(s.item.out+"%N")  end
	io.put_string ("There are "+se.solution.count.out+" pairs.")
	end

	se: SEMORDNILAP
end
