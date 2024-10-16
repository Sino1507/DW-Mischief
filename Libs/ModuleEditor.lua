local ModuleEditor = {}
ModuleEditor.__index = ModuleEditor

local args = {...}
if #args == 0 then error('[ModuleEditor] Insufficient arguments. (Expected atleast 1 Argument -> ModuleScript)') end 

ModuleEditor.Lib = {}
ModuleEditor.Result = {}
ModuleEditor.Query = {}

print(game:GetService('HttpService'):JSONEncode(args))
return ModuleEditor

