Xeon = CreateFrame("Frame", nil, UIParent)
Xeon:RegisterEvent("ADDON_LOADED")

CreateFrame("GameTooltip", "xeon_scan", nil, "GameTooltipTemplate")
xeon_scan:SetOwner(WorldFrame, "ANCHOR_NONE")

-- initialize var
Xeon.library = {}
Xeon.class = {}
Xeon.util = {}
Xeon.ui = {}

Xeon.common_value = {}

Xeon:SetScript(
    "OnEvent",
    function(...)
        if (event == "ADDON_LOADED") then
            this:UnregisterEvent("ADDON_LOADED")
            -- Register Events

            this:RegisterEvent("UI_ERROR_MESSAGE")
            this:RegisterEvent("GOSSIP_SHOW")


            local title = GetAddOnMetadata("Xeon", "Title")
            local ver = GetAddOnMetadata("Xeon", "Version")
            local author = GetAddOnMetadata("Xeon", "Author")
            local note = GetAddOnMetadata("Xeon", "Notes")
            _print(title .. " " .. "|cffFFFFFF" .. " #Author : " .. "|cffFF007F" .. author .. "|cffFFFFFF" .. " #Note : " .. "|cff00D8FF" .. note)
            return
        elseif event == "UI_ERROR_MESSAGE" then
            if string.find(arg1, "mounted") or string.find(arg1, "while silenced") then
                UIErrorsFrame:Clear()
                Xeon.library.buff:CancleBuffByDescription("Increases speed by (.+)%%")
            end
            if arg1 == "You are in shapeshift form" then
                UIErrorsFrame:Clear()
                Xeon.library.buff:CancleBuffByDescription("stopped breathing")
            end            
            return 
        elseif event == "GOSSIP_SHOW" then
            return 
        end
    end
)



