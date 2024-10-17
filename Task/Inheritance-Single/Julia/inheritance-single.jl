abstract type Animal end
abstract type Dog <: Animal end
abstract type Cat <: Animal end

struct Lab <: Dog end
struct Collie <: Dog end
