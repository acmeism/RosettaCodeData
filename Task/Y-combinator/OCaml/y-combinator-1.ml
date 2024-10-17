let fix f g = (fun x a -> f (x x) a) (fun x a -> f (x x) a) g
