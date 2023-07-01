{-# LANGUAGE GeneralizedNewtypeDeriving #-}

import Data.List (sort)

data Vec = Vec Double Double

vCross, vDot :: Vec -> Vec -> Double
vCross (Vec a b) (Vec c d) = a*d - b*c
vDot (Vec a b) (Vec c d) = a*c + b*d

vAdd, vSub :: Vec -> Vec -> Vec
vAdd (Vec a b) (Vec c d) = Vec (a + c) (b + d)
vSub (Vec a b) (Vec c d) = Vec (a - c) (b - d)

vLen :: Vec -> Double
vLen x = sqrt $ vDot x x

vDist :: Vec -> Vec -> Double
vDist a b = vLen (a `vSub` b)

vScale :: Double -> Vec -> Vec
vScale s (Vec x y) = Vec (x * s) (y * s)

vNorm :: Vec -> Vec
vNorm v@(Vec x y) = Vec (x / l) (y / l) where l = vLen v


newtype Angle = A Double
    deriving (Eq, Ord, Num, Fractional)

aPi = A pi

vAngle :: Vec -> Angle
vAngle (Vec x y) = A (atan2 y x)

aNorm :: Angle -> Angle
aNorm a | a > aPi   = a - aPi * 2
        | a < -aPi  = a + aPi * 2
        | otherwise = a


data Circle = Circle Double Double Double
    deriving (Eq)

circleCross :: Circle -> Circle -> [Angle]
circleCross (Circle x0 y0 r0) (Circle x1 y1 r1)
    | d >= r0 + r1 || d <= abs(r0 - r1) = []
    | otherwise = map aNorm [ang - da, ang + da]
        where
            d = vDist (Vec x0 y0) (Vec x1 y1)
            s = (r0 + r1 + d) / 2
            a = sqrt $ s * (s - d) * (s - r0) * (s - r1)
            h = 2 * a / d
            dr = Vec (x1 - x0) (y1 - y0)
            dx = vScale (sqrt $ r0 ^ 2 - h ^ 2) $ vNorm dr
            ang = if r0 ^ 2 + d ^ 2 > r1 ^ 2
                    then vAngle dr
                    else aPi + vAngle dr
            da = A (asin (h / r0))


-- Angles of the start and end points of the circle arc.
data Angle2 = Angle2 Angle Angle

data Arc = Arc Circle Angle2

arcPoint :: Circle -> Angle -> Vec
arcPoint (Circle x y r) (A a) =
    vAdd (Vec x y) (Vec (r * cos a) (r * sin a))

arcStart, arcMid, arcEnd, arcCenter :: Arc -> Vec
arcStart  (Arc c (Angle2 a0 a1)) = arcPoint c a0
arcMid    (Arc c (Angle2 a0 a1)) = arcPoint c ((a0 + a1) / 2)
arcEnd    (Arc c (Angle2 a0 a1)) = arcPoint c a1
arcCenter (Arc (Circle x y r) _) = Vec x y

arcArea :: Arc -> Double
arcArea (Arc (Circle _ _ r) (Angle2 a0 a1)) = r ^ 2 * aDiff / 2
    where (A aDiff) = a1 - a0


splitCircles :: [Circle] -> [Arc]
splitCircles cs = filter (not . inAnyCircle) arcs where
    cSplit :: (Circle, [Angle]) -> [Arc]
    cSplit (c, angs) =
        zipWith Arc (repeat c) $ zipWith Angle2 angs $ tail angs

    -- If an arc that was part of one circle is inside *another* circle,
    -- it will not be part of the zero-winding path, so reject it.
    inCircle :: (Vec, Circle) -> Circle -> Bool
    inCircle (Vec x0 y0, c1) c2@(Circle x y r) =
        c1 /= c2 && vDist (Vec x0 y0) (Vec x y) < r

    f :: Circle -> (Circle, [Angle])
    f c = (c, sort $ [-aPi, aPi] ++ (concatMap (circleCross c) cs))
    cAngs = map f cs
    arcs = concatMap cSplit cAngs

    inAnyCircle :: Arc -> Bool
    inAnyCircle arc@(Arc c _) = any (inCircle (arcMid arc, c)) cs


{-
Given a list of arcs, build sets of closed paths from them.
If one arc's end point is no more than 1e-4 from another's
start point, they are considered connected.  Since these
start/end points resulted from intersecting circles earlier,
they *should* be exactly the same, but floating point
precision may cause small differences, hence the 1e-4 error
margin.  When there are genuinely different intersections
closer than this margin, the method will backfire, badly.
-}
makePaths :: [Arc] -> [[Arc]]
makePaths arcs = joinArcs [] arcs where
    joinArcs :: [Arc] -> [Arc] -> [[Arc]]
    joinArcs a [] = [a]
    joinArcs [] (x:xs) = joinArcs [x] xs
    joinArcs a (x:xs)
        | vDist (arcStart (head a)) (arcEnd (last a)) < 1e-4
            = a : joinArcs [] (x:xs)
        | vDist (arcEnd (last a)) (arcStart x) < 1e-4
            = joinArcs (a ++ [x]) xs
        | otherwise = joinArcs a (xs ++ [x])


pathArea :: [Arc] -> Double
pathArea arcs = a + polylineArea e where
    (a, e) = foldl f (0, []) arcs
    f (a, e) arc = (a + arcArea arc, e ++ [arcCenter arc, arcEnd arc])


-- Slice N-polygon into N-2 triangles.
polylineArea :: [Vec] -> Double
polylineArea (v:vs) = sum $ zipWith (triArea v) vs (tail vs)
    where triArea a b c = ((b `vSub` a) `vCross` (c `vSub` b)) / 2


circlesArea :: [Circle] -> Double
circlesArea = sum . map pathArea . makePaths . splitCircles


circles :: [Circle]
circles = [Circle ( 1.6417233788) ( 1.6121789534) 0.0848270516,
           Circle (-1.4944608174) ( 1.2077959613) 1.1039549836,
           Circle ( 0.6110294452) (-0.6907087527) 0.9089162485,
           Circle ( 0.3844862411) ( 0.2923344616) 0.2375743054,
           Circle (-0.2495892950) (-0.3832854473) 1.0845181219,
           Circle ( 1.7813504266) ( 1.6178237031) 0.8162655711,
           Circle (-0.1985249206) (-0.8343333301) 0.0538864941,
           Circle (-1.7011985145) (-0.1263820964) 0.4776976918,
           Circle (-0.4319462812) ( 1.4104420482) 0.7886291537,
           Circle ( 0.2178372997) (-0.9499557344) 0.0357871187,
           Circle (-0.6294854565) (-1.3078893852) 0.7653357688,
           Circle ( 1.7952608455) ( 0.6281269104) 0.2727652452,
           Circle ( 1.4168575317) ( 1.0683357171) 1.1016025378,
           Circle ( 1.4637371396) ( 0.9463877418) 1.1846214562,
           Circle (-0.5263668798) ( 1.7315156631) 1.4428514068,
           Circle (-1.2197352481) ( 0.9144146579) 1.0727263474,
           Circle (-0.1389358881) ( 0.1092805780) 0.7350208828,
           Circle ( 1.5293954595) ( 0.0030278255) 1.2472867347,
           Circle (-0.5258728625) ( 1.3782633069) 1.3495508831,
           Circle (-0.1403562064) ( 0.2437382535) 1.3804956588,
           Circle ( 0.8055826339) (-0.0482092025) 0.3327165165,
           Circle (-0.6311979224) ( 0.7184578971) 0.2491045282,
           Circle ( 1.4685857879) (-0.8347049536) 1.3670667538,
           Circle (-0.6855727502) ( 1.6465021616) 1.0593087096,
           Circle ( 0.0152957411) ( 0.0638919221) 0.9771215985]

main = print $ circlesArea circles
