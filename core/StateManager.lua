local StateManager = {}

---@enum (key) StateManager.States
StateManager.States = {
    NONE = {},
    TESTING = require("core.states.TestState"),
    LOADING = require("core.states.LoadState"),
    MENUING = require("core.states.MenuState"),
    GAMEING = require("core.states.GameState"),
}

StateManager.CurrentState = StateManager.States.NONE

---@param x StateManager.States
function StateManager.setState(x)
    StateManager.CurrentState = StateManager.States[x]
    StateManager.CurrentState:enter()
end

return StateManager