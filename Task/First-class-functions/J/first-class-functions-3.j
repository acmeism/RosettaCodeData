   train  =. (<'`:')(0:`)(,^:)&6   NB. Producing the function  train    corresponding to the functional `:6
   inverse=. (<'^:')(0:`)(,^:)&_1  NB. Producing the function  inverse  corresponding to the functional ^:_1
   compose=. (<'@:')(0:`)(,^:)     NB. Producing the function  compose  corresponding to the functional @:
   an     =. <@:((,'0') ; ])       NB. Producing the atomic representation of a noun
   of     =. train@:([ ; an)       NB. Evaluating a function for an argument
   box    =. < @: train"0          NB. Producing a boxed list of the trains of the components

   ]A =. box (1&o.)`(2&o.)`(^&3)   NB. Producing a boxed list containing the Sin, Cos and Cubic functions
┌────┬────┬───┐
│1&o.│2&o.│^&3│
└────┴────┴───┘
   ]B =. inverse &.> A             NB. Producing their inverses
┌────────┬────────┬───────┐
│1&o.^:_1│2&o.^:_1│^&3^:_1│
└────────┴────────┴───────┘
   ]BA=. B compose &.> A           NB. Producing the compositions of the functions and their inverses
┌────────────────┬────────────────┬──────────────┐
│1&o.^:_1@:(1&o.)│2&o.^:_1@:(2&o.)│^&3^:_1@:(^&3)│
└────────────────┴────────────────┴──────────────┘
   BA of &> 0.5                    NB. Evaluating the compositions at 0.5
0.5 0.5 0.5
