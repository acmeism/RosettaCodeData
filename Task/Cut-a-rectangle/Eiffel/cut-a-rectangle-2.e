class
	GRID

create
	make

feature {NONE}

	n: INTEGER

	m: INTEGER

feature

	print_solution
	                -- Prints solution to cut a rectangle.
		do
			calculate_possibilities
			io.put_string ("Rectangle " + n.out + " x " + m.out + ": " + count.out + " possibilities%N")
		end

	count: INTEGER
			-- Number of solutions

	make (a_n: INTEGER; a_m: INTEGER)
	                -- Initialize Problem with 'a_n' and 'a_m'.
		require
			a_n > 0
			a_m > 0
		do
			n := a_n
			m := a_m
			count := 0
		end

	calculate_possibilities
	                -- Select all possible starting points.
		local
			i: INTEGER
		do
			if (n = 1 or m = 1) then
				count := 1
			end

			from
				i := 0
			until
				i > n or (n = 1 or m = 1)
			loop
				solve (create {POINT}.make_with_values (i, 0), create {POINT}.make_with_values (n - i, m), create {LINKED_LIST [POINT]}.make, create {LINKED_LIST [POINT]}.make)
				i := i + 1
			variant
				n - i + 1
			end
			from
				i := 0
			until
				i > m or (n = 1 or m = 1)
			loop
				solve (create {POINT}.make_with_values (n, i), create {POINT}.make_with_values (0, m - i), create {LINKED_LIST [POINT]}.make, create {LINKED_LIST [POINT]}.make)
				i := i + 1
			variant
				m - i + 1
			end
		end

feature {NONE}

	solve (p, q: POINT; visited_p, visited_q: LINKED_LIST [POINT])
	                -- Recursive solution of cut a rectangle.
		local
			possible_next: LINKED_LIST [POINT]
			next: LINKED_LIST [POINT]
			opposite: POINT
		do
			if p.negative or q.negative then

			elseif p.same (q) then
				add_solution
			else
				possible_next := get_possible_next (p)
				create next.make
				across
					possible_next as x
				loop
					if x.item.x >= n or x.item.y >= m then
							-- Next point cannot be on the border. Do nothing.

					elseif x.item.same (q) then
						add_solution
					elseif not contains (x.item, visited_p) and not contains (x.item, visited_q) then
						next.extend (x.item)
					end
				end

				across
					next as x
				loop
						-- Move in one direction
						-- Calculate the opposite end of the cut by moving into the opposite direction (compared to p -> x)
					create opposite.make_with_values (q.x - (x.item.x - p.x), q.y - (x.item.y - p.y))

					visited_p.extend (p)
					visited_q.extend (q)

					solve (x.item, opposite, visited_p, visited_q)

						-- Remove last point again
					visited_p.finish
					visited_p.remove

					visited_q.finish
					visited_q.remove
				end
			end
		end

	get_possible_next (p: POINT): LINKED_LIST [POINT]
			-- Four possible next points.
		local
			q: POINT
		do
			create Result.make

				--up
			create q.make_with_values (p.x + 1, p.y)
			if q.valid and q.x <= n and q.y <= m then
				Result.extend (q);
			end

				--down
			create q.make_with_values (p.x - 1, p.y)
			if q.valid and q.x <= n and q.y <= m then
				Result.extend (q)
			end

				--left
			create q.make_with_values (p.x, p.y - 1)
			if q.valid and q.x <= n and q.y <= m then
				Result.extend (q)
			end

				--right
			create q.make_with_values (p.x, p.y + 1)
			if q.valid and q.x <= n and q.y <= m then
				Result.extend (q)
			end
		end

	add_solution
			-- Increment count.
		do
			count := count + 1
		end

	contains (p: POINT; set: LINKED_LIST [POINT]): BOOLEAN
			-- Does set contain 'p'?
		do
			set.compare_objects
			Result := set.has (p)
		end

end
