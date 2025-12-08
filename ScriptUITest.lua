local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local NoclipEnabled = false
local ESPEnabled = false
local SavedPosition = CFrame.new()
local ESPData = {}

local Window = Rayfield:CreateWindow({
    Name = "Ryoki Hub",
    LoadingTitle = "Carregando...",
    LoadingSubtitle = "by @RyokiDev",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "RyokiHubConfigs",
        FileName = "Configs"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "Sistema de Key",
        Subtitle = "Entre com a Key",
        Note = "Key: RyokiFree123",
        FileName = "RyokiKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"RyokiFree123"}
    }
})

local MainTab = Window:CreateTab("Principal")
local InfoTab = Window:CreateTab("Informacoes")

MainTab:CreateSection("Teletransporte")

local MarkButton = MainTab:CreateButton({
    Name = "Marcar Posicao",
    Callback = function()
        local character = LocalPlayer.Character
        if character then
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                SavedPosition = root.CFrame
                Rayfield:Notify({
                    Title = "Posicao Marcada",
                    Content = "Posicao salva com sucesso",
                    Duration = 3
                })
            end
        end
    end
})

local TeleportButton = MainTab:CreateButton({
    Name = "Teleportar para Posicao Salva",
    Callback = function()
        local character = LocalPlayer.Character
        if character then
            local root = character:FindFirstChild("HumanoidRootPart")
            if root and SavedPosition then
                root.CFrame = SavedPosition
                Rayfield:Notify({
                    Title = "Teleportado",
                    Content = "Teleportado para posicao salva",
                    Duration = 3
                })
            end
        end
    end
})

MainTab:CreateSection("Movimentacao")

local NoclipToggle = MainTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(Value)
        NoclipEnabled = Value
        if Value then
            Rayfield:Notify({
                Title = "Noclip Ativado",
                Content = "Noclip ativado",
                Duration = 2
            })
        else
            Rayfield:Notify({
                Title = "Noclip Desativado",
                Content = "Noclip desativado",
                Duration = 2
            })
        end
    end
})

local SpeedSlider = MainTab:CreateSlider({
    Name = "Velocidade",
    Range = {16, 200},
    Increment = 1,
    Suffix = "estudos/s",
    CurrentValue = 16,
    Callback = function(Value)
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = Value
            end
        end
    end
})

local JumpSlider = MainTab:CreateSlider({
    Name = "Forca do Pulo",
    Range = {50, 200},
    Increment = 1,
    Suffix = "estudos",
    CurrentValue = 50,
    Callback = function(Value)
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.JumpPower = Value
            end
        end
    end
})

MainTab:CreateSection("Visual")

local ESPToggle = MainTab:CreateToggle({
    Name = "ESP de Jogadores",
    CurrentValue = false,
    Callback = function(Value)
        ESPEnabled = Value
        UpdateESP()
    end
})

InfoTab:CreateSection("Informacoes")
InfoTab:CreateLabel("Dono: @RyokiDev")
InfoTab:CreateLabel("Versao: FreePremium")
InfoTab:CreateParagraph("Aviso", "Algumas funcoes podem nao funcionar corretamente")

function CreateESP(player)
    if player == LocalPlayer then return end
    if ESPData[player] then return end
    if not player.Character then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Parent = game.CoreGui
    highlight.Adornee = player.Character
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.7
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    
    local billboard = Instance.new("BillboardGui")
    billboard.Parent = game.CoreGui
    billboard.Adornee = player.Character:WaitForChild("Head")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Enabled = true
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Parent = billboard
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size = UDim2.new(1, 0, 0.33, 0)
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Parent = billboard
    infoLabel.BackgroundTransparency = 1
    infoLabel.Size = UDim2.new(1, 0, 0.33, 0)
    infoLabel.Position = UDim2.new(0, 0, 0.33, 0)
    infoLabel.Text = "HP: 100"
    infoLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    infoLabel.TextSize = 12
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextStrokeTransparency = 0
    infoLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Parent = billboard
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Size = UDim2.new(1, 0, 0.33, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.66, 0)
    distanceLabel.Text = "0m"
    distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    distanceLabel.TextSize = 12
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.TextStrokeTransparency = 0
    distanceLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    
    ESPData[player] = {
        Highlight = highlight,
        Billboard = billboard,
        InfoLabel = infoLabel,
        DistanceLabel = distanceLabel
    }
    
    coroutine.wrap(function()
        while ESPEnabled and ESPData[player] and player.Character and player.Character.Parent do
            local localChar = LocalPlayer.Character
            local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChild("Humanoid")
            
            if localRoot and targetRoot and humanoid then
                local distance = (localRoot.Position - targetRoot.Position).Magnitude
                distanceLabel.Text = string.format("%.1fm", distance)
                infoLabel.Text = string.format("HP: %d", math.floor(humanoid.Health))
                
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

function RemoveESP(player)
    if ESPData[player] then
        if ESPData[player].Highlight then
            ESPData[player].Highlight:Destroy()
        end
        if ESPData[player].Billboard then
            ESPData[player].Billboard:Destroy()
        end
        ESPData[player] = nil
    end
end

function UpdateESP()
    if ESPEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                coroutine.wrap(function()
                    wait(1)
                    CreateESP(player)
                end)()
            end
        end
    else
        for player in pairs(ESPData) do
            RemoveESP(player)
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    if ESPEnabled then
        wait(1)
        CreateESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

playerAdded = LocalPlayer.CharacterAdded:Connect(function(character)
    if ESPEnabled then
        wait(1)
        UpdateESP()
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

LocalPlayer.CharacterAdded:Connect(function()
    local character = LocalPlayer.Character
    if character then
        wait(1)
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = SpeedSlider.CurrentValue
            humanoid.JumpPower = JumpSlider.CurrentValue
        end
    end
end)

if LocalPlayer.Character then
    wait(1)
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = SpeedSlider.CurrentValue
            humanoid.JumpPower = JumpSlider.CurrentValue
        end
    end
end

Rayfield:Notify({
    Title = "Ryoki Hub Carregado",
    Content = "Interface aberta",
    Duration = 6
})
