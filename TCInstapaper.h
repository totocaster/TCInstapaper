#import <Foundation/Foundation.h>

@class TCInstapaper;

@protocol TCInstapaperDelegate <NSObject>
- (void)instapaper:(TCInstapaper *)instapaper didDidFinishRequestWithCode:(NSUInteger)code;
@end

@interface TCInstapaper : NSObject {
	NSString *_username;
	NSString *_password;
	
	BOOL isAuthenticated;
	BOOL secure;
	
	id<TCInstapaperDelegate> delegate;
	
@private
	
	NSURLConnection *_connection;
	
}

@property (readonly) BOOL isAuthenticated;
@property (readwrite) BOOL secure;
@property (retain,readwrite) id<TCInstapaperDelegate> delegate;

- (id)initWithUsername:(NSString *)username;
- (id)initWithUsername:(NSString *)username andPassword:(NSString *)password;

- (void)authenticate;

- (void)addURLString:(NSString *)urlString title:(NSString *)title;
- (void)addURLString:(NSString *)urlString;


@end
