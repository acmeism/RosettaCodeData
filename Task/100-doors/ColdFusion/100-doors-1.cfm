	doorCount = 1;
	doorList = "";
	// create all doors and set all doors to open
	while (doorCount LTE 100) {
		doorList = ListAppend(doorList,"1");
		doorCount = doorCount + 1;
	}
	loopCount = 2;
	doorListLen = ListLen(doorList);
	while (loopCount LTE 100) {
		loopDoorListCount = 1;
		while (loopDoorListCount LTE 100) {
			testDoor = loopDoorListCount / loopCount;
			if (testDoor EQ Int(testDoor)) {
				checkOpen = ListGetAt(doorList,loopDoorListCount);
				if (checkOpen EQ 1) {
					doorList = ListSetAt(doorList,loopDoorListCount,"0");
				} else {
					doorList = ListSetAt(doorList,loopDoorListCount,"1");
				}
			}
			loopDoorListCount = loopDoorListCount + 1;
		}
		loopCount = loopCount + 1;
	}
