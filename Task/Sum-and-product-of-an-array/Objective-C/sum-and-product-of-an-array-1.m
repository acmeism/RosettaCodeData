- (float) sum:(NSMutableArray *)array
{
	int i, sum, value;
	sum = 0;
	value = 0;
	
	for (i = 0; i < [array count]; i++) {
		value = [[array objectAtIndex: i] intValue];
		sum += value;
	}
	
	return suml;
}
