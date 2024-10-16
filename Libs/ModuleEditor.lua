local ModuleEditor = {}
ModuleEditor.__index = ModuleEditor

local args = {...}

ModuleEditor.Lib = {}
ModuleEditor.Result = {}
ModuleEditor.Query = {}

print(game:GetService('HttpService'):JSONEncode(args))
return ModuleEditor
