-----------------------------------
-- Catastrophe
-- Scythe weapon skill
-- Skill Level: N/A
-- Drain target's HP. Bec de Faucon/Apocalypse: Additional effect: Haste
-- This weapon skill is available with the stage 5 relic Scythe Apocalypse or within Dynamis with the stage 4 Bec de Faucon.
-- Also available without Aftermath effects with the Crisis Scythe. After 13 weapon skills have been used successfully, gives one "charge" of Catastrophe.
-- Aligned with the Shadow Gorget & Soil Gorget.
-- Aligned with the Shadow Belt & Soil Belt.
-- Element: None
-- Modifiers: INT:40%  AGI:40%
-- 100%TP    200%TP    300%TP
-- 2.75      2.75      2.75
-----------------------------------
---@type TWeaponSkill
local weaponskillObject = {}

weaponskillObject.onUseWeaponSkill = function(player, target, wsID, tp, primary, action, taChar)
    local params = {}
    params.numHits = 1
    
    if xi.settings.main.USE_MODDED_WEAPON_SKILLS then
        params.ftpMod = { 5.0, 8.0, 11.0 }
        params.str_wsc = 0.8 params.int_wsc = 0.8
        critVaries = { 0.33, 0.67, 1.0 }
        atkVaries = { 1.5, 1.75, 2.0 }
        params.multiHitfTP = true
    else
        params.ftpMod = { 2.75, 2.75, 2.75 }
        params.agi_wsc = 0.4 params.int_wsc = 0.4

        if xi.settings.main.USE_ADOULIN_WEAPON_SKILL_CHANGES then
            params.str_wsc = 0.4 params.agi_wsc = 0.0 params.int_wsc = 0.4
        end
    end
    -- Apply aftermath
    if xi.settings.main.USE_MODDED_WEAPON_SKILLS then
        xi.aftermath.addStatusEffect(player, tp, xi.slot.MAIN, xi.aftermath.type.MYTHIC)
    else
        xi.aftermath.addStatusEffect(player, tp, xi.slot.MAIN, xi.aftermath.type.RELIC)
    end
    
    local damage, criticalHit, tpHits, extraHits = xi.weaponskills.doPhysicalWeaponskill(player, target, wsID, params, tp, action, primary, taChar)
    if xi.settings.main.USE_MODDED_WEAPON_SKILLS then
        local drain = math.floor(damage * 0.4)
        player:addHP(drain)    
        player:addMP(drain)
    else
        if not target:isUndead() then
            local drain = math.floor(damage * 0.4)
            player:addHP(drain)
            
        end
    end
    return tpHits, extraHits, criticalHit, damage
end

return weaponskillObject
