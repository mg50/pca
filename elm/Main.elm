module Main where
import Model (..)
import Input (actions)
import Display (display)
import Update (update)
import Mouse
import Window

state : Signal State
state = foldp update initialState actions

main : Signal Element
main = display <~ Window.dimensions ~ state
