#import <Cocoa/Cocoa.h>
#import <CommonCrypto/CommonDigest.h>


int main(int argc, char ** argv) {
    NSString * msg = @"Rosetta code";
    unsigned char buf[CC_SHA256_DIGEST_LENGTH];
    const char * rc = [msg cStringUsingEncoding:NSASCIIStringEncoding];
    if (! CC_SHA256(rc, strlen(rc), buf)) {
        NSLog(@"Failure...");
        return -1;
    }
    NSMutableString * res = [NSMutableString stringWithCapacity:(CC_SHA256_DIGEST_LENGTH * 2)];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; ++i) {
        [res appendFormat:@"%02x", buf[i]];
    }
    NSLog(@"Output: %@", res);
    return 0;
}
