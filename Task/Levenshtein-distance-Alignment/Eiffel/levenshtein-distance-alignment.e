distance (source, target: STRING): INTEGER
		-- Minimum number of operations to turn `source' into `target'.
	local
		l_distance: ARRAY2 [INTEGER]
		del, ins, subst: INTEGER
	do
		create l_distance.make (source.count, target.count)
		⟳ ic:(1 |..| source.count) ¦ l_distance [ic, 1] := ic - 1 ⟲
		⟳ ij:(1 |..| target.count) ¦ l_distance [1, ij] := ij - 1 ⟲

		⟳ ic:(2 |..| source.count) ¦
			⟳ jc:(2 |..| target.count) ¦
				if source [ic] = target [jc] then			-- same char
					l_distance [ic, jc] := l_distance [ic - 1, jc - 1]
				else							-- diff char
					del := l_distance [ic - 1, jc]			-- delete?
					ins := l_distance [ic, jc - 1]			-- insert?
					subst := l_distance [ic - 1, jc -1]		-- substitute/swap?
					l_distance [ic, jc] := del.min (ins.min (subst)) + 1
				end
			⟲
		⟲
		Result:= l_distance [source.count, target.count]
	end
