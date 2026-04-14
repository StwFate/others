local PastebinLink = "https://raw.githubusercontent.com/StwFate/others/refs/heads/main/test52.lua"
local CodeString = "loadstring(game:HttpGet('" .. PastebinLink .. "'))()"
local QueueOnTeleport = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)

local HasQueued = false
local function QueueNextTeleport()
    if QueueOnTeleport and not HasQueued then
        HasQueued = true
        QueueOnTeleport(CodeString)
    end
end

print("Script Ran")

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
                    ["value"] = "```" .. "ServerLocation: " .. game:GetService("ReplicatedStorage"):WaitForChild("ServerStatus"):GetAttribute("ServerLocation") .. " | " .. Ping .."ms" .. "```",
                    ["inline"] = false
                }
            },
            ["footer"] = {
                ["text"] = "Status: RiftEmission Active"
            },
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }
    
    local Success, Error = pcall(function()
        request({
            Url = WebhookURL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(Data)
        })
    end)

    if not Success then
        warn("Webhook failed: " .. tostring(Error))
    end
end

local function FindRandomServer()
    local Servers = ReplicatedStorage:WaitForChild("Servers", math.huge)
    local NAServers = {}
    
    for _, Server in Servers:GetChildren() do 
        if Server:GetAttribute("MapId") == "EstonianBorder" and not Server:GetAttribute("Premium") then
            local UpTime = Server:GetAttribute("UpTime")
            local Hour = tonumber(string.match(UpTime, "^(%d+)"))
            
            if Hour and Hour >= 6 then
                table.insert(NAServers, Server:GetAttribute("JobId"))
            end
        end
    end

    if #NAServers == 0 then return nil end
    
    return NAServers[math.random(1, #NAServers)]
end

if game.PlaceId == LobbyId then
    QueueNextTeleport()
    
    WaitForConsoleMessage("respawn client loaded")

    while true do
        local TargetId = FindRandomServer()
        if TargetId then
            TeleportToJobId(TargetId)
        end
        task.wait(1)
    end
else
    WaitForConsoleMessage("respawn client loaded")

    local Lighting = game:GetService("Lighting")
    local Atmosphere = Lighting:WaitForChild("Atmosphere", math.huge)

    task.wait(1)

    if Atmosphere.Color == Color3.fromRGB(141, 82, 128) then
        SendWebhook()

        local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
        local Exit = Remotes:WaitForChild("Exit")

        while true do
            Exit:FireServer()
            task.wait(1)
        end
    else
        QueueNextTeleport()

        local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
        local Exit = Remotes:WaitForChild("Exit")

        while true do
            Exit:FireServer()
            task.wait(1)
        end
    end
end
