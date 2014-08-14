//

#import <Foundation/Foundation.h>
#import "Decrypt.h"

int usage(){
	fprintf(stderr, "usage: voicedecode <passphrase> <encrypted file>\n");
	return 255;
}

int main(int argc, const char * argv[]){
	@autoreleasepool {
		if( argc != 3 )
			return usage();

		NSString *passPhrase = [NSString stringWithUTF8String: argv[1]];
		if( [passPhrase isEqualToString: @""] ){
			return usage();
		}

		NSString *fileName = [NSString stringWithUTF8String: argv[2]];
		if( [fileName isEqualToString: @""] ){
			return usage();
		}
		else if( [[NSFileManager defaultManager] fileExistsAtPath: fileName] == NO ){
			fprintf(stderr, "error: file %s doesn't exist.\n", [fileName UTF8String]);
			return 1;
		}

		Decrypt *decrypt = Decrypt.new;
		if( [decrypt decryptFile: fileName withPassphrase: passPhrase] == YES ){
			return 0;
		}
		else{
			return 1;
		}
	}
}
