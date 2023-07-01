fn main() {
    let hands = vec![
        "🂡 🂮 🂭 🂫 🂪",
        "🃏 🃂 🂢 🂮 🃍",
        "🃏 🂵 🃇 🂨 🃉",
        "🃏 🃂 🂣 🂤 🂥",
        "🃏 🂳 🃂 🂣 🃃",
        "🃏 🂷 🃂 🂣 🃃",
        "🃏 🂷 🃇 🂧 🃗",
        "🃏 🂻 🂽 🂾 🂱",
        "🃏 🃔 🃞 🃅 🂪",
        "🃏 🃞 🃗 🃖 🃔",
        "🃏 🃂 🃟 🂤 🂥",
        "🃏 🃍 🃟 🂡 🂪",
        "🃏 🃍 🃟 🃁 🃊",
        "🃏 🃂 🂢 🃟 🃍",
        "🃏 🃂 🂢 🃍 🃍",
        "🃂 🃞 🃍 🃁 🃊",
    ];
    for hand in hands{
        println!("{} {}", hand, poker_hand(hand));
    }
}

fn poker_hand(cards: &str) -> &str {
    let mut suits = vec![0u8; 4];
    let mut faces = vec![0u8; 15];
    let mut hand = vec![];

    for card in cards.chars(){
        if card == ' ' { continue; }
        let values = get_card_value(card);
        if values.0 < 14 && hand.contains(&values) {
            return "invalid";
        }
        hand.push(values);
        faces[values.0 as usize]+=1;
        if values.1 >= 0 {
            suits[values.1 as usize]+=1;
        }
    }
    if hand.len()!=5 {
        return "invalid";
    }
    faces[13] = faces[0]; //add ace-high count
    let jokers = faces[14];

    //count suits
    let mut colors = suits.into_iter()
        .filter(|&x| x > 0).collect::<Vec<_>>();
    colors.sort_unstable();
    colors[0] += jokers; // add joker suits to the highest one;
    let is_flush = colors[0] == 5;

    //straight
    let mut is_straight = false;
    //pointer to optimise some work
    //avoids looking again at cards that were the start of a sequence
    //as they cannot be part of another sequence
    let mut ptr = 14;
    while ptr>3{
        let mut jokers_left = jokers;
        let mut straight_cards = 0;
        for i in (0..ptr).rev(){
            if faces[i]==0 {
                if jokers_left == 0 {break;}
                jokers_left -= 1;
            }
            else if i==ptr-1 { ptr-=1; }
            straight_cards+=1;
        }
        ptr-=1;
        if straight_cards == 5 {
            is_straight = true;
            break;
        }
    }

     //count values
     let mut values = faces.into_iter().enumerate().take(14).filter(|&x| x.1>0).collect::<Vec<_>>();
     //sort by quantity, then by value, high to low
     values.sort_unstable_by(|a, b| if b.1 == a.1 { (b.0).cmp(&a.0) } else { (b.1).cmp(&a.1)} );
     let first_group = values[0].1 + jokers;
     let second_group = if values.len()>1 {values[1].1} else {0};

     match (is_flush, is_straight, first_group, second_group){
        (_,_,5,_) => "five-of-a-kind",
        (true, true, _, _) => if ptr == 8 {"royal-flush"} else {"straight-flush"},
        (_,_,4,_) => "four-of-a-kind",
        (_,_,3,2) => "full-house",
        (true,_,_,_) => "flush",
        (_,true,_,_) => "straight",
        (_,_,3,_) => "three-of-a-kind",
        (_,_,2,2) => "two-pair",
        (_,_,2,_) => "one-pair",
        _ => "high-card"
     }
}

fn get_card_value(card: char) -> (i8,i8) {
    // transform glyph to face + suit, zero-indexed
    let base = card as u32 - 0x1F0A1;
    let mut suit = (base / 16) as i8;
    let mut face = (base % 16) as i8;
    if face > 11 && face < 14 { face-=1; } // Unicode has a Knight that we do not want
    if face == 14 { suit = -1; } //jokers do not have a suit
    (face, suit)
}
