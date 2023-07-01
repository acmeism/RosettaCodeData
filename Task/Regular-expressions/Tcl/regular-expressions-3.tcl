set theString = "I am   a   string"
puts [regsub -- { +a +} $theString { another }]
