class
	ACKERMAN_EXAMPLE

feature -- Basic Operations

	ackerman (m, n: NATURAL): NATURAL
			-- Recursively compute the n-th term of a series.
		require
			non_negative_m: m >= 0
			non_negative_n: n >= 0
		do
			if m = 0 then
				Result := n + 1
			elseif m > 0 and n = 0 then
				Result := ackerman (m - 1, 1)
			elseif m > 0 and n > 0 then
				Result := ackerman (m - 1, ackerman (m, n - 1))
			else
				check invalid_arg_state: False end
			end
		end

end
