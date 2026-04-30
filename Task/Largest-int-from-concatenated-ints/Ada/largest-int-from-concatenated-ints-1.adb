function Order(Left, Right: Natural) return Boolean is
      ( (Img(Left) & Img(Right)) > (Img(Right) & Img(Left)) );
