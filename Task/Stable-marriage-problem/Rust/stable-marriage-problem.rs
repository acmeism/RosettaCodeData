use std::collections::HashMap;

fn matchmaker(
    men_preferences: &HashMap<String, Vec<String>>,
    women_preferences: &HashMap<String, Vec<String>>,
) -> HashMap<String, String> {

    let mut free_men: Vec<String> = men_preferences.keys().cloned().collect();
    let mut engaged: HashMap<String, String> = HashMap::new();

    // cloning for immutability of original data
    let mut men_preferences = men_preferences.clone();
    let women_preferences = women_preferences.clone();

    while !free_men.is_empty() {
        let man = free_men.remove(0);

        if let Some(proposal_list) = men_preferences.get_mut(&man) {

            if let Some(woman) = proposal_list.first().cloned() {
                proposal_list.remove(0);
                // checking for existence of husband
                if let Some(current_partner) = engaged.get(&woman).cloned() {
                    let men_list = &women_preferences[&woman];

                    // checking if the current partner is better than the new partner
                    if men_list.iter().position(|m| m == &current_partner).unwrap() > men_list.iter().position(|g| g == &man).unwrap() {
                        //prefers new person, dumping old partner
                        engaged.insert(woman.clone(), man.clone());

                        // free the current partner
                        free_men.push(current_partner.clone());
                    }
                    else {
                        // prefers current partner, so no change, adding man back to list
                        free_men.push(man.clone());
                    }
                }
                // no current partner, so engage
                else {
                    engaged.insert(woman.clone(),man.clone());
                }
            }
        }
    }
engaged
}

fn check_engagement(
    engaged: &HashMap<String, String>,
    men_preferences: &HashMap<String, Vec<String>>,
    women_preferences: &HashMap<String, Vec<String>>,
) -> bool {
    let inverse_engaged: HashMap<String, String> = engaged.iter().map(|(k, v)| (v.clone(), k.clone())).collect();

    for (wife, husband) in engaged {
        let women_prefers = &women_preferences[wife];
        let better_candidates_woman: Vec<&String> = women_prefers.iter().take_while(|&m| m != husband).collect();

        let man_prefers = &men_preferences[husband];
        let better_candidates_man: Vec<&String> = man_prefers.iter().take_while(|&g| g != wife).collect();

        for man in better_candidates_woman {
            if let Some(engaged_gal) = inverse_engaged.get(man) {
                let preferred_women = &men_preferences[man];

                if preferred_women.iter().position(|w| w == engaged_gal).unwrap() > preferred_women.iter().position(|w| w == wife).unwrap() {
                    println!("{} and {} like each other better than their present partners: {} and {}, respectively",
                        wife, man, husband, engaged_gal);
                    return false;
                }
            }
        }

        for woman in better_candidates_man {
            if let Some(engaged_guy) = engaged.get(woman) {
                let preferred_men = &women_preferences[woman];

                if preferred_men.iter().position(|m| m == engaged_guy).unwrap() > preferred_men.iter().position(|m| m == husband).unwrap() {
                    println!("{} and {} like each other better than their present partners: {} and {}, respectively",
                        husband,woman, wife, engaged_guy);
                    return false;
                }
            }
        }
    }
    true
}
fn main() {
    let mut men_preferences: HashMap<String, Vec<String>> = [
        ("abe", vec!["abi", "eve", "cath", "ivy", "jan", "dee", "fay", "bea", "hope", "gay"]),
        ("bob", vec!["cath", "hope", "abi", "dee", "eve", "fay", "bea", "jan", "ivy", "gay"]),
        ("col", vec!["hope", "eve", "abi", "dee", "bea", "fay", "ivy", "gay", "cath", "jan"]),
        ("dan", vec!["ivy", "fay", "dee", "gay", "hope", "eve", "jan", "bea", "cath", "abi"]),
        ("ed", vec!["jan", "dee", "bea", "cath", "fay", "eve", "abi", "ivy", "hope", "gay"]),
        ("fred", vec!["bea", "abi", "dee", "gay", "eve", "ivy", "cath", "jan", "hope", "fay"]),
        ("gav", vec!["gay", "eve", "ivy", "bea", "cath", "abi", "dee", "hope", "jan", "fay"]),
        ("hal", vec!["abi", "eve", "hope", "fay", "ivy", "cath", "jan", "bea", "gay", "dee"]),
        ("ian", vec!["hope", "cath", "dee", "gay", "bea", "abi", "fay", "ivy", "jan", "eve"]),
        ("jon", vec!["abi", "fay", "jan", "gay", "eve", "bea", "dee", "cath", "ivy", "hope"]),
    ].iter().map(|(k, v)| (k.to_string(), v.iter().map(|&s| s.to_string()).collect())).collect();

    let women_preferences: HashMap<String, Vec<String>> = [
        ("abi", vec!["bob", "fred", "jon", "gav", "ian", "abe", "dan", "ed", "col", "hal"]),
        ("bea", vec!["bob", "abe", "col", "fred", "gav", "dan", "ian", "ed", "jon", "hal"]),
        ("cath", vec!["fred", "bob", "ed", "gav", "hal", "col", "ian", "abe", "dan", "jon"]),
        ("dee", vec!["fred", "jon", "col", "abe", "ian", "hal", "gav", "dan", "bob", "ed"]),
        ("eve", vec!["jon", "hal", "fred", "dan", "abe", "gav", "col", "ed", "ian", "bob"]),
        ("fay", vec!["bob", "abe", "ed", "ian", "jon", "dan", "fred", "gav", "col", "hal"]),
        ("gay", vec!["jon", "gav", "hal", "fred", "bob", "abe", "col", "ed", "dan", "ian"]),
        ("hope", vec!["gav", "jon", "bob", "abe", "ian", "dan", "hal", "ed", "col", "fred"]),
        ("ivy", vec!["ian", "col", "hal", "gav", "fred", "bob", "abe", "ed", "jon", "dan"]),
        ("jan", vec!["ed", "hal", "gav", "abe", "bob", "jon", "col", "ian", "fred", "dan"]),
    ].iter().map(|(k, v)| (k.to_string(), v.iter().map(|&s| s.to_string()).collect())).collect();

    println!("\nEngagements:");
    let engaged = matchmaker(&men_preferences, &women_preferences);
    println!("  {:?}", engaged.clone());

    println!("\nCouples:");
    for (gal, guy) in engaged.iter() {
        println!("  {} is engaged to {}", gal, guy);
    }

    println!("\nEngagement stability check {}",
        if check_engagement(&engaged, &men_preferences, &women_preferences) { "PASSED" } else { "FAILED" });

    println!("\n\nSwapping two fiances to introduce an error");
    let women: Vec<String> = women_preferences.keys().cloned().collect();


    let mut engaged = engaged;
    let (woman1, woman2) = (women[0].clone(), women[1].clone());
    let temp = engaged[&woman1].clone();

    println!("  {} is now engaged to {}", &woman1, engaged[&woman1]);

    engaged.insert(woman1.clone(), engaged[&woman2].clone());
    engaged.insert(woman2.clone(), temp);


    println!("\nEngagement stability check {}",
             if check_engagement(&engaged, &men_preferences, &women_preferences) { "PASSED" } else { "FAILED" });
}
