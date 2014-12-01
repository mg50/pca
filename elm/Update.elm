module Update where
import LinearAlgebra (..)

data NonEmpty a = NonEmpty a [a]

mean : NonEmpty Vector -> Vector
mean (NonEmpty v vs) = let v' = foldr (:+:) v vs
                           len = toFloat (1 + length vs)
                       in (1/len) .*: v
