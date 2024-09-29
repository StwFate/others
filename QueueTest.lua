game.Players.LocalPlayer.OnTeleported:Connect(function()
    queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/StwFate/others/refs/heads/main/QueueTest.lua'))()")
end)

print("Hi")
