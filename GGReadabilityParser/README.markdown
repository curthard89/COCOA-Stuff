# GGReadabilityParser
-------------------------------
GGReadabilityParser is a complete rewrite of the current GGReadability, this new version is
almost four times as quick aswell as providing much better results.

The use is simple, you have to create a new GGReadabilityParser object like this:
	
	GGReadabilityParser * readability = [[GGReadabilityParser alloc] initWithURL:[NSURL URLWithString:@"someURLHere"]
                                                  						 options:GGReadabilityParserOptionClearStyles|GGReadabilityParserOptionClearLinkLists|GGReadabilityParserOptionFixLinks|GGReadabilityParserOptionFixImages|GGReadabilityParserOptionRemoveHeader|GGReadabilityParserOptionRemoveIFrames
                                       						   completionHandler:^(NSString *content)
    {
    	// handle returned content
    }
                                              						errorHandler:^(NSError *error) 
    {
    	// handle error returned
    }];
    
This will create object, it requires a NSURL for the URL, a list of options that you want the parser to carry out, a completion handler block and an error block.

To get readability to parser just call:

	[readability render];
	
If you want to check the load progress of it then you can simply check the loadProgress ivar - you can also bind to this.

## Licence
GGReadabilityParser is free to use for everyone.

Please leave credit in your application where it is due - its only nice to :)

