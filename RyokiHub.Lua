local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local NoclipEnabled = false
local ESPEnabled = false
local SavedPosition = CFrame.new()
local PanelVisible = true
local ESPHighlights = {}
local ButtonCooldowns = {}

local MainGUI = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleBtn = Instance.new("TextButton")
local ContentFrame = Instance.new("Frame")

MainGUI.Name = "RyokiHub"
MainGUI.Parent = game.CoreGui
MainGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = MainGUI
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Active = true
MainFrame.Draggable = true

local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(139, 92, 246)
UIStroke.Thickness = 2

ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MainGUI
ToggleBtn.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Position = UDim2.new(0, 10, 0.5, -15)
ToggleBtn.Size = UDim2.new(0, 40, 0, 30)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "☰"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 16
ToggleBtn.ZIndex = 2
ToggleBtn.Active = true
ToggleBtn.Draggable = true

ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ContentFrame.BorderSizePixel = 0
ContentFrame.Size = UDim2.new(1, 0, 1, 0)

local CloseButton = Instance.new("TextButton")
CloseButton.Parent = ContentFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(0.92, -12, 0.03, 0)
CloseButton.Size = UDim2.new(0, 24, 0, 24)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.AutoButtonColor = false

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Down:Connect(function()
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
end)

CloseButton.MouseButton1Up:Connect(function()
    CloseButton.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
end)

CloseButton.MouseLeave:Connect(function()
    CloseButton.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
end)

local Title = Instance.new("TextLabel")
Title.Parent = ContentFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.05, 0, 0.02, 0)
Title.Size = UDim2.new(0.9, 0, 0.1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Ryoki Hub (FreePremium)"
Title.TextColor3 = Color3.fromRGB(139, 92, 246)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Center

local SubTitle = Instance.new("TextLabel")
SubTitle.Parent = ContentFrame
SubTitle.BackgroundTransparency = 1
SubTitle.Position = UDim2.new(0.05, 0, 0.12, 0)
SubTitle.Size = UDim2.new(0.9, 0, 0.06, 0)
SubTitle.Font = Enum.Font.Gotham
SubTitle.Text = "Some options don't work"
SubTitle.TextColor3 = Color3.fromRGB(6, 182, 212)
SubTitle.TextSize = 12
SubTitle.TextXAlignment = Enum.TextXAlignment.Center

local function CreateButton(text, position, color, icon)
    local button = Instance.new("TextButton")
    local corner = Instance.new("UICorner")
    
    button.Parent = ContentFrame
    button.BackgroundColor3 = color
    button.BorderSizePixel = 0
    button.Position = position
    button.Size = UDim2.new(0.8, 0, 0.1, 0)
    button.Font = Enum.Font.GothamBold
    button.Text = "  " .. icon .. "  " .. text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.AutoButtonColor = false
    
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    local originalPosition = position
    
    button.MouseButton1Down:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(
            math.floor(color.R * 255 * 0.8),
            math.floor(color.G * 255 * 0.8),
            math.floor(color.B * 255 * 0.8)
        )
    end)
    
    button.MouseButton1Up:Connect(function()
        button.BackgroundColor3 = color
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = color
    end)
    
    return button, originalPosition
end

local NoclipBtn, NoclipPos = CreateButton("NOCLIP: OFF", UDim2.new(0.1, 0, 0.2, 0), Color3.fromRGB(239, 68, 68), "🚫")
local MarkBtn, MarkPos = CreateButton("MARCA LOCAL", UDim2.new(0.1, 0, 0.32, 0), Color3.fromRGB(16, 185, 129), "📍")
local TeleportBtn, TeleportPos = CreateButton("TELEPORTAR", UDim2.new(0.1, 0, 0.44, 0), Color3.fromRGB(59, 130, 246), "⚡")
local ESPBtn, ESPPos = CreateButton("ESP: OFF", UDim2.new(0.1, 0, 0.56, 0), Color3.fromRGB(139, 92, 246), "👁️")

local FooterFrame = Instance.new("Frame")
FooterFrame.Parent = ContentFrame
FooterFrame.BackgroundTransparency = 1
FooterFrame.Size = UDim2.new(0.8, 0, 0.08, 0)
FooterFrame.Position = UDim2.new(0.1, 0, 0.85, 0)

local OwnerLabel = Instance.new("TextLabel")
OwnerLabel.Parent = FooterFrame
OwnerLabel.BackgroundTransparency = 1
OwnerLabel.Size = UDim2.new(0.3, 0, 1, 0)
OwnerLabel.Position = UDim2.new(0, 0, 0, 0)
OwnerLabel.Font = Enum.Font.Gotham
OwnerLabel.Text = "Owner:"
OwnerLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
OwnerLabel.TextSize = 12
OwnerLabel.TextXAlignment = Enum.TextXAlignment.Left

local OwnerImage = Instance.new("ImageLabel")
OwnerImage.Parent = FooterFrame
OwnerImage.BackgroundTransparency = 1
OwnerImage.Size = UDim2.new(0, 20, 0, 20)
OwnerImage.Position = UDim2.new(0.3, 0, 0.1, 0)
OwnerImage.Image = "rbxassetid://110747388278175"

local OwnerName = Instance.new("TextLabel")
OwnerName.Parent = FooterFrame
OwnerName.BackgroundTransparency = 1
OwnerName.Size = UDim2.new(0.5, 0, 1, 0)
OwnerName.Position = UDim2.new(0.45, 0, 0, 0)
OwnerName.Font = Enum.Font.GothamBold
OwnerName.Text = "@RyokiDev"
OwnerName.TextColor3 = Color3.fromRGB(139, 92, 246)
OwnerName.TextSize = 12
OwnerName.TextXAlignment = Enum.TextXAlignment.Left

local corners = {
    Instance.new("UICorner"),
    Instance.new("UICorner"),
    Instance.new("UICorner")
}

for i, corner in ipairs(corners) do
    corner.CornerRadius = UDim.new(0, 12)
end

corners[1].Parent = MainFrame
corners[2].Parent = ContentFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleBtn

local function SafeButtonAnimation(button, originalPosition)
    if ButtonCooldowns[button] then return end
    ButtonCooldowns[button] = true
    
    local tweenIn = TweenService:Create(button, TweenInfo.new(0.1), {
        Position = button.Position - UDim2.new(0, 0, 0, 3)
    })
    
    local tweenOut = TweenService:Create(button, TweenInfo.new(0.1), {
        Position = originalPosition
    })
    
    tweenIn:Play()
    tweenIn.Completed:Wait()
    tweenOut:Play()
    
    wait(0.2)
    ButtonCooldowns[button] = false
end

local function ToggleNoclip()
    NoclipEnabled = not NoclipEnabled
    
    if NoclipEnabled then
        NoclipBtn.Text = "  🚫  NOCLIP: ON"
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
    else
        NoclipBtn.Text = "  🚫  NOCLIP: OFF"
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
    end
    SafeButtonAnimation(NoclipBtn, NoclipPos)
end

local function MarkPosition()
    local character = LocalPlayer.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            SavedPosition = humanoidRootPart.CFrame
            SafeButtonAnimation(MarkBtn, MarkPos)
        end
    end
end

local function TeleportToSaved()
    local character = LocalPlayer.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            humanoidRootPart.CFrame = SavedPosition
            SafeButtonAnimation(TeleportBtn, TeleportPos)
        end
    end
end

local function CreateESP(player)
    if player == LocalPlayer then return end
    if not player.Character then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Parent = game.CoreGui
    highlight.Adornee = player.Character
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.7
    
    local billboard = Instance.new("BillboardGui")
    billboard.Parent = game.CoreGui
    billboard.Adornee = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
    billboard.Size = UDim2.new(0, 200, 0, 80)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Parent = billboard
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size = UDim2.new(1, 0, 0.33, 0)
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Parent = billboard
    infoLabel.BackgroundTransparency = 1
    infoLabel.Size = UDim2.new(1, 0, 0.33, 0)
    infoLabel.Position = UDim2.new(0, 0, 0.33, 0)
    infoLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    infoLabel.TextSize = 12
    infoLabel.Font = Enum.Font.Gotham
    
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Parent = billboard
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Size = UDim2.new(1, 0, 0.33, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.66, 0)
    distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    distanceLabel.TextSize = 12
    distanceLabel.Font = Enum.Font.Gotham
    
    ESPHighlights[player] = {
        Highlight = highlight,
        Billboard = billboard,
        InfoLabel = infoLabel,
        DistanceLabel = distanceLabel
    }
    
    coroutine.wrap(function()
        while ESPEnabled and ESPHighlights[player] and player.Character and player.Character.Parent do
            local localChar = LocalPlayer.Character
            local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChild("Humanoid")
            
            if localRoot and targetRoot and humanoid then
                local distance = (localRoot.Position - targetRoot.Position).Magnitude
                distanceLabel.Text = string.format("%.1fm", distance)
                infoLabel.Text = string.format("HP: %d", humanoid.Health)
                
                if distance < 10 then
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                elseif distance < 25 then
                    highlight.FillColor = Color3.fromRGB(255, 165, 0)
                else
                    highlight.FillColor = Color3.fromRGB(0, 255, 0)
                end
            end
            wait(0.1)
        end
    end)()
end

local function RemoveESP(player)
    if ESPHighlights[player] then
        ESPHighlights[player].Highlight:Destroy()
        ESPHighlights[player].Billboard:Destroy()
        ESPHighlights[player] = nil
    end
end

local function ToggleESP()
    ESPEnabled = not ESPEnabled
    
    if ESPEnabled then
        ESPBtn.Text = "  👁️  ESP: ON"
        ESPBtn.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
        
        for _, player in pairs(Players:GetPlayers()) do
            CreateESP(player)
        end
    else
        ESPBtn.Text = "  👁️  ESP: OFF"
        ESPBtn.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
        
        for player in pairs(ESPHighlights) do
            RemoveESP(player)
        end
    end
    SafeButtonAnimation(ESPBtn, ESPPos)
end

local function TogglePanel()
    PanelVisible = not PanelVisible
    
    if PanelVisible then
        MainFrame.Visible = true
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 300, 0, 350)
        })
        tween:Play()
    else
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 0, 0, 0)
        })
        tween:Play()
        tween.Completed:Wait()
        MainFrame.Visible = false
    end
end

NoclipBtn.MouseButton1Click:Connect(ToggleNoclip)
MarkBtn.MouseButton1Click:Connect(MarkPosition)
TeleportBtn.MouseButton1Click:Connect(TeleportToSaved)
ESPBtn.MouseButton1Click:Connect(ToggleESP)
CloseButton.MouseButton1Click:Connect(TogglePanel)
ToggleBtn.MouseButton1Click:Connect(TogglePanel)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        TogglePanel()
    elseif input.KeyCode == Enum.KeyCode.F1 then
        ToggleESP()
    elseif input.KeyCode == Enum.KeyCode.F2 then
        ToggleNoclip()
    end
end)

RunService.Stepped:Connect(function()
    if NoclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

Players.PlayerAdded:Connect(function(player)
    if ESPEnabled then
        wait(1)
        CreateESP(player)
    end
end)

coroutine.wrap(function()
    while true do
        local character = LocalPlayer.Character
        if character then
            for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                if tool:IsA("Tool") and string.lower(tool.Name):find("brain") then
                    TeleportToSaved()
                    wait(1)
                end
            end
            for _, tool in pairs(character:GetChildren()) do
                if tool:IsA("Tool") and string.lower(tool.Name):find("brain") then
                    TeleportToSaved()
                    wait(1)
                end
            end
        end
        wait(0.5)
    end
end)()
