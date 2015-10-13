//Constructor function.
function Car(brand, weight) {
  this.brand = brand;
  this.weight = weight || 1000; // Resort to default value (with 'or' notation).
}
Car.prototype.getPrice = function() { // Method of Car.
  return this.price;
}

function Truck(brand, size) {
  this.car = Car;
  this.car(brand, 2000); // Call another function, modifying the "this" object (e.g. "superconstructor".)
  this.size = size; // Custom property for just this object.
}
Truck.prototype = Car.prototype; // Also "import" the prototype from Car.

var cars = [ // Some example car objects.
  new Car("Mazda"),
  new Truck("Volvo", 2)
];
for (var i=0; i<cars.length; i++) {
  alert(cars[i].brand + " " + cars[i].weight + " " + cars[i].size + ", " +
      (cars[i] instanceof Car) + " " + (cars[i] instanceof Truck));
}
