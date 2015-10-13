class
	ITEM

create
	make, make_from_other

feature

	name: STRING

	weight: INTEGER

	value: INTEGER

	make_from_other (other: ITEM)
			-- Item with name, weight and value set to 'other's name, weight and value.
		do
			name := other.name
			weight := other.weight
			value := other.value
		end

	make (a_name: String; a_weight, a_value: INTEGER)
			-- Item with name, weight and value set to 'a_name', 'a_weight' and 'a_value'.
		require
			a_name /= Void
			a_weight >= 0
			a_value >= 0
		do
			name := a_name
			weight := a_weight
			value := a_value
		end

end
