/* REXX */
Parse Value '(4.0,0.0)'  With '(' xa ',' ya ')'
Parse Value '(6.0,10.0)' With '(' xb ',' yb ')'
Parse Value '(0.0,3.0)'  With '(' xc ',' yc ')'
Parse Value '(10.0,7.0)' With '(' xd ',' yd ')'

Say 'The two lines are:'
Say 'yab='ya-xa*((yb-ya)/(xb-xa))'+x*'||((yb-ya)/(xb-xa))
Say 'ycd='yc-xc*((yd-yc)/(xd-xc))'+x*'||((yd-yc)/(xd-xc))

x=((yc-xc*((yd-yc)/(xd-xc)))-(ya-xa*((yb-ya)/(xb-xa))))/,
                         (((yb-ya)/(xb-xa))-((yd-yc)/(xd-xc)))
Say 'x='||x
        y=ya-xa*((yb-ya)/(xb-xa))+x*((yb-ya)/(xb-xa))
Say 'yab='y
Say 'ycd='yc-xc*((yd-yc)/(xd-xc))+x*((yd-yc)/(xd-xc))
Say 'Intersection: ('||x','y')'
