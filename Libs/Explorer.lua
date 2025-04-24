-- Explorer.lua
-- A recursive Explorer class for listing Instances (e.g., Sounds) in a UI hierarchy

local Explorer = {}
Explorer.__index = Explorer

Explorer.UI = nil
Explorer.UIWindow = nil
Explorer.Active = 0

-- Creates a new Explorer
-- @param Name: string - The display name of the explorer tab
-- @param EntryPoint: Instance - A Folder or any Instance whose children will be explored
-- @param Callback: function(instance: Instance) - Called when the user clicks an Instance button
function Explorer.new(Name, EntryPoint, Callback)
    assert(typeof(Name) == "string", "[Explorer] Name must be a string")
    assert(typeof(EntryPoint) == "Instance", "[Explorer] EntryPoint must be an Instance")
    assert(typeof(Callback) == "function", "[Explorer] Callback must be a function")

    local self = setmetatable({}, Explorer)
    self.Name = Name
    self.EntryPoint = EntryPoint
    self.Callback = Callback
    self.UIWindow = nil
    return self
end

-- Internal: Initialize or retrieve the UI Window using the same UI Lib
function Explorer:StartUI(Title, Color, Size, ToggleKey, CanResize)
    self.UI = self.UI or loadstring(game:HttpGet('https://raw.githubusercontent.com/Sino1507/DW-Mischief/main/Libs/ModuleUILib.lua'))()
    local window = self.UIWindow or self.UI:AddWindow(Title or 'Explorer', {
        main_color = Color or Color3.fromRGB(41, 74, 122),
        min_size = Size or Vector2.new(400, 500),
        toggle_key = ToggleKey or Enum.KeyCode.RightShift,
        can_resize = CanResize or true,
    })
    self.UIWindow = window
    return window
end

-- Recursive: Adds entries for an Instance and its children
-- @param container: UI Folder or ScrollingFrame
-- @param inst: Instance to represent
function Explorer:createEntry(container, inst)
    local children = inst:GetChildren()
    if #children > 0 then
        local folderUI = container:AddFolder(inst.Name)
        for _, child in ipairs(children) do
            self:createEntry(folderUI, child)
        end
    else
        container:AddButton(inst.Name, function()
            self.Callback(inst)
        end)
    end
end

-- Internal: Build the UI and populate entries with scrolling support
function Explorer:Init()
    local mainWindow = self:StartUI(
        'Explorer - Toggle with RightShift',
        Color3.fromRGB(41, 74, 122),
        Vector2.new(400, 500),
        Enum.KeyCode.RightShift,
        true
    )

    -- Create a new tab for this explorer
    local tab = mainWindow:AddTab(self.Name)
    Explorer.Active += 1

    -- Wrap tab contents in a ScrollingFrame
    local content = Instance.new("ScrollingFrame")
    content.Name = "ExplorerScroll"
    content.Parent = tab
    content.BackgroundTransparency = 1
    content.Size = UDim2.new(1, 0, 1, 0)
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.ScrollBarThickness = 6

    local layout = Instance.new("UIListLayout")
    layout.Parent = content
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end)

    -- Start recursion at the entry point into the scrolling container
    self:createEntry(content, self.EntryPoint)
end

-- Public: Start the Explorer UI
function Explorer:Start()
    self:Init()
end

return Explorer
