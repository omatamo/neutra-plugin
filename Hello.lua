local Hello = {}

Hello.Name = "Human"

function Hello:Init(core)
    self.UI = core.UI
    self.NotifyInfo = core.NotifyInfo
    
    self:SayHello()
end

function Hello:SayHello()
  self.Tab = self.UI.Window:AddTab({
    Name = "Hello",
    Icon = "user"
  })

  local HelloSection = self.Tab:AddSection("Hello World")
  
  HelloSection:AddButton({
    Title = "Wave Me",
    Callback = function()
      self.NotifyInfo("Hi "..self.Name, "From Hello plugin", 2)
    end
  })
end

function Hello:OnUnload()
    if self.Tab then
        self.Tab:Destroy()
    end
end
  
return Hello