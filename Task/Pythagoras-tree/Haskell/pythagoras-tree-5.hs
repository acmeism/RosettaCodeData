--import should go to the top of the code
import Graphics.EasyPlot

--change PNG by the desired format
main = plot (PNG "pith.png") $ map (mkLine . close) squares
  where mkLine = Data2D [Style Lines, Color Black,Title ""] []
        close lst = lst ++ [head lst]
