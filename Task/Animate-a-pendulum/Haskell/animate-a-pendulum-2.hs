import Graphics.Gloss

-- Initial conditions
g_  = (-9.8)        :: Float    --Gravity acceleration
v_0 = 0             :: Float    --Initial tangential speed
a_0 = 0 / 180 * pi  :: Float    --Initial angle
dt  = 0.01          :: Float    --Time step
t_f = 15            :: Float    --Final time for data logging
l_  = 200           :: Float    --Rod length

-- Define a type to represent the pendulum:
type Pendulum = (Float, Float, Float) -- (rod length, tangential speed, angle)

-- Pendulum's initial state
initialstate :: Pendulum
initialstate = (l_, v_0, a_0)

-- Step funtion: update pendulum to new position
movePendulum :: Float -> Pendulum -> Pendulum
movePendulum dt (l,v,a) = ( l , v_2 , a + v_2 / l * dt*10 )
    where   v_2 = v + g_ * (cos a) * dt

-- Convert from Pendulum to [Picture] for display
renderPendulum :: Pendulum -> [Picture]
renderPendulum (l,v,a) = map (uncurry Translate newOrigin)
                            [ Line    [ ( 0 , 0 ) , ( l * (cos a), l * (sin a) ) ]
                            , polygon [ ( 0 , 0 ) , ( -5 , 8.66 ) , ( 5 , 8.66 ) ]
                            , Translate ( l * (cos a)) (l * (sin a)) (circleSolid (0.04*l_))
                            , Translate (-1.1*l) (-1.3*l) (Scale 0.1 0.1 (Text currSpeed))
                            , Translate (-1.1*l) (-1.3*l + 20) (Scale 0.1 0.1 (Text currAngle))
                            ]
    where   currSpeed = "Speed (pixels/s) = " ++ (show v)
            currAngle = "Angle (deg) = " ++ (show ( 90 + a / pi * 180 ) )

-- New origin to beter display the animation
newOrigin = (0, l_ / 2)

-- Calcule a proper window size (for angles between 0 and -pi)
windowSize :: (Int, Int)
windowSize = ( 300 + 2 * round (snd newOrigin)
             , 200 + 2 * round (snd newOrigin) )

-- Run simulation
main :: IO ()
main = do   --plotOnGNU
            simulate window background fps initialstate render update
                where   window      = InWindow "Animate a pendulum" windowSize (40, 40)
                        background  = white
                        fps         = round (1/dt)
                        render xs   = pictures $ renderPendulum xs
                        update _    = movePendulum
