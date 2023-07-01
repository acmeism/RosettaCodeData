(StandardFileStream oldFileNamed: 'test.txt') contents lines do: [  :each | Transcript show: each. ]
