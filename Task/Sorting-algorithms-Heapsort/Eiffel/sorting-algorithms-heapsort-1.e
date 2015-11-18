class
	HEAPSORT

feature

	sort_array (ar: ARRAY [INTEGER])
			-- Sorts array 'ar' in ascending order.
		require
			not_empty: ar.count > 0
		local
			i, j, r, l, m, n: INTEGER
			sorted: BOOLEAN
		do
			n := ar.count
			j := 0
			i := 0
			m := 0
			r := n
			l := (n // 2)+1
			from
			until
				sorted
			loop
				if l > 1 then
					l := l - 1
					m := ar[l]
				else
					m := ar[r]
					ar[r] := ar[1]
					r := r - 1
					if r = 1 then
						ar[1]:=m
						sorted := True
					end
				end
				if not sorted then
					i := l
					j := l * 2
					from
					until
						j > r
					loop
						if (j < r) and (ar[j] < ar[j + 1]) then
							j := j + 1
						end
						if m < ar[j] then
							ar[i]:= ar[j]
							i := j
							j := j + i
						else
							j := r + 1
						end
					end
					ar[i]:= m
				end
			end
			ensure
				sorted: is_sorted(ar)
		end

feature{NONE}

	is_sorted (ar: ARRAY [INTEGER]): BOOLEAN
			--- Is 'ar' sorted in ascending order?
		local
			i: INTEGER
		do
			Result := True
			from
				i := ar.lower
			until
				i >= ar.upper
			loop
				if ar [i] > ar [i + 1] then
					Result := False
				end
				i := i + 1
			end
		end

end
