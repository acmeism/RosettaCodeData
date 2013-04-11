class Animal {}
class Dog is Animal {}
class Cat is Animal {}
class Lab is Dog {}
class Collie is Dog {}

say ~Collie.^parents;     # undefined type object
say ~Collie.new.^parents; # instantiated object
