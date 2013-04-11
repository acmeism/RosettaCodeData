[
   bla := someObject fooBar.
   foo := bla.
] on: MessageNotUnderstood do:[:ex |
   ex return: 'fortyTwo'
]
