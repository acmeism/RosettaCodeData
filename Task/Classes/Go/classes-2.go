import reflect

type happinessTester interface {
    happy() bool
}

type bottleOfWine struct {
    USD   float64
    empty bool
}

func (b *bottleOfWine) happy() bool {
    return b.USD > 10 && !b.empty
}

func main() {
    partySupplies := []happinessTester{
        &picnicBasket{2, true},
        &bottleOfWine{USD: 6},
    }
    for _, ps := range partySupplies {
        fmt.Printf("%s: happy? %t\n",
            reflect.Indirect(reflect.ValueOf(ps)).Type().Name(),
            ps.happy())
    }
}
