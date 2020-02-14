local MAJOR = "LibJayEvent"
local MINOR = 1

assert(LibStub, format("%s requires LibStub.", MAJOR))

local lib = LibStub:NewLibrary(MAJOR, MINOR)

if not lib then return end

--[[ local safecall, xsafecall
do -- safecall, xsafecall
    local pcall = pcall
    ---@param func function
    ---@return boolean retOK
    safecall = function(func, ...) return pcall(func, ...) end

    local geterrorhandler = geterrorhandler
    ---@param err string
    ---@return function handler
    local function errorhandler(err) return geterrorhandler()(err) end

    local xpcall = xpcall
    ---@param func function
    ---@return boolean retOK
    xsafecall = function(func, ...) return xpcall(func, errorhandler, ...) end
end ]]

lib.callbacks = lib.callbacks or
                    LibStub("LibJayCallback"):New(lib, "Register",
                                                      "Unregister")
local callbacks = lib.callbacks

lib.frame = lib.frame or CreateFrame("Frame")
local frame = lib.frame

frame:SetScript("OnEvent", function(self, event, ...)
    callbacks:TriggerEvent(event, ...)
end)

---@param event string
function callbacks:OnEventRegistered(event) frame:RegisterEvent(event) end

---@param event string
function callbacks:OnEventUnregistered(event) frame:UnregisterEvent(event) end

lib.FRAMEMIXIN = lib.FRAMEMIXIN or {}

---@param self table
---@param event string
local function OnEvent(self, event, ...) self[event](self, ...) end

function lib.FRAMEMIXIN:OnLoad() self:SetScript("OnEvent", OnEvent) end

local select = select
function lib.FRAMEMIXIN:RegisterEvents(...)
    for i = 1, select("#", ...) do self:RegisterEvent(select(i, ...)) end
end

function lib.FRAMEMIXIN:UnregisterEvents(...)
    for i = 1, select("#", ...) do self:UnregisterEvent(select(i, ...)) end
end

---@param unit string
function lib.FRAMEMIXIN:RegisterEventsForUnit(unit, ...)
    self:UnregisterEvents(...)

    for i = 1, select("#", ...) do
        self:RegisterUnitEvent(select(i, ...), unit)
    end
end

---@param unit1 string
---@param unit2 string
function lib.FRAMEMIXIN:RegisterEventsForUnits(unit1, unit2, ...)
    self:UnregisterEvents(...)

    for i = 1, select("#", ...) do
        self:RegisterUnitEvent(select(i, ...), unit1, unit2)
    end
end
