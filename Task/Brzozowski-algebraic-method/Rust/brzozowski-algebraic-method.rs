//use std::fmt;

#[derive(Clone)]
enum RegularExpression {
    EmptyExpr,
    EpsilonExpr,
    CarExpr(char),
    UnionExpr(Box<RegularExpression>, Box<RegularExpression>),
    ConcatExpr(Box<RegularExpression>, Box<RegularExpression>),
    StarExpr(Box<RegularExpression>),
}

impl RegularExpression {
    fn simplify(&self) -> RegularExpression {
        match self {
            RegularExpression::EmptyExpr => RegularExpression::EmptyExpr,
            RegularExpression::EpsilonExpr => RegularExpression::EpsilonExpr,
            RegularExpression::CarExpr(c) => RegularExpression::CarExpr(*c),
            RegularExpression::UnionExpr(e, f) => {
                let se = e.simplify();
                let sf = f.simplify();
                if se.equals(&sf) {
                    se
                } else if se.is_empty() {
                    sf
                } else if sf.is_empty() {
                    se
                } else {
                    RegularExpression::UnionExpr(Box::new(se), Box::new(sf))
                }
            }
            RegularExpression::ConcatExpr(e, f) => {
                let se = e.simplify();
                let sf = f.simplify();
                if se.is_epsilon() {
                    sf
                } else if sf.is_epsilon() {
                    se
                } else if se.is_empty() || sf.is_empty() {
                    RegularExpression::EmptyExpr
                } else {
                    RegularExpression::ConcatExpr(Box::new(se), Box::new(sf))
                }
            }
            RegularExpression::StarExpr(e) => {
                let se = e.simplify();
                if se.is_empty() || se.is_epsilon() {
                    RegularExpression::EpsilonExpr
                } else {
                    RegularExpression::StarExpr(Box::new(se))
                }
            }
        }
    }

    fn sprint_re(&self) -> String {
        match self {
            RegularExpression::EmptyExpr => "0".to_string(),
            RegularExpression::EpsilonExpr => "1".to_string(),
            RegularExpression::CarExpr(c) => c.to_string(),
            RegularExpression::UnionExpr(e, f) => format!("{}+{}", e.sprint_re(), f.sprint_re()),
            RegularExpression::ConcatExpr(e, f) => {
                format!("({})({})", e.sprint_re(), f.sprint_re())
            }
            RegularExpression::StarExpr(e) => format!("({})*", e.sprint_re()),
        }
    }

    fn equals(&self, other: &RegularExpression) -> bool {
        match (self, other) {
            (RegularExpression::EmptyExpr, RegularExpression::EmptyExpr) => true,
            (RegularExpression::EpsilonExpr, RegularExpression::EpsilonExpr) => true,
            (RegularExpression::CarExpr(c1), RegularExpression::CarExpr(c2)) => c1 == c2,
            (RegularExpression::UnionExpr(e1, f1), RegularExpression::UnionExpr(e2, f2)) => {
                (e1.equals(e2) && f1.equals(f2)) || (e1.equals(f2) && f1.equals(e2))
            }
            (RegularExpression::ConcatExpr(e1, f1), RegularExpression::ConcatExpr(e2, f2)) => {
                e1.equals(e2) && f1.equals(f2)
            }
            (RegularExpression::StarExpr(e1), RegularExpression::StarExpr(e2)) => e1.equals(e2),
            _ => false,
        }
    }

    fn is_empty(&self) -> bool {
        matches!(self, RegularExpression::EmptyExpr)
    }

    fn is_epsilon(&self) -> bool {
        matches!(self, RegularExpression::EpsilonExpr)
    }
}

fn recursive_simplify(expr: &RegularExpression, depth: usize) -> RegularExpression {
    if depth > 200 {
        expr.clone()
    } else {
        let simplified = expr.simplify();
        if simplified.equals(expr) {
            simplified
        } else {
            recursive_simplify(&simplified, depth + 1)
        }
    }
}

fn brzozowski(
    a: &[Vec<RegularExpression>],
    b: &[RegularExpression],
) -> RegularExpression {
    let m = a.len();
    let mut temp_a = a.to_vec();
    let mut temp_b = b.to_vec();

    for n in (0..m).rev() {
        temp_b[n] = RegularExpression::ConcatExpr(
            Box::new(RegularExpression::StarExpr(Box::new(temp_a[n][n].clone()))),
            Box::new(temp_b[n].clone()),
        );

        for j in 0..n {
            temp_a[n][j] = RegularExpression::ConcatExpr(
                Box::new(RegularExpression::StarExpr(Box::new(temp_a[n][n].clone()))),
                Box::new(temp_a[n][j].clone()),
            );
        }

        for i in 0..n {
            temp_b[i] = RegularExpression::UnionExpr(
                Box::new(temp_b[i].clone()),
                Box::new(RegularExpression::ConcatExpr(
                    Box::new(temp_a[i][n].clone()),
                    Box::new(temp_b[n].clone()),
                )),
            );
            for j in 0..n {
                temp_a[i][j] = RegularExpression::UnionExpr(
                    Box::new(temp_a[i][j].clone()),
                    Box::new(RegularExpression::ConcatExpr(
                        Box::new(temp_a[i][n].clone()),
                        Box::new(temp_a[n][j].clone()),
                    )),
                );
            }
        }

        for i in 0..n {
            temp_a[i][n] = RegularExpression::EmptyExpr;
        }
    }

    temp_b[0].clone()
}

fn main() {
    // Define the NFA transition matrix a
    let mut a = vec![vec![RegularExpression::EmptyExpr; 3]; 3];

    a[0][0] = RegularExpression::EmptyExpr;
    a[0][1] = RegularExpression::CarExpr('a');
    a[0][2] = RegularExpression::CarExpr('b');

    a[1][0] = RegularExpression::CarExpr('b');
    a[1][1] = RegularExpression::EmptyExpr;
    a[1][2] = RegularExpression::CarExpr('a');

    a[2][0] = RegularExpression::CarExpr('a');
    a[2][1] = RegularExpression::CarExpr('b');
    a[2][2] = RegularExpression::EmptyExpr;

    // Define the initial state vector b
    let b = vec![
        RegularExpression::EpsilonExpr,
        RegularExpression::EmptyExpr,
        RegularExpression::EmptyExpr,
    ];

    // Apply Brzozowski's algorithm
    let dfa_expr = brzozowski(&a, &b);

    // Print the regular expression
    println!("{}\n", dfa_expr.sprint_re());

    // Apply recursive simplification
    let simplified_dfa = recursive_simplify(&dfa_expr, 0);
    println!("{}", simplified_dfa.sprint_re());
}
