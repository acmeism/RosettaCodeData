-- file: trigdeg.fs

deg2rad deg = deg*pi/180.0
rad2deg rad = rad*180.0/pi

sind = sin . deg2rad
cosd = cos . deg2rad
tand = tan . deg2rad
atand = rad2deg . atan
atan2d y x = rad2deg (atan2 y x )

avg_angle angles = atan2d y x
    where
    y = mean (map sind angles)
    x = mean (map cosd angles)

-- End of trigdeg.fs --------
