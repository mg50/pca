module Input (points) where
import Model (..)
import Mouse
import Window

points : Signal [Point]
points =
  let point = normalize <~ dimensions' ~ position'
  in foldp (::) [] (sampleOn Mouse.clicks point)

dimensions' : Signal (Float, Float)
dimensions' = lift toFloat2 Window.dimensions

position' : Signal (Float, Float)
position' = lift toFloat2 Mouse.position

toFloat2 : (Int, Int) -> (Float, Float)
toFloat2 (x,y) = (toFloat x, toFloat y)

normalize : (Float, Float) -> (Float, Float) -> Point
normalize (w,h) (x,y) = let x' = x - w / 2
                            y' = h / 2 - y
                        in (x', y')
