use keyed_priority_queue::KeyedPriorityQueue;
use std::cmp::{Ord, Ordering, PartialOrd, Reverse};

static CORRECT_ORDER: [u8; 16] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0];
static ROW: [i32; 16] = [0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3];
static COLUMN: [i32; 16] = [0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3];

#[derive(Debug, Clone)]
struct State {
    est_tot_moves: u8,
    moves: String,
    est_moves_rem: u8,
}

impl PartialOrd for State {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.est_tot_moves.cmp(&other.est_tot_moves))
    }
}

impl Eq for State {}

impl PartialEq for State {
    fn eq(&self, other: &Self) -> bool {
        self.est_tot_moves.cmp(&other.est_tot_moves) == Ordering::Equal
    }
}

impl Ord for State {
    fn cmp(&self, other: &Self) -> Ordering {
        self.est_tot_moves
            .partial_cmp(&other.est_tot_moves)
            .unwrap()
    }
}

impl State {
    fn init(order: &[u8; 16]) -> State {
        State {
            est_tot_moves: State::estimate_moves(&order),
            moves: String::from(""),
            est_moves_rem: 0,
        }
    }

    fn find_index(order: &[u8; 16], tile: &u8) -> usize {
        order.iter().position(|&x| x == *tile).unwrap()
    }

    fn estimate_moves(current: &[u8; 16]) -> u8 {
        let mut h = 0;
        for tile in current.iter() {
            let current_index = State::find_index(current, &tile);
            let correct_index = State::find_index(&CORRECT_ORDER, &tile);
            h += ((COLUMN[current_index] - COLUMN[correct_index]).abs()
                + (ROW[current_index] - ROW[correct_index]).abs()) as u8;
        }
        h
    }

    fn make_move(
        &self,
        order: &[u8; 16],
        dir: fn(usize, [u8; 16]) -> ([u8; 16], String),
    ) -> ([u8; 16], State) {
        let est_moves_rem = State::estimate_moves(order);
        let (new_order, from) = dir(State::find_index(order, &0), *order);
        let moves = format!("{}{}", self.moves, from);
        let new_state = State {
            est_tot_moves: moves.len() as u8 + est_moves_rem,
            moves,
            est_moves_rem,
        };
        return (new_order, new_state);
    }

    fn left(index: usize, mut order: [u8; 16]) -> ([u8; 16], String) {
        order.swap(index, index - 1);
        return (order, String::from("l"));
    }

    fn right(index: usize, mut order: [u8; 16]) -> ([u8; 16], String) {
        order.swap(index, index + 1);
        return (order, String::from("r"));
    }

    fn up(index: usize, mut order: [u8; 16]) -> ([u8; 16], String) {
        order.swap(index, index - 4);
        return (order, String::from("u"));
    }

    fn down(index: usize, mut order: [u8; 16]) -> ([u8; 16], String) {
        order.swap(index, index + 4);
        return (order, String::from("d"));
    }

    fn children(&self, order: &[u8; 16]) -> Vec<([u8; 16], State)> {
        let index = State::find_index(order, &0);
        let mut new_states: Vec<([u8; 16], State)> = Vec::new();
        if COLUMN[index] > 0 {
            new_states.push(self.make_move(order, State::left))
        }
        if COLUMN[index] < 3 {
            new_states.push(self.make_move(order, State::right))
        }
        if ROW[index] > 0 {
            new_states.push(self.make_move(order, State::up))
        }
        if ROW[index] < 3 {
            new_states.push(self.make_move(order, State::down))
        }
        new_states
    }
}

fn main() {
    let mut open_states = KeyedPriorityQueue::<[u8; 16], Reverse<State>>::new();
    let start_order = [15, 14, 1, 6, 9, 11, 4, 12, 0, 10, 7, 3, 13, 8, 5, 2];
    // let start_order = [0, 1, 2, 3, 5, 6, 7, 4, 9, 10, 11, 8, 13, 14, 15, 12];
    open_states.push(start_order, Reverse(State::init(&start_order)));
    let mut closed_states = KeyedPriorityQueue::<[u8; 16], Reverse<State>>::new();

    'outer: while let Some((parent_order, Reverse(parent_state))) = open_states.pop() {
        for (child_order, child_state) in parent_state.children(&parent_order) {
            match (
                open_states.get_priority(&child_order).as_ref(),
                closed_states.get_priority(&child_order).as_ref(),
            ) {
                (None, None) => {
                    if child_order == CORRECT_ORDER {
                        println!("There are {} entries in the open list.", open_states.len());
                        println!(
                            "There are {} entries in the closed list.",
                            closed_states.len()
                        );
                        println!(
                            "Reaching the final board took {} moves.",
                            child_state.moves.len()
                        );
                        println!("The moves used were {}.", child_state.moves);
                        println!(
                            "The final order is:\n{:?}\n{:?}\n{:?}\n{:?}.",
                            &child_order[0..4],
                            &child_order[4..8],
                            &child_order[8..12],
                            &child_order[12..16]
                        );
                        break 'outer;
                    }
                    open_states.push(child_order, Reverse(child_state.clone()));
                }
                (Some(&Reverse(open_state)), None)
                    if open_state.moves.len() > child_state.moves.len() =>
                {
                    open_states.set_priority(&child_order, Reverse(child_state.clone()));
                }
                // (None, Some(&Reverse(closed_state))) if closed_state.moves.len() > child_state.moves.len() => {
                //     closed_states.remove_item(&child_order);
                //     open_states.push(child_order, Reverse(child_state.clone()));
                // },
                _ => {}
            };
        }
        closed_states.push(parent_order, Reverse(parent_state));
    }
}
