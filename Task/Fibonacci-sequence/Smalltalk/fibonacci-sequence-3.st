Integer >> fibBinet
    |phi rPhi|

    phi := Float phi.
    rPhi := 1 / phi.

    ^ (1 / 5 sqrt) * ((phi raisedTo:self) - (rPhi raisedTo:self))
