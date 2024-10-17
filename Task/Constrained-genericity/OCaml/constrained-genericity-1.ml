module type Eatable = sig
  type t
  val eat : t -> unit
end
