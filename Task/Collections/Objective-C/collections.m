#import <Foundation/Foundation.h>

void show_collection(id coll)
{
  id el;
  NSEnumerator *en;
  if ( [coll respondsToSelector: @selector(keyEnumerator)] ) {
    en = [coll keyEnumerator];
  } else {
    en = [coll objectEnumerator];
  }
  while( (el = [en nextObject]) != nil)
  {
    if ( [coll respondsToSelector: @selector(countForObject:)] ) {
      NSLog(@"%@ appears %d times", el, [coll countForObject: el]);
    } else if ( [coll isKindOfClass: [NSDictionary class]] ) {
      NSLog(@"%@ -> %@", el, [coll valueForKey: el]);
    } else {
      NSLog(@"%@", el);
    }
  }
  printf("\n");
}

int main()
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  // create an empty set
  NSMutableSet *set = [[NSMutableSet alloc] init];
  // populate it
  [set addObject: @"one"];
  [set addObject: [NSNumber numberWithInt: 10]];
  [set addObjectsFromArray: [NSArray arrayWithObjects: @"one",
				     [NSNumber numberWithInt: 20],
				     [NSNumber numberWithInt: 10],
				     @"two", nil] ];
  // let's show it
  show_collection(set);

  // create an empty counted set (a bag)
  NSCountedSet *cset = [[NSCountedSet alloc] init];
  // populate it
  [cset addObject: @"one"];
  [cset addObject: @"one"];
  [cset addObject: @"two"];
  // show it
  show_collection(cset);

  // create a dictionary
  NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
  // populate it
  [dict setValue: [NSNumber numberWithInt: 4] forKey: @"four"];
  [dict setValue: [NSNumber numberWithInt: 8] forKey: @"eight"];
  // show it
  show_collection(dict);

  [pool release];
  return EXIT_SUCCESS;
}
