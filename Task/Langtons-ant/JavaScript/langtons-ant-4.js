///////////////////
// LODASH IMPORT //
///////////////////

// import all lodash functions to the main namespace, but isNaN not to cause conflicts
_.each(_.keys(_), k => window[k === 'isNaN' ? '_isNaN' : k] = _[k]);

const
WORLD_WIDTH  = 100,
WORLD_HEIGHT = 100,
PIXEL_SIZE   = 4,
DIRTY_COLOR  = '#000',
VIRGIN_COLOR = '#fff',
RUNS         = 10000,
SPEED        = 50,

//            up right down left
DIRECTIONS = [0, 1,    2,    3],

displayWorld = (world) => each(world, (row, rowidx) => {
  each(row, (cell, cellidx) => {
    canvas.fillStyle = cell === 1 ? DIRTY_COLOR : VIRGIN_COLOR;
    canvas.fillRect(rowidx * PIXEL_SIZE, cellidx * PIXEL_SIZE, PIXEL_SIZE, PIXEL_SIZE);
  });
}),

moveAnt = (world, ant) => {
  world[ant.x][ant.y] = world[ant.x][ant.y] === 1 ? 0 : 1;
  ant.dir             = DIRECTIONS[(4 + ant.dir + (world[ant.x][ant.y] === 0 ? 1 : -1)) % 4];
  switch (ant.dir) {
    case DIRECTIONS[0]:
      ant.y -= 1;
      break;
    case DIRECTIONS[1]:
      ant.x -= 1;
      break;
    case DIRECTIONS[2]:
      ant.y += 1;
      break;
    case DIRECTIONS[3]:
      ant.x += 1;
      break;
  }

  return [world, ant];
},

updateWorld = (world, ant, runs) => {
  [world, ant] = moveAnt(world, ant);
  displayWorld(world);

  if (runs > 0) setTimeout(partial(updateWorld, world, ant, --runs), SPEED);
},

canvas = document.getElementById('c').getContext('2d');

let
world = map(range(WORLD_HEIGHT), i => map(range(WORLD_WIDTH), partial(identity, 0))),
ant   = {
  x:   WORLD_WIDTH  / 2,
  y:   WORLD_HEIGHT / 2,
  dir: DIRECTIONS[0]
};

canvas.canvas.width  = WORLD_WIDTH  * PIXEL_SIZE;
canvas.canvas.height = WORLD_HEIGHT * PIXEL_SIZE;

updateWorld(world, ant, RUNS);
