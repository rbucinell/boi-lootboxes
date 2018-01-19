--[[Initialize the Mod and its items]]
local game = Game()
local LootboxesMod = RegisterMod("Lootboxes", 1 );
LootboxesMod.DEBUG = false;

LootboxesMod.COLLECTIBLE_LOOTBOX    = Isaac.GetItemIdByName( "Lootbox" )
LootboxesMod.LOOTCHEST_TRASH        = Isaac.GetItemIdByName( "Trash Lootchest" )
LootboxesMod.LOOTCHEST_COMMON       = Isaac.GetItemIdByName( "Common Lootchest" )
LootboxesMod.LOOTCHEST_RARE         = Isaac.GetItemIdByName( "Rare Lootchest" )
LootboxesMod.LOOTCHEST_EPIC         = Isaac.GetItemIdByName( "Epic Lootchest" )
LootboxesMod.LOOTCHEST_LEGENDARY    = Isaac.GetItemIdByName( "Legendary Lootchest" )

--[ The Price of the lootbox to keep using it ]
local priceToPlay = 25

--[ Threshold values for a d100 roll on which chest user will get ]
local threshold = {}
threshold["common"] = 20
threshold["rare"] = 80
threshold["epic"] = 90
threshold["legendary"] = 95 

-- Percentage of getting style of drop (in order): troll, single, consumable, item tiers( d, c, b, a, s);
local trash_rates     = { 0.50,0.90,0.95,0.96,0.97,0.98,0.99,1}
local common_rates    = { 0.15,0.35,0.65,0.8,0.85,0.9,0.99,1}
local rare_rates      = { 0.05,0.1,0.25,0.4,0.6,0.8,0.95,1 }
local epic_rates      = { 0.01,0.05,0.1,0.25,0.4,0.7,0.95,1}
local legendary_rates = { 0,0,0.05,0.15,0.3,0.55,0.8,1}

--tiers of items in percentages: D, C, B, A, S tiers
local tiers = {
    D = 0.25,
    C = 0.5,
    B = 0.75,
    A = 0.95,
    S = 1 
}

--items ranked from http://www.isaacranks.com/afterbirthplus/ranks
local rankings = { 118, 153, 182, 12, 245, 331, 313, 230, 395, 169, 4, 237, 189, 80, 360, 223, 415, 108, 101, 105, 114, 359, 149, 261, 307, 345, 185, 216, 414, 52, 494, 50, 335, 215, 7, 203, 224, 51, 90, 168, 234, 165, 145, 275, 417, 1, 79, 70, 374, 170, 183, 109, 98, 196, 441, 138, 333, 375, 2, 393, 268, 243, 292, 229, 260, 347, 3, 411, 104, 278, 179, 341, 172, 184, 407, 370, 32, 399, 197, 424, 159, 81, 64, 477, 286, 259, 132, 350, 232, 402, 499, 83, 244, 193, 306, 78, 92, 213, 496, 212, 226, 48, 247, 69, 121, 453, 221, 462, 329, 373, 75, 389, 242, 255, 249, 309, 444, 225, 133, 220, 381, 82, 208, 217, 151, 376, 443, 387, 459, 190, 301, 305, 254, 120, 334, 68, 134, 356, 342, 503, 157, 379, 438, 210, 21, 122, 498, 466, 428, 490, 17, 18, 34, 423, 369, 38, 500, 156, 248, 311, 241, 246, 20, 397, 10, 150, 154, 173, 429, 317, 463, 451, 76, 110, 265, 257, 54, 199, 385, 339, 336, 158, 515, 495, 303, 11, 412, 218, 73, 390, 310, 510, 6, 253, 107, 146, 116, 479, 400, 524, 372, 16, 181, 143, 191, 363, 457, 461, 103, 152, 63, 207, 112, 289, 201, 14, 164, 327, 403, 408, 175, 485, 71, 304, 283, 512, 277, 464, 409, 483, 115, 312, 297, 74, 49, 337, 119, 445, 413, 320, 487, 58, 357, 130, 318, 471, 519, 280, 439, 89, 440, 279, 368, 343, 401, 46, 501, 187, 418, 493, 142, 72, 228, 362, 432, 513, 293, 139, 467, 9, 251, 271, 15, 416, 284, 410, 492, 264, 434, 166, 344, 97, 507, 202, 128, 113, 198, 266, 231, 162, 528, 355, 332, 425, 106, 87, 127, 100, 353, 140, 516, 299, 361, 314, 526, 240, 322, 452, 94, 262, 302, 514, 518, 209, 88, 256, 270, 489, 450, 250, 211, 125, 131, 176, 442, 57, 502, 200, 431, 26, 308, 392, 55, 330, 491, 454, 13, 324, 85, 129, 328, 28, 62, 340, 95, 160, 99, 354, 420, 377, 449, 398, 204, 458, 419, 465, 508, 148, 484, 91, 227, 219, 460, 194, 206, 222, 281, 470, 517, 366, 23, 529, 364, 24, 433, 272, 446, 27, 469, 473, 486, 161, 77, 269, 60, 506, 435, 174, 238, 448, 321, 405, 367, 141, 167, 346, 33, 22, 258, 288, 509, 267, 239, 505, 155, 287, 455, 391, 527, 430, 468, 456, 476, 300, 214, 144, 480, 511, 520, 205, 378, 349, 93, 117, 233, 298, 396, 422, 25, 35, 380, 384, 135, 504, 521, 19, 30, 404, 31, 365, 274, 47, 436, 102, 348, 522, 488, 282, 126, 406, 163, 195, 273, 472, 29, 53, 5, 358, 426, 497, 84, 8, 67, 525, 96, 171, 338, 388, 290, 319, 37, 86, 45, 394, 474, 42, 291, 192, 478, 252, 351, 437, 236, 66, 447, 296, 276, 65, 186, 123, 523, 295, 382, 188, 482, 178, 383, 137, 136, 352, 124, 316, 315, 481, 386, 326, 323, 371, 180, 147, 44, 177, 325, 56, 39, 427, 475, 285, 111, 36, 40, 421, 41, 294 }

local lootchests = { 
    LootboxesMod.LOOTCHEST_TRASH, 
    LootboxesMod.LOOTCHEST_COMMON, 
    LootboxesMod.LOOTCHEST_RARE, 
    LootboxesMod.LOOTCHEST_EPIC, 
    LootboxesMod.LOOTCHEST_LEGENDARY
}

--[[Hook into External Item Descriptions Mod]]
-- 2. Make sure we're not adding to a nil table
if not __eidItemDescriptions then
    __eidItemDescriptions = {};
  end
  -- 3. Add the description
  __eidItemDescriptions[LootboxesMod.COLLECTIBLE_LOOTBOX] = "Open a lookbox. Pay 25g or lose item after use";
  __eidItemDescriptions[LootboxesMod.LOOTCHEST_TRASH]     = "Poor quality chest";
  __eidItemDescriptions[LootboxesMod.LOOTCHEST_COMMON]    = "Standard quality chest";
  __eidItemDescriptions[LootboxesMod.LOOTCHEST_RARE]      = "Good quality chest";
  __eidItemDescriptions[LootboxesMod.LOOTCHEST_EPIC]      = "Great quality chest";
  __eidItemDescriptions[LootboxesMod.LOOTCHEST_LEGENDARY] = "Best quality chest, high odds for high tier items";


--[ Other variables to use ]
local v0 = Vector(0,0);
local offset = 50;

--[[ Generic Helper functions ]]

function table.length(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count
end

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

