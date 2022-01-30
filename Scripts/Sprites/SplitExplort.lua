---
--- Created by dogboydog
---

local spr = app.activeSprite
if not spr then
    return print "No active sprite"
end
local fs = app.fs
local outputFolder = fs.filePath(spr.filename)

local fullImage = Image(spr.width, spr.height)
fullImage:drawSprite(spr)

local splitX = 32
local splitY = 32

if spr.width % splitX ~= 0 then
    return print "Sprite width " .. spr.width .. " is not divisible by split size " .. splitX
end

if spr.height % splitY ~= 0 then
    return print "Sprite height " .. spr.height .. " is not divisible by split size " .. splitY
end 

