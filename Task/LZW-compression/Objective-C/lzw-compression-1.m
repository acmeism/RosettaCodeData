#import <Foundation/Foundation.h>
#import <stdio.h>

@interface LZWCompressor : NSObject
{
  @private
    NSMutableArray *iostream;
    NSMutableDictionary *dict;
    NSUInteger codemark;
}

-(LZWCompressor *) init;
-(LZWCompressor *) initWithArray: (NSMutableArray *) stream;
-(BOOL) compressData: (NSData *) string;
-(void) setArray: (NSMutableArray *) stream;
-(NSArray *) getArray;
@end

@implementation LZWCompressor : NSObject

-(LZWCompressor *) init
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

-(LZWCompressor *) initWithArray: (NSMutableArray *) stream
{
   self = [self init];
   if ( self )
   {
      [self setArray: stream];
   }
   return self;
}

-(void) dealloc
{
   [dict release];
   [iostream release];
   [super dealloc];
}

-(void) setArray: (NSMutableArray *) stream
{
   iostream = [stream retain];
}

-(BOOL) compressData: (NSData *) string;
{
    NSUInteger i;
    unsigned char j;

    // prepare dict
    for(i=0; i < 256; i++)
    {
       j = i;
       NSData *s = [NSData dataWithBytes: &j length: 1];
       [dict setObject: [NSNumber numberWithUnsignedInt: i] forKey: s];
    }

    NSMutableData *w = [NSMutableData data];
    NSMutableData *wc = [NSMutableData data];

    for(i=0; i < [string length]; i++)
    {
       [wc setData: w];
       [wc appendData: [string subdataWithRange: NSMakeRange(i, 1)]];
       if ( [dict objectForKey: wc] != nil )
       {
          [w setData: wc];
       } else {
          [iostream addObject: [dict objectForKey: w]];
          [dict setObject: [NSNumber numberWithUnsignedInt: codemark] forKey: wc];
          codemark++;
          [w setData: [string subdataWithRange: NSMakeRange(i, 1)]];
       }
    }
    if ( [w length] != 0 )
    {
       [iostream addObject: [dict objectForKey: w]];
    }
    return YES;
}

-(NSArray *) getArray
{
  return iostream;
}

@end
