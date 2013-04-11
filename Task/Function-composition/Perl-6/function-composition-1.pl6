sub infix:<∘> (&f, &g --> Block) {
    -> $args { f g |$args }
}
