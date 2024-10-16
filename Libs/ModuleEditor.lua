local ModuleEditor = {}
ModuleEditor.__index = ModuleEditor

local args = {...}
if #args == 0 then error('[ModuleEditor] Insufficient arguments. (Expected atleast 1 Argument -> ModuleScript)') end 
if args[1].ClassName ~= 'ModuleScript' and typeof(args[1]) ~= 'table' then error('[ModuleEditor] Incorrect arguments. (Expected atleast 1 Argument -> ModuleScript/Table)') end

ModuleEditor.Lib = {}
ModuleEditor.Result = {}
ModuleEditor.Query = {}

return ModuleEditor

