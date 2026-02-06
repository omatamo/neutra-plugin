local Hello = {}

-- Plugin Name
Hello.Name = "Hello"

-- Init first call
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
      self.NotifyInfo("Hi!", "From "..self.Name.." plugin", 2)
    end
  })
end

-- When module unload
function Hello:OnUnload()
  self.NotifyInfo("Hello Plugin", "Good Bye", 2)
end
  
return Hello