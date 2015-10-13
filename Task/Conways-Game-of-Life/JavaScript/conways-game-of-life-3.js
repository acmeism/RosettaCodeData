const _ = require('lodash');

///////////////////
// LODASH IMPORT //
///////////////////

// import all lodash functions to the main namespace, but isNaN not to cause conflicts
_.each(_.keys(_), k => global[k === 'isNaN' ? '_isNaN' : k] = _[k]);

///////////////
// FUNCTIONS //
///////////////
const WORLD_WIDTH  = 3,
      WORLD_HEIGHT = 3,
      displayWorld = (world) => console.log(map(world, x => x.join(' ')).join('\n') + '\n'),

      aliveNeighbours = (world, x, y) => chain(range(-1, 2))
                                          .reduce((acc, i) => acc.concat(map(range(-1, 2), ii => [i, ii])), [])
                                          .reject(partial(isEqual, [0, 0]))
                                          .map(i => {
                                            try {
                                              return world[x + i[0]][y + i[1]];
                                            } catch (err) {
                                              return null;
                                            }
                                          })
                                          .compact()
                                          .value()
                                          .length,

      isAlive = (cell, numAliveNeighbours) => (cell === 1 && inRange(numAliveNeighbours, 2, 4)) || (cell === 0 && numAliveNeighbours === 3) ? 1 : 0,
      updateWorld = (world) => map(world, (row, rowidx) => map(row, (cell, colidx) => isAlive(cell, aliveNeighbours(world, rowidx, colidx))));


// let world = map(range(WORLD_WIDTH), partial(ary(map, 2), range(WORLD_HEIGHT), partial(random, 0, 1, false)));
let world = [[0, 0, 0], [1, 1, 1], [0, 0, 0]];

setInterval(() => {
  world = updateWorld(world)
  displayWorld(world);
}, 1000);
