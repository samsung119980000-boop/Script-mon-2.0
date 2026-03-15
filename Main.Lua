-- [[ MonPhopuakMung HUB - FREE VERSION ]] --

local statusURL = "https://gist.githubusercontent.com/samsung119980000-boop/6db0bee911261ffc68f668fb7934a692/raw/status.txt"
local success, currentStatus = pcall(function() return game:HttpGet(statusURL) end)

if success and currentStatus:find("OFF") then
    return 
end

if game.CoreGui:FindFirstChild("FluentToggle") then game.CoreGui.FluentToggle:Destroy() end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local Window = Fluent:CreateWindow({
    Title = "YT : MonPhopuakMung 2.0",
    SubTitle = "Free Version",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 340),
    Acrylic = false, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local ToggleButton = Instance.new("ScreenGui", game.CoreGui)
local MainButton = Instance.new("TextButton", ToggleButton)
local UICorner = Instance.new("UICorner", MainButton)

ToggleButton.Name = "FluentToggle"
MainButton.Size = UDim2.new(0, 60, 0, 60)
MainButton.Position = UDim2.new(0.1, 0, 0.2, 0)
MainButton.Text = "🧩"
MainButton.TextSize = 35
MainButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainButton.TextColor3 = Color3.new(1,1,1)
MainButton.Draggable = true
MainButton.Active = true
UICorner.CornerRadius = UDim.new(0, 15)

MainButton.MouseButton1Click:Connect(function()
    for _, gui in pairs(game.CoreGui:GetChildren()) do
        if gui:IsA("ScreenGui") and (gui.Name == "ScreenGui" or gui:FindFirstChild("Frame")) and gui.Name ~= "FluentToggle" then
            gui.Enabled = not gui.Enabled
        end
    end
end)

local Tabs = {
    Main = Window:AddTab({ Title = "Home", Icon = "home" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "map-pin" }),
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "settings" })
}

local autoClick = false
Tabs.Main:AddToggle("AutoClick", {Title = "Auto Click", Default = false}):OnChanged(function(v)
    autoClick = v
    task.spawn(function()
        while autoClick do
            VirtualUser:CaptureController()
            VirtualUser:Button1Down(Vector2.new(1280, 672))
            task.wait(0.12)
        end
    end)
end)

local autoSam = false
Tabs.Main:AddToggle("AutoSam", {Title = "Auto Sam", Default = false}):OnChanged(function(v)
    autoSam = v
    local rem = game:GetService("ReplicatedStorage"):WaitForChild("Connections"):WaitForChild("Claim_Sam")
    task.spawn(function() while autoSam do rem:FireServer("Claim1") task.wait(3) end end)
end)

local wantedItems = {
    ["Rare Box"]=true, ["Ultra Rare Box"]=true, ["Chilly Fruit"]=true, ["Vampire Fruit"]=true,
    ["Sand Fruit"]=true, ["Plasma Fruit"]=true, ["Snow Fruit"]=true, ["Light Fruit"]=true,
    ["Candy Fruit"]=true, ["Quake Fruit"]=true, ["Blood Fruit"]=true, ["Ope Fruit"]=true,
    ["Gum Fruit"]=true, ["Dark Fruit"]=true, ["Rumble Fruit"]=true, ["Gravity Fruit"]=true,
    ["Venom Fruit"]=true, ["Magma Fruit"]=true, ["Gas Fruit"]=true, ["Hollow Fruit"]=true, ["Flame Fruit"]=true
}

local itemESP = false
local function updateItemESP(plr)
    if plr == player or not plr.Character or not plr.Character:FindFirstChild("Head") then return end
    local found = nil
    for _,item in pairs(plr.Backpack:GetChildren()) do
        for name, _ in pairs(wantedItems) do if item.Name:find(name) then found = item.Name break end end
        if found then break end
    end
    if not found then
        for _,item in pairs(plr.Character:GetChildren()) do
            if item:IsA("Tool") then
                for name, _ in pairs(wantedItems) do if item.Name:find(name) then found = item.Name break end end
                if found then break end
            end
        end
    end
    
    local tag = plr.Character.Head:FindFirstChild("ItemESP")
    if itemESP and found then
        if not tag then
            tag = Instance.new("BillboardGui", plr.Character.Head)
            tag.Name = "ItemESP"; tag.Size = UDim2.new(0, 150, 0, 30); tag.AlwaysOnTop = true; tag.ExtentsOffset = Vector3.new(0, 3, 0)
            local text = Instance.new("TextLabel", tag)
            text.Size = UDim2.new(1,0,1,0); text.BackgroundTransparency = 1; text.TextColor3 = Color3.fromRGB(255, 255, 0); text.TextScaled = true
            text.Text = "⭐ " .. plr.Name .. " มี: " .. found
        else
            local text = tag:FindFirstChildOfClass("TextLabel")
            if text then text.Text = "⭐ " .. plr.Name .. " มี: " .. found end
        end
    elseif tag then tag:Destroy() end
end

Tabs.Main:AddToggle("ItemESP", {Title = "Item ESP", Default = false}):OnChanged(function(v)
    itemESP = v
    if v then task.spawn(function() while itemESP do for _,p in pairs(Players:GetPlayers()) do pcall(function() updateItemESP(p) end) end task.wait(2) end end) end
end)

local autoPickup = false
Tabs.Main:AddToggle("AutoPickup", {Title = "Auto Pickup & Return", Default = false}):OnChanged(function(v)
    autoPickup = v
    if v then task.spawn(function()
        while autoPickup do
            task.wait(0.5)
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local originalPos = hrp.CFrame
                local collected = false
                for _,obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
                        local isWanted = false
                        for name, _ in pairs(wantedItems) do if obj.Name:find(name) then isWanted = true break end end
                        if isWanted and obj.Parent and not obj.Parent:FindFirstChild("Humanoid") then
                            collected = true; hrp.CFrame = obj.Handle.CFrame; task.wait(0.2)
                            firetouchinterest(hrp, obj.Handle, 0); task.wait(0.1); firetouchinterest(hrp, obj.Handle, 1)
                            local click = obj.Handle:FindFirstChildOfClass("ClickDetector")
                            if click then fireclickdetector(click) end
                            local prompt = obj:FindFirstChildOfClass("ProximityPrompt", true)
                            if prompt then fireproximityprompt(prompt) end
                            task.wait(0.5)
                        end
                    end
                end
                if collected and hrp then hrp.CFrame = originalPos; task.wait(1) end
            end
        end
    end) end
end)

local tpLocations = {
    ["Sam (Main)"] = CFrame.new(-1281.53, 215, -1339.01),
    ["Bob & Crab"] = CFrame.new(25.95, 221, -95.08),
    ["Cave Diamond (Lvl.40)"] = CFrame.new(-86.44, 213, -894.27),
    ["Rayleigh Cave"] = CFrame.new(2057.18, 487, -667.79),
    ["Snow Mountains"] = CFrame.new(6648.43, 415.99, -1460.59),
    ["Evill Island"] = CFrame.new(-5311.14, 213, -7618.62),
    ["Pyramid"] = CFrame.new(118.52, 307, 4946.11),
    ["Vokun Island"] = CFrame.new(4573.06, 214, 5055.81),
    ["Club"] = CFrame.new(1509.47, 257.38, 2165.49),
    ["Desert"] = CFrame.new(1078.03, 242.2, -3333.11),
    ["Forest"] = CFrame.new(-6042.84, 399, -10.66),
    ["Fish Spot"] = CFrame.new(1767.62, 215, 814.59)
}

for name, cf in pairs(tpLocations) do
    Tabs.Teleport:AddButton({
        Title = "Teleport to " .. name,
        Callback = function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then player.Character.HumanoidRootPart.CFrame = cf end
        end
    })
end

local selectedPlr = nil
local function getPlrs()
    local t = {}
    for _,p in pairs(game.Players:GetPlayers()) do if p ~= player then table.insert(t, p.Name) end end
    return t
end
local PDrop = Tabs.Player:AddDropdown("PlayerSelector", {Title = "Select Player", Values = getPlrs(), Callback = function(v) selectedPlr = v end})
Tabs.Player:AddButton({Title = "Refresh List", Callback = function() PDrop:SetValues(getPlrs()) end})
Tabs.Player:AddButton({Title = "Teleport to Player", Callback = function()
    local target = game.Players:FindFirstChild(selectedPlr)
    if target and target.Character then player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame end
end})

local noclip = false
RunService.Stepped:Connect(function()
    if noclip and player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)
Tabs.Misc:AddToggle("NC", {Title = "Noclip", Default = false}):OnChanged(function(v) noclip = v end)

local infJump = false
game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump and player.Character then player.Character.Humanoid:ChangeState("Jumping") end
end)
Tabs.Misc:AddToggle("IJ", {Title = "Infinite Jump", Default = false}):OnChanged(function(v) infJump = v end)
