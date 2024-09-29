local Speaker = game.Players.LocalPlayer; local Alive = Speaker.Character or Speaker.CharacterAdded:Wait()

if not getgenv().Timing then
    Alive.ChildAdded:Connect(function(i)
        task.wait(getgenv().Timing or 0.35)
        if i.Name == "BlackFlashFollow" then i:InvokeServer(true) end
    end)

    Speaker.CharacterAdded:Connect(function(Alive2)
        Alive2.ChildAdded:Connect(function(i)
            task.wait(getgenv().Timing or 0.35)
            if i.Name == "BlackFlashFollow" then i:InvokeServer(true) end
        end)
    end)

    queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/StwFate/others/refs/heads/main/InstantBlackFlash.lua'))()")
    
    print("Ran Black Flash")
end
