	doorCount = 1;
	doorList = "";
	loopCount = 1;
	while (loopCount LTE 100) {
		if (Sqr(loopCount) NEQ Int(Sqr(loopCount))) {
			doorList = ListAppend(doorList,0);
		} else {
			doorList = ListAppend(doorList,1);
		}
		loopCount = loopCount + 1;
	}
