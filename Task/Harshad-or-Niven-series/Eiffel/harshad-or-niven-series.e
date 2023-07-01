note
	description : "project application root class"
	date        : "$October 10, 2014$"
	revision    : "$Revision$"

class
	NIVEN_SERIES

create
	make

feature
	make
		local
			number : INTEGER
			count : INTEGER
			last : BOOLEAN
		do
			number := 1

			from
				number := 1
				last := false

			until
				last = true

			loop

				if
					(number \\ sum_of_digits(number) = 0)
				then
					count := count + 1

					if
						(count <= 20 )
					then
						print("%N")
						print(number)
					end

					if
						(number > 1000)
					then
						print("%N")
						print(number)
						last := true
					end
				end

				 number := number + 1
			end
		end

	sum_of_digits(no:INTEGER):INTEGER

		local
			sum : INTEGER
			num : INTEGER
		do
			sum := 0

			from
				num := no

			until
				num = 0

			loop
				sum := sum + num \\ 10
				num := num // 10
			end

			Result := sum
		end
end
