for (NSTextCheckingResult *match in [regex matchesInString:str
                                                   options:0
                                                     range:NSMakeRange(0, [str length])
                                     ]) {
    // match.range gives the range of the whole match
    // [match rangeAtIndex:i] gives the range of the i'th capture group (starting from 1)
}
