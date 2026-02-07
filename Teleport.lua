local TeleportPlugin = {}
TeleportPlugin.Name = "TeleportToPlayer"

function TeleportPlugin:Init(Core)
    self.Core = Core
    self.UI = Core.UI
    self.NotifySuccess = Core.NotifySuccess
    self.NotifyError = Core.NotifyError

    self:MakeUI()
end

function TeleportPlugin:MakeUI()
    self.Tab = self.UI.Window:AddTab({
        Name = "Teleport",
        Icon = "send"
    })

    local Section = self.Tab:AddSection("Teleport to Player")

    -- Dropdown live player list
    local selectedPlayer = nil
    local function getPlayerList()
        local list = {}
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer then
                table.insert(list, p.Name)
            end
        end
        return list
    end

    local playerDropdown = Section:AddDropdown({
        Title = "Select Player",
        Content = "Choose a player to teleport",
        Options = getPlayerList(),
        Default = nil,
        Callback = function(val)
            selectedPlayer = val
        end
    })

    -- Debounce update values
    local lastUpdate = 0
    local updateDelay = 0.5
    local function updatePlayerDropdown()
        local now = tick()
        if now - lastUpdate < updateDelay then return end
        lastUpdate = now

        if playerDropdown then
            playerDropdown:SetValues(getPlayerList())
        end
    end

    -- Event listener
    game.Players.PlayerAdded:Connect(updatePlayerDropdown)
    game.Players.PlayerRemoving:Connect(updatePlayerDropdown)

    -- Button teleport
    Section:AddButton({
        Title = "Teleport",
        Callback = function()
            if not selectedPlayer then
                self.NotifyError("Teleport", "No player selected!", 2)
                return
            end

            local target = game.Players:FindFirstChild(selectedPlayer)
            local localPlayer = game.Players.LocalPlayer

            if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
                self.NotifyError("Teleport", "Target player not valid!", 2)
                return
            end

            if not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                self.NotifyError("Teleport", "Your character not valid!", 2)
                return
            end

            -- Teleport lokal dengan offset
            localPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
            self.NotifySuccess("Teleport", "Teleported to "..selectedPlayer, 2)
        end
    })

    Section:AddParagraph({
        Title = "Info",
        Content = "Select a player from the list above and click Teleport. You will be moved to their position locally."
    })
end

return TeleportPlugin