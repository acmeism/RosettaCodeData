also minos
text-label ptr click-label
Variable click#  click# off
: click-win ( -- ) screen self window new window with
    X" There have been no clicks yet" text-label new
      dup F bind click-label
    ^ S[ 1 click# +!
         click# @ 0 <# #S s" Number of clicks: " holds #>
         click-label assign ]S X" Click me" button new
    &2 vabox new panel s" Clicks" assign show endwith ;
click-win
