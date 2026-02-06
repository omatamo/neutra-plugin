local AntiAFK = {}
AntiAFK.Name = "Anti AFK"

function AntiAFK:Init(core)
    self.UI = core.UI
    self.NotifySuccess = core.NotifySuccess
    self.NotifyInfo = core.NotifyInfo

    self.Enabled = false
    self.Connection = nil

    self:MakeUI()
end

function AntiAFK:SetState(state)
    if state == self.Enabled then return end
    self.Enabled = state

    local player = game:GetService("Players").LocalPlayer
    local VirtualUser = game:GetService("VirtualUser")

    if state then
        self.Connection = player.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)

        self.NotifySuccess("Anti AFK", "Enabled", 2)
    else
        if self.Connection then
            self.Connection:Disconnect()
            self.Connection = nil
        end

        self.NotifyInfo("Anti AFK", "Disabled", 2)
    end
end

function AntiAFK:MakeUI()
    self.Tab = self.UI.Window:AddTab({
        Name = "Anti AFK",
        Icon = "user"
    })

    local section = self.Tab:AddSection("AFK Protection")

    section:AddToggle({
        Title = "Enable Anti AFK",
        Content = "Prevent automatic kick due to inactivity",
        Default = false,
        Callback = function(state)
            self:SetState(state)
        end
    })
end

function AntiAFK:OnUnload()
    self:SetState(false)
    if self.Tab then
        self.Tab:Destroy()
    end
end

return AntiAFK