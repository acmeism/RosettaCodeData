;;(read <default-value> <prompt>) prompts the user with a default value using the browser dialog box.
;; we play sounds to make this look like an arcade game
(lib 'web) ; (play-sound) is defined in web.lib

(define (guess-feed (msg " 🔮 Enter a number in [0...100], -1 to stop.") (n (random 100)) (user 0))
   (set! user (read user msg))
   (play-sound 'ko)
   (unless (eq? n user ) ; user is the last user answer
       (guess-feed
               (cond ;; adapt prompt according to condition
                    ((not (integer? user)) "❌ Please, enter an integer")
                    (( < user 0) (error "🌵 - It was:" n)) ; exit to top level
                    ((> n user) "Too low ...")
                    ((< n user) "Too high ..."))
              n user))
    (play-sound 'ok )
    " 🔮 Well played!!  🍒 🍇 🍓")
