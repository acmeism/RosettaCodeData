package main

Animal :: struct {
  alive: bool
}

Dog :: struct {
  using animal: Animal,
  obedience_trained: bool
}

Cat :: struct {
  using animal: Animal,
  litterbox_trained: bool
}

Lab :: struct {
  using dog: Dog,
  color: string
}

Collie :: struct {
  using dog: Dog,
  catches_frisbee: bool
}

main :: proc() {
  pet : Lab

  pet.alive = true
  pet.obedience_trained = true
  pet.color = "yellow"
}
