module Util where
import Array as A
import Numeric (..)

pointToVect (x,y) = A.fromList [x,y]

vectToPoint v = let (x::y::_) = A.toList v
                in (x,y)
