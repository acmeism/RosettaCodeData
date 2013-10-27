use MONKEY_TYPING;
augment class Bag {
    method entropy {
	[+] map -> \p { - p * log p },
	self.values »/» +self;
    }
}

say '1223334444'.comb.Bag.entropy / log 2;
