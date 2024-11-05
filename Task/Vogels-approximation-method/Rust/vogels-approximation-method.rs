struct Vogel {
    supply: Vec<i32>,
    demand: Vec<i32>,
    costs: Vec<Vec<i32>>,
    n_rows: i32,
    n_cols: i32,
    row_done: Vec<bool>,
    col_done: Vec<bool>,
}

impl Vogel {
    fn approximate(&mut self) {
        let mut results = vec![vec![0_i32; self.n_cols as usize]; self.n_rows as usize];
        let mut supply_remaining = self.supply.iter().sum::<i32>();
        let mut total_cost = 0;
        while supply_remaining > 0 {
            let cell = self.next_cell();
            let r = cell[0];
            let c = cell[1];
            let q = if self.demand[c] < self.supply[r] {
                self.demand[c]
            } else {
                self.supply[r]
            };
            self.demand[c] -= q;
            if self.demand[c] == 0 {
                self.col_done[c] = true;
            }
            self.supply[r] -= q;
            if self.supply[r] == 0 {
                self.row_done[r] = true;
            }
            results[r][c] = q;
            supply_remaining -= q;
            total_cost += q * self.costs[r][c];
        }

        println!("    A   B   C   D   E");
        for (i, result) in results.iter().enumerate() {
            print!("{}", ('W' as u8 + i as u8) as char);
            for item in result {
                print!("  {:>2}", item);
            }
            println!();
        }
        println!("\nTotal Cost = {}", total_cost);
    }

    fn next_cell(&mut self) -> Vec<usize> {
        let res1 = self.max_penalty(self.n_rows, self.n_cols, true);
        let res2 = self.max_penalty(self.n_cols, self.n_rows, false);
        if res1[3] == res2[3] {
            return if res1[2] < res2[2] { res1 } else { res2 };
        }
        return if res1[3] > res2[3] { res2 } else { res1 };
    }

    fn max_penalty(&mut self, len1: i32, len2: i32, is_row: bool) -> Vec<usize> {
        let mut md = i32::MIN;
        let mut pc = -1_i32;
        let mut pm = -1_i32;
        let mut mc = -1;
        for i in 0..len1 as usize {
            if is_row && !self.row_done[i] || !is_row && !self.col_done[i] {
                let mut min1 = i32::MAX;
                let mut min2 = min1;
                let mut min_p = -1_i32;
                for j in 0..len2 as usize {
                    if is_row && !self.col_done[j] || !is_row && !self.row_done[j] {
                        let c = if is_row {
                            self.costs[i][j]
                        } else {
                            self.costs[j][i]
                        };
                        if c < min1 {
                            min2 = min1;
                            min1 = c;
                            min_p = j as i32;
                        } else if c < min2 {
                            min2 = c;
                        }
                    }
                }
                let diff = min2 - min1;
                if diff > md {
                    md = diff; // max diff
                    pm = i as i32; // pos of max diff
                    mc = min1; // min cost
                    pc = min_p; // pos of min cost
                }
            }
        }
        return if is_row {
            vec![pm as usize, pc as usize, mc as usize, md as usize]
        } else {
            vec![pc as usize, pm as usize, mc as usize, md as usize]
        };
    }
}

fn main() {
    let mut test = Vogel {
        supply: vec![50, 60, 50, 50],
        demand: vec![30, 20, 70, 30, 60],
        costs: vec![
            vec![16, 16, 13, 22, 17],
            vec![14, 14, 13, 19, 15],
            vec![19, 19, 20, 23, 50],
            vec![50, 12, 50, 15, 11],
        ],
        n_rows: 4,
        n_cols: 5,
        row_done: vec![false; 4],
        col_done: vec![false; 5],
    };
    test.approximate();
}
