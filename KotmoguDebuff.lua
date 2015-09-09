LoadAddOn("Blizzard_CompactRaidFrames")

local orbIDs = {
    -- blue instead of cyan
    -- [121164] = { color = "Blue",   r = 0.0039, g = 0.8745, b = 0.8431, texture = "Interface\\MiniMap\\TempleofKotmogu_ball_cyan.blp" },
    [121164] = { color = "Blue",   r = 0.0029, g = 0.6745, b = 1     , texture = "Interface\\MiniMap\\TempleofKotmogu_ball_cyan.blp" },
    
    [121175] = { color = "Purple", r = 0.7490, g = 0     , b = 1     , texture = "Interface\\MiniMap\\TempleofKotmogu_ball_purple.blp" },
    [121176] = { color = "Green",  r = 0.0039, g = 0.8745, b = 0.0039, texture = "Interface\\MiniMap\\TempleofKotmogu_ball_green.blp" },
    [121177] = { color = "Orange", r = 1     , g = 0.5019, b = 0     , texture = "Interface\\MiniMap\\TempleofKotmogu_ball_orange.blp" },
}

hooksecurefunc("CompactUnitFrame_HideAllDebuffs", function(frame)
    if frame.KotmoguDebuff then
        frame.KotmoguDebuff:Hide()
    end
end)

hooksecurefunc("CompactUnitFrame_UpdateDebuffs", function(frame)
    if (not UnitInBattleground("player") or not UnitIsPlayer(frame.displayedUnit) or not frame.optionTable.displayDebuffs) then
        if frame.KotmoguDebuff then
            frame.KotmoguDebuff:Hide()
        end
        return
    end 
    
    -- orb frame
    local orbframe = frame.KotmoguDebuff
    if not orbframe then
        orbframe = CreateFrame("Button", nil, frame)
        orbframe:EnableMouse(false)
        
        local texture = orbframe:CreateTexture(nil, "OVERLAY")
        texture:SetAllPoints(orbframe)
        orbframe.texture = texture
        
        local debuff = orbframe:CreateFontString(nil, "OVERLAY")
        debuff:SetPoint("CENTER", texture, "CENTER", 0, 0)
        debuff:SetJustifyH("CENTER")
        debuff:SetJustifyV("MIDDLE")
        orbframe.debuff = debuff
        
        orbframe:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)
        orbframe:SetFrameStrata("MEDIUM")
        
        frame.KotmoguDebuff = orbframe
    end
    
    -- if unit has orb
    local _, _, _, _, _, _, _, _, _, _, spellId, _, _, _, _, val2 = UnitDebuff(frame.displayedUnit, "Orb of Power")
    if not spellId then
        orbframe:Hide()
        return
    end

    local orb = orbIDs[spellId]
    if not orb then
        orbframe:Hide()
        return
    end

    -- set size
    local baseSize = frame:GetHeight() * 0.9
    if baseSize <= 0 then
        return
    else
        orbframe:SetWidth(baseSize)
        orbframe:SetHeight(baseSize)
        orbframe.debuff:SetFont("Fonts\\FRIZQT__.TTF", baseSize * 0.4, "THICKOUTLINE")
    end

    -- display
    orbframe.debuff:SetTextColor(orb.r, orb.g, orb.b, 1)
    orbframe.debuff:SetText(val2)
    -- orbframe.texture:SetTexture(orb.texture)
    orbframe:Show()
end)
