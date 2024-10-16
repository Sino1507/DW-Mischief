local ModuleEditor = {}
ModuleEditor.__index = ModuleEditor

local args = {...}
if #args == 0 then error('[ModuleEditor] Insufficient arguments. (Expected atleast 1 Argument -> ModuleScript)') end 
if typeof(args[1]) == 'userdata' and args[1].ClassName ~= 'ModuleScript' then
    if typeof(args[1]) ~= 'table' then 
        error('[ModuleEditor] Incorrect arguments. (Expected atleast 1 Argument -> ModuleScript/Table)') 
    end
end

ModuleEditor.Lib = {}
ModuleEditor.Result = {}
ModuleEditor.Query = {}

return ModuleEditor

