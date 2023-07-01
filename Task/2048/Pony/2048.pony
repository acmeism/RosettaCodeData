use "term"
use "random"
use "time"

interface EdgeRow
  fun val row() : Iterator[U32] ref
  fun val inc() : I32

primitive TopRow is EdgeRow
  fun row() : Iterator[U32] ref => let r : Array[U32] box = [0,1,2,3]
    r.values()
  fun inc() : I32 => 4

primitive LeftRow is EdgeRow
  fun row() : Iterator[U32] ref => let r : Array[U32] box = [0,4,8,12]
    r.values()
  fun inc() : I32 => 1

primitive RightRow is EdgeRow
  fun row() : Iterator[U32] ref => let r : Array[U32] box = [3,7,11,15]
    r.values()
  fun inc() : I32 => -1

primitive BottomRow is EdgeRow
  fun row() : Iterator[U32] ref => let r : Array[U32] box = [12,13,14,15]
    r.values()
  fun inc() : I32 =>  -4

primitive LEFT
primitive RIGHT
primitive UP
primitive DOWN
type Move is (LEFT|RIGHT|UP|DOWN)

class  KeyboardHandler is ANSINotify
   let _game : Game tag
   new iso create(game : Game tag) => _game = game

   fun ref apply(term: ANSITerm ref, input: U8 val) =>
     if input == 113 then
       _game.quit()
       term.dispose()
     end
   fun ref left(ctrl: Bool, alt: Bool, shift: Bool)  => _game.move(LEFT)
   fun ref down(ctrl: Bool, alt: Bool, shift: Bool)  => _game.move(DOWN)
   fun ref up(ctrl: Bool, alt: Bool, shift: Bool)    => _game.move(UP)
   fun ref right(ctrl: Bool, alt: Bool, shift: Bool) => _game.move(RIGHT)

type ROW is (U32,U32,U32,U32)

primitive Merger
  fun tag apply(r : ROW) : ROW =>
    match r
    | (0,0,0,_)            => (r._4,0,0,0)
    | (0,0,_,r._3)         => (r._3<<1,0,0,0)
    | (0,0,_,_)            => (r._3,r._4,0,0)
    | (0,_,r._2,_)         => (r._2<<1,r._4,0,0)
    | (0,_,0,r._2)         => (r._2<<1,0,0,0)
    | (0,_,0,_)            => (r._2,r._4,0,0)
    | (0,_,_,r._3)         => (r._2,r._3<<1,0,0)
    | (0,_,_,_)            => (r._2,r._3,r._4,0)
    | (_, r._1, _, r._3)   => (r._1<<1, r._3<<1, 0, 0)
    | (_, r._1, 0, _)      => (r._1<<1, r._4, 0, 0)
    | (_, r._1, _, _)      => (r._1<<1, r._3, r._4, 0)
    | (_, 0,r._1, _)       => (r._1<<1,r._4,0,0)
    | (_, 0,0, r._1)       => (r._1<<1,0,0,0)
    | (_, 0,0, _)          => (r._1,r._4,0,0)
    | (_, 0,_, r._3)       => (r._1, r._3<<1,0,0)
    | (_, 0,_, _)          => (r._1, r._3,r._4,0)
    | (_,_,r._2,_)         => (r._1, r._2<<1,r._4,0)
    | (_,_,0,r._2)         => (r._1, r._2<<1,0,0)
    | (_,_,0,_)            => (r._1, r._2,r._4,0)
    | (_,_,_,r._3)         => (r._1, r._2,r._3<<1,0)
    else
       r
    end
/**
* Game actor
*/
actor Game
  embed _grid : Array[U32] = Array[U32].init(0, 16)
  let _rand : Random = MT(Time.millis())
  let _env : Env
  let _board : String ref = recover String(1024) end

  new create(env: Env)=>
    _env = env
    _add_block()
    _add_block()
    _draw()

  fun _merge(start : U32, inc : I32) : (ROW | None) =>
    var st = start.i32()
    let rval : ROW = (_get(st),             _get(st + inc),
                      _get(st + (inc * 2)), _get(st + (inc * 3)))
    let rout = Merger(rval)
    if rout is rval then None else rout end

  fun ref _update(start : U32, inc : I32) : Bool =>
    match _merge(start, inc)
    | let rout : ROW =>
        var st = start.i32()
        _set(st,             rout._1)
        _set(st +  inc,      rout._2)
        _set(st + (inc * 2), rout._3)
        _set(st + (inc * 3), rout._4)
        true
    else
      false
    end

  fun ref _shift_to(edge : EdgeRow val) : Bool =>
    var updated = false
    for r in edge.row() do
      if _update(r, edge.inc()) then
        updated = true
      end
    end
    updated

  fun _fmt(i : U32) : String =>
    match i
    | 0 => " __ "
    | 2 => "\x1B[31m  2 \x1B[0m"
    | 4 => "\x1B[32m  4 \x1B[0m"
    | 8 => "\x1B[33m  8 \x1B[0m"
    | 16 => "\x1B[34m 16 \x1B[0m"
    | 32 => "\x1B[35m 32 \x1B[0m"
    | 64 => "\x1B[36m 64 \x1B[0m"
    | 128 => "\x1B[37m128 \x1B[0m"
    | 256 => "\x1B[41m\x1B[37m256 \x1B[0m"
    | 512 => "\x1B[42m\x1B[37m512 \x1B[0m"
    | 1024 => "\x1B[43m\x1B[37m1024\x1B[0m"
    | 2048 => "\x1B[47m\x1B[35m\x1B[1m\x1B[5m2048\x1B[0m"
    else
      i.string()
    end

  fun ref _draw() =>
    let s : String ref = _board
    s.truncate(0)
    var i : U32 = 0
    repeat
      if (i % 4) == 0 then
          s.append("---------------------\n")
      end
      s.append(_fmt(_get(i)))
      s.append(" ")
      i = i + 1
      if (i % 4) == 0 then
          s.append("\n")
      end
    until i==16 end
    _env.out.print(s.string())
    _env.out.print("Arrow keys to move. Press (q)uit key to quit.")

   fun ref _set(i:(I32|U32), v : U32) =>
     try
       _grid.update(i.usize(),v)
     else
       _env.out.print("cant update!")
     end

  fun _count() : U64 =>
     var c : U64 = 0
     for v in _grid.values() do
       c = c + if v == 0 then 0 else 1 end
     end
     c

  fun ref _add_block() =>
    let c = _count()
    if c == 16 then return end

    var hit =  _rand.int(16 - c)
    var i : U32 = 0
    while i < 16 do
      if (_get(i) == 0) then
        if hit == 0 then
          _set(i, if _rand.int(10) > 0 then 2 else 4 end)
          break
        end
        hit = hit - 1
      end
      i = i + 1
    end

  fun _get(i : (I32|U32)) : U32 => try  _grid(i.usize()) else 0  end

  fun _win() : Bool =>
    for v in _grid.values() do
      if v == 2048 then return true end
    end
    false

  fun _no_moves(edge : EdgeRow val) : Bool =>
    for r in edge.row() do
      match _merge(r, edge.inc())
      | let rout : ROW =>
        if (rout._1 == 0) or (rout._2 == 0) or
            (rout._3 == 0) or (rout._4 == 0) then
              return false
        end
      end
    end
    true

  fun _lose() : Bool =>
    (_grid.size() >= 16) and
    _no_moves(LeftRow) and
    _no_moves(RightRow) and
    _no_moves(TopRow) and
    _no_moves(BottomRow)

  be quit()=>
    _env.out.print("Exiting.. some terminals may require <ctrl-c>")
    _env.exitcode(0)
    _env.input.dispose()

  be move(m: Move) =>
    let updated =
      match m
      | LEFT =>  _shift_to(LeftRow)
      | RIGHT => _shift_to(RightRow)
      | UP =>    _shift_to(TopRow)
      | DOWN =>  _shift_to(BottomRow)
      else
        false
      end

    if _win() then
      _draw()
      _env.out.print("You win :)")
      quit()
    else
      if updated then
        _add_block()
        _draw()
      end
      if _lose() then
        _env.out.print("You lose :(")
        quit()
      end
    end

actor Main
  new create(env: Env) =>
    // unit test
    ifdef "test" then
      TestMain(env)
      return
    end
    // else game
    let input : Stdin tag = env.input
    env.out.print("Welcome to ponylang-2048...")
    let game = Game(env)
    let term = ANSITerm(KeyboardHandler(game), input)

    let notify : StdinNotify iso = object iso
        let term: ANSITerm = term
        let _in: Stdin tag = input
        fun ref apply(data: Array[U8] iso) => term(consume data)
        fun ref dispose() => _in.dispose()
    end

    input(consume notify)
