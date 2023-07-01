>> A = {2,'TPS Report'} %Declare cell-array and initialize

A =

    [2]    'TPS Report'

>> A{2} = struct('make','honda','year',2003)

A =

    [2]    [1x1 struct]

>> A{3} = {3,'HOVA'} %Create and assign A{3}

A =

    [2]    [1x1 struct]    {1x2 cell}

>> A{2} %Get A{2}

ans =

    make: 'honda'
    year: 2003
