>> list = {'a','b','c','d','e','c','f','c'};
>> searchCollection(list,'c','first')

ans =

     3

>> searchCollection(list,'c','last')

ans =

     8

>> searchCollection(list,'g','last')
??? Error using ==> searchCollection at 11
The string 'g' does not exist in this collection of strings.
