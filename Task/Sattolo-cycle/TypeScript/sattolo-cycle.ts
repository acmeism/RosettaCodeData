function sattoloCycle<T>(items: Array<T>): void {
    for (let i = items.length; i -= 1;) {
        const j = Math.floor(Math.random() * i);
        const tmp = items[i];
        items[i] = items[j];
        items[j] = tmp;
    }
}
