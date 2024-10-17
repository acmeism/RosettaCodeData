use std::io::{self,BufRead};
extern crate rand;

enum Usermove {
    Up,
    Down,
    Left,
    Right,
}

fn print_game(field :& [[u32;4];4] ){
    println!("{:?}",&field[0] );
    println!("{:?}",&field[1] );
    println!("{:?}",&field[2] );
    println!("{:?}",&field[3] );
}

fn get_usermove()-> Usermove {
    let umove: Usermove ;
    loop{
        let mut input = String::new();
        io::stdin().read_line(&mut input).unwrap();

        match input.chars().nth(0){
            Some('a') =>{umove = Usermove::Left ;break },
            Some('w') =>{umove = Usermove::Up   ;break },
            Some('s') =>{umove = Usermove::Down ;break },
            Some('d') =>{umove = Usermove::Right;break },
            _   => {println!("input was {}: invalid character should be a,s,w or d ",input.chars().nth(0).unwrap());} ,
        }
    }
    umove
}

//this function inplements the user moves.
//for every element it looks if the element is zero
// if the element is zero it looks against the direction of the movement if any
//element is not zero then it will move it to the element its place then it will look for
//a matching element
//  if the element is not zero then it will look for a match if no match is found
// then it will look for the next element

fn do_game_step(step : &Usermove, field:&mut [[u32;4];4]){
    match *step {
        Usermove::Left =>{
            for array in field{
                for  col in 0..4 {
                    for testcol in (col+1)..4 {
                        if array[testcol] != 0 {
                            if array[col] == 0 {
                                array[col] += array[testcol];
                                array[testcol] = 0;
                            }
                            else if array[col] == array[testcol] {
                                array[col] += array[testcol];
                                array[testcol] = 0;
                                break;
                            } else {
                                break
                            }
                        }
                    }
                }
            }
        } ,
        Usermove::Right=>{
            for array in field{
                for  col in (0..4).rev() {
                    for testcol in (0..col).rev() {
                        if array[testcol] != 0 {
                            if array[col] == 0 {
                                array[col] += array[testcol];
                                array[testcol] = 0;
                            }
                            else if array[col] == array[testcol] {
                                array[col] += array[testcol];
                                array[testcol] = 0;
                                break;
                            }else {
                                break;
                            }
                        }
                    }
                }
            }
        } ,
        Usermove::Down   =>{
            for col in 0..4 {
                for row in (0..4).rev() {
                    for testrow in (0..row).rev() {
                        if field[testrow][col] != 0 {
                            if field[row][col] == 0 {
                                field[row][col] += field[testrow][col];
                                field[testrow][col] = 0;
                            } else if field[row][col] == field[testrow][col] {
                                field[row][col] += field[testrow][col];
                                field[testrow][col] = 0;
                                break;
                            }else {
                                break;
                            }

                        }
                    }
                }
            }
        } ,
        Usermove::Up =>{
            for col in 0..4 {
                for row in 0..4{
                    for testrow in (row+1)..4 {
                        if field[testrow][col] != 0 {
                            if field[row][col] == 0 {
                                field[row][col] += field[testrow][col];
                                field[testrow][col] = 0;
                            } else if field[row][col] == field[testrow][col] {
                                field[row][col] += field[testrow][col];
                                field[testrow][col] = 0;
                                break;
                            }else {
                                break;
                            }
                        }
                    }
                }
            }
        },
    }
}

fn spawn( field: &mut  [[u32;4];4]){
    loop{
        let x = rand::random::<usize>();
        if field[x % 4][(x/4)%4] == 0 {
            if x % 10 == 0 {
                field[x % 4][(x/4)%4]= 4;
            }else{
                field[x % 4][(x/4)%4]= 2;
            }
            break;
        }
    }
}


fn main() {
    let mut field : [[u32; 4];4] =  [[0;4];4];
    let mut test : [[u32; 4];4] ;
    'gameloop:loop {
        //check if there is still an open space
        test=field.clone();
        spawn(&mut field);
        //if all possible moves do not yield a change then there is no valid move left
        //and it will be game over
        for i in [Usermove::Up,Usermove::Down,Usermove::Left,Usermove::Right].into_iter(){
            do_game_step(i, &mut test);
            if test != field{
                break;//found a valid move
            }
            match *i{
                Usermove::Right=> {
                    println!("No more valid move, you lose");
                    break 'gameloop;
                },
                _=>{},
            }
        }
        print_game(&field);
        println!("move the blocks");

        test=field.clone();
        while test==field {
            do_game_step(&get_usermove(), &mut field);
        }

        for row in field.iter(){
            if row.iter().any(|x| *x == 2048){
                print_game(&field );
                println!("You Won!!");
                break;
            }
        }
    }
}
