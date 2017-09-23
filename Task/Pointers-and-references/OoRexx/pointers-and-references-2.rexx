a.='not set'
a.3=3
Say 'Before Call sub: a.3='a.3
Call sub a.
Say ' After Call sub: a.3='a.3
Call sub2 a.
Say ' After Call sub2: a.3='a.3
Exit

sub: Procedure
Use Arg a. -- this established access to the caller's object
a.3=27
Return

sub2: Procedure
Parse Arg a. -- this gets the value of the caller's object
a.3=9
Say 'in sub2: a.='a.
Say 'in sub2: a.3='a.3  -- this changes the local a.
Return
