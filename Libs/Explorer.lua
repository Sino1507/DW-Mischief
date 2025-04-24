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
     -- Load the UI library once
     self.UI = self.UI or loadstring(game:HttpGet('https://raw.githubusercontent.com/Sino1507/DW-Mischief/main/Libs/ModuleUILib.lua'))()
     -- Create or reuse the main window
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
 -- @param container: UI Folder or Tab
 -- @param inst: Instance to represent
 function Explorer:createEntry(container, inst)
     -- If the Instance has children, create a folder
     local children = inst:GetChildren()
     if #children > 0 then
         local folderUI = container:AddFolder(inst.Name)
         -- Recursively add each child
         for _, child in ipairs(children) do
             self:createEntry(folderUI, child)
         end
     else
         -- Leaf node: add as a button
         container:AddButton(inst.Name, function()
             -- Invoke callback with the clicked instance
             self.Callback(inst)
         end)
     end
 end
 
 -- Internal: Build the UI and populate entries
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
 
     -- Start recursion at the entry point
     self:createEntry(tab, self.EntryPoint)
 end
 
 -- Public: Start the Explorer UI
 function Explorer:Start()
     self:Init()
 end
 
 return Explorer
