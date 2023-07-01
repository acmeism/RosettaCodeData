functor
import Application System
define
   ArgSpec =
   record(
      c(type:string single      %% option "--c" expects a string, may only occur once,
	optional:false char:&c) %% is not optional and has a shortcut "-c"
	
      h(type:string single      %% option "--h" expects a string, may only occur once,
	default:"default h"     %% is optional and has a default value if not given
	char:&h)                %% and has a shortcut "-h"
      )
   Args = {Application.getArgs ArgSpec}
   {System.showInfo Args.c}
   {System.showInfo Args.h}
   {Application.exit 0}
end
