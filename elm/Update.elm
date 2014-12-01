module Update (update) where
import LinearAlgebra (..)
import Model (..)
import Util (findPoint)
import Dict as D

update : Action -> State -> State
update action state =
  case action of
    Mouseup point -> handleMouseup point state
    Mousedown point -> handleMousedown point state
    Mousemove point -> handleMousemove point state

handleMousedown point state =
  { state | draggingId <- findPoint point state.points }

handleMousemove point state =
  case state.draggingId of
    Just id -> let points' = D.insert id point state.points
               in { state | points <- points' }
    Nothing -> state

handleMouseup point state =
  case state.draggingId of
    Just _ -> { state | draggingId <- Nothing }
    Nothing -> let id = state.freshId
               in { state | points <- D.insert id point state.points
                          , freshId <- id+1
                  }
