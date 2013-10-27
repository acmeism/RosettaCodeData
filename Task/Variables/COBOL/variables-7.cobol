some-str (1:1)      *> Gets the first character from the string
some-num (1:3)      *> Get the first three digits from the number
another-string (5:) *> Get everything from the 5th character/digit onwards.

*> To get a proper array slice, you must use reference modification on its parent data item:
some-table-area (4:6) *> Get 6 characters from the array after from the 4th char onwards
*> To reference modify an array element
some-table (1) (5:1)  *> Get the 5th character from the 1st element in the table
