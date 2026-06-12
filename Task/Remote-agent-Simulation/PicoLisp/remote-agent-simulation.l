# Global variables:
#  '*Port' is the port where the server is listening
#  '*Sock' is the TCP socket after a client connected
#  '*World' holds the current world
#  '*Agent' is the field where the agent is in
#  '*Ball' is the ball the agent is holding
#  '*Dir' is a circular list of directions (north east south west .)

(load "@lib/simul.l")

# The server port
(setq *Port (port 54545))

# Return a random Field
(de randomField ()
   (get *World (rand 1 DX) (rand 1 DY)) )

# Create a world of size 'DX' * 'DY' with 'Balls' and 'Walls'
(de makeWorld (DX DY Balls Walls)
   (when (>= Balls (* DX DY))
      (quit "Too many balls") )
   (when (>= Walls (* (dec DX) (dec DY)))
      (quit "Too many walls") )
   (for Column (setq *World (grid DX DY))          # Initialize fields
      (for This Column
         (let Color (get '(R G Y B) (rand 1 4))
            (=: field Color)                       # Set field color
            (when (ge0 (dec 'Balls))
               (until
                  (with (randomField DX DY)        # Find a field without ball
                     (unless (: ball)              # and set a ball
                        (=: ball Color) ) ) ) ) ) ) )
   (do Walls                              # Create walls
      (until
         (let
            (Field (randomField DX DY)    # Try random field
               F (if (rand T) car cdr)    # and random side
               G (if (rand T) '(car set . con) '(cdr con . set))
               Old ((car G) (F (val Field))) )
            (when Old
               ((cadr G) (F (val Field)) NIL)  # Remove connections to neighbor
               ((cddr G) (F (val Old)) NIL)
               (or
                  (reachable? Field (* DX DY))  # Field still reachable?
                  (nil                          # No: Restore connections
                     ((cadr G) (F (val Field)) Old)
                     ((cddr G) (F (val Old)) Field) ) ) ) ) ) ) )

# Test whether a field is reachable
(de reachable? (Field Fields)
   (let Visited NIL
      (recur (Field)
         (when (and Field (not (memq Field Visited)))
            (push 'Visited Field)
            (recurse (west Field))
            (recurse (east Field))
            (recurse (south Field))
            (recurse (north Field)) ) )
      (= Fields (length Visited)) ) )

# Test for ending condition
(de ending? ()
   (nor
      *Ball
      (find
         '((Column)
            (find
               '((This)
                  (and (: ball) (n== (: field) (: ball))) )
               Column ) )
         *World ) ) )

# Initialize for a new game
(de newGame (DX DY Balls Walls)
   (makeWorld DX DY Balls Walls)
   (setq
      *Agent (randomField DX DY)
      *Dir (do (rand 1 4) (rot '(north east south west .))) ) )

# Start the game server
(de gameServer (DX DY Balls Walls)
   (loop
      (setq *Sock (listen *Port))
      (NIL (fork) (close *Port))
      (close *Sock) )
   (seed *Pid)  # Ensure private random sequence
   (in *Sock
      (out *Sock (prin "A"))  # Greeting
      (when (= "A" (char (rd 1)))
         (newGame DX DY Balls Walls)
         (and *Dbg (showWorld))
         (while (rd 1)
            (out *Sock
               (case (char @)  # Command character
                  ("\^"  # Forward
                     (ifn ((car *Dir) *Agent)  # Hit wall?
                        (prin "|")             # Yes: Bump event
                        (with (setq *Agent @)  # Else go to new position
                           (prin (: field))
                           (and (: ball) (prin (lowc @))) ) ) )
                  (">"  # Turn right
                     (pop '*Dir) )
                  ("<"  # Turn left
                     (do 3 (pop '*Dir)) )
                  ("@"  # Get ball
                     (with *Agent
                        (cond
                           ((not (: ball)) (prin "s"))  # No ball in sector
                           (*Ball (prin "A"))           # Agent full
                           (T
                              (setq *Ball (: ball))
                              (=: ball) ) ) ) )
                  ("!"  # Drop ball
                     (with *Agent
                        (cond
                           ((not *Ball) (prin "a"))  # No ball in agent
                           ((: ball) (prin "S"))     # Sector full
                           (T (=: ball *Ball)
                              (off *Ball)
                              (and (ending?) (prin "+")) ) ) ) ) )  # Game over
               (prin ".") ) ) ) )  # Stop event
   (bye) )

# Visualize (debug)
(de showWorld ()
   (disp *World 0
      '((This)
         (pack
            (if (== *Agent This) "*" " ")
            (: field)
            (if (: ball) (lowc @) " ") ) ) ) )
