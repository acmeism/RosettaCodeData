constant @p = flat { @_.sort.antipairs.Hash{@_} }(<
  😅😎📸👑👐✌ 💻✊😻💀💁🍃😲🤦☺🤙🔵🌕💎🌎🎶🖕⚠💆🌖🤭❣⚽➡😮☹😂
  🥰💣🤧🐷▶🌈😵🎁👼🦋🤐🙂💟🌔✅🌑🍒😟🌒👎🤪😃🍑👍😜❓💩📣😙😖🎵😝
  🐶😓🏃📌🔴🌺🌊😔🐾😀😌🤣👉💙🤠💦🍻🙋💿🤢🤑💓👶🌞🍎🌸🥀🌚🤷💍🖤🍊
  🎉⭐🎂😏☀🚩👆🐉🙈🐸💾😫🙇👏❄😗😹😴📍💸💞😬😍👌😒💋💗😶😛😪☎🎈
  🍀🚶🤝🥵💨💧☝ 🙁🌗😁💡💪🪐👈👋🙌🙆🙅🍺🤞🌹✔🍓✨😤😭🌌🌟🤗😥😘🙏
  💢🥳😆☄🌴😈😑🎼🤓😇💌😉😕🌱😚⚡💰❤🌘🧐❌💅💖💘👅💛🤘🤤😠😩💚💐
  🛰 🥂💃🤟🥺🌓🤯😱🤫🙊🖥 ✈😯😡😐🤮👇🌿🗣 🤨🥴✋🤬💕🌻😰🚀🌏😣😷💔😋
  😨👊🙃😞💝💥🌼🌷💫☕😄🧡🔥🤩🙄👻🤔💜🎤🌍⬇🏆🤲🕺💯😳👀🎊🚨🎀😊😢
>.join.comb) xx 2;

sub fade($_) { $_ * $_ * $_ * ($_ * ($_ * 6 - 15) + 10) }
sub lerp($t, $a, $b) { $a + $t * ($b - $a) }
sub grad($h is copy, $x, $y, $z) {
    $h +&= 15;
    my $u = $h < 8 ?? $x !! $y;
    my $v = $h < 4 ?? $y !! $h == 12|14 ?? $x !! $z;
    ($h +& 1 ?? -$u !! $u) + ($h +& 2 ?? -$v !! $v);
}

sub noise($x is copy, $y is copy, $z is copy) {
    my ($u, $v, $w) = map &fade, ($x, $y, $z) »-=«
    my ($X, $Y, $Z) = ($x, $y, $z)».floor »+&» 255;
    my ($AA, $AB) = @p[$_] + $Z, @p[$_ + 1] + $Z given @p[$X] + $Y;
    my ($BA, $BB) = @p[$_] + $Z, @p[$_ + 1] + $Z given @p[$X + 1] + $Y;
    lerp($w, lerp($v, lerp($u, grad(@p[$AA    ], $x    , $y    , $z     ),
                               grad(@p[$BA    ], $x - 1, $y    , $z     )),
                      lerp($u, grad(@p[$AB    ], $x    , $y - 1, $z     ),
                               grad(@p[$BB    ], $x - 1, $y - 1, $z     ))),
             lerp($v, lerp($u, grad(@p[$AA + 1], $x    , $y    , $z - 1 ),
                               grad(@p[$BA + 1], $x - 1, $y    , $z - 1 )),
                      lerp($u, grad(@p[$AB + 1], $x    , $y - 1, $z - 1 ),
                               grad(@p[$BB + 1], $x - 1, $y - 1, $z - 1 ))));
}

say noise 3.14, 42, 7;
