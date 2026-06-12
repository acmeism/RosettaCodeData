NB. String Distance Wrapper Function
mfksDF     =: {:@:[ - (mfks@:(mfkh&.>)~ {.)~

NB. Most Frequent K Distance
mfks       =:  score@:(charMap@:[ {"1 charVals@:])/@:kHashes
  score    =.  ([ +/ .* =)/                  NB. (+ +/ .* *.&:*)/  for sum += freq_in_left + freq_in_right
  charMap  =.  (,&< i.&> <@:~.@:,)&;/
  charVals =.  (; , 0:)"1
  kHashes  =.  0 1 |: ({.&>~ [: <./ #&>)

NB. Most Frequent K Hashing
mfkh       =:   _&$: : (takeK freqHash)      NB. Default LHA of _ means "return complete frequency table"
  takeK    =.  (<.#) {. ]
  freqHash =.  ~. (] \:~ ,.&:(<"0)) #/.~

NB. No need to fix mfksDF
mfkh =: mfkh f.
mfks =: mfks f.
