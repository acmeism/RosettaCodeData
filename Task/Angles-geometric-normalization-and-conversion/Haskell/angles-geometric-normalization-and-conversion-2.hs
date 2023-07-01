-- radians
newtype Rad = Rad Double
  deriving (Eq, Ord, Num, Real, Fractional, RealFrac, Floating)

instance Show Rad where
  show (Rad 0) = printf "∠0"
  show (Rad r) = printf "∠%.3f" r

instance Angle Rad where
  fullTurn = Rad 2*pi
  mkAngle = Rad
  value (Rad r) = r

-- degrees
newtype Deg = Deg Double
  deriving (Eq, Ord, Num, Real, Fractional, RealFrac, Floating)

instance Show Deg where
  show (Deg 0) = printf "0°"
  show (Deg d) =  printf "%.3g°" d

instance Angle Deg where
  fullTurn = Deg 360
  mkAngle = Deg
  value (Deg d) = d

-- grads
newtype Grad = Grad Double
  deriving (Eq, Ord, Num, Real, Fractional, RealFrac, Floating)

instance Show Grad where
  show (Grad 0) = printf "0g"
  show (Grad g) = printf "%.3gg" g

instance Angle Grad where
  fullTurn = Grad 400
  mkAngle = Grad
  value (Grad g) = g

-- mils
newtype Mil = Mil Double
  deriving (Eq, Ord, Num, Real, Fractional, RealFrac, Floating)

instance Show Mil where
  show (Mil 0) = printf "0m"
  show (Mil m) =  printf "%.3gm" m

instance Angle Mil where
  fullTurn = Mil 6400
  mkAngle = Mil
  value (Mil m) = m


-- example of non-linear angular unit
newtype Slope = Slope Double
  deriving (Eq, Ord, Num, Real, Fractional, RealFrac, Floating)

instance Show Slope where
  show (Slope 0) = printf "0%"
  show (Slope m) = printf "%.g" (m * 100) ++ "%"

instance Angle Slope where
  fullTurn = undefined
  mkAngle = Slope
  value (Slope t) = t
  toTurn   = toTurn @Rad . angle . atan . value
  fromTurn = angle . tan . value . fromTurn @Rad
  normalize = id
