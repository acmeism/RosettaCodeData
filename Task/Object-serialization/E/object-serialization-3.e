def objs := [makeEvent(timer.now()),
             makeArrival(timer.now(), "Smith", 7)]

stdout.println(objs)
<file:objects.dat>.setBytes(surgeon.serialize(objs))
stdout.println(surgeon.unserialize(<file:objects.dat>.getBytes()))
