//States
var states = [{
  'name': 'Ready',
  'initial': true,
  'events': {
    'Deposit': 'Waiting',
    'Quit': 'Exiting',
  }
}, {
  'name': 'Waiting',
  'events': {
    'Select': 'Dispensing',
    'Refund': 'Refunding'
  }
}, {
  'name': 'Dispensing',
  'events': {
    'Remove': 'Ready'
  }
}, {
  'name': 'Refunding',
  'events': {
    getReady: 'Ready'
  }
}, {
  'name': 'Exiting',
  'events': {}
}];

function StateMachine(states) {
  this.states = states;
  this.indexes = {};
  for (var i = 0; i < this.states.length; i++) {
    this.indexes[this.states[i].name] = i;
    if (this.states[i].initial) {
      this.currentState = this.states[i];
    }
  }
};
StateMachine.prototype.consumeEvent = function(e) {
  if (this.currentState.events[e]) {
    this.currentState = this.states[this.indexes[this.currentState.events[e]]];
  }
}
StateMachine.prototype.getStatus = function() {
  return this.currentState.name;
}
var fsm = new StateMachine(states);
var s, currentButtons, answer;
while ((s = fsm.getStatus()) !== "Exiting") {
  switch (s) {
    case "Refunding":
      window.alert('Refunding');
      fsm.consumeEvent("getReady")
      break;
    case "Dispensing":
    case "Waiting":
    case "Ready":
      currentButtons = Object.keys(fsm.states[fsm.indexes[s]].events)
      answer = window.prompt(currentButtons.join(' ') + '?');
      answer = currentButtons.find(function(key) {
        return key.match(new RegExp('^' + answer, 'i'))
      });
      if (answer) {
        fsm.consumeEvent(answer);
      }
  }
}
