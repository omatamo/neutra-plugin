local Hello = {}

Hello.Name = "Human"

function Hello:Init(core)
    self.UI = core.UI
    self.NotifyInfo = core.NotifyInfo
    
    self:SayHello()
end

function Hello:SayHello()
  local HelloTab = self.UI.Window:AddTab({
    Name = "Hello",
    Icon = "user"
  })

  local HelloSection = HelloTab:AddSection("Hello World")
  
  HelloTab:AddButton({
    Title = "Wave Me",
    Callback = function()
      self.NotifyInfo("Hi "..self.Name, "From Hello plugin", 2)
    end
  })
end
  
return Hello