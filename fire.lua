-- [[ FIRE HUB v4 - BY: MHILLLCHILLI ]]
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

-- Tema de cores calibrado (Moderno, Retangular e Visível)
local Cores = {
    Fundo = Color3.fromRGB(15, 15, 18),
    AbasBarra = Color3.fromRGB(22, 22, 26),
    Laranja = Color3.fromRGB(255, 90, 0),
    Texto = Color3.fromRGB(255, 255, 255),
    TextoEscuro = Color3.fromRGB(160, 160, 160),
    BotaoAtivo = Color3.fromRGB(40, 40, 45),
    BotaoInativo = Color3.fromRGB(25, 25, 28)
}

-- Estados Globais
local Estado = {
    Fly = false, 
    ESP = false, 
    AutoChat = false, 
    KillAura = false,
    SuperSpeed = false,
    SuperJump = false,
    InfJump = false,
    Noclip = false
}
local Conexoes = {}
local ListaEliminados = {}

-- =============================================================================
-- FUNÇÕES DE SISTEMA (ARRAS TAR NATIVO E ARREDONDAMENTO LEVE)
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
-- ESTRUTURA VISUAL DA GUI (RETANGULAR - Redimensionada para comportar mais abas)
-- =============================================================================
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 380, 0, 260) -- Aumentado levemente para caber tudo bem organizado
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -130)
MainFrame.BackgroundColor3 = Cores.Fundo
MainFrame.BorderSizePixel = 0
cArredondar(MainFrame, 6)

local BordaPrincipal = Instance.new("UIStroke", MainFrame)
BordaPrincipal.Color = Cores.Laranja
BordaPrincipal.Thickness = 2

-- Barra de Topo
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 32)
TopBar.BackgroundColor3 = Cores.AbasBarra
TopBar.BorderSizePixel = 0
cArredondar(TopBar, 6)
cArrastar(TopBar, MainFrame)

local Titulo = Instance.new("TextLabel", TopBar)
Titulo.Size = UDim2.new(1, -40, 1, 0)
Titulo.Position = UDim2.new(0, 10, 0, 0)
Titulo.Text = "🔥 FIRE HUB v4 | Criador: Mhilllchilli"
Titulo.TextColor3 = Cores.Texto
Titulo.TextSize = 13
Titulo.Font = Enum.Font.GothamBold
Titulo.BackgroundTransparency = 1
Titulo.TextXAlignment = Enum.TextXAlignment.Left

-- Botão Minimizar
local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 24, 0, 24)
MinBtn.Position = UDim2.new(1, -28, 0, 4)
MinBtn.Text = "🗕"
MinBtn.TextColor3 = Cores.Laranja
MinBtn.TextSize = 16
MinBtn.Font = Enum.Font.GothamBold
MinBtn.BackgroundTransparency = 1

-- BOLINHA FLUTUANTE (Modo Minimizado)
local BolaFogo = Instance.new("TextButton", ScreenGui)
BolaFogo.Size = UDim2.new(0, 48, 0, 48)
BolaFogo.Position = UDim2.new(0.1, 0, 0.1, 0)
BolaFogo.BackgroundColor3 = Cores.Laranja
BolaFogo.Text = "🔥"
BolaFogo.TextSize = 24
BolaFogo.Visible = false
cArredondar(BolaFogo, 24)
cArrastar(BolaFogo, BolaFogo)

local function alternarMinimizar()
    local flutuando = not MainFrame.Visible
    MainFrame.Visible = flutuando
    BolaFogo.Visible = not flutuando
    if not flutuando then
        BolaFogo.Position = UDim2.new(0, MainFrame.AbsolutePosition.X + 166, 0, MainFrame.AbsolutePosition.Y + 106)
    end
end
MinBtn.MouseButton1Click:Connect(alternarMinimizar)
BolaFogo.MouseButton1Click:Connect(alternarMinimizar)

-- =============================================================================
-- SISTEMA DE ABAS NATIVO
-- =============================================================================
local BarraAbas = Instance.new("Frame", MainFrame)
BarraAbas.Size = UDim2.new(0, 95, 1, -32) -- Ajustado largura para comportar os nomes
BarraAbas.Position = UDim2.new(0, 0, 0, 32)
BarraAbas.BackgroundColor3 = Cores.AbasBarra
BarraAbas.BorderSizePixel = 0

local AreaConteudo = Instance.new("Frame", MainFrame)
AreaConteudo.Size = UDim2.new(1, -95, 1, -32)
AreaConteudo.Position = UDim2.new(0, 95, 0, 32)
AreaConteudo.BackgroundTransparency = 1

local AbasCriadas = {}
local PaginasCriadas = {}

local function CriarAba(nome, ordem)
    local btnAba = Instance.new("TextButton", BarraAbas)
    btnAba.Size = UDim2.new(1, 0, 0, 32)
    btnAba.Position = UDim2.new(0, 0, 0, (ordem-1) * 32)
    btnAba.BackgroundColor3 = Cores.BotaoInativo
    btnAba.Text = nome
    btnAba.TextColor3 = Cores.TextoEscuro
    btnAba.TextSize = 11
    btnAba.Font = Enum.Font.GothamMedium
    btnAba.BorderSizePixel = 0
    
    local pag = Instance.new("ScrollingFrame", AreaConteudo)
    pag.Size = UDim2.new(1, -12, 1, -12)
    pag.Position = UDim2.new(0, 6, 0, 6)
    pag.BackgroundTransparency = 1
    pag.Visible = false
    pag.CanvasSize = UDim2.new(0, 0, 0, 350)
    pag.ScrollBarThickness = 3
    pag.ScrollBarImageColor3 = Cores.Laranja
    
    local layout = Instance.new("UIListLayout", pag)
    layout.Padding = UDim.new(0, 5)
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

-- Definição das 5 Abas (2 Novas Adicionadas)
local AbaGeral    = CriarAba("⚔️ Geral", 1)
local AbaPoderes  = CriarAba("⚡ Poderes", 2)
local AbaJogador  = CriarAba("🏃 Jogador", 3)  -- NOVA!
local AbaTeleport = CriarAba("🎯 Teleporte", 4) -- NOVA!
local AbaConfig   = CriarAba("⚙️ Config", 5)

-- Ativar primeira aba por padrão
AbasCriadas[1].TextColor3 = Cores.Laranja
AbasCriadas[1].BackgroundColor3 = Cores.BotaoAtivo
PaginasCriadas[1].Visible = true

-- Criador de botões internos das abas
local function adicionarBotao(abaFrame, texto, acao)
    local b = Instance.new("TextButton", abaFrame)
    b.Size = UDim2.new(1, -4, 0, 32)
    b.BackgroundColor3 = Cores.BotaoInativo
    b.Text = texto
    b.TextColor3 = Cores.Texto
    b.TextSize = 11
    b.Font = Enum.Font.Gotham
    cArredondar(b, 4)
    local s = Instance.new("UIStroke", b)
    s.Color = Color3.fromRGB(45, 45, 50)
    s.Thickness = 1
    b.MouseButton1Click:Connect(acao)
    return b, s
end

-- =============================================================================
-- MECÂNICAS CORE E AUXILIARES
-- =============================================================================
local function forcarAtaque(tool)
    if not tool then return end
    tool:Activate()
    for _, child in pairs(tool:GetDescendants()) do
        if child:IsA("RemoteEvent") or child:IsA("BindableEvent") then
            child:FireServer()
            child:FireServer(LocalPlayer:GetMouse().Hit.Position)
        end
    end
end

local function garantirArmaEquipada()
    local char = LocalPlayer.Character if not char then return nil end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if bp then
            tool = bp:FindFirstChildOfClass("Tool")
            if tool then tool.Parent = char task.wait(0.05) end
        end
    end
    return tool
end

local function encontrarLobby()
    local spawnPoint = workspace:FindFirstChildOfClass("SpawnLocation")
    if spawnPoint then return spawnPoint.CFrame + Vector3.new(0, 3, 0) end
    local lobbyMapeado = workspace:FindFirstChild("Lobby") or workspace:FindFirstChild("lobby")
    if lobbyMapeado and lobbyMapeado:IsA("BasePart") then return lobbyMapeado.CFrame + Vector3.new(0, 3, 0) end
    return CFrame.new(0, 100, 0)
end

-- =============================================================================
-- 1. [ ABA GERAL ]
-- =============================================================================
adicionarBotao(AbaGeral, "⭐ GANHAR PARTIDA (Secreto)", function()
    table.clear(ListaEliminados)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local lobbyPos = encontrarLobby()
    
    task.spawn(function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hum.Health > 0 and not table.find(ListaEliminados, p.UserId) then
                    local alvoHRP = p.Character.HumanoidRootPart
                    char.HumanoidRootPart.CFrame = alvoHRP.CFrame * CFrame.new(0, 0, 3.5)
                    task.wait(0.1)
                    
                    local tempoGasto = 0
                    while hum.Health > 0 and tempoGasto < 0.4 do
                        local arma = garantirArmaEquipada()
                        forcarAtaque(arma)
                        char.HumanoidRootPart.CFrame = alvoHRP.CFrame * CFrame.new(0, 0, 3.5)
                        task.wait(0.05)
                        tempoGasto = tempoGasto + 0.05
                    end
                    table.insert(ListaEliminados, p.UserId)
                    char.HumanoidRootPart.CFrame = lobbyPos
                    task.wait(0.5)
                end
            end
        end
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
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") then
                        if p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                            local dist = (char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                            if dist <= 16 then
                                local arma = garantirArmaEquipada()
                                forcarAtaque(arma)
                            end
                        end
                    end
                end
            end
        end)
    elseif Conexoes.Aura then Conexoes.Aura:Disconnect() end
end)

local cam = workspace.CurrentCamera
local bFly, sFly = adicionarBotao(AbaPoderes, "✈️ Voo Livre: OFF", function()
    Estado.Fly = not Estado.Fly
    bFly.Text = Estado.Fly and "✈️ Voo Livre: ON" or "✈️ Voo Livre: OFF"
    sFly.Color = Estado.Fly and Cores.Laranja or Color3.fromRGB(45, 45, 50)
    
    local c = LocalPlayer.Character local hrp = c and c:FindFirstChild("HumanoidRootPart") local hum = c and c:FindFirstChildOfClass("Humanoid")
    if Estado.Fly and hrp and hum then
        hum.PlatformStand = true
        local bv = Instance.new("BodyVelocity", hrp); bv.Name = "FlyBV"; bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        Conexoes.Fly = RS.RenderStepped:Connect(function()
            local dir = Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
            bv.Velocity = dir.Magnitude > 0 and dir.Unit * 70 or Vector3.zero
        end)
    else
        if Conexoes.Fly then Conexoes.Fly:Disconnect() end
        if hum then hum.PlatformStand = false end
        if hrp and hrp:FindFirstChild("FlyBV") then hrp.FlyBV:Destroy() end
    end
end)

-- =============================================================================
-- 3. [ ABA JOGADOR ] (NOVA ABA!)
-- =============================================================================
local bSpeed, sSpeed = adicionarBotao(AbaJogador, "🏃 Velocidade Maxima: OFF", function()
    Estado.SuperSpeed = not Estado.SuperSpeed
    bSpeed.Text = Estado.SuperSpeed and "🏃 Velocidade Maxima: ON" or "🏃 Velocidade Maxima: OFF"
    sSpeed.Color = Estado.SuperSpeed and Cores.Laranja or Color3.fromRGB(45, 45, 50)
    
    if Estado.SuperSpeed then
        Conexoes.Speed = RS.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 65 else hum.WalkSpeed = 16 end
        end)
    else
        if Conexoes.Speed then Conexoes.Speed:Disconnect() end
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end
end)

local bJump, sJump = adicionarBotao(AbaJogador, "🦘 Super Pulo: OFF", function()
    Estado.SuperJump = not Estado.SuperJump
    bJump.Text = Estado.SuperJump and "🦘 Super Pulo: ON" or "🦘 Super Pulo: OFF"
    sJump.Color = Estado.SuperJump and Cores.Laranja or Color3.fromRGB(45, 45, 50)
    
    if Estado.SuperJump then
        Conexoes.Jump = RS.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.JumpPower = 120; hum.UseJumpPower = true end
        end)
    else
        if Conexoes.Jump then Conexoes.Jump:Disconnect() end
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
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
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.Velocity = Vector3.new(hrp.Velocity.X, 60, hrp.Velocity.Z) end
            end
        end)
    else
        if Conexoes.InfJump then Conexoes.InfJump:Disconnect() end
    end
end)

local bNoClip, sNoClip = adicionarBotao(AbaJogador, "👻 Atravessar Paredes: OFF", function()
    Estado.Noclip = not Estado.Noclip
    bNoClip.Text = Estado.Noclip and "👻 Atravessar Paredes: ON" or "👻 Atravessar Paredes: OFF"
    sNoClip.Color = Estado.Noclip and Cores.Laranja or Color3.fromRGB(45, 45, 50)
    
    if Estado.Noclip then
        Conexoes.Noclip = RS.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, child in pairs(char:GetDescendants()) do
                    if child:IsA("BasePart") and child.CanCollide then child.CanCollide = false end
                end
            end
        end)
    else
        if Conexoes.Noclip then Conexoes.Noclip:Disconnect() end
    end
end)

-- =============================================================================
-- 4. [ ABA TELEPORTE ] (NOVA ABA!)
-- =============================================================================
adicionarBotao(AbaTeleport, "🏠 Teleportar para o Lobby", function()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = encontrarLobby() end
end)

adicionarBotao(AbaTeleport, "🎯 Teleportar pro Player mais Próximo", function()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local menorDistancia = math.huge
    local alvo = nil
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (hrp.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if dist < menorDistancia then
                menorDistancia = dist
                alvo = p.Character.HumanoidRootPart
            end
        end
    end
    if alvo then hrp.CFrame = alvo.CFrame * CFrame.new(0, 0, 3) end
end)

adicionarBotao(AbaTeleport, "🎲 Teleporte Aleatório", function()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local listaPlayers = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(listaPlayers, p.Character.HumanoidRootPart)
        end
    end
    if #listaPlayers > 0 then
        local sorteado = listaPlayers[math.random(1, #listaPlayers)]
        hrp.CFrame = sorteado.CFrame * CFrame.new(0, 0, 2)
    end
end)

-- =============================================================================
-- 5. [ ABA CONFIG ]
-- =============================================================================
local function atualizarESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local h = p.Character:FindFirstChild("FireESP")
            if Estado.ESP then
                if not h then
                    h = Instance.new("Highlight", p.Character); h.Name = "FireESP"
                    h.FillColor, h.FillTransparency = Cores.Laranja, 0.5
                    h.OutlineColor, h.OutlineTransparency = Cores.Texto, 0
                end
            elseif h then h:Destroy() end
        end
    end
end
local bEsp, sEsp = adicionarBotao(AbaConfig, "👁️ Ver Oponentes (ESP): OFF", function()
    Estado.ESP = not Estado.ESP
    bEsp.Text = Estado.ESP and "👁️ Ver Oponentes (ESP): ON" or "👁️ Ver Oponentes (ESP): OFF"
    sEsp.Color = Estado.ESP and Cores.Laranja or Color3.fromRGB(45, 45, 50)
    atualizarESP()
end)
Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(function() task.wait(0.6); atualizarESP() end) end)