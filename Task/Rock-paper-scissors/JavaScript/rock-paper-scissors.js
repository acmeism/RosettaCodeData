const logic = {
    rock: { w: 'scissor', l: 'paper'},
    paper: {w:'rock', l:'scissor'},
    scissor: {w:'paper', l:'rock'},
}

class Player {
    constructor(name){
        this.name = name;
    }
    setChoice(choice){
        this.choice = choice;
    }
    challengeOther(PlayerTwo){
        return logic[this.choice].w === PlayerTwo.choice;
    }
}

const p1 = new Player('Chris');
const p2 = new Player('John');

p1.setChoice('rock');
p2.setChoice('scissor');

p1.challengeOther(p2); //true (Win)
