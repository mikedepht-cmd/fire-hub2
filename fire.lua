-- [[ FIRE HUB v5 - REFORMULADO & CORRIGIDO ]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")

-- Evita duplicar a GUI ao reexecutar
local antiga = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("FireHubMhilllchilli")
if antiga then antiga:Destroy() end

local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.Name = "FireHubMhilllchilli"
ScreenGui.ResetOnSpawn = false

-- Tema de cores calibrado (Premium Dark & Neon Orange)
local Cores = {
    Fundo = Color3.fromRGB(18, 18, 22),
    AbasBarra = Color3.fromRGB(24, 24, 28),
    Laranja = Color3.fromRGB(255, 85, 0),
    Texto = Color3.fromRGB(255, 255, 255),
    TextoEscuro = Color3.fromRGB(150, 150, 155),
    BotaoAtivo = Color3.fromRGB(35, 35, 40),
    BotaoInativo = Color3.fromRGB(25, 25, 28)
}

-- Estados Globais e Gerenciador de Conexões (Prevenção de Lag)
local Estado = {
    Fly = false, ESP = false, KillAura = false,
    SuperSpeed = false, SuperJump = false, InfJump = false, Noclip = false
}
local Conexoes = {}
local OriginalCollisions = {}

-- =============================================================================
-- FUNÇÕES DE SISTEMA
-- =============================================================================
local function cArredondar(obj, px)
    local corner = Instance.new("UICorner", obj)
    corner.CornerRadius = UDim.new(0, px)
end

local function cArrastar(gatilho, alvo)
    local drag, start, pos
    gatilho.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true; start = i.Position; pos = alvo.Position
        end
    end)
    gatilho.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - start
            alvo.Position = UDim2.new(pos.X.Scale, pos.X.Offset + d.X, pos.Y.Scale, pos.Y.Offset + d.Y)
        end
    end)
end

-- =============================================================================
-- ESTRUTURA VISUAL DA GUI
-- =============================================================================
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 280)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -140)
MainFrame.BackgroundColor3 = Cores.Fundo
MainFrame.BorderSizePixel = 0
cArredondar(MainFrame, 6)

local BordaPrincipal = Instance.new("UIStroke", MainFrame)
BordaPrincipal.Color = Cores.Laranja
BordaPrincipal.Thickness = 1.5

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Cores.AbasBarra
TopBar.BorderSizePixel = 0
cArredondar(TopBar, 6)
cArrastar(TopBar, MainFrame)

local Titulo = Instance.new("TextLabel", TopBar)
Titulo.Size = UDim2.new(1, -40, 1, 0)
Titulo.Position = UDim2.new(0, 12)
Titulo.Text = "🔥 FIRE HUB v5 | Premium Edition"
Titulo.TextColor3 = Cores.Texto
Titulo.TextSize = 14
Titulo.Font = Enum.Font.GothamBold
Titulo.BackgroundTransparency = 1
Titulo.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -35, 0, 2.5)
MinBtn.Text = "🗕"
MinBtn.TextColor3 = Cores.Laranja
MinBtn.TextSize = 16
MinBtn.Font = Enum.Font.GothamBold
MinBtn.BackgroundTransparency = 1

local BolaFogo = Instance.new("TextButton", ScreenGui)
BolaFogo.Size = UDim2.new(0, 50, 0, 50)
BolaFogo.Position = UDim2.new(0.1, 0, 0.1, 0)
BolaFogo.BackgroundColor3 = Cores.Fundo
BolaFogo.Text = "🔥"
BolaFogo.TextSize = 22
BolaFogo.Visible = false
cArredondar(BolaFogo, 25)
cArrastar(BolaFogo, BolaFogo)

local StrokeBola = Instance.new("UIStroke", BolaFogo)
StrokeBola.Color = Cores.Laranja
StrokeBola.Thickness = 2

local function alternarMinimizar()
    local flutuando = not MainFrame.Visible
    MainFrame.Visible = flutuando
    BolaFogo.Visible = not flutuando
end
MinBtn.MouseButton1Click:Connect(alternarMinimizar)
BolaFogo.MouseButton1Click:Connect(alternarMinimizar)

local BarraAbas = Instance.new("Frame", MainFrame)
BarraAbas.Size = UDim2.new(0, 100, 1, -35)
BarraAbas.Position = UDim2.new(0, 0, 0, 35)
BarraAbas.BackgroundColor3 = Cores.AbasBarra
BarraAbas.BorderSizePixel = 0

local AreaConteudo = Instance.new("Frame", MainFrame)
AreaConteudo.Size = UDim2.new(1, -100, 1, -35)
AreaConteudo.Position = UDim2.new(0, 100, 0, 35)
AreaConteudo.BackgroundTransparency = 1

local AbasCriadas = {}
local PaginasCriadas = {}

local function CriarAba(nome, ordem)
    local btnAba = Instance.new("TextButton", BarraAbas)
    btnAba.Size = UDim2.new(1, 0, 0, 35)
    btnAba.Position = UDim2.new(0, 0, 0, (ordem-1) * 35)
    btnAba.BackgroundColor3 = Cores.BotaoInativo
    btnAba.Text = nome
    btnAba.TextColor3 = Cores.TextoEscuro
    btnAba.TextSize = 12
    btnAba.Font = Enum.Font.GothamMedium
    btnAba.BorderSizePixel = 0

    local pag = Instance.new("ScrollingFrame", AreaConteudo)
    pag.Size = UDim2.new(1, -12, 1, -12)
    pag.Position = UDim2.new(0, 6, 0, 6)
    pag.BackgroundTransparency = 1
    pag.Visible = false
    pag.CanvasSize = UDim2.new(0, 0, 0, 400)
    pag.ScrollBarThickness = 4
    pag.ScrollBarImageColor3 = Cores.Laranja

    local layout = Instance.new("UIListLayout", pag)
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    btnAba.MouseButton1Click:Connect(function()
        for _, v in pairs(PaginasCriadas) do v.Visible = false end
        for _, v in pairs(AbasCriadas) do v.TextColor3 = Cores.TextoEscuro; v.BackgroundColor3 = Cores.BotaoInativo end
        pag.Visible = true
        btnAba.TextColor3 = Cores.Laranja
        btnAba.BackgroundColor3 = Cores.BotaoAtivo
    end)

    table.insert(AbasCriadas, btnAba)
    table.insert(PaginasCriadas, pag)
    return pag
end

local AbaGeral    = CriarAba("⚔️ Geral", 1)
local AbaPoderes  = CriarAba("⚡ Poderes", 2)
local AbaJogador  = CriarAba("🏃 Jogador", 3)
local AbaTeleport = CriarAba("🎯 Teleporte", 4)
local AbaConfig   = CriarAba("⚙️ Config", 5)

AbasCriadas[1].TextColor3 = Cores.Laranja
AbasCriadas[1].BackgroundColor3 = Cores.BotaoAtivo
PaginasCriadas[1].Visible = true

local function adicionarBotao(abaFrame, texto, acao)
    local b = Instance.new("TextButton", abaFrame)
    b.Size = UDim2.new(1, -4, 0, 34)
    b.BackgroundColor3 = Cores.BotaoInativo
    b.Text = texto
    b.TextColor3 = Cores.Texto
    b.TextSize = 11
    b.Font = Enum.Font.GothamSemibold
    cArredondar(b, 4)
    local s = Instance.new("UIStroke", b)
    s.Color = Color3.fromRGB(45, 45, 50)
    s.Thickness = 1
    b.MouseButton1Click:Connect(acao)
    return b, s
end

-- =============================================================================
-- FUNÇÕES AUXILIARES DE GAMEPLAY
-- =============================================================================
local function garantirArmaEquipada()
    local char = LocalPlayer.Character if not char then return nil end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if bp then
            tool = bp:FindFirstChildOfClass("Tool")
            if tool then tool.Parent = char end
        end
    end
    return tool
end

local function forcarAtaque(tool)
    if not tool then return end
    tool:Activate()
    for _, child in pairs(tool:GetDescendants()) do
        if child:IsA("RemoteEvent") or child:IsA("BindableEvent") then
            child:FireServer()
        end
    end
end

local function encontrarLobby()
    local spawnPoint = workspace:FindFirstChildOfClass("SpawnLocation")
    if spawnPoint then return spawnPoint.CFrame + Vector3.new(0, 3, 0) end
    return CFrame.new(0, 50, 0)
end

-- =============================================================================
-- 1. [ ABA GERAL ]
-- =============================================================================
adicionarBotao(AbaGeral, "⭐ GANHAR PARTIDA (Insta-Kill)", function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local originalPos = char.HumanoidRootPart.CFrame

    task.spawn(function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local arma = garantirArmaEquipada()
                    char.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    task.wait(0.1)
                    forcarAtaque(arma)
                end
            end
        end
        char.HumanoidRootPart.CFrame = originalPos
    end)
end)

-- =============================================================================
-- 2. [ ABA PODERES ]
-- =============================================================================
local bAura, sAura = adicionarBotao(AbaPoderes, "⚡ Kill Aura: OFF", function()
    Estado.KillAura = not Estado.KillAura
    bAura.Text = Estado.KillAura and "⚡ Kill Aura: ON" or "⚡ Kill Aura: OFF"
    sAura.Color = Estado.KillAura and Cores.Laranja or Color3.fromRGB(45, 45, 50)

    if Estado.KillAura then
        Conexoes.Aura = RS.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local hum = p.Character:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then
                            local dist = (char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                            if dist <= 18 then
                                local arma = garantirArmaEquipada()
                                forcarAtaque(arma)
                            end
                        end
                    end
                end
            end
        end)
    else
        if Conexoes.Aura then Conexoes.Aura:Disconnect(); Conexoes.Aura = nil end
    end
end)

local cam = workspace.CurrentCamera
local bFly, sFly = adicionarBotao(AbaPoderes, "✈️ Voo Livre: OFF", function()
    Estado.Fly = not Estado.Fly
    bFly.Text = Estado.Fly and "✈️ Voo Livre: ON" or "✈️ Voo Livre: OFF"
    sFly.Color = Estado.Fly and Cores.Laranja or Color3.fromRGB(45, 45, 50)

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if Estado.Fly and hrp and hum then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlyVelocity"
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = Vector3.zero
        bv.Parent = hrp

        Conexoes.Fly = RS.RenderStepped:Connect(function()
            local moveDirection = Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end
            
            bv.Velocity = moveDirection.Magnitude > 0 and moveDirection.Unit * 60 or Vector3.zero
        end)
    else
        if Conexoes.Fly then Conexoes.Fly:Disconnect(); Conexoes.Fly = nil end
        if hrp and hrp:FindFirstChild("FlyVelocity") then hrp.FlyVelocity:Destroy() end
    end
end)

-- =============================================================================
-- 3. [ ABA JOGADOR ]
-- =============================================================================
local bSpeed, sSpeed = adicionarBotao(AbaJogador, "🏃 Velocidade Máxima: OFF", function()
    Estado.SuperSpeed = not Estado.SuperSpeed
    bSpeed.Text = Estado.SuperSpeed and "🏃 Velocidade Máxima: ON" or "🏃 Velocidade Máxima: OFF"
    sSpeed.Color = Estado.SuperSpeed and Cores.Laranja or Color3.fromRGB(45, 45, 50)

    if Estado.SuperSpeed then
        Conexoes.Speed = RS.PreRender:Connect(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 65 end
        end)
    else
        if Conexoes.Speed then Conexoes.Speed:Disconnect(); Conexoes.Speed = nil end
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end
end)

local bJump, sJump = adicionarBotao(AbaJogador, "🦘 Super Pulo: OFF", function()
    Estado.SuperJump = not Estado.SuperJump
    bJump.Text = Estado.SuperJump and "🦘 Super Pulo: ON" or "🦘 Super Pulo: OFF"
    sJump.Color = Estado.SuperJump and Cores.Laranja or Color3.fromRGB(45, 45, 50)

    if Estado.SuperJump then
        Conexoes.Jump = RS.PreRender:Connect(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.JumpPower = 120; hum.UseJumpPower = true end
        end)
    else
        if Conexoes.Jump then Conexoes.Jump:Disconnect(); Conexoes.Jump = nil end
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpPower = 50 end
    end
end)

local bInfJ, sInfJ = adicionarBotao(AbaJogador, "☁️ Pulo Infinito: OFF", function()
    Estado.InfJump = not Estado.InfJump
    bInfJ.Text = Estado.InfJump and "☁️ Pulo Infinito: ON" or "☁️ Pulo Infinito: OFF"
    sInfJ.Color = Estado.InfJump and Cores.Laranja or Color3.fromRGB(45, 45, 50)

    if Estado.InfJump then
        Conexoes.InfJump = UIS.InputBegan:Connect(function(input, gpe)
            if input.KeyCode == Enum.KeyCode.Space and not gpe then
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.Velocity = Vector3.new(hrp.Velocity.X, 60, hrp.Velocity.Z) end
            end
        end)
    else
        if Conexoes.InfJump then Conexoes.InfJump:Disconnect(); Conexoes.InfJump = nil end
    end
end)

local bNoClip, sNoClip = adicionarBotao(AbaJogador, "👻 Atravessar Paredes: OFF", function()
    Estado.Noclip = not Estado.Noclip
    bNoClip.Text = Estado.Noclip and "👻 Atravessar Paredes: ON" or "👻 Atravessar Paredes: OFF"
    sNoClip.Color = Estado.Noclip and Cores.Laranja or Color3.fromRGB(45, 45, 50)

    if Estado.Noclip then
        Conexoes.Noclip = RS.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        OriginalCollisions[part] = true
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if Conexoes.Noclip then Conexoes.Noclip:Disconnect(); Conexoes.Noclip = nil end
        for part, _ in pairs(OriginalCollisions) do
            if part and part.Parent then part.CanCollide = true end
        end
        table.clear(OriginalCollisions)
    end
end)

-- =============================================================================
-- 4. [ ABA TELEPORTE ]
-- =============================================================================
adicionarBotao(AbaTeleport, "🏠 Teleportar para o Lobby", function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = encontrarLobby() end
end)

adicionarBotao(AbaTeleport, "🎯 Player Mais Próximo", function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local menorDist = math.huge
    local alvo = nil

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (hrp.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if dist < menorDist then
                menorDist = dist
                alvo = p.Character.HumanoidRootPart
            end
        end
    end
    if alvo then hrp.CFrame = alvo.CFrame * CFrame.new(0, 0, 3) end
end)

-- =============================================================================
-- 5. [ ABA CONFIG / ESP CORRIGIDA ]
-- =============================================================================
local function limparESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then
            local h = p.Character:FindFirstChild("FireESP")
            if h then h:Destroy() end
        end
    end
end

local function aplicarESP()
    if not Estado.ESP then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("FireESP") then
            local h = Instance.new("Highlight")
            h.Name = "FireESP"
            h.FillColor = Cores.Laranja
            h.FillTransparency = 0.5
            h.OutlineColor = Cores.Texto
            h.OutlineTransparency = 0
            h.Parent = p.Character
        end
    end
end

local bEsp, sEsp = adicionarBotao(AbaConfig, "👁️ Ver Oponentes (ESP): OFF", function()
    Estado.ESP = not Estado.ESP
    bEsp.Text = Estado.ESP and "👁️ Ver Oponentes (ESP): ON" or "👁️ Ver Oponentes (ESP): OFF"
    sEsp.Color = Estado.ESP and Cores.Laranja or Color3.fromRGB(45, 45, 50)
    
    if Estado.ESP then
        aplicarESP()
        Conexoes.ESP = Players.PlayerAdded:Connect(function(p)
            p.CharacterAdded:Connect(function() task.wait(0.5); aplicarESP() end)
        end)
    else
        if Conexoes.ESP then Conexoes.ESP:Disconnect(); Conexoes.ESP = nil end
        limparESP()
    end
end)