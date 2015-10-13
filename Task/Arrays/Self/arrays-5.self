v do: [:each | each printLine].
v copy mapBy: [:each | each squared].
v copy filterBy: [:each | each > 10].
