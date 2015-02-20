class
	COMBINATIONS
create
	make
feature
	make(n, k:INTEGER)
		require
			n_positive: n>0
			k_positive: k>0
			k_smaller_equal: k<=n
		do
			create set.make
			set.extend ("")
			create sol.make
			sol:=solve(set,k,n-k)
			sol:= conv_sol(n, sol)
		ensure
			correct_num_of_sol: num_of_comb(n,k)= sol.count
		end
	set: LINKED_LIST[STRING]
	sol: LINKED_LIST[STRING]

	conv_sol(n: INTEGER; solution: LINKED_LIST[STRING]):LINKED_LIST[STRING]
	local
		i,j: INTEGER
		temp: STRING
	do
		create temp.make (n)
		from
			i:=1
		until
			i>solution.count
		loop
			from
				j:= 1
			until
				j> n
			loop
				if solution[i].at (j)= '1' then
					temp.append (j.out)
				end
				j:= j+1
			end
			solution[i].deep_copy( temp)
			temp.wipe_out
			i:= i+1
		end
		Result:= solution
	end

	solve(seta: LINKED_LIST[STRING];one,zero: INTEGER): LINKED_LIST[STRING]
		local
			new_P1,  new_P0: LINKED_LIST[STRING]
		do
			create new_P1.make
			create new_P0.make
			if  one > 0  then
				new_P1.deep_copy(seta)
				across new_P1 as P1  loop new_P1.item.append ("1")  end
			     new_P1:=solve(new_P1, one-1, zero)
		 	end
			if zero > 0 then
				new_P0.deep_copy(seta)
				across new_P0 as P0  loop new_P0.item.append ("0")  end
				new_P0:=solve(new_P0, one, zero-1)
			end
			if one=0 and zero= 0 then
				Result:= seta
			else
				create Result.make
				Result.fill (new_p0)
				Result.fill (new_p1)
			end
		end

	num_of_comb (n,k:INTEGER):INTEGER
	--- used for contracts
		local
			upper, lower, m, l: INTEGER
		do
			upper:= 1
			lower:= 1
			m:= n
			l:= k
			from
			until
				m<n-k+1
			loop
				upper:= m*upper
				lower:= l*lower
				m:= m-1
				l:= l-1
			end
			Result:= upper//lower
		end
end
