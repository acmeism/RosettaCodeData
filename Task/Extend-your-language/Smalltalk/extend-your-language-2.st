or:condition2 ifBoth:bothBlk ifFirst:firstBlk ifSecond:scndBlk ifNone:noneBlk
  "I know for sure, that I am false..."
  ^ condition2 ifTrue:scndBlk ifFalse:noneBlk
