#import <Foundation/Foundation.h>

// a fantasy two level hierarchy
@interface Animal : NSObject <NSCoding>
{
  NSString *animalName;
  int numberOfLegs;
}
- (id) initWithName: (NSString*)name andLegs: (NSInteger)legs;
- (void) dump;
// the following allows "(de)archiving" of the object
- (void) encodeWithCoder: (NSCoder*)coder;
- (id) initWithCoder: (NSCoder*)coder;
@end

@implementation Animal
- (id) initWithName: (NSString*)name andLegs: (NSInteger)legs
{
  if ((self = [super init])) {
    animalName = [name retain];
    numberOfLegs = legs;
  }
  return self;
}
- (void) dealloc
{
  [animalName release];
  [super dealloc];
}
- (void) dump
{
  NSLog(@"%@ has %d legs", animalName, numberOfLegs);
}
// ========
- (void) encodeWithCoder: (NSCoder*)coder
{
  [coder encodeObject: animalName forKey: @"Animal.name"];
  [coder encodeInt: numberOfLegs forKey: @"Animal.legs"];
}
- (id) initWithCoder: (NSCoder*)coder
{
  if ((self = [super init])) {
    animalName = [[coder decodeObjectForKey: @"Animal.name"] retain];
    numberOfLegs = [coder decodeIntForKey: @"Animal.legs"];
  }
  return self;
}
@end

@interface Mammal : Animal <NSCoding>
{
  BOOL hasFur;
  NSMutableArray *eatenList;
}
- (id) initWithName: (NSString*)name hasFur: (BOOL)fur;
- (void) addEatenThing: (NSString*)thing;
- (void) dump;
// for archiving / dearchiving:
- (void) encodeWithCoder: (NSCoder*)coder;
- (id) initWithCoder: (NSCoder*)coder;
@end

@implementation Mammal
- (id) init
{
  if ((self = [super init])) {
    hasFur = NO;
    eatenList = [[NSMutableArray alloc] initWithCapacity: 10];
  }
  return self;
}
- (id) initWithName: (NSString*)name hasFur: (BOOL)fur
{
  if ((self = [super initWithName: name andLegs: 4])) {
    hasFur = fur;
    eatenList = [[NSMutableArray alloc] initWithCapacity: 10];
  }
  return self;
}
- (void) addEatenThing: (NSString*)thing
{
  [eatenList addObject: thing];
}
- (void) dealloc
{
  [eatenList release];
  [super dealloc];
}
- (void) dump
{
  [super dump];
  NSLog(@"has fur? %@", (hasFur) ? @"yes" : @"no" );
  // fast enum not implemented yet in gcc 4.3, at least
  // without a patch that it seems to exist...
  NSEnumerator *en = [eatenList objectEnumerator];
  id element;
  NSLog(@"it has eaten %d things:", [eatenList count]);
  while( (element = [en nextObject]) != nil )
    NSLog(@"it has eaten a %@", element);
  NSLog(@"end of eaten things list");
}
// ========= de/archiving
- (void) encodeWithCoder: (NSCoder*)coder
{
  [super encodeWithCoder: coder];
  [coder encodeBool: numberOfLegs forKey: @"Mammal.hasFur"];
  [coder encodeObject: eatenList forKey: @"Mammal.eaten"];
}
- (id) initWithCoder: (NSCoder*)coder
{
  if ((self = [super initWithCoder: coder])) {
    hasFur = [coder decodeBoolForKey: @"Mammal.hasFur"];
    eatenList = [[coder decodeObjectForKey: @"Mammal.eaten"] retain];
  }
  return self;
}
@end


int main()
{
  Mammal *aMammal;
  Animal *anAnimal;
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  // let us create a fantasy animal
  anAnimal = [[Animal alloc]
	       initWithName: @"Eptohippos"
	       andLegs: 7
	      ];
  // for some reason an Eptohippos is not an horse with 7 legs,
  // and it is not a mammal, of course...

  // let us create a fantasy mammal (which is an animal too)
  aMammal = [[Mammal alloc]
	      initWithName: @"Mammaluc"
	      hasFur: YES
	     ];
  // let us add some eaten stuff...
  [aMammal addEatenThing: @"lamb"];
  [aMammal addEatenThing: @"table"];
  [aMammal addEatenThing: @"web page"];

  // dump anAnimal
  NSLog(@"----- original Animal -----");
  [anAnimal dump];

  // dump aMammal...
  NSLog(@"----- original Mammal -----");
  [aMammal dump];

  // now let us store the objects...
  NSMutableData *data = [[NSMutableData alloc] init];
  NSKeyedArchiver *arch = [[NSKeyedArchiver alloc]
			    initForWritingWithMutableData: data];
  [arch encodeObject: anAnimal forKey: @"Eptohippos"];
  [arch encodeObject: aMammal forKey: @"Mammaluc"];
  [anAnimal release];
  [aMammal release];
  [arch finishEncoding];
  [arch release];
  [data writeToFile: @"objects.dat" atomically: YES];
  [data release];

  // now we want to retrieve the saved objects...
  NSData *ldata = [[NSData alloc]
		     initWithContentsOfFile: @"objects.dat"];
  NSKeyedUnarchived *darch = [[NSKeyedUnarchiver alloc]
	                       initForReadingWithData: ldata];
  Animal *archivedAnimal = [darch decodeObjectForKey: @"Eptohippos"];
  Mammal *archivedMammal = [darch decodeObjectForKey: @"Mammaluc"];
  [darch finishDecoding];
  [ldata release];
  [darch release];

  // now let's dump/print the objects...
  NSLog(@"\n");
  NSLog(@"----- the archived Animal -----");
  [archivedAnimal dump];
  NSLog(@"----- the archived Mammal -----");
  [archivedMammal dump];

  [pool release];
  return EXIT_SUCCESS;
}
