-- beer.sp

{b  " bottles of beer"         <
 bi { itoa << }                <
 bb { bi ! b << w << "\n" << } <
 w  " on the wall"             <
 beer
    {<-
        { iter 1 + dup
          <- bb ! ->
          bi ! b << "\n" <<
          "Take one down, pass it around\n" <<
          iter bb ! "\n" << }
    ->
    times}
    < }

-- At the prompt, type 'N beer !' (no quotes), where N is the number of stanzas you desire
