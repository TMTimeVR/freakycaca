repeat task.wait() until game:IsLoaded()
shared.oldgetcustomasset = shared.oldgetcustomasset or getcustomasset
task.spawn(function()
    repeat task.wait() until shared.VapeFullyLoaded
    getgenv().getcustomasset = shared.oldgetcustomasset
end)

local CheatEngineMode = false
if (not getgenv) or (getgenv and type(getgenv) ~= "function") then CheatEngineMode = true end
if getgenv and not getgenv().shared then CheatEngineMode = true; getgenv().shared = {}; end
if getgenv and not getgenv().debug then CheatEngineMode = true; getgenv().debug = {traceback = function(string) return string end} end
if getgenv and not getgenv().require then CheatEngineMode = true; end
if getgenv and getgenv().require and type(getgenv().require) ~= "function" then CheatEngineMode = true end

local debugChecks = {
    Type = "table",
    Functions = {
        "getupvalue",
        "getupvalues",
        "getconstants",
        "getproto"
    }
}

local function checkExecutor()
    if identifyexecutor ~= nil and type(identifyexecutor) == "function" then
        local suc, res = pcall(function()
            return identifyexecutor()
        end)   
        local blacklist = {'solara', 'cryptic', 'xeno'}
        local core_blacklist = {'solara', 'xeno'}
        if suc then
            for i,v in pairs(blacklist) do
                if string.find(string.lower(tostring(res)), v) then CheatEngineMode = true end
            end
            for i,v in pairs(core_blacklist) do
                if string.find(string.lower(tostring(res)), v) then
                    pcall(function()
                        getgenv().queue_on_teleport = function() warn('queue_on_teleport disabled!') end
                    end)
                end
            end
        end
    end
end
task.spawn(function() pcall(checkExecutor) end)

local function checkRequire()
    if CheatEngineMode then return end
    local bedwarsID = {
        game = {6872274481, 8444591321, 8560631822},
        lobby = {6872265039}
    }
    if table.find(bedwarsID.game, game.PlaceId) then
        repeat task.wait() until game:GetService("Players").LocalPlayer.Character
        repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui and game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("TopBarAppGui")
        local suc, data = pcall(function()
            return require(game:GetService("ReplicatedStorage").TS.remotes).default.Client
        end)
        if (not suc) or type(data) ~= 'table' or (not data.Get) then CheatEngineMode = true end
    end
end

local function checkDebug()
    if CheatEngineMode then return end
    if not getgenv().debug then 
        CheatEngineMode = true 
    else 
        if type(debug) ~= debugChecks.Type then 
            CheatEngineMode = true
        else 
            for _, v in pairs(debugChecks.Functions) do
                if not debug[v] or (debug[v] and type(debug[v]) ~= "function") then 
                    CheatEngineMode = true 
                else
                    local suc, res = pcall(debug[v]) 
                    if tostring(res) == "Not Implemented" then 
                        CheatEngineMode = true 
                    end
                end
            end
        end
    end
end
if not CheatEngineMode then checkDebug() end

local RiseMode = true
local baseDirectory = RiseMode and "rise/" or "vape/"
if not isfolder('vape') then makefolder('vape') end
if not isfolder('rise') then makefolder('rise') end
shared.CheatEngineMode = shared.CheatEngineMode or CheatEngineMode

local isfile = isfile or function(file)
	local suc, res = pcall(function() return readfile(file) end)
	return suc and res ~= nil
end
local delfile = delfile or function(file) writefile(file, "") end
if not isfolder(baseDirectory) then makefolder(baseDirectory) end

local VWFunctions = {}
function VWFunctions.LogStats()
    pcall(function()
        local executor = identifyexecutor and identifyexecutor() or "Unknown"
        local HWID = tostring(game:GetService("RbxAnalyticsService"):GetClientId())
        local executors = {"solara", "fluxus", "macsploit", "hydrogen", "wave", "codex", "arceus", "delta", "vega", "cubix", "celery", "cryptic", "cacti", "appleware", "synapse", "salad"}
        if identifyexecutor then
            for _, v in pairs(executors) do
                if string.find(string.lower(executor), v) then
                    executor = v
                    break
                end
            end
        end
        local headers = {
            ["Content-type"] = "application/json",
            ["Authorization"] = "Bearer imsureitwontgetddosed"
        }
        local data = {
            ["client_id"] = HWID, 
            ["executor"] = executor
        }
        local final_data = game:GetService("HttpService"):JSONEncode(data)
        local url = "https://voidware-stats.vapevoidware.xyz/stats/data/add"
        local a = request({
            Url = url,
            Method = 'POST',
            Headers = headers,
            Body = final_data
        })
        local statusCodes = {
            ["403"] = "Voidware Error]: Error doing step2 Error code: 1986",
            ["401"] = "Voidware Error]: Error doing step2 Error code: 1922",
            ["429"] = "Voidware Error]: Error doing step2 Error code: 1954 Please rejoin!"
        }
        if a["StatusCode"] ~= 200 then 
            if statusCodes[tostring(a["StatusCode"])] then 
                warn(tostring(statusCodes[tostring(a["StatusCode"])])) 
            else 
                warn("Voidware Error]: Error doing step2 Error code: 1900") 
            end 
        end
    end)
end
function VWFunctions.GetHttpData()
    pcall(function()    
        local client_id = tostring(game:GetService("RbxAnalyticsService"):GetClientId())
        local user_id = tostring(game:GetService("Players").LocalPlayer.UserId)
        local voidware_id = "github"
        return voidware_id, user_id, client_id
    end)
end

shared.VWFunctions = VWFunctions
getgenv().VWFunctions = VWFunctions
