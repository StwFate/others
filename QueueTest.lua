game.Players.LocalPlayer.OnTeleported:Connect(function()
    queue_on_teleport("loadstring(game:HttpGet(''))()")
end)

print("Hi")
