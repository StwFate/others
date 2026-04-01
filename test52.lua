local PastebinLink = "https://raw.githubusercontent.com/StwFate/others/refs/heads/main/test52.lua"
local CodeString = "loadstring(game:HttpGet('" .. PastebinLink .. "'))()"
local QueueOnTeleport = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)

if game:IsLoaded() then else game.Loaded:Wait() end

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LogService = game:GetService("LogService")

local PlaceId = game.PlaceId
local LobbyId = 7336302630
local GameId = 7353845952

local function TeleportToJobId(Id)
    local TeleportRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Teleport")

    if not Id then return end

    -- Queue the script ONLY right before we intentionally teleport to a new game server
    if QueueOnTeleport then
        QueueOnTeleport(CodeString)
    end

    TeleportRemote:InvokeServer({
        JobId = Id,
        ServerName = Id,
        PlaceId = 7353845952
    })
end

local function WaitForConsoleMessage(TargetMessage)
    local Found = false
    
    repeat
        for _, Log in LogService:GetLogHistory() do
            if string.find(Log.message, TargetMessage) then
                Found = true
                break
            end
        end
        
        if not Found then
            task.wait()
        end
    until Found
end

local function SendWebhook()
    local WebhookURL = "https://discord.com/api/webhooks/1488438437093834862/-s_ZeZLG0872MvN7i5pP5vhRszTkvuYnMQ3Aqs5f0mopqY27NKlSLfUlzIh8nbyOovmk"
    local Stats = game:GetService("Stats")
    local NetworkStats = Stats.Network
    local Ping = math.floor(NetworkStats.ServerStatsItem["Data Ping"]:GetValue())

    local Data = {
        ["content"] = "@everyone",
        ["embeds"] = {{
            ["title"] = "Whisper Found!",
            ["description"] = "A Rift Emission has been detected in this session.",
            ["color"] = 8388736, -- Purple
            ["fields"] = {
                {
                    ["name"] = "Server JobId",
                    ["value"] = "```" .. game.JobId .. "```",
                    ["inline"] = false
                },
                {
                    ["name"] = "Server & Ping:",
                    ["value"] = "
