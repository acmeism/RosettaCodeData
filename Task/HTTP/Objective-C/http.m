#import <Foundation/Foundation.h>

int main (int argc, const char * argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSError        *error;
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://rosettacode.org"]]
                                            returningResponse:&response
                                                        error:&error];

    NSLog(@"%@", [[[NSString alloc] initWithData:data
                                          encoding:NSUTF8StringEncoding] autorelease]);

    [pool drain];
    return 0;
}
