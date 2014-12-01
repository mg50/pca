module Main where
import Model (..)
import Input (points)
import Display (display)
import Numeric (..)
import LinearAlgebra (..)
import Util (..)
import Array as A
import Mouse
import Window

axes : Signal [Point]
axes = let convert = map pointToVect >> pcaEigenpairs >> sortBy snd >> reverse >> map fst >> map vectToPoint
           takeOne xs = case xs of
                          [] -> []
                          (b::bs) -> [b]
       in lift convert points |> lift takeOne

pointsMean : Signal Point
pointsMean = let f pts = case map pointToVect pts of
                           [] -> (0, 0)
                           (p::ps) -> NonEmpty p ps |> mean |> vectToPoint
             in lift f points

main = display <~ Window.dimensions ~ points ~ axes ~ pointsMean
