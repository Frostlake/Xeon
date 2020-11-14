Xeon.ui.rangeCheck = CreateFrame("Frame", nil, UIParent)

Xeon.ui.rangeCheck:SetScript(
    "OnEvent",
    function(...)
        if event == "ADDON_LOADED" then
            

            -- Register Events          
            
            return
        end
    end
)

Xeon.ui.rangeCheck.values = {
  
}

function Xeon.ui.rangeCheck:CreateRangeChecker()
    local frame = CreateFrame("Frame", "RangeCheckFrame")
    tinsert(UISpecialFrames, "RangeCheckFrame")
    frame:SetWidth(200)
    frame:SetHeight(50)
    frame:SetPoint("CENTER", nil, "CENTER", 0, 0)
    frame:SetBackdrop(
        {
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background"
        }
    )
    frame:SetBackdropColor(.01, .01, .01, .91)

    local txt = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    txt:SetPoint("CENTER", frame.txt, "CENTER", 0, 12)
    txt:SetText("|cff00D8FF" .. "Retro Helper" .. "|cffFFFFFF" .. " Config")
    frame.txt = txt

    return frame
end

