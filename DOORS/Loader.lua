-- I don't own this script, I just wanna modify something for myself.
-- original: https://github.com/notpoiu/mspaint

if game.PlaceId == 2440500124 then
local compatibility_mode = false do
    local executor_name = identifyexecutor and identifyexecutor() or "your executor"

    -- Known executors that do not support the functions
    if executor_name == "Solara" then compatibility_mode = true end

    function test(name: string, func: () -> (), ...)
        if compatibility_mode then return end

        local success, error_msg = pcall(func, ...)
        
        if not success then
            compatibility_mode = true
            print("mspaint: " .. executor_name .. " does not support " .. name .. ", falling back to compatibility mode")
        end
        
        return success
    end
        
    test("require", function() require(game:GetService("ReplicatedStorage"):FindFirstChildWhichIsA("ModuleScript", true)) end)
    test("hookmetamethod", function()
        -- From UNC Env Check
        local object = setmetatable({}, { __index = newcclosure(function() return false end), __metatable = "Locked!" })
        local ref = hookmetamethod(object, "__index", function() return true end)
        assert(object.test == true, "Failed to hook a metamethod and change the return value")
        assert(ref() == false, "Did not return the original function")
        
        local method, ref; ref = hookmetamethod(game, "__namecall", function(...)
            if not method then
                method = getnamecallmethod()
            end
            return ref(...)
        end)
        
        game:GetService("Lighting")
        assert(method == "GetService", "Did not get the correct method (GetService)")
    end)

    test("firesignal", function()
        local event = Instance.new("BindableEvent")
        
        local fired = false
        event.Event:Connect(function(value) fired = value end)

        firesignal(event.Event, true)
        task.wait(.05)
        event:Destroy()
        
        assert(fired == true, "Failed to fire a BindableEvent")
    end)
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/lo2z/scripts/main/DOORS/DOORS.lua"))()

else   
game.Players.LocalPlayer:Kick("this script is only made for doors, not for another random ass games. But if you executed this script in the lobby (DOORS) then please not execute this ingame, NOT in the lobby") 
end
