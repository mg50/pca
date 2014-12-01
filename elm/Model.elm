module Model where
import Dict as D

type Point = (Float, Float)
type State = { points: D.Dict Int Point
             , draggingId: Maybe Int
             , freshId: Int
             , projectionsVisible: Bool
             }

data Action = Mouseup Point
            | Mousedown Point
            | Mousemove Point
            | ToggleProjections

initialState : State
initialState = State D.empty Nothing 0 False
