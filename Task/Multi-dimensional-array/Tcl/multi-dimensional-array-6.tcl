% array set players {
    1,name      Fido
    1,score     0
    1,colour    green

    2,name      Scratchy
    2,score     99
    2,colour    pink
}
% foreach player {1 2} {
    puts "$players($player,name) is $players($player,colour) and has $players($player,score) points"
}
Fido is green and has 0 points
Scratchy is pink and has 99 points
%
