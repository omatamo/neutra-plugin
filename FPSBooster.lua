local FPSBooster = {}
FPSBooster.Name = "FPS Booster"

function FPSBooster:Init(core)
    self.UI = core.UI
    self.NotifySuccess = core.NotifySuccess
    self.NotifyInfo = core.NotifyInfo

    self:MakeUI()
end

-- 🔥 Disable Shadows
local function disableShadows()
    local lighting = game:GetService("Lighting")
    lighting.GlobalShadows = false

    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CastShadow = false
        end
    end
end

-- 💡 Disable Post Processing
local function disableEffects()
    local lighting = game:GetService("Lighting")

    for _, v in ipairs(lighting:GetChildren()) do
        if v:IsA("PostEffect")
        or v:IsA("BloomEffect")
        or v:IsA("BlurEffect")
        or v:IsA("SunRaysEffect")
        or v:IsA("ColorCorrectionEffect")
        or v:IsA("DepthOfFieldEffect")
        or v:IsA("Atmosphere")
        or v:IsA("Clouds") then
            v.Enabled = false
        end
    end
end

-- 🧱 Force Plastic Material
local function forcePlastic()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
        end
    end
end

-- 🎇 Disable Particles
local function disableParticles()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter")
        or obj:IsA("Trail")
        or obj:IsA("Beam")
        or obj:IsA("Smoke")
        or obj:IsA("Fire") then
            obj.Enabled = false
        end
    end
end

-- 🖼 Remove Textures
local function removeTextures()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Decal") or obj:IsA("Texture") then
            obj:Destroy()
        end
    end
end

-- 💀 Ultra Mode
local function ultraLow()
    disableShadows()
    disableEffects()
    disableParticles()
    forcePlastic()
    removeTextures()
end

function FPSBooster:MakeUI()
    self.Tab = self.UI.Window:AddTab({
        Name = "FPS Booster",
        Icon = "eyes"
    })

    local section = self.Tab:AddSection("Performance Controls")

    section:AddButton({
        Title = "Disable Shadows",
        Callback = function()
            disableShadows()
            self.NotifySuccess("FPSBooster", "Shadows Disabled", 2)
        end
    })

    section:AddButton({
        Title = "Disable Effects",
        Callback = function()
            disableEffects()
            self.NotifySuccess("FPSBooster", "Post Effects Disabled", 2)
        end
    })

    section:AddButton({
        Title = "Disable Particles",
        Callback = function()
            disableParticles()
            self.NotifySuccess("FPSBooster", "Particles Disabled", 2)
        end
    })

    section:AddButton({
        Title = "Force Plastic Material",
        Callback = function()
            forcePlastic()
            self.NotifySuccess("FPSBooster", "Materials Set to Plastic", 2)
        end
    })

    section:AddButton({
        Title = "Remove Textures",
        Callback = function()
            removeTextures()
            self.NotifySuccess("FPSBooster", "Textures Removed", 2)
        end
    })

    section:AddButton({
        Title = "Ultra Low Graphics (ALL)",
        Callback = function()
            ultraLow()
            self.NotifySuccess("FPSBooster", "Ultra Low Mode Enabled 🔥", 3)
        end
    })
end

function FPSBooster:OnUnload()
    if self.Tab then
        self.Tab:Destroy()
    end
end

return FPSBooster