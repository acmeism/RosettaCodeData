#import <Foundation/Foundation.h>
#import <stdio.h>

@interface LZWCompressor : NSObject
{
  @private
    NSMutableArray *iostream;
    NSMutableDictionary *dict;
    NSUInteger codemark;
}

-(instancetype) init;
-(instancetype) initWithArray: (NSMutableArray *) stream;
-(BOOL) compressData: (NSData *) string;
-(void) setArray: (NSMutableArray *) stream;
-(NSArray *) getArray;
@end

@implementation LZWCompressor : NSObject

-(instancetype) init
{
   self = [super init];
   if ( self )
   {
      iostream = nil;
      codemark = 256;
      dict = [[NSMutableDictionary alloc] initWithCapacity: 512];
   }
   return self;
}

-(instancetype) initWithArray: (NSMutableArray *) stream
{
   self = [self init];
   if ( self )
   {
      [self setArray: stream];
   }
   return self;
}

-(void) setArray: (NSMutableArray *) stream
{
   iostream = stream;
}

-(BOOL) compressData: (NSData *) string;
{
    // prepare dict
    for(NSUInteger i=0; i < 256; i++)
    {
       unsigned char j = i;
       NSData *s = [NSData dataWithBytes: &j length: 1];
       dict[s] = @(i);
    }

    NSData *w = [NSData data];

    for(NSUInteger i=0; i < [string length]; i++)
    {
       NSMutableData *wc = [NSMutableData dataWithData: w];
       [wc appendData: [string subdataWithRange: NSMakeRange(i, 1)]];
       if ( dict[wc] != nil )
       {
          w = wc;
       } else {
          [iostream addObject: dict[w]];
          dict[wc] = @(codemark);
          codemark++;
          w = [string subdataWithRange: NSMakeRange(i, 1)];
       }
    }
    if ( [w length] != 0 )
    {
       [iostream addObject: dict[w]];
    }
    return YES;
}

-(NSArray *) getArray
{
  return iostream;
}

@end
