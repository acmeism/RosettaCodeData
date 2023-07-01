random = new Random()

int rand5() {
    random.nextInt(5) + 1
}

int rand7From5() {
    def raw = 25
    while (raw > 21) {
        raw = 5*(rand5() - 1) + rand5()
    }
    (raw % 7) + 1
}
