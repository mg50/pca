module Main where
import Model (..)
import Input (actions)
import Display (display)
import Update (update)
import Numeric (..)
import LinearAlgebra (..)
import Util (..)
import Array as A
import Dict as D
import Mouse
import Window

axes : Signal [Point]
axes = let convert = map pointToVect >> pcaEigenpairs >> sortBy snd >> reverse >> map fst >> map vectToPoint
           takeOne xs = case xs of
                          [] -> []
                          (b::bs) -> [b]
       in points |> lift convert
                 |> lift takeOne

pointsMean : Signal Point
pointsMean = let f pts = case map pointToVect pts of
                           [] -> (0, 0)
                           (p::ps) -> NonEmpty p ps |> mean |> vectToPoint
             in lift f points

state : Signal State
state = foldp update initialState actions

points : Signal [Point]
points = let f st = st.points |> D.toList |> map snd
         in lift f state

--main : Signal Element
main = display <~ Window.dimensions
                ~ state
                ~ axes
                ~ pointsMean
