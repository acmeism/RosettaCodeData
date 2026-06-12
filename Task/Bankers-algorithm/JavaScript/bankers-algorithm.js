const readline = require('readline').createInterface({
    input: process.stdin,
    output: process.stdout,
  });

  function askQuestion(query) {
    return new Promise(resolve => {
      readline.question(query, answer => {
        resolve(answer);
      });
    });
  }

  async function main() {
    const resources = parseInt(await askQuestion("Number of resources: "));
    const processes = parseInt(await askQuestion("Number of processes: "));
    const maxResources = (await askQuestion("Maximum resources: ")).split(" ").map(Number);

    console.log("\n-- resources allocated for each process --");
    const currentlyAllocated = [];
    for (let j = 0; j < processes; j++) {
      const processResources = (await askQuestion(`process ${j + 1}: `)).split(" ").map(Number);
      currentlyAllocated.push(processResources);
    }

    console.log("\n--- maximum resources for each process ---");
    const maxNeed = [];
    for (let j = 0; j < processes; j++) {
      const processMaxNeed = (await askQuestion(`process ${j + 1}: `)).split(" ").map(Number);
      maxNeed.push(processMaxNeed);
    }

    let allocated = new Array(resources).fill(0);
    for (let i = 0; i < processes; i++) {
      for (let j = 0; j < resources; j++) {
        allocated[j] += currentlyAllocated[i][j];
      }
    }
    console.log(`\nTotal resources allocated: ${allocated}`);

    const available = maxResources.map((resource, i) => resource - allocated[i]);
    console.log(`Total resources available: ${available}\n`);

    let running = new Array(processes).fill(true);
    let count = processes;
    while (count !== 0) {
      let safe = false;
      for (let i = 0; i < processes; i++) {
        if (running[i]) {
          let executing = true;
          for (let j = 0; j < resources; j++) {
            if (maxNeed[i][j] - currentlyAllocated[i][j] > available[j]) {
              executing = false;
              break;
            }
          }
          if (executing) {
            console.log(`process ${i + 1} running`);
            running[i] = false;
            count -= 1;
            safe = true;
            for (let j = 0; j < resources; j++) {
              available[j] += currentlyAllocated[i][j];
            }
            break;
          }
        }
      }
      if (!safe) {
        console.log("The process is in an unsafe state.");
        break;
      }

      console.log(`The process is in a safe state.\nAvailable resources: ${available}\n\n`);
    }

    readline.close();
  }

  main();
