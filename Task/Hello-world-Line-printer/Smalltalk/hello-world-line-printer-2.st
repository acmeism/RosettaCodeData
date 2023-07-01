s := PipeStream writingTo:'lpr'.
s nextPutLine:'Hello, world'.
s close.
