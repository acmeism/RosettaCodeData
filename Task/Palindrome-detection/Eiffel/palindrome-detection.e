	is_palindrome (a_string: STRING): BOOLEAN
			-- Is `a_string' a palindrome?
		require
			string_attached: a_string /= Void
		local
			l_index, l_count: INTEGER
		do
			from
				Result := True
				l_index := 1
				l_count := a_string.count
			until
				l_index >= l_count - l_index + 1 or not Result
			loop
				Result := (Result and a_string [l_index] = a_string [l_count - l_index + 1])
				l_index := l_index + 1
			end
		end
