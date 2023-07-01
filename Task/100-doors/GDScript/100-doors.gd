func Doors(door_count:int) -> void :
  var doors : Array
  doors.resize(door_count)

  # Note : Initialization is not necessarily mandatory (by default values are false)
  # Intentionally left here
  for i in door_count :
    doors[i] = false

  # do visits
  for i in door_count :
    for j in range(i,door_count,i+1) :
      doors[j] = not doors[j]
  	
  # print results
  var results : String = ""
  for i in door_count :
    results += str(i+1) + " " if doors[i] else ""
  print("Doors open : %s" % [results] )

# calling the function from the _ready function
func _ready() -> void :
  Doors(100)
