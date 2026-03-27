--[[
    ╔══════════════════════════════════════════╗
    ║      H4LL0 W0RLD HUB | WALLHOP         ║
    ║         Universal  •  v2.0              ║
    ║       KEY: H4ll0_access_Wallhop         ║
    ╚══════════════════════════════════════════╝
]]

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Debris           = game:GetService("Debris")
local LocalPlayer      = Players.LocalPlayer
local Camera           = workspace.CurrentCamera

local C = {
    BG        = Color3.fromRGB(14, 14, 16),
    BG2       = Color3.fromRGB(18, 18, 22),
    BG3       = Color3.fromRGB(22, 22, 28),
    Card      = Color3.fromRGB(26, 26, 32),
    Accent    = Color3.fromRGB(180, 20, 20),
    AccentDim = Color3.fromRGB(100, 10, 10),
    AccentGlow= Color3.fromRGB(220, 40, 40),
    ON        = Color3.fromRGB(180, 20, 20),
    OFF       = Color3.fromRGB(40, 40, 50),
    Text      = Color3.fromRGB(230, 225, 235),
    TextSub   = Color3.fromRGB(140, 130, 155),
    TextDim   = Color3.fromRGB(80, 75, 95),
    Border    = Color3.fromRGB(45, 42, 55),
    BorderAcc = Color3.fromRGB(90, 20, 20),
    Green     = Color3.fromRGB(50, 200, 120),
    Gold      = Color3.fromRGB(255, 200, 50),
    Purple    = Color3.fromRGB(168, 85, 247),
}

local Toggles = {
    Aimbot     = false,
    SilentAim  = false,
    StrongLock = false,
    ESP        = false,
    GodMode    = false,
    WallHop    = false,
    AntiAFK    = false,
    BoostFPS   = false,
}

local Settings = {
    FOV          = 150,
    AimSpeed     = 8,
    AimPart      = "Head",
    WallHopForce = 60,
    WallHopFlick = 30,
}

local Connections = {}
local Minimized   = false
local VALID_KEY   = "H4ll0_access_Wallhop"

local function New(class, props, parent)
    local obj = Instance.new(class)
    for k,v in pairs(props or {}) do pcall(function() obj[k]=v end) end
    if parent then obj.Parent=parent end
    return obj
end
local function Corner(p,r) return New("UICorner",{CornerRadius=UDim.new(0,r or 6)},p) end
local function Stroke(p,col,th) return New("UIStroke",{Color=col or C.Border,Thickness=th or 1},p) end
local function Tween(obj,props,t)
    pcall(function() TweenService:Create(obj,TweenInfo.new(t or 0.2,Enum.EasingStyle.Quart),props):Play() end)
end
local function GetChar()
    local char = LocalPlayer.Character
    if not char then return nil,nil,nil end
    return char, char:FindFirstChild("HumanoidRootPart"), char:FindFirstChildOfClass("Humanoid")
end
local function StopAll()
    for k,c in pairs(Connections) do pcall(function() c:Disconnect() end); Connections[k]=nil end
end
local function ClearESP()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr.Character then
            local root=plr.Character:FindFirstChild("HumanoidRootPart")
            if root then local bb=root:FindFirstChild("ESP_BB"); if bb then pcall(function() bb:Destroy() end) end end
            local hl=plr.Character:FindFirstChild("ESP_HL"); if hl then pcall(function() hl:Destroy() end) end
        end
    end
end
local function GetAimTarget()
    local closest,dist=nil,math.huge
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LocalPlayer and plr.Character then
            local part=plr.Character:FindFirstChild(Settings.AimPart) or plr.Character:FindFirstChild("Head")
            if part then
                local sp,onScreen=Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local center=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
                    local d=(Vector2.new(sp.X,sp.Y)-center).Magnitude
                    if d<Settings.FOV and d<dist then dist=d; closest=part end
                end
            end
        end
    end
    return closest
end

local function ApplyFeature(key, val)
    local char,hrp,hum = GetChar()

    if key=="Aimbot" then
        if val then
            Connections.Aimbot=RunService.RenderStepped:Connect(function()
                local t=GetAimTarget()
                if t then pcall(function()
                    Camera.CFrame=Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position,t.Position),math.clamp(Settings.AimSpeed/100,0.02,0.3))
                end) end
            end)
        else
            if Connections.Aimbot then pcall(function() Connections.Aimbot:Disconnect() end); Connections.Aimbot=nil end
        end

    elseif key=="SilentAim" then
        if val then
            Connections.SilentAim=RunService.RenderStepped:Connect(function()
                local t=GetAimTarget()
                if t and hrp then pcall(function()
                    local dir=(t.Position-hrp.Position).Unit
                    hrp.CFrame=CFrame.new(hrp.Position)*CFrame.Angles(0,math.atan2(dir.X,dir.Z),0)
                end) end
            end)
        else
            if Connections.SilentAim then pcall(function() Connections.SilentAim:Disconnect() end); Connections.SilentAim=nil end
        end

    elseif key=="StrongLock" then
        if val then
            Connections.StrongLock=RunService.RenderStepped:Connect(function()
                local t=GetAimTarget()
                if t then pcall(function() Camera.CFrame=CFrame.lookAt(Camera.CFrame.Position,t.Position) end) end
            end)
        else
            if Connections.StrongLock then pcall(function() Connections.StrongLock:Disconnect() end); Connections.StrongLock=nil end
        end

    elseif key=="ESP" then
        if val then
            Connections.ESP=RunService.Heartbeat:Connect(function()
                local _,hrp2,_=GetChar()
                for _,plr in ipairs(Players:GetPlayers()) do
                    if plr~=LocalPlayer and plr.Character then
                        local root=plr.Character:FindFirstChild("HumanoidRootPart")
                        if root then
                            local dist2=hrp2 and math.floor((root.Position-hrp2.Position).Magnitude) or 0
                            local bb=root:FindFirstChild("ESP_BB")
                            if bb then
                                local lbl=bb:FindFirstChildOfClass("TextLabel")
                                if lbl then lbl.Text="💀 "..plr.Name.."\n📏 "..dist2.."m" end
                            else
                                pcall(function()
                                    local b=New("BillboardGui",{Name="ESP_BB",Size=UDim2.new(0,120,0,32),StudsOffset=Vector3.new(0,4,0),AlwaysOnTop=true},root)
                                    New("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="💀 "..plr.Name.."\n📏 "..dist2.."m",TextColor3=C.AccentGlow,TextSize=11,Font=Enum.Font.GothamBold,TextWrapped=true},b)
                                    local hl=Instance.new("Highlight")
                                    hl.Name="ESP_HL"; hl.FillColor=Color3.fromRGB(180,20,20)
                                    hl.OutlineColor=Color3.fromRGB(255,50,50)
                                    hl.FillTransparency=0.45
                                    hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
                                    hl.Adornee=plr.Character; hl.Parent=plr.Character
                                end)
                            end
                        end
                    end
                end
            end)
        else
            if Connections.ESP then pcall(function() Connections.ESP:Disconnect() end); Connections.ESP=nil end
            ClearESP()
        end

    elseif key=="GodMode" then
        if val then
            Connections.GodMode=RunService.Heartbeat:Connect(function()
                local _,_,h=GetChar(); if h and h.Health<h.MaxHealth then h.Health=h.MaxHealth end
            end)
        else
            if Connections.GodMode then pcall(function() Connections.GodMode:Disconnect() end); Connections.GodMode=nil end
        end

    elseif key=="WallHop" then
        if val then
            local wasOnWall = false

            Connections.WallHop = RunService.Stepped:Connect(function()
                local c,hrp2,hum2 = GetChar()
                if not c or not hrp2 or not hum2 then return end

                local params = RaycastParams.new()
                params.FilterDescendantsInstances = {c}
                params.FilterType = Enum.RaycastFilterType.Exclude

                -- Cek 4 arah
                local dirs = {
                    {vec=hrp2.CFrame.LookVector,   side="front"},
                    {vec=-hrp2.CFrame.LookVector,  side="back"},
                    {vec=hrp2.CFrame.RightVector,  side="right"},
                    {vec=-hrp2.CFrame.RightVector, side="left"},
                }

                local onWall  = false
                local hitSide = nil
                for _,d in ipairs(dirs) do
                    local ray=workspace:Raycast(hrp2.Position, d.vec*2.5, params)
                    if ray and math.abs(ray.Normal.Y)<0.5 then
                        onWall=true; hitSide=d.side; break
                    end
                end

                local state = hum2:GetState()
                local isAirborne = state==Enum.HumanoidStateType.Freefall
                                or state==Enum.HumanoidStateType.Jumping

                -- Hop hanya saat PERTAMA menyentuh wall (wasOnWall false → true)
                if onWall and isAirborne and not wasOnWall then
                    pcall(function()
                        -- Flick direction berdasarkan sisi wall
                        local flickX, flickZ = 0, 0
                        if hitSide=="right" then
                            -- Wall di kanan → flick ke kiri
                            flickX = -hrp2.CFrame.RightVector.X * Settings.WallHopFlick
                            flickZ = -hrp2.CFrame.RightVector.Z * Settings.WallHopFlick
                        elseif hitSide=="left" then
                            -- Wall di kiri → flick ke kanan
                            flickX = hrp2.CFrame.RightVector.X * Settings.WallHopFlick
                            flickZ = hrp2.CFrame.RightVector.Z * Settings.WallHopFlick
                        elseif hitSide=="front" then
                            -- Wall depan → flick mundur
                            flickX = -hrp2.CFrame.LookVector.X * Settings.WallHopFlick
                            flickZ = -hrp2.CFrame.LookVector.Z * Settings.WallHopFlick
                        elseif hitSide=="back" then
                            -- Wall belakang → flick maju
                            flickX = hrp2.CFrame.LookVector.X * Settings.WallHopFlick
                            flickZ = hrp2.CFrame.LookVector.Z * Settings.WallHopFlick
                        end

                        local bv = Instance.new("BodyVelocity")
                        bv.Velocity = Vector3.new(
                            flickX,
                            Settings.WallHopForce,
                            flickZ
                        )
                        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                        bv.Parent = hrp2
                        Debris:AddItem(bv, 0.15)
                    end)
                end

                -- Update state
                wasOnWall = onWall

                -- Reset wasOnWall saat landing biar bisa hop lagi
                if state==Enum.HumanoidStateType.Running
                or state==Enum.HumanoidStateType.RunningNoPhysics then
                    wasOnWall = false
                end
            end)
        else
            if Connections.WallHop then pcall(function() Connections.WallHop:Disconnect() end); Connections.WallHop=nil end
        end

    elseif key=="AntiAFK" then
        if val then
            Connections.AntiAFK=RunService.Heartbeat:Connect(function()
                pcall(function() LocalPlayer:Move(Vector3.new(0,0,0)) end)
            end)
        else
            if Connections.AntiAFK then pcall(function() Connections.AntiAFK:Disconnect() end); Connections.AntiAFK=nil end
        end

    elseif key=="BoostFPS" then
        if val then
            for _,obj in ipairs(workspace:GetDescendants()) do
                pcall(function()
                    if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                        obj.Enabled=false
                    end
                end)
            end
        end
    end
end

-- ═══════════════════════════
--        KEY SCREEN
-- ═══════════════════════════
local GUI = New("ScreenGui",{Name="H4ll0WallHop",ResetOnSpawn=false,DisplayOrder=999,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},game.CoreGui)

local KeyScreen = New("Frame",{Size=UDim2.new(1,0,1,0),BackgroundColor3=C.BG,BorderSizePixel=0},GUI)

for i=1,30 do
    New("Frame",{Size=UDim2.new(0,1,1,0),Position=UDim2.new(i/30,0,0,0),BackgroundColor3=C.Border,BackgroundTransparency=0.9,BorderSizePixel=0},KeyScreen)
    New("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,i/30,0),BackgroundColor3=C.Border,BackgroundTransparency=0.9,BorderSizePixel=0},KeyScreen)
end

local KeyCard=New("Frame",{Size=UDim2.new(0,360,0,320),Position=UDim2.new(0.5,-180,0.5,-160),BackgroundColor3=C.BG2,BorderSizePixel=0},KeyScreen)
Corner(KeyCard,14); Stroke(KeyCard,C.Border,1)
New("Frame",{Size=UDim2.new(1,0,0,3),BackgroundColor3=C.Accent,BorderSizePixel=0},KeyCard)

local skull=New("TextLabel",{Size=UDim2.new(0,60,0,60),Position=UDim2.new(0.5,-30,0,18),BackgroundTransparency=1,Text="🏃",TextSize=44,Font=Enum.Font.GothamBold},KeyCard)
task.spawn(function()
    while skull and skull.Parent do
        task.wait(math.random(2,5))
        skull.TextTransparency=0.7; task.wait(0.07)
        skull.TextTransparency=0; task.wait(0.07)
        skull.TextTransparency=0.5; task.wait(0.05)
        skull.TextTransparency=0
    end
end)

New("TextLabel",{Size=UDim2.new(1,0,0,24),Position=UDim2.new(0,0,0,84),BackgroundTransparency=1,Text="H4LL0 W0RLD HUB | WALLHOP",TextColor3=C.Text,TextSize=13,Font=Enum.Font.GothamBold},KeyCard)
New("TextLabel",{Size=UDim2.new(1,0,0,18),Position=UDim2.new(0,0,0,106),BackgroundTransparency=1,Text="Universal  •  Key Needed",TextColor3=C.TextDim,TextSize=11,Font=Enum.Font.Gotham},KeyCard)

local inputBG=New("Frame",{Size=UDim2.new(1,-40,0,38),Position=UDim2.new(0,20,0,138),BackgroundColor3=C.BG3,BorderSizePixel=0},KeyCard)
Corner(inputBG,8); Stroke(inputBG,C.Border,1)
local KInput=New("TextBox",{Size=UDim2.new(1,-16,1,0),Position=UDim2.new(0,8,0,0),BackgroundTransparency=1,PlaceholderText="Enter key...",PlaceholderColor3=C.TextDim,Text="",TextColor3=C.Text,TextXAlignment=Enum.TextXAlignment.Left,TextSize=12,Font=Enum.Font.GothamBold,ClearTextOnFocus=false},inputBG)

local DiscBtn=New("TextButton",{Size=UDim2.new(0,100,0,32),Position=UDim2.new(0,20,0,190),BackgroundColor3=C.BG3,Text="💬 Discord",TextColor3=C.TextSub,TextSize=11,Font=Enum.Font.GothamBold,BorderSizePixel=0},KeyCard); Corner(DiscBtn,7); Stroke(DiscBtn,C.Border,1)
local PasteBtn=New("TextButton",{Size=UDim2.new(0,80,0,32),Position=UDim2.new(0.5,-40,0,190),BackgroundColor3=C.BG3,Text="📋 Paste",TextColor3=C.TextSub,TextSize=11,Font=Enum.Font.GothamBold,BorderSizePixel=0},KeyCard); Corner(PasteBtn,7); Stroke(PasteBtn,C.Border,1)
local EnterBtn=New("TextButton",{Size=UDim2.new(0,80,0,32),Position=UDim2.new(1,-100,0,190),BackgroundColor3=C.Accent,Text="▶ Enter",TextColor3=Color3.fromRGB(255,200,200),TextSize=11,Font=Enum.Font.GothamBold,BorderSizePixel=0},KeyCard); Corner(EnterBtn,7)
local KStatus=New("TextLabel",{Size=UDim2.new(1,-40,0,20),Position=UDim2.new(0,20,0,232),BackgroundTransparency=1,Text="Enter key to access WallHop Hub",TextColor3=C.TextDim,TextXAlignment=Enum.TextXAlignment.Left,TextSize=10,Font=Enum.Font.Gotham},KeyCard)

local hintBox=New("Frame",{Size=UDim2.new(1,-40,0,40),Position=UDim2.new(0,20,0,260),BackgroundColor3=C.AccentDim,BackgroundTransparency=0.7,BorderSizePixel=0},KeyCard)
Corner(hintBox,7); Stroke(hintBox,C.BorderAcc,1)
New("TextLabel",{Size=UDim2.new(1,-16,1,0),Position=UDim2.new(0,8,0,0),BackgroundTransparency=1,Text="🔑 Gabung Discord → get key gratis!",TextColor3=C.Accent,TextXAlignment=Enum.TextXAlignment.Left,TextSize=10,Font=Enum.Font.GothamBold,TextWrapped=true},hintBox)

DiscBtn.MouseButton1Click:Connect(function()
    pcall(function() setclipboard("https://discord.gg/xCV9Tf4y5N") end)
    DiscBtn.Text="✓ Copied!"; DiscBtn.BackgroundColor3=C.Green
    task.wait(2); DiscBtn.Text="💬 Discord"; DiscBtn.BackgroundColor3=C.BG3
end)
PasteBtn.MouseButton1Click:Connect(function()
    local ok,cb=pcall(getclipboard); if ok and cb~="" then KInput.Text=cb end
end)

-- ═══════════════════════════
--        MAIN GUI
-- ═══════════════════════════
local function BuildMain()
    KeyScreen:Destroy()

    local Win=New("Frame",{Size=UDim2.new(0,520,0,420),Position=UDim2.new(0.5,-260,0.5,-210),BackgroundColor3=C.BG,BorderSizePixel=0,Active=true},GUI)
    Corner(Win,12); Stroke(Win,C.Border,1)
    New("Frame",{Size=UDim2.new(1,0,0,2),BackgroundColor3=C.Accent,BorderSizePixel=0},Win)

    for i=1,20 do
        New("Frame",{Size=UDim2.new(0,1,1,0),Position=UDim2.new(i/20,0,0,0),BackgroundColor3=C.Border,BackgroundTransparency=0.94,BorderSizePixel=0,ZIndex=0},Win)
    end

    local drag,dStart,dPos=false,nil,nil
    Win.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            drag=true; dStart=i.Position; dPos=Win.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local d=i.Position-dStart
            Win.Position=UDim2.new(dPos.X.Scale,dPos.X.Offset+d.X,dPos.Y.Scale,dPos.Y.Offset+d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end
    end)

    local Top=New("Frame",{Size=UDim2.new(1,0,0,44),BackgroundColor3=C.BG2,BorderSizePixel=0,ZIndex=5},Win)
    New("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),BackgroundColor3=C.Border,BorderSizePixel=0,ZIndex=6},Top)
    New("TextLabel",{Size=UDim2.new(0,22,1,0),Position=UDim2.new(0,12,0,0),BackgroundTransparency=1,Text="🏃",TextSize=18,ZIndex=6},Top)
    New("TextLabel",{Size=UDim2.new(0,220,1,0),Position=UDim2.new(0,38,0,0),BackgroundTransparency=1,Text="H4ll0 W0rld Hub | WallHop",TextColor3=C.Text,TextXAlignment=Enum.TextXAlignment.Left,TextSize=12,Font=Enum.Font.GothamBold,ZIndex=6},Top)

    local badge=New("Frame",{Size=UDim2.new(0,68,0,20),Position=UDim2.new(0,262,0.5,-10),BackgroundColor3=Color3.fromRGB(15,8,8),BorderSizePixel=0,ZIndex=6},Top)
    Corner(badge,5); Stroke(badge,C.Accent,1)
    New("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="🏃 WALLHOP",TextColor3=C.Accent,TextSize=9,Font=Enum.Font.GothamBold,ZIndex=7},badge)

    local MinBtn=New("TextButton",{Size=UDim2.new(0,26,0,22),Position=UDim2.new(1,-60,0.5,-11),BackgroundColor3=C.BG3,Text="─",TextColor3=C.TextSub,TextSize=13,Font=Enum.Font.GothamBold,BorderSizePixel=0,ZIndex=6},Top); Corner(MinBtn,5)
    local CloseBtn=New("TextButton",{Size=UDim2.new(0,26,0,22),Position=UDim2.new(1,-28,0.5,-11),BackgroundColor3=C.Accent,Text="✕",TextColor3=Color3.fromRGB(255,200,200),TextSize=11,Font=Enum.Font.GothamBold,BorderSizePixel=0,ZIndex=6},Top); Corner(CloseBtn,5)
    CloseBtn.MouseButton1Click:Connect(function() StopAll(); ClearESP(); Tween(Win,{Size=UDim2.new(0,520,0,0)},0.3); task.wait(0.35); GUI:Destroy() end)
    MinBtn.MouseButton1Click:Connect(function()
        Minimized=not Minimized
        if Minimized then Tween(Win,{Size=UDim2.new(0,520,0,44)},0.3); MinBtn.Text="□"
        else Tween(Win,{Size=UDim2.new(0,520,0,420)},0.3); MinBtn.Text="─" end
    end)

    -- ENIGMA TABS
    local TabBar=New("Frame",{Size=UDim2.new(1,-24,0,34),Position=UDim2.new(0,12,0,52),BackgroundColor3=C.BG3,BorderSizePixel=0,ZIndex=5},Win)
    Corner(TabBar,8); Stroke(TabBar,C.Border,1)
    New("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,3)},TabBar)
    New("UIPadding",{PaddingLeft=UDim.new(0,3),PaddingRight=UDim.new(0,3),PaddingTop=UDim.new(0,3),PaddingBottom=UDim.new(0,3)},TabBar)

    local CA=New("Frame",{Size=UDim2.new(1,-24,1,-104),Position=UDim2.new(0,12,0,94),BackgroundTransparency=1,ClipsDescendants=true},Win)

    local Pages,TabBtns={},{}
    local function MakePage(name)
        local pg=New("ScrollingFrame",{Name=name,Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=C.Accent,CanvasSize=UDim2.new(0,0,0,0),Visible=false},CA)
        local ll=New("UIListLayout",{Padding=UDim.new(0,8)},pg)
        New("UIPadding",{PaddingTop=UDim.new(0,4)},pg)
        ll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() pg.CanvasSize=UDim2.new(0,0,0,ll.AbsoluteContentSize.Y+16) end)
        Pages[name]=pg; return pg
    end
    local function SetTab(name)
        for n,pg in pairs(Pages) do pg.Visible=(n==name) end
        for n,btn in pairs(TabBtns) do
            if n==name then Tween(btn,{BackgroundColor3=C.Accent,TextColor3=Color3.fromRGB(255,200,200)},0.15)
            else Tween(btn,{BackgroundColor3=Color3.fromRGB(0,0,0),TextColor3=C.TextSub},0.15); btn.BackgroundTransparency=1 end
        end
    end
    for _,t in ipairs({{"Combat","💀"},{"WallHop","🏃"},{"Visual","👁"},{"Settings","⚙"}}) do
        MakePage(t[1])
        local btn=New("TextButton",{Size=UDim2.new(0.25,-3,1,0),BackgroundTransparency=1,BackgroundColor3=Color3.fromRGB(0,0,0),Text=t[2].." "..t[1],TextColor3=C.TextSub,TextSize=11,Font=Enum.Font.GothamBold,BorderSizePixel=0},TabBar)
        Corner(btn,6); TabBtns[t[1]]=btn
        btn.MouseButton1Click:Connect(function() SetTab(t[1]) end)
    end

    local function Label(parent,txt,col)
        local f=New("Frame",{Size=UDim2.new(1,0,0,18),BackgroundTransparency=1},parent)
        New("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text=txt,TextColor3=col or C.TextDim,TextXAlignment=Enum.TextXAlignment.Left,TextSize=10,Font=Enum.Font.GothamBold},f)
    end
    local function Toggle(parent,label,key,desc,col)
        local card=New("Frame",{Size=UDim2.new(1,0,0,desc and 54 or 42),BackgroundColor3=C.Card,BorderSizePixel=0},parent)
        Corner(card,8); Stroke(card,C.Border,1)
        New("TextLabel",{Size=UDim2.new(1,-70,0,20),Position=UDim2.new(0,12,0,6),BackgroundTransparency=1,Text=label,TextColor3=C.Text,TextXAlignment=Enum.TextXAlignment.Left,TextSize=12,Font=Enum.Font.GothamBold},card)
        if desc then New("TextLabel",{Size=UDim2.new(1,-70,0,16),Position=UDim2.new(0,12,0,26),BackgroundTransparency=1,Text=desc,TextColor3=C.TextDim,TextXAlignment=Enum.TextXAlignment.Left,TextSize=10,Font=Enum.Font.Gotham},card) end
        local onCol=col or C.ON
        local pill=New("TextButton",{Size=UDim2.new(0,44,0,22),Position=UDim2.new(1,-56,0.5,-11),BackgroundColor3=C.OFF,Text="",BorderSizePixel=0},card); Corner(pill,11)
        local dot=New("Frame",{Size=UDim2.new(0,16,0,16),Position=UDim2.new(0,3,0.5,-8),BackgroundColor3=Color3.fromRGB(200,200,210),BorderSizePixel=0},pill); Corner(dot,8)
        pill.MouseButton1Click:Connect(function()
            Toggles[key]=not Toggles[key]; local on=Toggles[key]
            Tween(pill,{BackgroundColor3=on and onCol or C.OFF},0.2)
            Tween(dot,{Position=on and UDim2.new(0,25,0.5,-8) or UDim2.new(0,3,0.5,-8)},0.2)
            if on then dot.BackgroundColor3=Color3.fromRGB(255,255,255) else dot.BackgroundColor3=Color3.fromRGB(200,200,210) end
            pcall(function() ApplyFeature(key,on) end)
        end)
    end
    local function InputSlider(parent,label,min,max,def,fn,suffix)
        local card=New("Frame",{Size=UDim2.new(1,0,0,66),BackgroundColor3=C.Card,BorderSizePixel=0},parent); Corner(card,8); Stroke(card,C.Border,1)
        New("TextLabel",{Size=UDim2.new(0.6,0,0,20),Position=UDim2.new(0,12,0,6),BackgroundTransparency=1,Text=label,TextColor3=C.Text,TextXAlignment=Enum.TextXAlignment.Left,TextSize=12,Font=Enum.Font.GothamBold},card)
        local valBG=New("Frame",{Size=UDim2.new(0,80,0,24),Position=UDim2.new(1,-92,0,6),BackgroundColor3=C.BG3,BorderSizePixel=0},card); Corner(valBG,6); Stroke(valBG,C.Border,1)
        local valBox=New("TextBox",{Size=UDim2.new(1,-8,1,0),Position=UDim2.new(0,4,0,0),BackgroundTransparency=1,Text=tostring(def)..(suffix or ""),TextColor3=C.AccentGlow,TextXAlignment=Enum.TextXAlignment.Center,TextSize=11,Font=Enum.Font.GothamBold,ClearTextOnFocus=false},valBG)
        local track=New("Frame",{Size=UDim2.new(1,-24,0,6),Position=UDim2.new(0,12,0,40),BackgroundColor3=C.BG3,BorderSizePixel=0},card); Corner(track,3)
        local pct=(def-min)/(max-min)
        local fill=New("Frame",{Size=UDim2.new(pct,0,1,0),BackgroundColor3=C.Accent,BorderSizePixel=0},track); Corner(fill,3)
        local thumb=New("Frame",{Size=UDim2.new(0,14,0,14),Position=UDim2.new(pct,-7,0.5,-7),BackgroundColor3=Color3.fromRGB(255,220,220),BorderSizePixel=0},track); Corner(thumb,7)
        local sliding=false
        track.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliding=true end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sliding=false end end)
        UserInputService.InputChanged:Connect(function(i)
            if sliding and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
                local rel=math.clamp((i.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
                local v=math.floor(min+(max-min)*rel)
                valBox.Text=tostring(v)..(suffix or ""); fill.Size=UDim2.new(rel,0,1,0); thumb.Position=UDim2.new(rel,-7,0.5,-7)
                pcall(fn,v)
            end
        end)
        valBox.FocusLost:Connect(function()
            local v=tonumber(valBox.Text:match("%d+"))
            if v then
                v=math.clamp(v,min,max); local r=(v-min)/(max-min)
                fill.Size=UDim2.new(r,0,1,0); thumb.Position=UDim2.new(r,-7,0.5,-7)
                valBox.Text=tostring(v)..(suffix or ""); pcall(fn,v)
            end
        end)
    end
    local function Btn(parent,label,col,fn)
        local b=New("TextButton",{Size=UDim2.new(1,0,0,36),BackgroundColor3=col or C.Card,Text=label,TextColor3=col and Color3.fromRGB(255,200,200) or C.Text,TextSize=12,Font=Enum.Font.GothamBold,BorderSizePixel=0},parent)
        Corner(b,8); if not col then Stroke(b,C.Border,1) end
        b.MouseButton1Click:Connect(function() pcall(fn); b.BackgroundColor3=C.Green; task.wait(0.4); b.BackgroundColor3=col or C.Card end)
        return b
    end

    -- ══════════════════
    --   💀 COMBAT TAB
    -- ══════════════════
    local CP=Pages["Combat"]
    Label(CP,"  AIMBOT",C.Accent)
    Toggle(CP,"Aimbot","Aimbot","Camera-only aim ke target terdekat")

    -- Switch mode
    local switchCard=New("Frame",{Size=UDim2.new(1,0,0,54),BackgroundColor3=C.Card,BorderSizePixel=0},CP); Corner(switchCard,8); Stroke(switchCard,C.Border,1)
    New("TextLabel",{Size=UDim2.new(1,0,0,20),Position=UDim2.new(0,12,0,6),BackgroundTransparency=1,Text="🔀 Switch Aimbot Mode",TextColor3=C.Text,TextXAlignment=Enum.TextXAlignment.Left,TextSize=12,Font=Enum.Font.GothamBold},switchCard)
    local modeStatus=New("TextLabel",{Size=UDim2.new(1,0,0,16),Position=UDim2.new(0,12,0,28),BackgroundTransparency=1,Text="Mode: Aimbot (Camera)",TextColor3=C.AccentGlow,TextXAlignment=Enum.TextXAlignment.Left,TextSize=10,Font=Enum.Font.GothamBold},switchCard)
    local m1=New("TextButton",{Size=UDim2.new(0,62,0,20),Position=UDim2.new(1,-192,0.5,-10),BackgroundColor3=C.Accent,Text="Camera",TextColor3=Color3.fromRGB(255,200,200),TextSize=9,Font=Enum.Font.GothamBold,BorderSizePixel=0},switchCard); Corner(m1,5)
    local m2=New("TextButton",{Size=UDim2.new(0,55,0,20),Position=UDim2.new(1,-124,0.5,-10),BackgroundColor3=C.BG3,Text="Silent",TextColor3=C.TextSub,TextSize=9,Font=Enum.Font.GothamBold,BorderSizePixel=0},switchCard); Corner(m2,5); Stroke(m2,C.Border,1)
    local m3=New("TextButton",{Size=UDim2.new(0,55,0,20),Position=UDim2.new(1,-62,0.5,-10),BackgroundColor3=C.BG3,Text="Lock",TextColor3=C.TextSub,TextSize=9,Font=Enum.Font.GothamBold,BorderSizePixel=0},switchCard); Corner(m3,5); Stroke(m3,C.Border,1)

    local function setMode(mode)
        Toggles.Aimbot=false; Toggles.SilentAim=false; Toggles.StrongLock=false
        for _,k in ipairs({"Aimbot","SilentAim","StrongLock"}) do
            if Connections[k] then pcall(function() Connections[k]:Disconnect() end); Connections[k]=nil end
        end
        for _,b in ipairs({m1,m2,m3}) do b.BackgroundColor3=C.BG3; b.TextColor3=C.TextSub end
        if mode=="camera" then Toggles.Aimbot=true; ApplyFeature("Aimbot",true); modeStatus.Text="Mode: Aimbot (Camera)"; m1.BackgroundColor3=C.Accent; m1.TextColor3=Color3.fromRGB(255,200,200)
        elseif mode=="silent" then Toggles.SilentAim=true; ApplyFeature("SilentAim",true); modeStatus.Text="Mode: Silent Aim"; m2.BackgroundColor3=C.Accent; m2.TextColor3=Color3.fromRGB(255,200,200)
        elseif mode=="lock" then Toggles.StrongLock=true; ApplyFeature("StrongLock",true); modeStatus.Text="Mode: Strong Lock"; m3.BackgroundColor3=C.Accent; m3.TextColor3=Color3.fromRGB(255,200,200) end
    end
    m1.MouseButton1Click:Connect(function() setMode("camera") end)
    m2.MouseButton1Click:Connect(function() setMode("silent") end)
    m3.MouseButton1Click:Connect(function() setMode("lock") end)

    -- Aim Part
    local partCard=New("Frame",{Size=UDim2.new(1,0,0,54),BackgroundColor3=C.Card,BorderSizePixel=0},CP); Corner(partCard,8); Stroke(partCard,C.Border,1)
    New("TextLabel",{Size=UDim2.new(1,0,0,20),Position=UDim2.new(0,12,0,6),BackgroundTransparency=1,Text="🎯 Aim Part",TextColor3=C.Text,TextXAlignment=Enum.TextXAlignment.Left,TextSize=12,Font=Enum.Font.GothamBold},partCard)
    local partSt=New("TextLabel",{Size=UDim2.new(1,0,0,16),Position=UDim2.new(0,12,0,28),BackgroundTransparency=1,Text="Target: HEAD 💀",TextColor3=C.Gold,TextXAlignment=Enum.TextXAlignment.Left,TextSize=10,Font=Enum.Font.GothamBold},partCard)
    local p1=New("TextButton",{Size=UDim2.new(0,55,0,20),Position=UDim2.new(1,-120,0.5,-10),BackgroundColor3=C.Accent,Text="Head",TextColor3=Color3.fromRGB(255,200,200),TextSize=9,Font=Enum.Font.GothamBold,BorderSizePixel=0},partCard); Corner(p1,5)
    local p2=New("TextButton",{Size=UDim2.new(0,55,0,20),Position=UDim2.new(1,-58,0.5,-10),BackgroundColor3=C.BG3,Text="Body",TextColor3=C.TextSub,TextSize=9,Font=Enum.Font.GothamBold,BorderSizePixel=0},partCard); Corner(p2,5); Stroke(p2,C.Border,1)
    p1.MouseButton1Click:Connect(function() Settings.AimPart="Head"; partSt.Text="Target: HEAD 💀"; p1.BackgroundColor3=C.Accent; p1.TextColor3=Color3.fromRGB(255,200,200); p2.BackgroundColor3=C.BG3; p2.TextColor3=C.TextSub end)
    p2.MouseButton1Click:Connect(function() Settings.AimPart="UpperTorso"; partSt.Text="Target: BODY 🏃"; p2.BackgroundColor3=C.Accent; p2.TextColor3=Color3.fromRGB(255,200,200); p1.BackgroundColor3=C.BG3; p1.TextColor3=C.TextSub end)
    InputSlider(CP,"🎯 FOV Radius",50,500,150,function(v) Settings.FOV=v end," px")
    InputSlider(CP,"⚡ Aim Speed",1,30,8,function(v) Settings.AimSpeed=v end,"")

    -- ══════════════════
    --   🏃 WALLHOP TAB
    -- ══════════════════
    local WP=Pages["WallHop"]

    -- Info card
    local whInfo=New("Frame",{Size=UDim2.new(1,0,0,70),BackgroundColor3=C.Card,BorderSizePixel=0},WP); Corner(whInfo,8); Stroke(whInfo,C.Accent,1.5)
    New("Frame",{Size=UDim2.new(0,3,1,0),BackgroundColor3=C.Accent,BorderSizePixel=0},whInfo)
    New("TextLabel",{Size=UDim2.new(1,-20,1,0),Position=UDim2.new(0,14,0,0),BackgroundTransparency=1,
        Text="🏃 WallHop Pro\nSentuh dinding saat di udara → auto hop ke atas!\nFlick kiri/kanan otomatis sesuai sisi dinding.",
        TextColor3=C.TextSub,TextXAlignment=Enum.TextXAlignment.Left,TextSize=10,TextWrapped=true,Font=Enum.Font.Gotham},whInfo)

    Label(WP,"  WALLHOP SETTINGS",C.Accent)
    Toggle(WP,"🏃 WallHop","WallHop","Sentuh wall saat airborne → auto hop!",C.AccentGlow)
    InputSlider(WP,"⬆️ Hop Force (naik)",20,150,60,function(v) Settings.WallHopForce=v end,"")
    InputSlider(WP,"↔️ Flick Force (kiri/kanan)",10,80,30,function(v) Settings.WallHopFlick=v end,"")
    Toggle(WP,"🦘 God Mode","GodMode","HP selalu penuh",C.Green)

    -- Tips
    local tipCard=New("Frame",{Size=UDim2.new(1,0,0,72),BackgroundColor3=C.Card,BorderSizePixel=0},WP); Corner(tipCard,8); Stroke(tipCard,C.Border,1)
    New("TextLabel",{Size=UDim2.new(1,-16,1,0),Position=UDim2.new(0,8,0,0),BackgroundTransparency=1,
        Text="✅ Aktifkan WallHop → lari ke tembok\n✅ Loncat → menyentuh wall → auto hop naik!\n✅ Dinding kanan = flick kiri, kiri = flick kanan\n✅ Atur Hop Force & Flick Force sesuai selera",
        TextColor3=C.TextSub,TextXAlignment=Enum.TextXAlignment.Left,TextSize=10,TextWrapped=true,Font=Enum.Font.Gotham},tipCard)

    -- ══════════════════
    --   👁 VISUAL TAB
    -- ══════════════════
    local VP=Pages["Visual"]
    Label(VP,"  ESP",C.Accent)
    Toggle(VP,"Player ESP","ESP","Highlight + nama + jarak realtime",C.Accent)
    Label(VP,"  UTILITY",C.Accent)
    Toggle(VP,"Anti AFK","AntiAFK","Cegah kick AFK")
    Toggle(VP,"Boost FPS","BoostFPS","Matikan partikel & efek berat")
    Btn(VP,"☀️ Full Bright",C.AccentDim,function()
        local L=game:GetService("Lighting"); L.Brightness=10; L.ClockTime=14; L.FogEnd=1e6; L.GlobalShadows=false
    end)

    -- ══════════════════
    --   ⚙ SETTINGS TAB
    -- ══════════════════
    local SETP=Pages["Settings"]
    Label(SETP,"  SERVER",C.Accent)
    Btn(SETP,"🔄 Rejoin Server",C.AccentDim,function()
        game:GetService("TeleportService"):Teleport(game.PlaceId,LocalPlayer)
    end)
    Btn(SETP,"🌐 Server Hop",C.AccentDim,function()
        pcall(function()
            local data=game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
            local servers={}
            for _,s in ipairs(data.data) do if s.playing<s.maxPlayers then table.insert(servers,s.id) end end
            if #servers>0 then game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,servers[math.random(1,#servers)],LocalPlayer) end
        end)
    end)
    Label(SETP,"  ABOUT",C.Accent)
    local about=New("Frame",{Size=UDim2.new(1,0,0,76),BackgroundColor3=C.Card,BorderSizePixel=0},SETP); Corner(about,8); Stroke(about,C.Accent,1)
    New("Frame",{Size=UDim2.new(0,3,1,0),BackgroundColor3=C.Accent,BorderSizePixel=0},about)
    New("TextLabel",{Size=UDim2.new(1,-20,1,0),Position=UDim2.new(0,14,0,0),BackgroundTransparency=1,
        Text="🏃  H4ll0 W0rld Hub | WallHop  v2.0\nGame   : Universal (semua game)\nKey    : H4ll0_access_Wallhop\nDiscord: discord.gg/xCV9Tf4y5N",
        TextColor3=C.TextSub,TextXAlignment=Enum.TextXAlignment.Left,TextSize=10,TextWrapped=true,Font=Enum.Font.Gotham},about)

    local stopBtn=New("TextButton",{Size=UDim2.new(1,0,0,36),BackgroundColor3=C.Accent,Text="⛔  Stop All Features",TextColor3=Color3.fromRGB(255,200,200),TextSize=12,Font=Enum.Font.GothamBold,BorderSizePixel=0},SETP); Corner(stopBtn,8)
    stopBtn.MouseButton1Click:Connect(function()
        StopAll(); ClearESP()
        for k in pairs(Toggles) do Toggles[k]=false end
        stopBtn.Text="✅ All Stopped"; task.wait(2); stopBtn.Text="⛔  Stop All Features"
    end)

    SetTab("WallHop")
end

-- ═══════════════════════════
--      KEY VALIDATION
-- ═══════════════════════════
EnterBtn.MouseButton1Click:Connect(function()
    if KInput.Text==VALID_KEY then
        KStatus.Text="✅ Key Valid! Loading..."; KStatus.TextColor3=C.Green
        for _,obj in ipairs(KeyScreen:GetDescendants()) do
            pcall(function()
                if obj:IsA("TextLabel") or obj:IsA("TextButton") then Tween(obj,{TextTransparency=1},0.3) end
                if obj:IsA("Frame") then Tween(obj,{BackgroundTransparency=1},0.3) end
            end)
        end
        Tween(KeyScreen,{BackgroundTransparency=1},0.3)
        task.wait(0.5); BuildMain()
    else
        KStatus.Text="❌ Key salah!"; KStatus.TextColor3=C.Accent
        Tween(inputBG,{BackgroundColor3=Color3.fromRGB(40,8,8)},0.2)
        task.wait(0.4); Tween(inputBG,{BackgroundColor3=C.BG3},0.2)
    end
end)
