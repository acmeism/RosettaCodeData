class Latch {
  constructor(limit) {
    this.semafor = limit;
    this.lock = new Promise(resolve => {
      this.resolve = resolve;
    });
  }

  wait() {
    this.semafor--;
    if (this.semafor === 0) {
      this.resolve();
    }
    return this.lock;
  }
}

class Worker {
  static async doWork(howLong, barrier, name) {
    await new Promise(resolve => setTimeout(resolve, howLong));
    console.log(`Worker ${name} finished work`);
    await barrier.wait();
    console.log(`Worker ${name} finished assembly`);
  }
}

async function main() {
  const latch = new Latch(5);

  // Random number generator function
  const getRandomInt = (min, max) => {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  };

  const promises = [
    Worker.doWork(getRandomInt(300, 3000), latch, "John"),
    Worker.doWork(getRandomInt(300, 3000), latch, "Henry"),
    Worker.doWork(getRandomInt(300, 3000), latch, "Smith"),
    Worker.doWork(getRandomInt(300, 3000), latch, "Jane"),
    Worker.doWork(getRandomInt(300, 3000), latch, "Mary")
  ];

  await Promise.all(promises);
  console.log("Assembly is finished");
}

main();
