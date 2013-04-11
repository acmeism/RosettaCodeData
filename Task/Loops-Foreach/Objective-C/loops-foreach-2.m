NSArray *collect;
//...
NSEnumerator *enm = [collect objectEnumerator];
id i;
while( (i = [enm nextObject]) ) {
  // do something with object i
}
