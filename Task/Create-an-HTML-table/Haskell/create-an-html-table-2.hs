{-# LANGUAGE QuasiQuotes #-}

import Data.List (elemIndex)
import Text.Hamlet (shamlet, Html)
import Text.Cassius (Css, renderCss, cassius)
import Text.Blaze.Html.Renderer.String (renderHtml)
import System.Random (getStdGen, randomRs)

styles :: p -> Css
styles = [cassius|
  table, th, td
    border: 1px solid black
    border-collapse: collapse
  th, td
    padding: 15px
  th, .rowLabel
    background-color: #895
  td
    text-align: right
  |]

renderTable :: [[Int]] -> Html
renderTable xs = [shamlet|
  $doctype 5
  <html>
    <head>
      <style>
        #{renderCss $ styles undefined}
    <body>
      <table>
        <tr>
          <th>
          $forall header <- headers
            <th>#{header}
        $forall row <- xs
          <tr>
            $maybe index <- elemIndex row xs
              <td .rowLabel>#{index + 1}
            $nothing
              <td>?
            $forall cell <- row
              <td>#{cell}
  |]
 where
   headers = ['X', 'Y', 'Z']

main :: IO ()
main = renderHtml . renderTable . rowsOf 3 . take 9 <$> randomValues >>= putStrLn
 where
   rowsOf _ [] = []
   rowsOf n xs = take n xs : rowsOf n (drop n xs)
   randomValues = randomRs (1, 9999) <$> getStdGen
