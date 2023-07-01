USING: arrays formatting fry io kernel math random sequences ;

: setup ( -- seq seq ) 100 <iota> dup >array randomize ;

: rand ( -- ? )
    setup [ 50 sample member? not ] curry find nip >boolean not ;

: trail ( m seq -- n )
    50 pick '[ [ nth ] keep over _ = ] replicate [ t = ] any?
    2nip ;

: optimal ( -- ? ) setup [ trail ] curry [ and ] map-reduce ;

: simulate ( m quot -- x )
    dupd replicate [ t = ] count swap /f 100 * ; inline

"Simulation count: 10,000" print
10,000 [ rand ] simulate "Random play success: "
10,000 [ optimal ] simulate "Optimal play success: "
[ write "%.2f%%\n" printf ] 2bi@
