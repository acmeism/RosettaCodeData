#import <Foundation/Foundation.h>

@interface MovingAverage : NSObject {
	unsigned int period;
	NSMutableArray *window;
	double sum;
}
@end

@implementation MovingAverage

// init with default period
- (id)init {
	self = [super init];
    if(self) {
		period = 10;
		window = [[NSMutableArray alloc] init];
		sum = 0.0;
	}
	return self;
}

// init with specified period
- (id)initWithPeriod:(unsigned int)thePeriod {
	self = [super init];
    if(self) {
		period = thePeriod;
		window = [[NSMutableArray alloc] init];
		sum = 0.0;
	}
	return self;
}

// clear
- (void)dealloc {
	[window release];
	[super dealloc];
}

// add a new number to the window
- (void)add:(double)val {
	sum += val;
	[window addObject:[NSNumber numberWithDouble:val]];
	if([window count] > period) {
		NSNumber *n = [window objectAtIndex:0];
		sum -= [n doubleValue];
		[window removeObjectAtIndex:0];
	}
}

// get the average value
- (double)avg {
	if([window count] == 0) {
		return 0; // technically the average is undefined
	}
	return sum / [window count];
}

// set the period, resizes current window
- (void)setPeriod:(unsigned int)thePeriod {
	// make smaller?
	if(thePeriod < [window count]) {
		for(int i = 0; i < thePeriod; ++i) {
			NSNumber *n = [window objectAtIndex:0];
			sum -= [n doubleValue];
			[window removeObjectAtIndex:0];
		}
	}
	period = thePeriod;
}

// get the period (window size)
- (unsigned int)period {
	return period;
}

// clear the window and current sum
- (void)clear {
	[window removeAllObjects];
	sum = 0;
}

@end
