var DecTab = function () {
  this.conditions = [];
  this.rules = [];
  this.actions = [];
}

DecTab.prototype.Conditions = function () {
  var args = [].slice.call(arguments);
  for (var i = 0; i < args.length; i++) {
    this.conditions.push(args[i]);
  }
  return this;
};

DecTab.prototype.RulesActions = function (rules, actions) {
  var count = 0;
  var actionable;
  this.rules.push(rules)
  this.actions.push(actions);
  return this;
};

DecTab.prototype.Decide = function () {
  var decision = [];
  var decided = false;
  for (var i = 0; i < this.conditions.length; i++) {
    decision.push((this.conditions[i]()));
  }
  var decisionstring = "." + decision.join(".") + ".";

  for (i = 0; i < this.rules.length; i++) {
    var rule = [];
    for (var j = 0; j < this.rules[i].length; j++) {
      rule.push((this.rules[i][j]));
    }
    var rulestring = "." + rule.join(".") + ".";
    if (rulestring === decisionstring) {
      decided = true;
      for (var k = 0; k < this.actions[i].length; k++) {
        this.actions[i][k]();
      }
      break;
    }
  }
  if (!decided) {
    WScript.Echo("No decision table rows matched.");
  }
}
