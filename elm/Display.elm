module Display (display) where
import LinearAlgebra (pcaEigenpairs)
import Array as A
import Model (..)
import Util (pointToVect, vectToPoint)

display (w,h) points eigenvectors mean =
  let w' = toFloat w
      h' = toFloat h
      styleAxis = traced (solid black)
      xAxis = styleAxis <| segment (-w'/2, 0) (w'/2, 0)
      yAxis = styleAxis <| segment (0, -h'/2) (0, h'/2)
      dots = map toDot points
      pointToVect (x,y) = A.fromList [x, y]
      eigenArrows = drawEigenArrows mean eigenvectors
      projectedPoints = (project mean) eigenvectors points
  in collage w h <| (xAxis::yAxis::dots) ++ eigenArrows ++ projectedPoints

project : Point -> [Point] -> [Point] -> [Form]
project (mx,my) es pts =
  case es of
    [] -> []
    (e::_) -> let proj (ex,ey) (x,y) = let n = ex*x + ey*y
                                        in (n*ex,n*ey)
                  toDot (x,y) = circle 5 |> filled blue |> move (x,y)
               in map (proj e >> toDot) pts

drawEigenArrows : Point -> [Point] -> [Form]
drawEigenArrows (mx,my) pts =
  let drawOne (x,y) = let seg = segment (mx,my) (mx+100*x, my+100*y) |> traced (solid red)
                          dot = circle 5 |> filled red |> move (mx,my)
                      in [seg, dot]
  in pts |> map adjustQuadrant |> map drawOne |> concat

toDot : Point -> Form
toDot (x,y) = circle 5 |> filled black |> move (x,y)

adjustQuadrant : Point -> Point
adjustQuadrant (x,y) =
  if x < 0 then  (-x,-y) else (x,y)
