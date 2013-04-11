- (float) prod:(NSMutableArray *)array
{
	int i, prod, value;
	prod = 0;
	value = 0;
	
	for (i = 0; i < [array count]; i++) {
		value = [[array objectAtIndex: i] intValue];
		prod *= value;
	}
	
	return suml;
}
