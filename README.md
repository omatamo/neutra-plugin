# 🧩 Neutra Plugin Documentation

Guide for creating plugins for **Neutra Loader**.

## 🚀 Load Neutra

```lua
loadstring(game:HttpGet("https://neutraproject.vercel.app/LOADER"))()
```

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

# 🖥 UI Elements

This documentation explains all available UI elements including `Content` parameter.

---

## 🪟 Create Tab

```lua
self.Tab = self.UI.Window:AddTab({
    Name = "Tab Name",
    Icon = "star" -- optional
})
```

---

## 📦 Add Section

```lua
local Section = self.Tab:AddSection("Section Title", true)
```

Second parameter:
- `true`  → collapsible
- `false` → normal section

---

## 📜 Paragraph

```lua
Section:AddParagraph({
    Title = "Information",
    Content = "This is description text under the title."
})
```

✔ `Title` = header text  
✔ `Content` = description text  

---

## 🔘 Button

```lua
Section:AddButton({
    Title = "Click Me",
    Content = "Optional description under button",
    Callback = function()
        print("Clicked")
    end
})
```

✔ `Content` = small description text  

---

## 🔁 Toggle

```lua
Section:AddToggle({
    Title = "Enable Feature",
    Content = "Turn this on to activate feature",
    Default = false,
    Callback = function(state)
        print("State:", state)
    end
})
```

✔ `Default` = true / false  
✔ `Content` = description text  

---

## 📋 Dropdown (Single Select)

```lua
Section:AddDropdown({
    Title = "Select Option",
    Content = "Choose one option",
    Options = {"A", "B", "C"},
    Default = nil,
    Callback = function(selected)
        print(selected)
    end
})
```

---

## 📋 Dropdown (Multi Select)

```lua
Section:AddDropdown({
    Title = "Select Multiple",
    Content = "You can select more than one",
    Options = {"A", "B", "C"},
    Multi = true,
    Default = {},
    Callback = function(selectedTable)
        for _, v in ipairs(selectedTable) do
            print(v)
        end
    end
})
```

✔ `Multi = true` enables multi selection  

---

## ✏️ Input

```lua
Section:AddInput({
    Title = "Enter Value",
    Content = "Input something here",
    Default = "",
    Placeholder = "Type here...",
    Callback = function(value)
        print(value)
    end
})
```

✔ `Placeholder` = hint text  
✔ `Default` = default value  

---

## 🔢 Slider

```lua
Section:AddSlider({
    Title = "Speed",
    Content = "Adjust the speed value",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print(value)
    end
})
```

---

## 🔔 Notifications

```lua
self.NotifySuccess("Title", "Message", 2)
self.NotifyError("Title", "Message", 2)
self.NotifyInfo("Title", "Message", 2)
```

Last parameter = duration (seconds)

---

## 🧹 Proper Cleanup (IMPORTANT)

```lua
function MyPlugin:OnUnload()
    if self.Tab then
        self.Tab:Destroy()
    end
end
```

Always clean UI to avoid ghost tabs.
