repeat task.wait() until game:IsLoaded()

local RiseMode = true
local baseDirectory = RiseMode and "rise/" or "vape/"

if not isfolder('vape') then makefolder('vape') end
if not isfolder('rise') then makefolder('rise') end
if not isfolder(baseDirectory) then makefolder(baseDirectory) end

local function install_profiles(num)
    if not num then return warn("No number specified!") end
    local guiprofiles = {}
    local profilesfetched
    local repoOwner = RiseMode and "VapeVoidware/RiseProfiles" or "Erchobg/VoidwareProfiles"
    
    local function downloadProfile(path)
        local fullPath = baseDirectory..path
        if not isfile(fullPath) then
            local res = game:HttpGet('https://raw.githubusercontent.com/'..repoOwner..'/main/'..path)
            writefile(fullPath, res)
        end
    end

    local function fetchProfileList(path)
        local url = "https://api.github.com/repos/"..repoOwner.."/contents/"..path
        local res = game:HttpGet(url)
        for _, v in pairs(game:GetService("HttpService"):JSONDecode(res)) do
            if v.name then table.insert(guiprofiles, path.."/"..v.name) end
        end
    end

    if num == 1 then fetchProfileList("Profiles") end
    if num == 2 then fetchProfileList("ClosetProfiles") end
    repeat task.wait() until guiprofiles[1]
    for _, name in pairs(guiprofiles) do
        downloadProfile(name)
    end

    if not isfolder(baseDirectory.."Libraries") then makefolder(baseDirectory.."Libraries") end
    if num == 1 then writefile(baseDirectory.."Libraries/profilesinstalled3.txt", "true") end
    if num == 2 then writefile(baseDirectory.."ClosetProfiles/profilesinstalled3.txt", "true") end
end

local function are_installed_1()
    return isfile(baseDirectory.."Libraries/profilesinstalled3.txt")
end

local function are_installed_2()
    return isfile(baseDirectory.."ClosetProfiles/profilesinstalled3.txt")
end

if not are_installed_1() then install_profiles(1) end
if not are_installed_2() then install_profiles(2) end

-- Grab the latest commit
local url = RiseMode and "https://github.com/VapeVoidware/VWRise/" or "https://github.com/VapeVoidware/VoidwareBakup"
local commit = "main"
for _, line in pairs(game:HttpGet(url):split("\n")) do
    if line:find("commit") and line:find("fragment") then
        local str = line:split("/")[5]
        commit = str:sub(1, str:find('"') - 1)
        break
    end
end

writefile(baseDirectory.."commithash2.txt", commit)

if ((not isfile(baseDirectory.."commithash.txt")) or (readfile(baseDirectory.."commithash.txt") ~= commit or commit == "main")) then
    for _, path in pairs({
        "Universal.lua", "MainScript.lua", "GuiLibrary.lua"
    }) do
        local full = baseDirectory..path
        if isfile(full) and readfile(full):find("--This watermark is used to delete the file") then
            delfile(full)
        end
    end
end
