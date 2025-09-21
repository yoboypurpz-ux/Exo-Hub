local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ExoHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 260, 0, 200)
Frame.Position = UDim2.new(0.5, -130, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Visible = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.TextColor3 = Color3.fromRGB(0, 255, 128)
Title.TextStrokeTransparency = 0.2
Title.TextStrokeColor3 = Color3.fromRGB(0, 200, 0)
Title.Text = "☢ Exo Hub ☢"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.Parent = Frame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

local function makeButton(text, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -40, 0, 40)
    btn.Position = UDim2.new(0, 20, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(0, 60, 0)
    btn.TextColor3 = Color3.fromRGB(0, 255, 128)
    btn.TextStrokeTransparency = 0.2
    btn.TextStrokeColor3 = Color3.fromRGB(0, 200, 0)
    btn.Text = text
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 18
    btn.Parent = Frame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    return btn
end

local CameraButton = makeButton("Camera Noclip: OFF", 50)
local PlatformButton = makeButton("Platform: OFF", 100)
local ESPButton = makeButton("Player ESP: OFF", 150)

local cameraNoclip = false
local platformEnabled = false
local espEnabled = false
local platformPart = nil
local alignPos = nil
local attachment = nil

local function addESP(player)
    if player ~= LocalPlayer and player.Character then
        if not player.Character:FindFirstChild("ExoESP") then
            local highlight = Instance.new("Highlight")
            highlight.Name = "ExoESP"
            highlight.FillColor = Color3.fromRGB(0, 255, 128)
            highlight.OutlineColor = Color3.fromRGB(0, 255, 128)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Adornee = player.Character
            highlight.Parent = player.Character
        end
        if not player.Character:FindFirstChild("ExoNameTag") then
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "ExoNameTag"
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.Adornee = player.Character:FindFirstChild("Head")
            billboard.AlwaysOnTop = true
            billboard.Parent = player.Character
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = player.DisplayName
            label.TextColor3 = Color3.fromRGB(0, 255, 128)
            label.TextStrokeTransparency = 0.2
            label.TextStrokeColor3 = Color3.fromRGB(0, 200, 0)
            label.Font = Enum.Font.GothamBold
            label.TextSize = 16
            label.Parent = billboard
        end
    end
end

CameraButton.MouseButton1Click:Connect(function()
    cameraNoclip = not cameraNoclip
    CameraButton.Text = "Camera Noclip: " .. (cameraNoclip and "ON" or "OFF")
    if cameraNoclip then
        LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
    else
        LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Zoom
    end
end)

PlatformButton.MouseButton1Click:Connect(function()
    platformEnabled = not platformEnabled
    PlatformButton.Text = "Platform: " .. (platformEnabled and "ON" or "OFF")
    if not platformEnabled then
        if platformPart then
            platformPart:Destroy()
            platformPart = nil
        end
        if alignPos then
            alignPos:Destroy()
            alignPos = nil
        end
        if attachment then
            attachment:Destroy()
            attachment = nil
        end
    end
end)

ESPButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    ESPButton.Text = "Player ESP: " .. (espEnabled and "ON" or "OFF")
    if espEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            addESP(player)
        end
    else
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character then
                if player.Character:FindFirstChild("ExoESP") then
                    player.Character.ExoESP:Destroy()
                end
                if player.Character:FindFirstChild("ExoNameTag") then
                    player.Character.ExoNameTag:Destroy()
                end
            end
        end
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if espEnabled then
            task.wait(0.5)
            addESP(player)
        end
    end)
end)

RunService.RenderStepped:Connect(function()
    if platformEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = LocalPlayer.Character.HumanoidRootPart
        local head = LocalPlayer.Character:FindFirstChild("Head")
        if not platformPart then
            platformPart = Instance.new("Part")
            platformPart.Size = Vector3.new(10, 1, 10)
            platformPart.Anchored = true
            platformPart.CanCollide = true
            platformPart.BrickColor = BrickColor.new("Lime green")
            platformPart.Material = Enum.Material.Neon
            platformPart.Transparency = 0.1
            platformPart.Name = "RazPlatform"
            platformPart.Parent = workspace
            platformPart.Position = root.Position - Vector3.new(0, 3, 0)
            attachment = Instance.new("Attachment")
            attachment.Parent = root
            alignPos = Instance.new("AlignPosition")
            alignPos.MaxForce = Vector3.new(0, math.huge, 0)
            alignPos.Responsiveness = 200
            alignPos.Attachment0 = attachment
            alignPos.Parent = root
        end
        local stop = false
        if head then
            local rayOrigin = head.Position
            local rayDirection = Vector3.new(0, 2, 0)
            local params = RaycastParams.new()
            params.FilterDescendantsInstances = {LocalPlayer.Character, platformPart}
            params.FilterType = Enum.RaycastFilterType.Blacklist
            local result = workspace:Raycast(rayOrigin, rayDirection, params)
            if result then
                stop = true
            end
        end
        if not stop then
            platformPart.Position = Vector3.new(root.Position.X, platformPart.Position.Y + 0.25, root.Position.Z)
        end
        if alignPos then
            alignPos.Position = Vector3.new(root.Position.X, platformPart.Position.Y + 3, root.Position.Z)
        end
    end
end)

if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 60, 0, 60)
    ToggleBtn.Position = UDim2.new(0, 20, 0.8, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 60, 0)
    ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 128)
    ToggleBtn.Text = "Exo"
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 18
    ToggleBtn.Parent = ScreenGui
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ToggleBtn
    ToggleBtn.MouseButton1Click:Connect(function()
        Frame.Visible = not Frame.Visible
    end)
else
    UserInputService.InputBegan:Connect(function(input, gp)
        if input.KeyCode == Enum.KeyCode.F4 and not gp then
            Frame.Visible = not Frame.Visible
        end
    end)
end
