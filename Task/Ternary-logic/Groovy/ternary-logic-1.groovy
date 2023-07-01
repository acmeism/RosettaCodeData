enum Trit {
    TRUE, MAYBE, FALSE

    private Trit nand(Trit that) {
        switch ([this,that]) {
            case { FALSE in it }: return TRUE
            case { MAYBE in it }: return MAYBE
            default             : return FALSE
        }
    }
    private Trit nor(Trit that) { this.or(that).not() }

    Trit and(Trit that)   { this.nand(that).not() }
    Trit or(Trit that)    { this.not().nand(that.not()) }
    Trit not()            { this.nand(this) }
    Trit imply(Trit that) { this.nand(that.not()) }
    Trit equiv(Trit that) { this.and(that).or(this.nor(that)) }
}
