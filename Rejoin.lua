local Rejoin = {}

-- Plugin Name
Rejoin.Name = "Smart Rejoin"

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

function Rejoin:SmartRejoin()
    local player = Players.LocalPlayer
    local placeId = game.PlaceId
    local jobId = game.JobId

    local triedFallback = false
    local connection

    connection = TeleportService.TeleportInitFailed:Connect(function(plr, result, errorMessage)
        if plr == player and not triedFallback then
            triedFallback = true

            warn("Exact rejoin failed:", result, errorMessage)

            if connection then
                connection:Disconnect()
            end

            task.wait(1)
            TeleportService:Teleport(placeId, player)
        end
    end)

    local success, err = pcall(function()
        TeleportService:TeleportToPlaceInstance(placeId, jobId, player)
    end)

    if not success and not triedFallback then
        warn("Immediate error:", err)

        if connection then
            connection:Disconnect()
        end

        TeleportService:Teleport(placeId, player)
    end
end

-- Init first call
function Rejoin:Init(core)
    self.UI = core.UI
    self.NotifyInfo = core.NotifyInfo
    
    self:MakeUI()
end

function Rejoin:MakeUI()
    self.Tab = self.UI.Window:AddTab({
        Name = "Smart Rejoin",
        Icon = "send"
    })

    local HelloSection = self.Tab:AddSection("Rejoin Server")

    local placeId = game.PlaceId
    local jobId   = game.JobId

    HelloSection:AddParagraph({
        Title = "Server ID",
        Content = "PlaceId: "..tostring(placeId).."\nJobId: "..tostring(jobId)
    })

    HelloSection:AddParagraph({
        Title = "Information",
        Content = "You will rejoin this exact same server instance."
    })

    HelloSection:AddButton({
        Title = "Rejoin",
        Callback = function()
            self:SmartRejoin()
        end
    })
end

-- When module unload
function Rejoin:OnUnload()
  self.NotifyInfo("Rejoin Plugin", "Good Bye", 2)
end
  
return Rejoin