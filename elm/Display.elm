module Display (display) where
import LinearAlgebra (pcaEigenpairs, NonEmpty(..), mean)
import Array as A
import Dict as D
import Model (..)
import Util (pointToVect, vectToPoint)

display : (Int,Int) -> State -> Element
display (w,h) state =
  let points = state.points |> D.toList |> map snd
      eigenpairs = getEigenpairs points
      mean = getMean points
      w' = toFloat w
      h' = toFloat h
      styleAxis = traced (solid black)
      xAxis = styleAxis <| segment (-w'/2, 0) (w'/2, 0)
      yAxis = styleAxis <| segment (0, -h'/2) (0, h'/2)
      dots = map toDot points
      pointToVect (x,y) = A.fromList [x, y]
      eigenArrows = drawEigenArrows mean eigenpairs
      projectedPoints = if state.projectionsVisible
                        then project eigenpairs points
                        else []
  in collage w h <| (xAxis::yAxis::dots) ++ eigenArrows ++ projectedPoints

project : [(Point,Float)] -> [Point] -> [Form]
project pairs pts =
  case pairs of
    [] -> []
    (e,_)::_ ->
      let proj (ex,ey) (x,y) = let n = ex*x + ey*y
                               in (n*ex,n*ey)
          toDot (x,y) = circle 5 |> filled blue |> move (x,y)
      in map (proj e >> toDot) pts

drawEigenArrows : Point -> [(Point, Float)] -> [Form]
drawEigenArrows (mx,my) pairs =
  let drawOne ((x,y), l) =
        let seg = segment (mx,my) (mx+100*x, my+100*y) |> traced (solid red)
            dot = circle 5 |> filled red |> move (mx,my)
        in [seg, dot]
  in pairs |> map adjustQuadrant |> map drawOne |> concat

toDot : Point -> Form
toDot (x,y) = circle 5 |> filled black |> move (x,y)

adjustQuadrant : (Point, Float) -> (Point, Float)
adjustQuadrant ((x,y), l) =
  let p' = if x < 0 then  (-x,-y) else (x,y)
  in (p',l)

getMean : [Point] -> Point
getMean pts =
  case map pointToVect pts of
    [] -> (0, 0)
    (p::ps) -> NonEmpty p ps |> mean |> vectToPoint

getEigenpairs : [Point] -> [(Point, Float)]
getEigenpairs points =
  let takeOne xs = case xs of
                     [] -> []
                     (b::bs) -> [b]
  in points |> map pointToVect
            |> pcaEigenpairs
            |> sortBy snd
            |> reverse
            |> takeOne
            |> map (\(x,y) -> (vectToPoint x, y))
