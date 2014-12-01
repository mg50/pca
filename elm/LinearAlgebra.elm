module LinearAlgebra where
import Numeric (..)
import Array (fromList, toList, Array)
import Array as A

pcaEigenpairs : [Vector] -> [(Vector, Float)]
pcaEigenpairs vs =
  case vs of
    [] -> []
    (x::xs) -> let m = mean (NonEmpty x xs)
                   vs' = fromList <| map (\v -> v :-: m) vs
                   covariance = transpose vs' ::*:: vs'
                   {eigenvectors,eigenvalues} = eig covariance
               in zipWith (,) eigenvectors.real eigenvalues.real

mkMatrix : [[Float]] -> Matrix
mkMatrix = map fromList >> fromList

infixl 6 :+:
(:+:) : Vector -> Vector -> Vector
(:+:) v1 v2 = fromList <| zipWith (+) (toList v1) (toList v2)

infixl 6 :-:
(:-:) : Vector -> Vector -> Vector
(:-:) v1 v2 = fromList <| zipWith (-) (toList v1) (toList v2)

infixl 7 :*:
(:*:) : Vector -> Vector -> Float
(:*:) v1 v2 = sum <| zipWith (*) (toList v1) (toList v2)

infixl 8 .*:
(.*:) : Float -> Vector -> Vector
(.*:) s v = A.map (\x -> x*s) v

infixl 7 ::*:
(::*:) : Matrix -> Vector -> Vector
(::*:) m v = A.map (\v' -> v' :*: v) m

infixl 7 ::*::
(::*::) : Matrix -> Matrix -> Matrix
(::*::) = mmDot

normalize : Vector -> Vector
normalize v = let n2 = sqNorm v
              in (1 / sqrt n2) .*: v

sqNorm : Vector -> Float
sqNorm v = (v :*: v)

data NonEmpty a = NonEmpty a [a]

mean : NonEmpty Vector -> Vector
mean (NonEmpty v vs) = let v' = foldr (:+:) v vs
                           len = toFloat (1 + length vs)
                       in (1/len) .*: v'
