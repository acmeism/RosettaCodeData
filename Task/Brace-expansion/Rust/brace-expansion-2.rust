fn main() {
    let input = "~/{Downloads,Pictures}/*.{jpg,gif,png}
It{{em,alic}iz,erat}e{d,}, please.
{,{,gotta have{ ,\\, again\\, }}more }cowbell!
{}} some }{,{\\\\{ edge, edge} \\,}{ cases, {here} \\\\\\\\\\}";

    for line in input.split("\n") {
        println!("{}", line);
        for line in get_item(line, 0).0 {
            println!("\t{}", line);
        }
    }
}

fn get_item(s: &str, depth: usize) -> (Vec<String>, &str) {
    let mut out = vec![String::new()];
    let mut s = s;
    while !s.is_empty() {
        let mut c = s.chars().nth(0).unwrap().to_string();
        if depth > 0 && (c == "," || c == "}") {
            return (out, s);
        }
        if c == "{" {
            let x = get_group(&s[1..], depth + 1);
            if x.is_some() {
                let (items, s_new) = x.unwrap();
                out = out
                    .iter()
                    .map(|out_item| {
                        items
                            .iter()
                            .map(|item| format!("{}{}", out_item, item))
                            .collect::<Vec<String>>()
                    })
                    .flatten()
                    .collect();
                s = s_new;
                continue;
            }
        }
        if c == "\\" && s.len() > 1 {
            s = &s[1..];
            c.push(s.chars().nth(0).unwrap());
        }
        out = out
            .iter()
            .map(|o| [o, &c[..]].concat())
            .collect::<Vec<String>>();
        s = &s[1..];
    }
    (out, s)
}

fn get_group(s: &str, depth: usize) -> Option<(Vec<String>, &str)> {
    let mut out: Vec<String> = vec![];
    let mut comma = false;
    let mut s = s;
    while !s.is_empty() {
        let (g, new_s) = get_item(s, depth);
        s = new_s;
        if s.is_empty() {
            break;
        }
        out.extend(g);
        if s.chars().nth(0).unwrap() == '}' {
            if comma {
                return Some((out, &s[1..]));
            }
            return Some((
                out.iter().map(|item| format!("{{{}}}", item)).collect(),
                &s[1..],
            ));
        }
        if s.chars().nth(0).unwrap() == ',' {
            comma = true;
            s = &s[1..];
        }
    }
    None
}
