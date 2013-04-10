note
	description: "A door with an address and an open or closed state."
	date: "07-AUG-2011"
	revision: "1.0"

class
	DOOR

create
	make

feature -- initialization

	make (addr: INTEGER; status: BOOLEAN)
			-- create door with address and status
		require
			valid_address: addr /= '%U'
			valid_status: status /= '%U'
		do
			address := addr
			open := status
		ensure
			address_set: address = addr
			status_set: open = status
		end

feature -- access

	address: INTEGER

	open: BOOLEAN assign set_open

feature -- mutators

	set_open (status: BOOLEAN)
		require
			valid_status: status /= '%U'
		do
			open := status
		ensure
			open_updated: open = status
		end

end
