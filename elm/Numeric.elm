module Numeric where
import Array (..)
import Native.Numeric

type Vector = Array Float
type Matrix = Array (Array Float)
type Complex a = { real: a, imaginary: a }

transpose : Matrix -> Matrix
transpose = Native.Numeric.transpose

mmDot : Matrix -> Matrix -> Matrix
mmDot = Native.Numeric.mmDot

eig : Matrix -> { eigenvalues: Complex [Float]
                , eigenvectors: Complex [Vector]
                }
eig = Native.Numeric.eig
