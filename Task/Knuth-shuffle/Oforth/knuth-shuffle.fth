Indexable method: shuffle
| s i l |
   self asListBuffer ->l
   self size dup ->s 1- loop: i [ s i - rand i +  i  l swapValues ]
   l dup freeze ;
