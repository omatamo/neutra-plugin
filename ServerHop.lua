local ServerHop = {}
ServerHop.Name = "Server Hop"

function ServerHop:Init(core)
    self.UI = core.UI
    self.NotifySuccess = core.NotifySuccess
    self.NotifyError = core.NotifyError
    self.NotifyInfo = core.NotifyInfo

    self:MakeUI()
end

function ServerHop:Hop()
    local TeleportService = game:GetService("TeleportService")
    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")

    local player = Players.LocalPlayer
    local placeId = game.PlaceId

    self.NotifyInfo("ServerHop", "Searching new server...", 2)

    local success, result = pcall(function()
        return HttpService:JSONDecode(
            game:HttpGet(
                "https://games.roblox.com/v1/games/" ..
                placeId ..
                "/servers/Public?sortOrder=Asc&limit=100"
            )
        )
    end)

    if not success or not result or not result.data then
        self.NotifyError("ServerHop", "Failed to fetch server list", 3)
        return
    end

    local servers = result.data
    local currentJobId = game.JobId

    for _, server in ipairs(servers) do
        if server.playing < server.maxPlayers and server.id ~= currentJobId then
            self.NotifySuccess("ServerHop", "Teleporting...", 2)
            TeleportService:TeleportToPlaceInstance(placeId, server.id, player)
            return
        end
    end

    self.NotifyError("ServerHop", "No available server found", 3)
end

function ServerHop:MakeUI()
    self.Tab = self.UI.Window:AddTab({
        Name = "Server Hop",
        Icon = "loop"
    })

    local section = self.Tab:AddSection("Server Control")

    section:AddButton({
        Title = "Hop Server",
        Callback = function()
            self:Hop()
        end
    })
end

function ServerHop:OnUnload()
    if self.Tab then
        self.Tab:Destroy()
    end
end

return ServerHop