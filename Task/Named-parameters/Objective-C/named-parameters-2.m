@implementation Demo

- (double) hypotenuseOfX: (double)x andY: (double)y {
    return hypot(x,y);
}
- (double) hypotenuseOfX: (double)x andY: (double)y andZ: (double)z {
    return hypot(hypot(x, y), z);
}

@end
