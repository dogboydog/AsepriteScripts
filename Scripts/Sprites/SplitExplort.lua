---
--- Created by dogboydog
---

local spr = app.activeSprite
if not spr then
    return print "No active sprite"
end
local fs = app.fs
local outputFolder = fs.filePath(spr.filename)

fs.makeDirectory(outputFolder)

local fullImage = Image(spr.width, spr.height)
fullImage:drawSprite(spr)

local splitX = 32
local splitY = 32

local dlg = Dialog { title = "Export Split" }
dlg:label { label = "The image will be split into separate sprites,", text = "left to right, top to bottom." }
dlg:label { label = "Provide the width and height to be used", text = "for all of the images." }

dlg:number { id = "splitX", label = "Split width:", text = splitX , decimals=0}
dlg:number{ id = "splitY", label = "Split height:", text = splitY, decimals=0 }
dlg:label { label = "Export path:", text = outputFolder }
dlg:button { id = "confirm", text = "Confirm" }
dlg:button { id = "cancel", text = "Cancel" }
dlg:show()
local data = dlg.data
if data.confirm then
    do
        splitX = data.splitX
        splitY = data.splitY
        if spr.width % splitX ~= 0 then
            return print("Sprite width " .. spr.width .. " is not divisible by split size " .. splitX)
        end

        if spr.height % splitY ~= 0 then
            return print("Sprite height " .. spr.height .. " is not divisible by split size " .. splitY)
        end

        local splitImage = Image(splitX, splitY)

        local exportPrefix = fs.fileTitle(spr.filename)
        local exportPath = ""
        local splitNumber = 1;
        for y = 0, spr.height - 1, splitY do
            for x = 0, spr.width - 1, splitX do
                splitImage = Image(splitX, splitY)
                local splitRect = Rectangle { x = x, y = y, width = splitX, height = splitY }
                for it in fullImage:pixels(splitRect) do
                    local pixelValue = it() -- get pixel
                    splitImage:drawPixel(it.x - x, it.y - y, pixelValue)
                end
                exportPath = fs.joinPath(outputFolder, exportPrefix .. splitNumber .. '.png')
                splitNumber = splitNumber + 1
                splitImage:saveAs(exportPath, spr.palettes[1])
            end
        end

    end
else

    -- do nothing, canceled
end
        