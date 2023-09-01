begin globals
begin enum 1
  _btn1
  _btn2
  _btn3
  _sum
  _msg
  _popup
  _skill
  _human = 0
  _robot
end enum
str15 cr : cr = chr$(13)
str255 string(1) :  short who = _human
byte best(3), sum, num, skill = 1 //Medium skill
poke int @best(0), 33751297 //Initialize computer responses
end globals

local fn buildWindow
  subclass window 1,      @"21 Game in FutureBasic" , (  0,  0,640,200 )
  popupbutton _popup,, 1, @"Minimum;Medium;Maximum" , ( 80, 17,100, 32 )
  textlabel   _msg   ,    @"Original code: J. Reeve", ( 20,160,600, 32 )
  textlabel   _skill ,    @"Skill level:",            ( 20, 12, 75, 32 )
  textfield   _sum  ,,    @"0",( 530,85,90,60 )
  button      _btn1 ,,  , @"1",( 245,20,50,50 ),,NSBezelStyleRegularSquare
  button      _btn2 ,,  , @"2",( 295,20,50,50 ),,NSBezelStyleRegularSquare
  button      _btn3 ,,  , @"3",( 345,20,50,50 ),,NSBezelStyleRegularSquare
  ControlSetAlignment(    _msg, NSTextAlignmentCenter )
  ControlSetAlignment(    _sum, NSTextAlignmentCenter )
  TextFieldSetEditable(   _sum, no )
  ControlSetFontWithName( _msg,  @"Menlo", 15.0 )
  ControlSetFontWithName( _btn1, @"Menlo", 20.0 )
  ControlSetFontWithName( _btn2, @"Menlo", 20.0 )
  ControlSetFontWithName( _btn3, @"Menlo", 20.0 )
  ControlSetFontWithName( _sum,  @"Menlo", 32.0 )
  text @"menlo", 15.0
end fn

local fn show( add as byte )
  CFStringRef msg
  if (sum + add) > 21 then beep : exit fn
  button 1, who : button 2, who : button 3, who
  sum += add : cls
  ControlSetIntegerValue( _sum, sum )
  string( who ) +=  "+" + chr$( add or 48 ) + "    "
  print cr;cr;cr;string( _human );cr;cr;string( _robot )
  if sum < 21
    if who == _robot then msg = @"Your turn..." else msg = @"My turn..."
  else
    if who == _robot
      msg = @"Too bad. I win. Press any key to play again."
    else
      msg = @"Congratulations! YOU WIN! Press any key to play again."
    end if
  end if
  if peek( @string( who ) ) > 20 then textlabel _msg, msg
  who = who xor _robot
end fn

local fn play( add as byte )
  if sum + add > 21 then beep : exit fn
  fn show( add )       //Show human's play
  if sum < 21
    if (skill + maybe) > 0 then num = best(sum mod 4) else num = rnd(3)
    if sum + num > 21 then num = 21 - sum
    timerbegin 1.0, NO //wait a sec before playing
      fn show( num )   //Show computer's play
    timerend
  end if
end fn

local fn start
  sum = 0 : cls
  string( _human ) = "       You: " : string( _robot ) = "  Computer: "
  string( 1-who ) += "   "
  if who == _robot
    if skill == 2 then num = 1 else num = rnd( 3 )
    textlabel _msg, fn StringWithFormat( @"I'll start with %i.", num )
    fn show( num )
  else
    ControlSetIntegerValue( _sum, sum )
    textlabel _msg, @"You start. Type or click 1, 2, or 3."
  end if
end fn

local fn DoDialog( evt as long, tag as long)
  byte key
  select ( evt )
    case _windowKeyUp
      if sum == 21 then fn start : exit fn
      if who == _robot then exit fn
      key = intval( fn EventCharacters )
      if key > 0 && key < 4 then fn play( key )
    case _btnClick
      if tag < _popup then beep : fn play( tag ) : exit fn
      skill = popupbutton( _popup )
    case _windowWillClose : end
  end select
end fn

fn buildWindow
fn start
on dialog fn doDialog
handleevents
