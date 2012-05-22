# GGReadabilityParser
-------------------------------
GGReadabilityParser is a complete rewrite of the current GGReadability. This new version is
almost four times as fast and it provides much better results.

Using it is simple. You create a new GGReadabilityParser object like this:
	
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
    
This will create the GGReadabilityParser object. It requires an NSURL for the URL you want to process, a list of options that you want the parser to apply to the content and finally a completion handler block and an error block.

To get readability to parse just call:

	[readability render];
	
If you want to check the load progress then you can simply check the loadProgress property. You can also bind to this.

## Licence
GGReadabilityParser is free to use for everyone.

Please credit GGReadabilityParser in your application. It’s the nice thing to do. :)

