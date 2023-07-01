const FACES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'j', 'q', 'k', 'a'];
const SUITS = ['♥', '♦', '♣', '♠'];

function analyzeHand(hand){
	let cards  = hand.split(' ').filter(x => x !== 'joker');
	let jokers = hand.split(' ').length - cards.length;
	
	let faces = cards.map( card => FACES.indexOf(card.slice(0,-1)) );
	let suits = cards.map( card => SUITS.indexOf(card.slice(-1)) );
	
	if( cards.some( (card, i, self) => i !== self.indexOf(card) ) || faces.some(face => face === -1) || suits.some(suit => suit === -1) )
		return 'invalid';
	
	let flush    = suits.every(suit => suit === suits[0]);
	let groups   = FACES.map( (face,i) => faces.filter(j => i === j).length).sort( (x, y) => y - x );
	let shifted  = faces.map(x => (x + 1) % 13);
	let distance = Math.min( Math.max(...faces) - Math.min(...faces), Math.max(...shifted) - Math.min(...shifted));
	let straight = groups[0] === 1 && distance < 5;
	groups[0] += jokers;
	
	if      (groups[0] === 5)                    return 'five-of-a-kind'
	else if (straight && flush)                  return 'straight-flush'
	else if (groups[0] === 4)                    return 'four-of-a-kind'
	else if (groups[0] === 3 && groups[1] === 2) return 'full-house'
	else if (flush)                              return 'flush'
	else if (straight)                           return 'straight'
	else if (groups[0] === 3)                    return 'three-of-a-kind'
	else if (groups[0] === 2 && groups[1] === 2) return 'two-pair'
	else if (groups[0] === 2)                    return 'one-pair'
	else                                         return 'high-card';
}
