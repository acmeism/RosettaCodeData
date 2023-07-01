or:condition2 ifBoth:bothBlk ifFirst:firstBlk ifSecond:scndBlk ifNone:noneBlk
  "I know for sure, that I am true..."
  ^ condition2 ifTrue:bothBlk ifFalse:firstBlk
