software {
	var doors = len(100)
	
	for pass over [1, 100]
		var door = pass - 1
		loop door < len(doors) {
			doors[door] = doors[door]/0
			door += pass
		}
	end
	
	for door,isopen in doors
		if isopen
			print("Door ",door+1,": open")
		end
	end
	print("All other doors are closed")
}
