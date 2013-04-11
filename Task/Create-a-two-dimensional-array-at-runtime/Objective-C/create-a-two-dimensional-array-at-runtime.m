#import <Foundation/Foundation.h>

int main()
{
  int num1, num2, i, j;
  NSMutableArray *arr;

  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  scanf("%d %d", &num1, &num2);

  NSLog(@"%d %d", num1, num2);

  arr = [NSMutableArray arrayWithCapacity: (num1*num2)];
  // initialize it with 0s
  for(i=0; i < (num1*num2); i++) [arr addObject: [NSNumber numberWithInt: 0]];

  // replace 0s with something more interesting
  for(i=0; i < num1; i++) {
    for(j=0; j < num2; j++) {
      [arr replaceObjectAtIndex: (i*num2+j) withObject: [NSNumber numberWithInt: (i*j)]];
    }
  }

  // access a value: i*num2+j, where i,j are the indexes for the bidimensional array
  NSLog(@"%@", [arr objectAtIndex: (1*num2+3)]);
  [pool release];
  return 0;
}
