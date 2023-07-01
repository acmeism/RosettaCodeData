import: emitter

: anEvent2
| e i |
   Emitter new(null) ->e
   e onEvent($myEvent, #[ "Event is signaled !" println ])
   10 loop: i [
      1000 System sleep
      $myEvent e emit
      ]
   e close ;
