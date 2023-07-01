use charnames qw(greek);
$x = "\N{sigma} \U\N{sigma}";
$y = "\x{2708}";
print scalar reverse("$x $y");      # ✈ Σ σ
