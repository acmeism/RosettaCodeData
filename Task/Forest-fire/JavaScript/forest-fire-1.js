"use strict"

const _ = require('lodash');

const WIDTH_ARGUMENT_POSITION  = 2;
const HEIGHT_ARGUMENT_POSITION = 3;
const TREE_PROBABILITY         = 0.5;
const NEW_TREE_PROBABILITY     = 0.01;
const BURN_PROBABILITY         = 0.0001;
const CONSOLE_RED              = '\x1b[31m';
const CONSOLE_GREEN            = '\x1b[32m';
const CONSOLE_COLOR_CLOSE      = '\x1b[91m';
const CONSOLE_CLEAR            = '\u001B[2J\u001B[0;0f';
const NEIGHBOURS               = [
    [-1, -1],
    [-1,  0],
    [-1,  1],
    [ 0, -1],
    [ 0,  1],
    [ 1, -1],
    [ 1,  0],
    [ 1,  1]
];
const PRINT_DECODE             = {
    ' ': ' ',
    'T': `${CONSOLE_GREEN}T${CONSOLE_COLOR_CLOSE}`,
    'B': `${CONSOLE_RED}T${CONSOLE_COLOR_CLOSE}`,
};
const CONDITIONS = {
    'T': (forest, y, x) => Math.random() < BURN_PROBABILITY || burningNeighbour(forest, y, x) ? 'B' : 'T',
    ' ':  () => Math.random() < NEW_TREE_PROBABILITY ? 'T' : ' ',
    'B':  () => ' '
};

const WIDTH  = process.argv[WIDTH_ARGUMENT_POSITION]  || 20;
const HEIGHT = process.argv[HEIGHT_ARGUMENT_POSITION] || 10;

const update = forest => {
    return _.map(forest, (c, ci) => {
        return _.map(c, (r, ri) => {
            return CONDITIONS[r](forest, ci, ri);
        });
    });
}

const printForest = forest => {
    process.stdout.write(CONSOLE_CLEAR);
    _.each(forest, c => {
        _.each(c, r => {
            process.stdout.write(PRINT_DECODE[r]);
        });
        process.stdout.write('\n');
    })
}

const burningNeighbour = (forest, y, x) => {
    return _(NEIGHBOURS)
           .map(n => _.isUndefined(forest[y + n[0]]) ? null : forest[y + n[0]][x + n[1]])
           .any(_.partial(_.isEqual, 'B'));
};

let forest = _.times(HEIGHT, () => _.times(WIDTH, () => Math.random() < TREE_PROBABILITY ? 'T' : ' '));

setInterval(() => {
    forest = update(forest);
    printForest(forest)
}, 20);
