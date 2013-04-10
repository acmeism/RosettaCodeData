%screen     = Bitmap object
%startPoint = [x0,y0]
%endPoint   = [x1,y1]
%color      = [red,green,blue]

function bresenhamLine(screen,startPoint,endPoint,color)

  if( any(color > 255) )
      error 'RGB colors must be between 0 and 255';
  end

  %Check for vertical line, x0 == x1
  if( startPoint(1) == endPoint(1) )
      %Draw vertical line
      for i = (startPoint(2):endPoint(2))
          setPixel(screen,[startPoint(1) i],color);
      end
  end

  %Simplified Bresenham algorithm
  dx = abs(endPoint(1) - startPoint(1));
  dy = abs(endPoint(2) - startPoint(2));

  if(startPoint(1) < endPoint(1))
      sx = 1;
  else
      sx = -1;
  end

  if(startPoint(2) < endPoint(2))
      sy = 1;
  else
      sy = -1;
  end

  err = dx - dy;
  pixel = startPoint;

  while(true)

      screen.setPixel(pixel,color); %setPixel(x0,y0)

      if( pixel == endPoint )
          break;
      end

      e2 = 2*err;

      if( e2 > -dy )
          err = err - dy;
          pixel(1) = pixel(1) + sx;
      end

      if( e2 < dx )
          err = err + dx;
          pixel(2) = pixel(2) + sy;
      end
  end

  assignin('caller',inputname(1),screen); %saves the changes to the object
end
