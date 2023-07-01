#import <CommonCrypto/CommonDigest.h>

NSString *myString = @"The quick brown fox jumped over the lazy dog's back";
NSData *data = [myString dataUsingEncoding:NSUTF8StringEncoding]; // or another encoding of your choosing
unsigned char digest[CC_MD5_DIGEST_LENGTH];
if (CC_MD5([data bytes], [data length], digest)) {
    NSMutableString *hex = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hex appendFormat: @"%02x", (int)(digest[i])];
    }
    NSLog(@"%@", hex);
}
