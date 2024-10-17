#[derive(Clone)]
enum Attrib {
    Color,
    Man,
    Drink,
    Animal,
    Smoke,
}
enum Colors {
    Red,
    Green,
    White,
    Yellow,
    Blue,
}
enum Humans {
    English,
    Swede,
    Dane,
    German,
    Norwegian,
}
enum Drinks {
    Tea,
    Coffee,
    Milk,
    Beer,
    Water,
}
#[allow(unused)]
enum Animals {
    Dog,
    Birds,
    Cats,
    Horse,
    Zebra,
}
enum Smokes {
    PallMall,
    Dunhill,
    Blend,
    BlueMaster,
    Prince,
}

struct HouseNoRule {
    houseno: usize,
    a: Attrib,
    v: i32,
}

struct AttrPairRule {
    a1: Attrib,
    v1: i32,
    a2: Attrib,
    v2: i32,
}
impl AttrPairRule {
    fn invalid(&self, ha: &Vec<Vec<i32>>, i: usize) -> bool {
        let (j, k) = (self.a1.clone() as usize, self.a2.clone() as usize);
        return (ha[i][j] >= 0 && ha[i][k] >= 0)
            && ((ha[i][j] == self.v1 && ha[i][k] != self.v2)
                || (ha[i][j] != self.v1 && ha[i][k] == self.v2));
    }
}

struct NextToRule {
    a1: Attrib,
    v1: i32,
    a2: Attrib,
    v2: i32,
}
impl NextToRule {
    fn invalid(&self, ha: &Vec<Vec<i32>>, i: usize) -> bool {
        let (j, k) = (self.a1.clone() as usize, self.a2.clone() as usize);
        return (ha[i][j] == self.v1)
            && ((i == 0 && ha[i + 1][k] >= 0 && ha[i + 1][k] != self.v2)
                || (i == ha.len() - 1 && ha[i - 1][k] != self.v2)
                || (ha[i + 1][k] >= 0 && ha[i + 1][k] != self.v2 && ha[i - 1][k] != self.v2));
    }
}

struct LeftOfRule {
    a1: Attrib,
    v1: i32,
    a2: Attrib,
    v2: i32,
}
impl LeftOfRule {
    fn invalid_circ(&self, ha: &Vec<Vec<i32>>) -> bool {
        let end = ha.len() - 1;
        let (j, k) = (self.a1.clone() as usize, self.a2.clone() as usize);
        return (ha[0][k] == self.v2) || (ha[end][j] == self.v1);
    }
    fn invalid(&self, ha: &Vec<Vec<i32>>, i: usize) -> bool {
        let (j, k) = (self.a1.clone() as usize, self.a2.clone() as usize);
        return i > 0
            && (ha[i][j] >= 0 && ha[i - 1][j] == self.v1 && ha[i][k] != self.v2
                || ha[i - 1][j] != self.v1 && ha[i][k] == self.v2);
    }
}

struct Rules<'a> {
    pairs: &'a [AttrPairRule],
    nexttos: &'a [NextToRule],
    leftofs: &'a [LeftOfRule],
}
impl<'a> Rules<'a> {
    fn invalid(&self, ha: &Vec<Vec<i32>>) -> bool {
        for rule in self.leftofs {
            if rule.invalid_circ(ha) {
                return true;
            }
        }
        for i in 0..ha.len() {
            for rule in self.pairs {
                if rule.invalid(ha, i) {
                    return true;
                }
            }
            for rule in self.nexttos {
                if rule.invalid(ha, i) {
                    return true;
                }
            }
            for rule in self.leftofs {
                if rule.invalid(ha, i) {
                    return true;
                }
            }
        }
        return false;
    }
    fn search(
        &self,
        used: &mut Vec<Vec<bool>>,
        ha: &mut Vec<Vec<i32>>,
        hno: usize,
        attr: usize,
        attribs: &Vec<&str>,
        attr_names: &Vec<Vec<&str>>,
    ) {
        let end = ha.len() - 1;
        let (nexthno, nextattr);
        if attr < end {
            nextattr = attr + 1;
            nexthno = hno;
        } else {
            nextattr = 0;
            nexthno = hno + 1;
        }
        if ha[hno][attr] != -1 {
            self.search(used, ha, nexthno, nextattr, attribs, attr_names);
        } else {
            for i in 0..ha.len() {
                if used[attr][i] {
                    continue;
                }
                used[attr][i] = true;
                ha[hno][attr] = i as i32;
                if !self.invalid(ha) {
                    if hno == end && attr == end {
                        print_houses(ha, attribs, attr_names);
                    } else {
                        self.search(used, ha, nexthno, nextattr, attribs, attr_names);
                    }
                }
                used[attr][i] = false;
            }
            ha[hno][attr] = -1;
        }
    }
}

fn zebra_problem() {
    let attribs: Vec<&str> = "Color, Man, Drink, Animal, Smoke"
        .split(", ")
        .into_iter()
        .collect();
    let colors: Vec<&str> = "Red, Green, White, Yellow, Blue"
        .split(", ")
        .into_iter()
        .collect();
    let humans: Vec<&str> = "English, Swede, Dane, German, Norwegian"
        .split(", ")
        .into_iter()
        .collect();
    let drinks: Vec<&str> = "Tea, Coffee, Milk, Beer, Water"
        .split(", ")
        .into_iter()
        .collect();
    let animals: Vec<&str> = "Dog, Birds, Cats, Horse, Zebra"
        .split(", ")
        .into_iter()
        .collect();
    let smokes: Vec<&str> = "PallMall, Dunhill, Blend, BlueMaster, Prince"
        .split(", ")
        .into_iter()
        .collect();
    let attr_names = vec![colors, humans, drinks, animals, smokes];

    let housenos = [
        HouseNoRule {
            houseno: 2,
            a: Attrib::Drink,
            v: Drinks::Milk as i32,
        }, // Cond 9: In the middle house they drink milk.
        HouseNoRule {
            houseno: 0,
            a: Attrib::Man,
            v: Humans::Norwegian as i32,
        }, // Cond 10: The Norwegian lives in the first house.
    ];
    let ps = [
        AttrPairRule {
            a1: Attrib::Man,
            v1: Humans::English as i32,
            a2: Attrib::Color,
            v2: Colors::Red as i32,
        }, // Cond 2: The English man lives in the red house.
        AttrPairRule {
            a1: Attrib::Man,
            v1: Humans::Swede as i32,
            a2: Attrib::Animal,
            v2: Animals::Dog as i32,
        }, // Cond 3: The Swede has a dog.
        AttrPairRule {
            a1: Attrib::Man,
            v1: Humans::Dane as i32,
            a2: Attrib::Drink,
            v2: Drinks::Tea as i32,
        }, // Cond 4: The Dane drinks tea.
        AttrPairRule {
            a1: Attrib::Color,
            v1: Colors::Green as i32,
            a2: Attrib::Drink,
            v2: Drinks::Coffee as i32,
        }, // Cond 6: drink coffee in the green house.
        AttrPairRule {
            a1: Attrib::Smoke,
            v1: Smokes::PallMall as i32,
            a2: Attrib::Animal,
            v2: Animals::Birds as i32,
        }, // Cond 7: The man who smokes Pall Mall has birds.
        AttrPairRule {
            a1: Attrib::Smoke,
            v1: Smokes::Dunhill as i32,
            a2: Attrib::Color,
            v2: Colors::Yellow as i32,
        }, // Cond 8: In the yellow house they smoke Dunhill.
        AttrPairRule {
            a1: Attrib::Smoke,
            v1: Smokes::BlueMaster as i32,
            a2: Attrib::Drink,
            v2: Drinks::Beer as i32,
        }, // Cond 13: The man who smokes Blue Master drinks beer.
        AttrPairRule {
            a1: Attrib::Man,
            v1: Humans::German as i32,
            a2: Attrib::Smoke,
            v2: Smokes::Prince as i32,
        }, // Cond 14: The German smokes Prince
    ];
    let ns = [
        NextToRule {
            a1: Attrib::Smoke,
            v1: Smokes::Blend as i32,
            a2: Attrib::Animal,
            v2: Animals::Cats as i32,
        }, // Cond 11: The man who smokes Blend lives in the house next to the house with cats.
        NextToRule {
            a1: Attrib::Smoke,
            v1: Smokes::Dunhill as i32,
            a2: Attrib::Animal,
            v2: Animals::Horse as i32,
        }, // Cond 12: In a house next to the house where they have a horse, they smoke Dunhill.
        NextToRule {
            a1: Attrib::Man,
            v1: Humans::Norwegian as i32,
            a2: Attrib::Color,
            v2: Colors::Blue as i32,
        }, // Cond 15: The Norwegian lives next to the blue house.
        NextToRule {
            a1: Attrib::Smoke,
            v1: Smokes::Blend as i32,
            a2: Attrib::Drink,
            v2: Drinks::Water as i32,
        }, // Cond 16: They drink water in a house next to the house where they smoke Blend.
    ];
    let ls = [
        LeftOfRule {
            a1: Attrib::Color,
            v1: Colors::Green as i32,
            a2: Attrib::Color,
            v2: Colors::White as i32,
        }, // Cond 5: The green house is immediately to the left of the white house.
    ];
    let rules = Rules {
        pairs: &ps[..],
        nexttos: &ns[..],
        leftofs: &ls[..],
    };

    let mut used = vec![vec![false; 5]; 5];
    let mut ha = vec![vec![-1_i32; 5]; 5];
    for rule in housenos {
        let (a, v) = (rule.a as usize, rule.v as usize);
        ha[rule.houseno][a] = rule.v;
        used[a][v] = true;
    }
    rules.search(&mut used, &mut ha, 0, 0, &attribs, &attr_names);
}

fn print_houses(ha: &Vec<Vec<i32>>, attribs: &Vec<&str>, attr_names: &Vec<Vec<&str>>) {
    print!("{:<10}", "House");
    for s in attribs {
        print!("{:<10}", s);
    }
    println!();
    for i in 0..ha.len() {
        print!("{:<10}", i);
        for j in 0..attr_names.len() {
            print!(
                "{:<10}",
                if ha[i][j] >= 0 {
                    attr_names[j][ha[i][j] as usize]
                } else {
                    " "
                }
            );
        }
        println!();
    }
}

fn main() {
    zebra_problem();
}
