-- Reference: G:\Steam\steamapps\common\The Binding of Isaac Rebirth\resources
-- https://moddingofisaac.com/docs/


--[[Initialize the Mod and its items]]
local game = Game()
local LootboxesMod = RegisterMod("Lootboxes", 1 );
LootboxesMod.DEBUG = false;

LootboxesMod.COLLECTIBLE_LOOTBOX    = Isaac.GetItemIdByName( "Lootbox" )


--[[ Logging Functions ]]
local eLog = {"Log:"}
function LootboxesMod:eLogDraw()
    if LootboxesMod.DEBUG then
        for i,j in ipairs(eLog) do
            Isaac.RenderText(j,50,i*15,255,255,255,255)
        end
    end
end

function LootboxesMod:eLogWrite(str)
    if LootboxesMod.DEBUG then
        table.insert(eLog,str)
        if #eLog > 10 then
            table.remove(eLog,1)
        end
    end
end
LootboxesMod:AddCallback(ModCallbacks.MC_POST_RENDER, LootboxesMod.eLogDraw);

