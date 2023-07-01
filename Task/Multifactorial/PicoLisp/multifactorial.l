(de multifact (N Deg)
   (let Res N
      (while (> N Deg)
         (setq Res (* Res (dec 'N Deg))) )
      Res ) )

(for I 5
   (prin "Degree " I ":")
   (for J 10
      (prin " " (multifact J I)) )
   (prinl) )
