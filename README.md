# 🧩 Neutra Plugin Documentation

Guide for creating plugins for **Neutra Loader**.

---

## 📦 Basic Plugin Structure

Every plugin **MUST** return a table and include a `Name` field.

```lua
local MyPlugin = {}

MyPlugin.Name = "My Plugin"

function MyPlugin:Init(core)
    -- Called when the plugin is successfully loaded
end

function MyPlugin:OnUnload()
    -- Called when the plugin is unloaded
end

return MyPlugin
```

---

## 🔌 Plugin Lifecycle

### `:Init(core)`

Called when the plugin is loaded.

The `core` parameter provides access to:

- `core.UI`
- `core.NotifySuccess`
- `core.NotifyError`
- `core.NotifyInfo`
- `core.Services`
- `core.Modules`

Example:

```lua
function MyPlugin:Init(core)
    self.Core = core
    self.UI = core.UI
    self.NotifySuccess = core.NotifySuccess

    self:MakeUI()
end
```

---

### `:OnUnload()`

Called when the plugin is unloaded.

Use this to:
- Destroy UI
- Stop threads
- Disconnect connections

Example:

```lua
function MyPlugin:OnUnload()
    if self.Tab then
        self.Tab:Destroy()
    end
end
```

---

## 🖥 Creating UI in Plugin

Since the UI is created in the main script, plugins must use `core.UI`.

Example:

```lua
function MyPlugin:MakeUI()
    self.Tab = self.UI.Window:AddTab({
        Name = "Example",
        Icon = "star"
    })

    local Section = self.Tab:AddSection("Main Section")

    Section:AddButton({
        Title = "Click Me",
        Callback = function()
            self.NotifySuccess("Plugin", "Button clicked!", 2)
        end
    })
end
```

---

## 🌐 How to Load a Plugin

### 🔹 From URL

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/username/repo/main/plugin.lua"))()
```

### 🔹 From Local File

Enter the file path inside the loader:

```
/MyPlugin.lua
```

---

## 📁 Simple Plugin Example

```lua
local Hello = {}

Hello.Name = "Hello"

function Hello:Init(core)
    self.UI = core.UI
    self.NotifyInfo = core.NotifyInfo
    self:MakeUI()
end

function Hello:MakeUI()
    self.Tab = self.UI.Window:AddTab({
        Name = "Hello",
        Icon = "user"
    })

    local Section = self.Tab:AddSection("Hello World")

    Section:AddButton({
        Title = "Say Hi",
        Callback = function()
            self.NotifyInfo("Hello", "Hi from plugin!", 2)
        end
    })
end

function Hello:OnUnload()
    if self.Tab then
        self.Tab:Destroy()
    end
end

return Hello
```

---

## ⚠️ Plugin Rules

- MUST have `Name`
- MUST `return table`
- Do not modify core directly
- Use `pcall` if needed
- Clean up UI in `OnUnload`

---

## 🧠 Advanced Tip

### Store Connections

```lua
self.Connection = game:GetService("RunService").Heartbeat:Connect(function()
    print("Running")
end)
```

Then disconnect in unload:

```lua
if self.Connection then
    self.Connection:Disconnect()
end
```

---

## 🔥 Example Public Plugin Repo

```
https://github.com/omatamo/neutra-plugin
```

---

## 🚀 Load Neutra Loader

```lua
loadstring(game:HttpGet("https://neutraproject.vercel.app/LOADER"))()
```
