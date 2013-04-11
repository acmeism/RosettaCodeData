double testData[10] = {1,2,3,4,5,5,4,3,2,1};
int periods[2] = {3,5};
for(int i = 0; i < 2; ++i) {
	MovingAverage *ma = [[MovingAverage alloc] initWithPeriod:periods[i]];
	for(int j = 0; j < 10; ++j) {
		[ma add:testData[j]];
		NSLog(@"Next number = %f, SMA = %f", testData[j], [ma avg]);
	}
	[ma release];
	NSLog(@"\n");
}
