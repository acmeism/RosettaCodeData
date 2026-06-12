class Cuboid {
    constructor() {
        this.length = 0.0;
        this.breadth = 0.0;
        this.height = 0.0;
    }

    getVolume() {
        return this.length * this.breadth * this.height;
    }

    setLength(val) {
        this.length = val;
    }

    setBreadth(val) {
        this.breadth = val;
    }

    setHeight(val) {
        this.height = val;
    }

    add(c) {
        const result = new Cuboid();
        result.length = this.length + c.length;
        result.breadth = this.breadth + c.breadth;
        result.height = this.height + c.height;
        return result;
    }

    subtract(c) {
        const result = new Cuboid();
        result.length = this.length - c.length;
        result.breadth = this.breadth - c.breadth;
        result.height = this.height - c.height;
        return result;
    }
}

function main() {
    const c1 = new Cuboid();
    const c2 = new Cuboid();
    let c3 = new Cuboid();

    c1.setLength(6.0);
    c1.setBreadth(7.0);
    c1.setHeight(5.0);

    c2.setLength(12.0);
    c2.setBreadth(13.0);
    c2.setHeight(10.0);

    let volume = c1.getVolume();
    console.log("Volume of 1st cuboid:", volume);

    volume = c2.getVolume();
    console.log("Volume of 2nd cuboid:", volume);

    c3 = c1.add(c2);
    volume = c3.getVolume();
    console.log("Volume of 3rd cuboid after adding:", volume);

    c3 = c1.subtract(c2);
    volume = c3.getVolume();
    console.log("Volume of 3rd cuboid after subtracting:", volume);
}

main();

