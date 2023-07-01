Camera := Object clone
Camera click := method("Taking snapshot" println)

MobilePhone := Object clone
MobilePhone call := method("Calling home" println)

CameraPhone := Camera clone
CameraPhone appendProto(MobilePhone)

myPhone := CameraPhone clone
myPhone click	// --> "Taking snapshot"
myPhone call	// --> "Calling home"
