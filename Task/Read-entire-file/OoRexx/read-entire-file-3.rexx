file = 'c:\test.txt'
myStream = .stream~new(file)
if mystream~open('read') = 'READY:'
then do
   myString = myStream~charIn(,myStream~chars)
   myStream~close
end
