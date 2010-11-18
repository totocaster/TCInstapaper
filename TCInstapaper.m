#import "TCInstapaper.h"

@implementation TCInstapaper

@synthesize delegate, isAuthenticated;

- (id)init
{
	self = [super init];
	if (self != nil) {
		isAuthenticated = NO;
	}
	return self;
}

- (id)initWithUsername:(NSString *)username
{
	return [self initWithUsername:username andPassword:@""];
}

- (id)initWithUsername:(NSString *)username andPassword:(NSString *)password
{
	_username = username;
	_password = password;
	
	//NSLog(@"*** TCInstapaper: user = %@, password = %@",_username,_password);
	
	return [self init];
}


- (void)authenticate
{
	NSString *requestString = [NSString stringWithFormat:@"username=%@&password=%@",_username,_password];
	//NSLog(@"*** TCInstapaper: %@",[requestString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]);
	
	NSData *requestData = [NSData dataWithBytes:[requestString UTF8String] length:[requestString length]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.instapaper.com/api/authenticate"]];
	[request setHTTPBody:requestData];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
	
	_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
}

- (void)addURLString:(NSString *)urlString title:(NSString *)title
{
	NSString *requestString = [NSString stringWithFormat:@"username=%@&password=%@&url=%@",_username,_password,urlString];
	if (title)
	{
		requestString = [requestString stringByAppendingFormat:@"&title=%@",title];
	}
	
	NSData *requestData = [NSData dataWithBytes:[requestString UTF8String] length:[requestString length]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.instapaper.com/api/add"]];
	[request setHTTPBody:requestData];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
	
	_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)addURLString:(NSString *)urlString
{
	[self addURLString:urlString title:nil];
}

#pragma mark -
#pragma mark NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// TODO: error handling
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[_connection cancel];
	_connection = nil;
	
	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
	[self.delegate instapaper:self didDidFinishRequestWithCode:[httpResponse statusCode]];
	 
}

- (void)dealloc
{
	[_connection release];
	[super dealloc];
}



@end
