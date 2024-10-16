local ModuleEditor = {}
ModuleEditor.__index = ModuleEditor

local args = {...}
--[[
if #args == 0 then 
    error('[ModuleEditor] Insufficient arguments. (Expected at least 1 Argument -> ModuleScript)') 
end

local firstArgType = typeof(args[1])
if firstArgType == 'Instance' then
    if args[1].ClassName ~= 'ModuleScript' then
        error('[ModuleEditor] Incorrect argument. (Expected ModuleScript)')
    end
elseif firstArgType ~= 'table' then
    error('[ModuleEditor] Incorrect argument. (Expected ModuleScript or Table)')
end]]


ModuleEditor.UI = nil
ModuleEditor.UIWindow = nil 
ModuleEditor.Active = 0

function ModuleEditor.new(Name, Data, Callback)
    local NewModuleEditor = {}
    setmetatable(NewModuleEditor, ModuleEditor)

    if Data == nil then 
        error('[ModuleEditor] Insufficient arguments.') 
    end
    
    local DataType = typeof(Data)
    if DataType == 'Instance' then
        if Data.ClassName ~= 'ModuleScript' then
            error('[ModuleEditor] Incorrect argument. (Expected ModuleScript)')
        else
            Data = require(Data)
        end
    elseif DataType ~= 'table' then
        error('[ModuleEditor] Incorrect argument. (Expected ModuleScript or Table)')
    end

    
    NewModuleEditor.Data = Data
    NewModuleEditor.Name = Name
    NewModuleEditor.Window = nil
    NewModuleEditor.Result = Data
    NewModuleEditor.Query = {}
    NewModuleEditor.Callback = Callback

    function NewModuleEditor:Start()
        ModuleEditor:Init(self)
    end

    return NewModuleEditor
end

function ModuleEditor:StartUI(Title, Color, Size, Toggle, Resize)
    self.UI = (self.UI ~= nil and self.UI) or loadstring(game:HttpGet('https://raw.githubusercontent.com/Sino1507/DW-Mischief/main/Libs/ModuleUILib.lua'))()
    local Window = self.UIWindow or self.UI:AddWindow(Title or 'Module Editor', {
        main_color = Color or Color3.fromRGB(41, 74, 122),
        min_size = Size or Vector2.new(500, 600),
        toggle_key = Toggle or Enum.KeyCode.RightShift,
        can_resize = Resize or true,
    })

    self.UIWindow = Window

    return Window
end

function ModuleEditor:createEntry(Window, Table, Index, Value)
    Index = tostring(Index)
    if typeof(Value) == 'string' then 
        Window:AddTextBox(Index..': '..tostring(Value), function(text)
            Table[Index] = text
            --v = text
        end)
    elseif typeof(Value) == 'number' then
        Window:AddTextBox(Index..': '..tostring(Value), function(text)
            local num = tonumber(text)

            if typeof(num) ~= 'number' then return end

            Table[Index] = num
            --v = num
        end)
    elseif typeof(Value) == 'boolean' then
        Window:AddSwitch(Index..': '..tostring(Value), function(value)
            Table[Index] = value
            --v = value
        end):Set(Value)
    elseif typeof(Value) == 'nil' then
        Table[Index] = nil
        Window:AddLabel(Index..': NIL')
    elseif typeof(Value) == 'table' then
        local tablefolder = Window:AddFolder(Index..': {}')
        Table[Index] = Value
        for DataName, DataValue in pairs(Value) do 
            ModuleEditor:createEntry(tablefolder, Table[Index], DataName, DataValue)
        end
    end
end

function ModuleEditor:InitUI(Editor)
    for idx, val in pairs(Editor.Data) do 
        ModuleEditor:createEntry(Editor.Window, Editor.Query, idx, val)
    end

    Editor.Window:AddButton('Done!', function()
        for i, v in pairs(Editor.Query) do 
            if typeof(v) ~= 'table' then 
                Editor.Result[i] = v
                continue
            else
                Editor.Result[i] = {}
                for y,b in pairs(v) do 
                    Editor.Result[i][tonumber(y)] = b
                end
            end
        end

        Editor.Window:DestroyWindow()

        ModuleEditor:Completed(Editor)
    end)
end

function ModuleEditor:Init(Editor)
    local Data = Editor.Data or ''

    local Window = ModuleEditor:StartUI('Module Editor - Toggle with RightShift')
    Editor.Window = Window:AddTab(Editor.Name or 'Editor')

    ModuleEditor.Active += 1
    ModuleEditor:InitUI(Editor)
end

function ModuleEditor:Completed(Editor) 
    ModuleEditor.Active -= 1
    Editor.Callback(Editor.Result)
    Editor = nil
end

return ModuleEditor

