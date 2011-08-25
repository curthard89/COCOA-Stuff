/*
 Copyright (c) 2011 Curtis Hard - GeekyGoodness
 
 Permission is hereby granted, free of charge, to any person obtaining
 a copy of this software and associated documentation files (the
 "Software"), to deal in the Software without restriction, including
 without limitation the rights to use, copy, modify, merge, publish,
 distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to
 the following conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 
 
 GGReadability was originally based on the open source JS readability code.
 Since then I have changed how this works so it does the follow :
    - Convert all line breaks and br tags to p tags so we can search better
    - If parsed a hint, score up the element based on wether it matches the hint parsed in
    - Scores up elements based on image size within them
    - Scores up elements based on size of embeds inside them
    - Scores up elements on puncation, number of words, how many paragraphs they have and if they contain lists or headers
    - Scores up elements on same principle readabilty did with checking class and id's against certain key words
    - Scores up elements on wether they use the HTML5 article or section tag names
    - Marks down on forms, inputs and any other stuff thats not normally inside articles
    - Marks down on same principle readabily uses with checking class and id's against certain key words
 Once the element has been found, its then cleaned from any unwanted elements, such as unwanted divs etc then replaces p tags
 we have injected back with br tags, then removes duplicate br tags if they are next to each other.
*/

#import <Foundation/Foundation.h>

@interface GGReadabilityScorer : NSObject {

    NSInteger score;
    NSXMLElement * element;
    
}

@property ( nonatomic, assign ) NSInteger score;
@property ( nonatomic, retain ) NSXMLElement * element;

@end

@protocol GGReadabilityDelegate;

// use these for init'ing with blocks
typedef void (^GGReadabilityCompletionHandler)(NSString * parsedString);
typedef void (^GGReadabilityErrorHandler)(NSError * error);
typedef NSString * (^GGReadabilityURLHandler)(NSString * parsedString);

@interface GGReadability : NSObject <NSURLConnectionDelegate> {
    
    NSString * hint;
    NSURL * URL;
    id<GGReadabilityDelegate> delegate;
    
    float loadProgress;
    BOOL isRendering;
    NSString * contents;

@private
    NSArray * hintWords;
    NSMutableData * responseData;
    long long length;    
    NSURLConnection * connection;
    NSURLResponse * response;
    BOOL useBlocks;
    
    GGReadabilityCompletionHandler completionBlock;
    GGReadabilityErrorHandler errorBlock;
    
}

@property ( nonatomic, copy ) NSString * hint;
@property ( nonatomic, retain ) NSURL * URL;
@property ( nonatomic, assign ) id delegate;
@property ( nonatomic, assign ) float loadProgress;
@property ( nonatomic, assign ) BOOL isRendering;
@property ( nonatomic, assign ) BOOL useBlocks;
@property ( nonatomic, copy ) NSString * contents;

+ (void)addURLHandler:(GGReadabilityURLHandler)handler
               forURL:(NSURL *)aURL;

+ (void)removeHandlerForURL:(NSURL *)aURL;

- (id)initWithURL:(NSURL *)aURL
         delegate:(id<GGReadabilityDelegate>)anObject;

- (id)initWithURL:(NSURL *)aURL
completionHandler:(void (^)(NSString * string))completeHandler
     errorHandler:(void (^)(NSError * error))errorHandler;

- (void)stop;
- (void)render;

@end

@protocol GGReadabilityDelegate <NSObject>

@optional
- (void)readability:(GGReadability *)readability
    didReceiveError:(NSError *)error;

@required
- (void)readability:(GGReadability *)readability
 didReceiveContents:(NSString *)contents;

@end
