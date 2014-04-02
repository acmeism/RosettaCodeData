#import <CommonCrypto/CommonHMAC.h>

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
 NSString* key = @"secret";
 NSString* data = @"Message";

 const char *cKey = [key cStringUsingEncoding:NSASCIIStringEncoding];
 const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
 unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
 CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);

 NSMutableString* result = [NSMutableString stringWithCapacity:(CC_SHA256_DIGEST_LENGTH * 2)];
	
  for(CC_LONG i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
   [result appendFormat:@"%02x", cHMAC[i]];

  NSLog(@"Sha-256: %@", result);

}
