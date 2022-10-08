local srv = game.GetService
getgenv().objects = {}
--^^ getservice to srv connect

local runservice = srv(game, "RunService")
local inputservice = srv(game, "UserInputService")
local replicated = srv(game, "ReplicatedStorage")
--^^ services

local players = srv(game, "Players")

function walk_speed_check()
	for _,v in next, players:GetChildren() do
		if (v.Character and v.Character:FindFirstChild("Humanoid")) then
			if (v.Character and v.Character:FindFirstChildOfClass("Humanoid")) then
				if (v.Character.Humanoid.WalkSpeed > 16) then
					v:Kick("Retard")
				end
			end
		end
	end
end


function teleport_check(hrp,speaker)
	pcall(function()
		local last_mag
		if (hrp and hrp.Parent) then
			last_mag = hrp.Position
			while task.wait() and hrp.Parent do
				if (hrp and hrp.Parent) then
					local mag = (hrp.Position-shared.last_mag).magnitude
					if (mag < 1) then
						shared.last_mag = mag
						hrp.Anchored = true;task.wait(3)
						if not hrp.Anchored then
							speaker:Kick()
						else
							hrp.Anchored = false
						end
					end
				end
			end
		end
	end)
end

function anticheat_for_hovers() -- anticheat for flying, inf-jump, hovering, etc
	for _,v in next, players:GetChildren() do
		if (v.Character and v.Character:FindFirstChild("Humanoid")) then
			if (v.Character and v.Character:FindFirstChildOfClass("Humanoid")) then
				local rayOrigin = v.Character.HumanoidRootPart.Position
				local rayDirection = Vector3.new(0, -math.huge, 0)
				-- to check part below

				local raycastParams = RaycastParams.new()
				raycastParams.FilterDescendantsInstances = {v.Character.descendantsToFilter}
				raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
				local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)

				if raycastResult then
					local inst = raycastResult
					local mag = (inst.Position-v.Character.HumanoidRootPart.Position).magnitude
					if mag < 12 then
						v.Character.HumanoidRootPart.CFrame = inst.CFrame + Vector3.new(0,3,0); task.wait()
						v.Character.HumanoidRootPart.Anchored = true;task.wait(3)
						if not v.Character.HumanoidRootPart.Anchored then
							v:Kick()
						else
							v.Character.HumanoidRootPart.Anchored = false
						end
					end
				end
			end
		end
	end
end

while task.wait() do
	pcall(function()
		anticheat_for_hovers()
		walk_speed_check()
	end)
end
