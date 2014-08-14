//

#import "Decrypt.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation Decrypt

- (BOOL) decryptFile: (NSString *) fileName withPassphrase: (NSString *) passphrase {
	NSString *decryptedFile = [self getRawFilePath: fileName];

	NSData *content = [self AES256Decrypt: [[NSFileManager defaultManager] contentsAtPath: fileName] WithKey: passphrase];
	if( content == nil || [content length] == 0 ){
		fprintf(stderr, "error: decrypt failed. wrong passphrase?\n");
		return NO;
	}

	if( [[NSFileManager defaultManager] createFileAtPath: decryptedFile contents: content attributes: nil] == YES ){
		return YES;
	}
	else{
		fprintf(stderr, "error: failed to save file: %s\n", [fileName UTF8String]);
		return NO;
	}
}

- (NSString *) getRawFilePath: (NSString *) file {
	NSString *decryptedFile = [[file stringByDeletingPathExtension] lastPathComponent];

	if( [decryptedFile isEqualToString: file] == YES ){
		return [NSString stringWithFormat: @"%@.raw", decryptedFile];
	}
	else{
		return decryptedFile;
	}
}

- (NSData *) AES256Decrypt: (NSData *) data WithKey: (NSString *) key {
	char keyPtr[kCCKeySizeAES256+1];
	bzero(keyPtr, sizeof(keyPtr));

	[key getCString:keyPtr maxLength: sizeof(keyPtr) encoding: NSUTF8StringEncoding];

	NSUInteger dataLength = [data length];
	size_t bufferSize = dataLength + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);

	size_t numBytesDecrypted = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
										  kCCOptionPKCS7Padding | kCCOptionECBMode,
										  keyPtr, kCCBlockSizeAES128,
										  NULL,
										  [data bytes], dataLength,
										  buffer, bufferSize,
										  &numBytesDecrypted);

	if (cryptStatus == kCCSuccess) {
		return [NSData dataWithBytesNoCopy: buffer length: numBytesDecrypted];
	}

	free(buffer);
	return nil;
}

@end
