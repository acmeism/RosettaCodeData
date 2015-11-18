class Car {
  /**
   * A few brands of cars
   * @type {string[]}
   */
  static brands = ['Mazda', 'Volvo'];

  /**
   * Weight of car
   * @type {number}
   */
  weight = 1000;

  /**
   * Brand of car
   * @type {string}
   */
  brand;

  /**
   * Price of car
   * @type {number}
   */
  price;

  /**
   * @param {string} brand - car brand
   * @param {number} weight - mass of car
   */
  constructor(brand, weight) {
    if (brand) this.brand = brand;
    if (weight) this.weight = weight
  }

  /**
   * Drive
   * @param distance - distance to drive
   */
  drive(distance = 10) {
    console.log(`A ${this.brand} ${this.constructor.name} drove ${distance}cm`);
  }

  /**
   * Formatted stats string
   */
  get formattedStats() {
    let out =
      `Type: ${this.constructor.name.toLowerCase()}`
      + `\nBrand: ${this.brand}`
      + `\nWeight: ${this.weight}`;

    if (this.size) out += `\nSize: ${this.size}`;

    return out
  }
}

class Truck extends Car {
  /**
   * Size of truck
   * @type {number}
   */
  size;

  /**
   * @param {string} brand - car brand
   * @param {number} size - size of car
   */
  constructor(brand, size) {
    super(brand, 2000);
    if (size) this.size = size;
  }
}

let myTruck = new Truck('Volvo', 2);
console.log(myTruck.formattedStats);
myTruck.drive(40);
