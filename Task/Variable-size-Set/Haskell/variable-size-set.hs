import Data.Int
import Foreign.Storable

task name value = putStrLn $ name ++ ": " ++ show (sizeOf value) ++ " byte(s)"

main = do
  let i8  = 0::Int8
  let i16 = 0::Int16
  let i32 = 0::Int32
  let i64 = 0::Int64
  let int = 0::Int
  task "Int8" i8
  task "Int16" i16
  task "Int32" i32
  task "Int64" i64
  task "Int" int
