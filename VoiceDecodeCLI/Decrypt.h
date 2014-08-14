//

#import <Foundation/Foundation.h>

@interface Decrypt : NSObject

- (BOOL) decryptFile: (NSString *) file withPassphrase: (NSString *) passphrase;

@end
