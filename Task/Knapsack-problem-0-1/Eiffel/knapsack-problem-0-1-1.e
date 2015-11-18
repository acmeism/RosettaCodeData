class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
		local
			knapsack: KNAPSACKZEROONE
		do
			create knapsack.make (400)
			knapsack.add_item (create {ITEM}.make ("", 0, 0))
			knapsack.add_item (create {ITEM}.make ("map", 9, 150))
			knapsack.add_item (create {ITEM}.make ("compass", 13, 35))
			knapsack.add_item (create {ITEM}.make ("water", 153, 200))
			knapsack.add_item (create {ITEM}.make ("sandwich", 50, 160))
			knapsack.add_item (create {ITEM}.make ("glucose", 15, 60))
			knapsack.add_item (create {ITEM}.make ("tin", 68, 45))
			knapsack.add_item (create {ITEM}.make ("banana", 27, 60))
			knapsack.add_item (create {ITEM}.make ("apple", 39, 40))
			knapsack.add_item (create {ITEM}.make ("cheese", 23, 30))
			knapsack.add_item (create {ITEM}.make ("beer", 52, 10))
			knapsack.add_item (create {ITEM}.make ("suntan cream", 11, 70))
			knapsack.add_item (create {ITEM}.make ("camera", 32, 30))
			knapsack.add_item (create {ITEM}.make ("T-shirt", 24, 15))
			knapsack.add_item (create {ITEM}.make ("trousers", 48, 10))
			knapsack.add_item (create {ITEM}.make ("umbrella, ella ella", 73, 40))
			knapsack.add_item (create {ITEM}.make ("waterproof trousers", 42, 70))
			knapsack.add_item (create {ITEM}.make ("waterproof overclothes", 43, 75))
			knapsack.add_item (create {ITEM}.make ("note-case", 22, 80))
			knapsack.add_item (create {ITEM}.make ("sunglasses", 7, 20))
			knapsack.add_item (create {ITEM}.make ("towel", 18, 12))
			knapsack.add_item (create {ITEM}.make ("socks", 4, 50))
			knapsack.add_item (create {ITEM}.make ("book", 30, 10))
			knapsack.compute_solution
		end

end
