"use strict";

// Simulate several thousand instances of the game:
const gamesCount = 2000;

// ...where the prisoners randomly open drawers.
const randomResults = playGame(gamesCount, randomStrategy);

// ...where the prisoners use the optimal strategy mentioned in the Wikipedia article.
const optimalResults = playGame(gamesCount, optimalStrategy);

// Show and compare the computed probabilities of success for the two strategies.
console.log(`Games count: ${gamesCount}`);
console.log(`Probability of success with "random" strategy: ${computeProbability(randomResults, gamesCount)}`);
console.log(`Probability of success with "optimal" strategy: ${computeProbability(optimalResults, gamesCount)}`);

function playGame(gamesCount, strategy, prisonersCount = 100) {
    const results = new Array();

    for (let game = 1; game <= gamesCount; game++) {
        // A room having a cupboard of 100 opaque drawers numbered 1 to 100, that cannot be seen from outside.
        // Cards numbered 1 to 100 are placed randomly, one to a drawer, and the drawers all closed; at the start.
        const drawers = initDrawers(prisonersCount);

        // A prisoner tries to find his own number.
        // Prisoners start outside the room.
        // They can decide some strategy before any enter the room.
        let found = 0;
        for (let prisoner = 1; prisoner <= prisonersCount; prisoner++, found++)
            if (!find(prisoner, drawers, strategy)) break;

        // If all 100 findings find their own numbers then they will all be pardoned. If any don't then all sentences stand.
        results.push(found == prisonersCount);
    }

    return results;
}

function find(prisoner, drawers, strategy) {
    // A prisoner can open no more than 50 drawers.
    const openMax = Math.floor(drawers.length / 2);

    // Prisoners start outside the room.
    let card;
    for (let open = 0; open < openMax; open++) {
        // A prisoner tries to find his own number.
        card = strategy(prisoner, drawers, card);

        // A prisoner finding his own number is then held apart from the others.
        if (card == prisoner)
            break;
    }

    return (card == prisoner);
}

function randomStrategy(prisoner, drawers, card) {
    // Simulate the game where the prisoners randomly open drawers.

    const min = 0;
    const max = drawers.length - 1;

    return drawers[draw(min, max)];
}

function optimalStrategy(prisoner, drawers, card) {
    // Simulate the game where the prisoners use the optimal strategy mentioned in the Wikipedia article.

    // First opening the drawer whose outside number is his prisoner number.
    // If the card within has his number then he succeeds...
    if (typeof card === "undefined")
        return drawers[prisoner - 1];

    // ...otherwise he opens the drawer with the same number as that of the revealed card.
    return drawers[card - 1];
}

function initDrawers(prisonersCount) {
    const drawers = new Array();
    for (let card = 1; card <= prisonersCount; card++)
        drawers.push(card);

    return shuffle(drawers);
}

function shuffle(drawers) {
    const min = 0;
    const max = drawers.length - 1;
    for (let i = min, j; i < max; i++)     {
        j = draw(min, max);
        if (i != j)
            [drawers[i], drawers[j]] = [drawers[j], drawers[i]];
    }

    return drawers;
}

function draw(min, max) {
    // See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/random
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

function computeProbability(results, gamesCount) {
    return Math.round(results.filter(x => x == true).length * 10000 / gamesCount) / 100;
}
