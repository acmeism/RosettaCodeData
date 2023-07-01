t := (FillInTheBlankMorph request: 'Enter time in seconds') asNumber.
Transcript show: 'Sleeping...'.
(Delay forSeconds: t) wait.
Transcript show: 'Awake!'.
