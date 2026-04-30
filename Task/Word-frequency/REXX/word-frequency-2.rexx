-- 10 Mar 2026
include Setting
arg file top
if file='' | file='.' then
   file='Miserables.txt'
if top='' then
   top=10

say 'WORD FREQUENCY'
say version
say
call CountWords file
call SaveCount
call ShowCount top
call ShowWord top
call Timer
exit

CountWords:
procedure expose Dict. List.
parse arg file
-- Init
abc=Xrange('a','z'); all=Xrange('00'x,'FF'x)
Dict.=0; List.=0; n=0
-- Process file
do while Lines(file)
-- Convert to lower case and filter only a-z
   line=Translate(Lower(Linein(file)),abc,abc||all)
   do i=1 to Words(line)
      w=Word(line,i)
-- Not in dictionary? Add to list
      if Dict.w=0 then do
         n+=1; List.Dict.n=w
      end
-- Count in dictionary
      Dict.w+=1
   end i
end
List.0=n
say n 'different words found'
say
return

SaveCount:
procedure expose Dict. List.
-- Move counts to list
do i=1 to List.0
   w=List.Dict.i; List.Count.i=Dict.w
end
return

ShowCount:
procedure expose List.
arg top
call SortSt 'List.Count.','List.Dict.'
say 'Frequency by count'
say 'word             rank count'
say '---------------------------'
n=0
do i=List.0 by -1 to 1
   n+=1
   if n<=top then
      say Left(List.Dict.i,15) Right(n,5) Right(List.Count.i,5)
   List.Rank.i=n
end
say '...'
say
return

ShowWord:
procedure expose List.
arg top
call SortSt 'List.Dict.','List.Rank. List.Count.'
say 'Frequency by word'
say 'word             rank count'
say '---------------------------'
do i=1 to top
   say Left(List.Dict.i,15) Right(List.Rank.i,5) Right(List.Count.i,5)
end
say '...'
say
return

-- SortSt; Timer
include Math
