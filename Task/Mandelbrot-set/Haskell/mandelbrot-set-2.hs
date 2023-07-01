-- first attempt
-- putStrLn $ foldr (++) "" [ if x==(-2) then "\n" else let (a, b) = iterate (\(x', y') -> (x'^2-y'^2+x, 2*x'*y'+y)) (0, 0) !! 500 in (snd.head.filter (\(v, c)->v) $ zip ([(<0.01), (<0.025), (<0.05), (<0.1), (<0.5), (<1), (<4), (\_ -> True)] <*> [a^2 + b^2]) [".", "\'", ":", "!", "|", "}", "#", " "]) | y <- [1, 0.98 .. -1], x <- [-2, -1.98 .. 0.5]]

-- replaced iterate with foldr, modified the snd.head part and a introduced a check to stop the magnitude from exploding
-- foldr(>>)(return())[putStrLn[let(a,b)=foldr(\_(u,w)->if(u^2+w^2<4)then(u^2-w^2+x,2*u*w+y)else(u,w))(0,0)[1..500]in snd.last$(filter(\(f,v)->f)$zip(map(a^2+b^2>)[0,0.01,0.025,0.05,0.1,0.5,1,4])['.','\'',':','!','|','}','#',' '])|x<-[-2,-1.98..0.5]]|y<-[1,0.98.. -1]]

-- without different characters in the output
-- foldr(>>)(return())[putStrLn[let(a,b)=foldr(\_(u,w)->(u^2-w^2+x,2*u*w+y))(0,0)[1..500]in if a^2+b^2<4 then '*' else ' '|x<-[-2,-1.98..0.5]]|y<-[1,0.98.. -1]]

-- using mapM_ instead of foldr, bind operator instead of list comprehension and replacing 'let' with a lambda function
 -- mapM_ putStrLn $[1,0.98.. -1]>>= \y->return $[-2,-1.98..0.5]>>= \x->return (if(\(a,b)->a^2+b^2<4)(foldr(\_(u,w)->(u^2-w^2+x,2*u*w+y))(0,0)[1..500]) then '*' else ' ')

-- open GHCI > Copy and paste any of above one-liners > Hit enter
