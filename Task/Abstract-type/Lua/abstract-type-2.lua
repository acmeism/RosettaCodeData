A = class()         -- New class A inherits BaseClass by default
AA = A:class()      -- New class AA inherits from existing class A
B = abstractClass() -- New abstract class B
BB = B:class()      -- BB is not abstract
A:new()             -- Okay: New class instance
AA:new()            -- Okay: New class instance
B:new()             -- Error: B is abstract
BB:new()            -- Okay: BB is not abstract
