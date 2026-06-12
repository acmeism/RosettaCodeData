-- only for testrun
import Text.Printf
import Control.Monad

-- The classic CIE ΔE2000 implementation, which operates on two L*a*b* colors, and returns their difference.
-- "l" ranges from 0 to 100, while "a" and "b" are unbounded and commonly clamped to the range of -128 to 127.
ciede_2000 :: [Double] -> Double
ciede_2000 [l_1, a_1, b_1, l_2, a_2, b_2] =
    -- Returns the square root so that the Delta E 2000 reflects the actual geometric
    -- distance within the color space, which ranges from 0 to approximately 185.
    sqrt (l * l + h * h + c * c + c * h * r_t)
  where
  -- Michel Leonard uses Haskell with the CIEDE2000 color-difference formula.
  -- k_l, k_c, k_h are parametric factors to be adjusted according to
  -- different viewing parameters such as textures, backgrounds...
    k_l = 1.0
    k_c = 1.0
    k_h = 1.0
    n = let x = (sqrt (a_1 * a_1 + b_1 * b_1) + sqrt (a_2 * a_2 + b_2 * b_2)) * 0.5
      -- A factor involving chroma raised to the power of 7 designed to make
      -- the influence of chroma on the total color difference more accurate.
            y = x ^ 7
        in 1.0 + 0.5 * (1.0 - sqrt (y / (y + 6103515625.0)))

    -- Since hypot is not available, sqrt is used here to calculate the
    -- Euclidean distance while avoiding overflow/underflow.
    c_1 = sqrt (a_1 * a_1 * n * n + b_1 * b_1)
    c_2 = sqrt (a_2 * a_2 * n * n + b_2 * b_2)
    -- atan2 is preferred over atan because it accurately computes the angle of
    -- a point (x, y) in all quadrants, handling the signs of both coordinates.
    h_1 = correctH $ atan2 b_1 (a_1 * n)
    h_2 = correctH $ atan2 b_2 (a_2 * n)
    correctH x = if x < 0.0 then x + 2.0 * pi else x
    -- Cross-implementation consistent rounding.
    n_0 = let x = abs $ h_2 - h_1 in if pi - 1E-14 < x && x < pi + 1E-14 then pi else x
    -- When the hue angles lie in different quadrants, the straightforward
    -- average can produce a mean that incorrectly suggests a hue angle in
    -- the wrong quadrant, the next lines handle this issue.
    h_m = let x = (h_1 + h_2) * 0.5 in if pi >= n_0 then x else x + pi
    h_d = let x = (h_2 - h_1) * 0.5 in if pi >= n_0 then x else if 0.0 < x then x - pi else x + pi
    -- GitHub Project : https://github.com/michel-leonard/ciede2000-color-matching
    p = 36.0 * h_m - 55.0 * pi
    n_2 = let x = (c_1 + c_2) * 0.5 in x ^ 7
    -- The hue rotation correction term is designed to account for the
    -- non-linear behavior of hue differences in the blue region.
    r_t = (-2.0) * sqrt (n_2 / (n_2 + 6103515625.0))
                 * sin (pi / 3.0 * exp(p * p / ((-25.0) * pi * pi)))
    n_3 = let x = (l_1 + l_2) * 0.5 in (x - 50.0) * (x - 50.0)
    -- Lightness.
    l = (l_2 - l_1) / (k_l * (1.0 + 0.015 * n_3 / sqrt (20.0 + n_3)))
    -- These coefficients adjust the impact of different harmonic
    -- components on the hue difference calculation.
    t = 1.0 + 0.24 * sin (2.0 * h_m + pi * 0.5)
            + 0.32 * sin (3.0 * h_m + 8.0 * pi / 15.0)
            - 0.17 * sin (h_m + pi / 3.0)
            - 0.20 * sin (4.0 * h_m + 3.0 * pi / 20.0)
    n_4 = c_1 + c_2
    -- Hue.
    h = 2.0 * sqrt (c_1 * c_2) * sin h_d / (k_h * (1.0 + 0.0075 * n_4 * t))
    -- Chroma.
    c = (c_2 - c_1) / (k_c * (1.0 + 0.0225 * n_4))

testdata :: [([Double],Double)]
testdata =
 [([ 73.0,   49.0,   39.4, 73.0,   49.0,   39.4 ], 0.0)
 ,([ 30.0,  -41.0, -119.1, 30.0,  -41.0, -119.0 ], 0.0134319631)
 ,([ 79.0, -117.0, -100.4, 79.5, -117.0, -100.0 ], 0.3572501235)
 ,([ 15.0,  -55.0,    6.7, 14.0,  -55.0,    7.0 ], 0.6731711696)
 ,([ 83.0,   98.0,  -59.5, 85.2,   98.0,  -59.5 ], 1.4597018301)
 ,([ 59.0,  -11.0,  -95.0, 56.3,  -11.0,  -95.0 ], 2.4566352112)
 ,([ 74.0,   -1.0,   68.6, 81.0,   -1.0,   69.0 ], 4.9755487499)
 ,([ 46.4,  125.0,    6.0, 40.0,  125.0,    6.0 ], 5.8974138376)
 ,([ 18.0,   -5.0,   68.0, 20.0,    5.0,   82.0 ], 6.8542258013)
 ,([ 35.5,  -99.0,  109.0, 25.0,  -99.0,  109.0 ], 8.1462591143)
 ,([ 59.0,   77.0,   41.5, 63.3,   77.0,   12.4 ], 13.1325726695)
 ,([ 40.0,  -92.0,    7.7, 58.0,  -92.0,   -8.0 ], 19.1411733022)
 ,([ 49.0,   -9.0,  -74.5, 51.1,   31.0,   16.0 ], 48.1082375109)
 ,([ 88.0, -124.0,   56.0, 97.0,   62.0,  -28.0 ], 63.9449872676)
 ,([ 98.0,   75.7,   11.0,  3.0,  -62.0,   11.0 ], 126.5088270078)
 ]

main :: IO ()
main = do
  putStrLn "   result        difference args"
  forM_ testdata (\(args,expected) -> do
    let res = ciede_2000 args
    printf "%15.10f, %1.2e, %s\n" res (abs $ res - expected) (show args)
    )
