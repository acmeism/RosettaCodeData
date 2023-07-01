class
	APPLICATION
inherit
	ARGUMENTS
create
	make

feature {NONE} -- Initialization

	make
		local
			i: INTEGER
			s: detachable STRING
		do
			if i = Void then
				print("i = Void")
			end
			if s = Void then
				print("s = Void")
			end
		end
end
