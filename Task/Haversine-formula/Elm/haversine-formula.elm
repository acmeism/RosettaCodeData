haversine : ( Float, Float ) -> ( Float, Float ) -> Float
haversine ( lat1, lon1 ) ( lat2, lon2 ) =
    let
        r =
            6372.8

        dLat =
            degrees (lat2 - lat1)

        dLon =
            degrees (lon2 - lon1)

        a =
            (sin (dLat / 2))
                ^ 2
                + (sin (dLon / 2))
                ^ 2
                * cos (degrees lat1)
                * cos (degrees lat2)
    in
        r * 2 * asin (sqrt a)

view =
    Html.div []
      [ Html.text (toString (haversine ( 36.12, -86.67 ) ( 33.94, -118.4 )))
      ]
