module Model where
import Dict as D

type Point = (Float, Float)
type State = { points: D.Dict Int Point
             , draggingId: Maybe Int
             , freshId: Int}

data Action = Mouseup Point
            | Mousedown Point
            | Mousemove Point

initialState : State
initialState = State D.empty Nothing 0
