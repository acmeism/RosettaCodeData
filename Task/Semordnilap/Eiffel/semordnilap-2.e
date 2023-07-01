class
	APPLICATION

create
	make

feature

	make
		local
			test: ARRAY [STRING]
			s: STRING
		do
			create se.make
			test := se.solution
			create sort.sort (test)
			across
				test.subarray (1, 5) as t
			loop
				s := t.item
				io.put_string (t.item + "%T")
				s.mirror
				io.put_string (s)
				io.new_line
			end
			io.put_string ("Total number of semordnilaps: ")
			io.put_integer (test.count)
		end

	se: SEMORDNILAP

	sort: MERGE_SORT [STRING]

end
