class
	APPLICATION

create
	make

feature

	fang_check (original, fang1, fang2: INTEGER_64): BOOLEAN
			-- Are 'fang1' and 'fang2' correct fangs of the 'original' number?
		require
			original_positive: original > 0
			fangs_positive: fang1 > 0 and fang2 > 0
		local
			original_length: INTEGER
			fang, ori: STRING
			sort_ori, sort_fang: SORTED_TWO_WAY_LIST [CHARACTER]
		do
			create sort_ori.make
			create sort_fang.make
			create ori.make_empty
			create fang.make_empty
			original_length := original.out.count // 2
			if fang1.out.count /= original_length or fang2.out.count /= (original_length) then
				Result := False
			elseif fang1.out.ends_with ("0") and fang2.out.ends_with ("0") then
				Result := False
			else
				across
					1 |..| original.out.count as c
				loop
					sort_ori.extend (original.out [c.item])
				end
				across
					sort_ori as o
				loop
					ori.extend (o.item)
				end
				across
					1 |..| fang1.out.count as c
				loop
					sort_fang.extend (fang1.out [c.item])
					sort_fang.extend (fang2.out [c.item])
				end
				across
					sort_fang as f
				loop
					fang.extend (f.item)
				end
				Result := fang.same_string (ori)
			end
		ensure
			fangs_right_length: Result implies original.out.count = fang1.out.count + fang2.out.count
		end

	make
                -- Uses fang_check to find vampire nubmers.
		local
			i, numbers: INTEGER
			fang1, fang2: INTEGER_64
			num: ARRAY [INTEGER_64]
			math: DOUBLE_MATH
		do
			create math
			from
				i := 1000
			until
				numbers > 25
			loop
				if i.out.count \\ 2 = 0 then
					from
						fang1 := 10
					until
						fang1 >= math.sqrt (i)
					loop
						if (i \\ fang1 = 0) then
							fang2 := i // fang1
							if i \\ 9 = (fang1 + fang2) \\ 9 then
								if fang1 * fang2 = i and fang1 <= fang2 and then fang_check (i, fang1, fang2) then
									numbers := numbers + 1
									io.put_string (i.out + ": " + fang1.out + " " + fang2.out)
									io.new_line
								end
							end
						end
						fang1 := fang1 + 1
					end
				end
				i := i + 1
			end
			num := <<16758243290880, 24959017348650, 14593825548650>>
			across
				num as n
			loop
				from
					fang1 := 1000000
				until
					fang1 >= math.sqrt (n.item) + 1
				loop
					if (n.item \\ fang1 = 0) then
						fang2 := (n.item // fang1)
						if fang1 * fang2 = n.item and fang1 <= fang2 and then fang_check (n.item, fang1, fang2) then
							io.put_string (n.item.out + ": " + fang1.out + " " + fang2.out + "%N")
						end
					end
					fang1 := fang1 + 1
				end
			end
		end

end
