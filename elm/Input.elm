module Input (actions) where
import Model (..)
import Mouse
import Window
import Keyboard as K

actions : Signal Action
actions = merges [mouseUp, mouseDown, mouseMove, toggleProjections]

toggleProjections : Signal Action
toggleProjections = sampleOn K.space (constant ToggleProjections)

mouseUp = let down = keepIf not False Mouse.isDown
          in Mouseup <~ sampleOn down currentPoint

mouseDown = let down = keepIf identity True Mouse.isDown
            in Mousedown <~ sampleOn down currentPoint

mouseMove = Mousemove <~ currentPoint

currentPoint : Signal Point
currentPoint = normalize <~ dimensions' ~ position'

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
