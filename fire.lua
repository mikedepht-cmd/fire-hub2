-- [[ FIRE HUB v4 - BY: MHILLLCHILLI (OPTIMIZED & COMPACT) ]]
local Players, UIS, RS, TS = game:GetService("Players"), game:GetService("UserInputService"), game:GetService("RunService"), game:GetService("TweenService")
local LP = Players.LocalPlayer

local antiga = LP:WaitForChild("PlayerGui"):FindFirstChild("FireHubMhilllchilli")
if antiga then antiga:Destroy() end

local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
ScreenGui.Name = "FireHubMhilllchilli"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Cores = {
    Fundo = Color3.fromRGB(15, 15, 18), AbasBarra = Color3.fromRGB(22, 22, 26),
    Laranja = Color3.fromRGB(255, 90, 0), Texto = Color3.fromRGB(255, 255, 255),
    TextoEscuro = Color3.fromRGB(160, 160, 160), BotaoAtivo = Color3.fromRGB(40, 40, 45),
    BotaoInativo = Color3.fromRGB(25, 25, 28), Borda = Color3.fromRGB(45, 45, 50)
}

local Estado = {Fly = false, ESP = false, KillAura = false, SuperSpeed = false, SuperJump = false, InfJump = false, Noclip = false}
local Conexoes, ListaEliminados = {}, {}

local function cArredondar(obj, px)
    local c = Instance.new("UICorner", obj)
    c.CornerRadius = UDim.new(0, px)
end

local function cArrastar(gatilho, alvo)
    local drag, start, pos
    gatilho.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true; start = i.Position; pos = alvo.Position end
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

-- GUI PRINCIPAL
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size, MainFrame.Position, MainFrame.BackgroundColor3, MainFrame.BorderSizePixel = UDim2.new(0, 380, 0, 260), UDim2.new(0.5, -190, 0.5, -130), Cores.Fundo, 0
cArredondar(MainFrame, 6)

local BordaPrincipal = Instance.new("UIStroke", MainFrame)
BordaPrincipal.Color, BordaPrincipal.Thickness = Cores.Laranja, 2

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size, TopBar.BackgroundColor3, TopBar.BorderSizePixel = UDim2.new(1, 0, 0, 32), Cores.AbasBarra, 0
cArredondar(TopBar, 6)
cArrastar(TopBar, MainFrame)

local Titulo = Instance.new("TextLabel", TopBar)
Titulo.Size, Titulo.Position, Titulo.Text, Titulo.TextColor3, Titulo.TextSize, Titulo.Font, Titulo.BackgroundTransparency, Titulo.TextXAlignment = UDim2.new(1, -40, 1, 0), UDim2.new(0, 10, 0, 0), "🔥 FIRE HUB v4 | Criador: Mhilllchilli", Cores.Texto, 13, Enum.Font.GothamBold, 1, Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size, MinBtn.Position, MinBtn.Text, MinBtn.TextColor3, MinBtn.TextSize, MinBtn.Font, MinBtn.BackgroundTransparency = UDim2.new(0, 24, 0, 24), UDim2.new(1, -28, 0, 4), "🗕", Cores.Laranja, 16, Enum.Font.GothamBold, 1

local BolaFogo = Instance.new("TextButton", ScreenGui)
BolaFogo.Size, BolaFogo.Position, BolaFogo.BackgroundColor3, BolaFogo.Text, BolaFogo.TextSize, BolaFogo.Visible = UDim2.new(0, 48, 0, 48), UDim2.new(0.1, 0, 0.1, 0), Cores.Laranja, "🔥", 24, false
cArredondar(BolaFogo, 24)
cArrastar(BolaFogo, BolaFogo)

local function alternarMinimizar()
    local flutuando = not MainFrame.Visible
    MainFrame.Visible, BolaFogo.Visible = flutuando, not flutuando
    if not flutuando then BolaFogo.Position = UDim2.new(0, MainFrame.AbsolutePosition.X + 166, 0, MainFrame.AbsolutePosition.Y + 106) end
end
MinBtn.MouseButton1Click:Connect(alternarMinimizar)
BolaFogo.MouseButton1Click:Connect(alternarMinimizar)

-- SISTEMA DE ABAS
local BarraAbas = Instance.new("Frame", MainFrame)
BarraAbas.Size, BarraAbas.Position, BarraAbas.BackgroundColor3, BarraAbas.BorderSizePixel = UDim2.new(0, 95, 1, -32), UDim2.new(0, 0, 0, 32), Cores.AbasBarra, 0

local AreaConteudo = Instance.new("Frame", MainFrame)
AreaConteudo.Size, AreaConteudo.Position, AreaConteudo.BackgroundTransparency = UDim2.new(1, -95, 1, -32), UDim2.new(0, 95, 0, 32), 1

local AbasCriadas, PaginasCriadas = {}, {}

local function CriarAba(nome, ordem)
    local btnAba = Instance.new("TextButton", BarraAbas)
    btnAba.Size, btnAba.Position, btnAba.BackgroundColor3, btnAba.Text, btnAba.TextColor3, btnAba.TextSize, btnAba.Font, btnAba.BorderSizePixel = UDim2.new(1, 0, 0, 32), UDim2.new(0, 0, 0, (ordem-1) * 32), Cores.BotaoInativo, nome, Cores.TextoEscuro, 11, Enum.Font.GothamMedium, 0
    
    local pag = Instance.new("ScrollingFrame", AreaConteudo)
    pag.Size, pag.Position, pag.BackgroundTransparency, pag.Visible, pag.CanvasSize, pag.AutomaticCanvasSize, pag.ScrollBarThickness, pag.ScrollBarImageColor3 = UDim2.new(1, -12, 1, -12), UDim2.new(0, 6, 0, 6), 1, false, UDim2.new(0, 0, 0, 0), Enum.AutomaticCanvasSize.Y, 3, Cores.Laranja
    
    local layout = Instance.new("UIListLayout", pag)
    layout.Padding, layout.SortOrder = UDim.new(0, 5), Enum.SortOrder.LayoutOrder
    
    btnAba.MouseButton1Click:Connect(function()
        for i, v in ipairs(PaginasCriadas) do v.Visible = false; AbasCriadas[i].TextColor3 = Cores.TextoEscuro; AbasCriadas[i].BackgroundColor3 = Cores.BotaoInativo end
        pag.Visible, btnAba.TextColor3, btnAba.BackgroundColor3 = true, Cores.Laranja, Cores.BotaoAtivo
    end)
    table.insert(AbasCriadas, btnAba); table.insert(PaginasCriadas, pag)
    return pag
end

local AbaGeral, AbaPoderes, AbaJogador, AbaTeleport, AbaConfig = CriarAba("⚔️ Geral", 1), CriarAba("⚡ Poderes", 2), CriarAba("🏃 Jogador", 3), CriarAba("🎯 Teleporte", 4), CriarAba("⚙️ Config", 5)
AbasCriadas[1].TextColor3, AbasCriadas[1].BackgroundColor3, PaginasCriadas[1].Visible = Cores.Laranja, Cores.BotaoAtivo, true

local function adicionarBotao(abaFrame, texto, acao)
    local b = Instance.new("TextButton", abaFrame)
    b.Size, b.BackgroundColor3, b.Text, b.TextColor3, b.TextSize, b.Font = UDim2.new(1, -4, 0, 32), Cores.BotaoInativo, texto, Cores.Texto, 11, Enum.Font.Gotham
    cArredondar(b, 4)
    local s = Instance.new("UIStroke", b)
    s.Color, s.Thickness = Cores.Borda, 1
    b.MouseButton1Click:Connect(function()
        local sucesso, erro = pcall(acao)
        if not sucesso then warn("[FIRE HUB ERROR]: " .. tostring(erro)) end
    end)
    return b, s
end

-- FUNÇÕES CORE
local function forcarAtaque(tool)
    if not tool or not tool:IsA("Tool") then return end
    tool:Activate()
    for _, child in ipairs(tool:GetChildren()) do
        if child:IsA("RemoteEvent") or child:IsA("BindableEvent") then
            child:FireServer()
            child:FireServer(LP:GetMouse().Hit.Position)
        end
    end
end

local function garantirArmaEquipada()
    local char = LP.Character or LP.CharacterAdded:Wait()
    local tool = char:FindFirstChildOfClass("Tool") or (LP:FindFirstChild("Backpack") and LP.Backpack:FindFirstChildOfClass("Tool"))
    if tool and tool.Parent ~= char then tool.Parent = char; task.wait() end
    return tool
end

local function encontrarLobby()
    local spawn = workspace:FindFirstChildOfClass("SpawnLocation") or workspace:FindFirstChild("Lobby") or workspace:FindFirstChild("lobby")
    return spawn and (spawn.CFrame + Vector3.new(0, 3, 0)) or CFrame.new(0, 100, 0)
end

-- 1. ABA GERAL
adicionarBotao(AbaGeral, "⭐ GANHAR PARTIDA (Secreto)", function()
    table.clear(ListaEliminados)
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local lobbyPos = encontrarLobby()
    
    task.spawn(function()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hum, alvoHRP = p.Character:FindFirstChildOfClass("Humanoid"), p.Character.HumanoidRootPart
                if hum and hum.Health > 0 and not table.find(ListaEliminados, p.UserId) then
                    hrp.CFrame = alvoHRP.CFrame * CFrame.new(0, 0, 3); task.wait(0.05)
                    local tempoGasto = 0
                    while hum and hum.Health > 0 and tempoGasto < 0.4 do
                        forcarAtaque(garantirArmaEquipada())
                        hrp.CFrame = alvoHRP.CFrame * CFrame.new(0, 0, 3)
                        RS.Heartbeat:Wait()
                        tempoGasto = tempoGasto + 0.02
                    end
                    table.insert(ListaEliminados, p.UserId)
                end
            end
        end
        hrp.CFrame = lobbyPos
    end)
end)

-- 2. ABA PODERES
local bAura, sAura = adicionarBotao(AbaPoderes, "⚡ Kill Aura: OFF", function()
    Estado.KillAura = not Estado.KillAura
    bAura.Text, sAura.Color = Estado.KillAura and "⚡ Kill Aura: ON" or "⚡ Kill Aura: OFF", Estado.KillAura and Cores.Laranja or Cores.Borda
    if Estado.KillAura then
        Conexoes.Aura = RS.Heartbeat:Connect(function()
            local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 and (hrp.Position - p.Character.HumanoidRootPart.Position).Magnitude <= 18 then
                        forcarAtaque(garantirArmaEquipada())
                    end
                end
            end
        end)
    elseif Conexoes.Aura then Conexoes.Aura:Disconnect(); Conexoes.Aura = nil end
end)

local cam = workspace.CurrentCamera
local bFly, sFly = adicionarBotao(AbaPoderes, "✈️ Voo Livre: OFF", function()
    Estado.Fly = not Estado.Fly
    bFly.Text, sFly.Color = Estado.Fly and "✈️ Voo Livre: ON" or "✈️ Voo Livre: OFF", Estado.Fly and Cores.Laranja or Cores.Borda
    local c = LP.Character
    local hrp, hum = c and c:FindFirstChild("HumanoidRootPart"), c and c:FindFirstChildOfClass("Humanoid")
    if Estado.Fly and hrp and hum then
        hum.PlatformStand = true
        local bv, bg = Instance.new("BodyVelocity", hrp), Instance.new("BodyGyro", hrp)
        bv.Name, bv.MaxForce = "FlyBV", Vector3.new(1e5, 1e5, 1e5)
        bg.Name, bg.MaxTorque, bg.CFrame = "FlyBG", Vector3.new(1e5, 1e5, 1e5), hrp.CFrame
        Conexoes.Fly = RS.RenderStepped:Connect(function()
            if not hrp or not bv or not bg then return end
            local dir = Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
            bv.Velocity, bg.CFrame = dir.Magnitude > 0 and dir.Unit * 70 or Vector3.zero, cam.CFrame
        end)
    else
        if Conexoes.Fly then Conexoes.Fly:Disconnect(); Conexoes.Fly = nil end
        if hum then hum.PlatformStand = false end
        if hrp then
            local fv, fg = hrp:FindFirstChild("FlyBV"), hrp:FindFirstChild("FlyBG")
            if fv then fv:Destroy() end if fg then fg:Destroy() end
        end
    end
end)

-- 3. ABA JOGADOR
local bSpeed, sSpeed = adicionarBotao(AbaJogador, "🏃 Velocidade Maxima: OFF", function()
    Estado.SuperSpeed = not Estado.SuperSpeed
    bSpeed.Text, sSpeed.Color = Estado.SuperSpeed and "🏃 Velocidade Maxima: ON" or "🏃 Velocidade Maxima: OFF", Estado.SuperSpeed and Cores.Laranja or Cores.Borda
    if Estado.SuperSpeed then
        Conexoes.Speed = RS.Heartbeat:Connect(function()
            local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.WalkSpeed ~= 65 then hum.WalkSpeed = 65 end
        end)
    else
        if Conexoes.Speed then Conexoes.Speed:Disconnect(); Conexoes.Speed = nil end
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end
end)

local bJump, sJump = adicionarBotao(AbaJogador, "🦘 Super Pulo: OFF", function()
    Estado.SuperJump = not Estado.SuperJump
    bJump.Text, sJump.Color = Estado.SuperJump and "🦘 Super Pulo: ON" or "🦘 Super Pulo: OFF", Estado.SuperJump and Cores.Laranja or Cores.Borda
    if Estado.SuperJump then
        Conexoes.Jump = RS.Heartbeat:Connect(function()
            local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.UseJumpPower = true; if hum.JumpPower ~= 120 then hum.JumpPower = 120 end end
        end)