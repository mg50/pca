module Util where
import Array as A
import Numeric (..)
import Model (..)
import Dict as D

pointToVect (x,y) = A.fromList [x,y]

vectToPoint v = let (x::y::_) = A.toList v
                in (x,y)

radius = 5

findPoint : Point -> D.Dict Int Point -> Maybe Int
findPoint p ps =
  let go xs = case xs of
    [] -> Nothing
    (i,p')::rest -> if sqDist p p' <= radius^2
                    then Just i
                    else go rest
  in go (D.toList ps)

sqDist (x,y) (x',y') = (x-x')^2 + (y-y')^2
