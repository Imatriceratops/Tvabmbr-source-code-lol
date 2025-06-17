iconPath = 'icons/jai' -- Picture grid file name of icon.
iconName = 'GF' -- Sets icon name. Make sure to name it something you can remember!

objectOrder = -1 -- Set to -1 if you wish to not use object order! (The higher value is, the more it will layer above the sprites. Vice Versa.)

isPlayer = true -- If false, it will flip X and go on opponent's side.
winningIcons = false -- If true, it will use a winning icon. (Your icon grid image file must have 3 icons!)

useXML = false -- If true, the icon will also use .XML for sprite animations. (WARNING: You may need to reposition the icon! Reposition it using the offsets for XML animations!)
numberOfIcons = 3 -- How many icons are there in one lane in the spritesheet? (Resizing purposes?)
XMLAnims = { -- They should be layed out as (1st: Normal, 2nd: Lose, 3rd: Win).
  --{'animName', 'animPrefix', offsetX, offsetY}

    {'normal', 'black icon calm', 0, 0},
    {'lose', 'black icon mad', 0, 0},
    {'win', 'icon win', 0, 0}
}

customizePos = false -- If true, you will be able to freely change the icon position.

doIconBop = true -- If false, stops icon bop. (Also stops it from returning to normal!)
bopMultiplier = 1.2 -- Sets how big the bop should be when on beat.
bopSpeed = 9 -- The higher the value, the faster the bop ends.

iconScale = {
    1, -- Scale X
    1 -- Scale Y
}

iconPos = {
    100, -- Offset X
    -40 -- Offset Y
}

local iconOffsets = {0, 0}
function onCreatePost()
    luaDebugMode = true

    if not useXML then
        makeLuaSprite('icon-' .. iconName, iconPath, 0, getProperty('healthBar.y') - 75 + iconPos[2])
    else
        makeAnimatedLuaSprite('icon-' .. iconName, iconPath, 0, getProperty('healthBar.y') - 75 + iconPos[2])
        for i, v in pairs(XMLAnims) do
            addAnimationByPrefix('icon-' .. iconName, v[1], v[2], 24, true)
        end
    end
    if not useXML then
        if not winningIcons then
            loadGraphic('icon-' .. iconName, iconPath, math.floor(getProperty('icon-' .. iconName .. '.width') / 2), math.floor(getProperty('icon-' .. iconName .. '.height')))
            iconOffsets[1] = (getProperty('icon-' .. iconName .. '.width') - 150) / 2 -- unnecessary.
            iconOffsets[2] = (getProperty('icon-' .. iconName .. '.width') - 150) / 2 -- unnecessary.
            addAnimation('icon-' .. iconName, iconName, {0, 1}, 0, false)
        else
            loadGraphic('icon-' .. iconName, iconPath, math.floor(getProperty('icon-' .. iconName .. '.width') / 3), math.floor(getProperty('icon-' .. iconName .. '.height')))
            iconOffsets[1] = (getProperty('icon-' .. iconName .. '.width') - 150) / 3 -- unnecessary.
            iconOffsets[2] = (getProperty('icon-' .. iconName .. '.width') - 150) / 3 -- unnecessary.
            addAnimation('icon-' .. iconName, iconName, {0, 1, 2}, 0, false)
        end
    else
        iconOffsets[1] = (getProperty('icon-' .. iconName .. '.width') - getProperty('icon-' .. iconName .. '.width')/2) / numberOfIcons
        iconOffsets[2] = (getProperty('icon-' .. iconName .. '.width') - getProperty('icon-' .. iconName .. '.width')/2) / numberOfIcons
    end

    if objectOrder >= 0 then
        setObjectOrder('icon-' .. iconName, objectOrder)
    end
    scaleObject('icon-' .. iconName, iconScale[1], iconScale[2])
    updateHitbox('icon-' .. iconName)
    setObjectCamera('icon-' .. iconName, 'hud')
    setProperty('icon-' .. iconName .. '.flipX', isPlayer)
    if not useXML then
        playAnim('icon-' .. iconName, iconName, false)
    else
        playAnim('icon-' .. iconName, XMLAnims[1][1], false)
    end

    if stringStartsWith(version, '0.6') then
        setProperty('icon-' .. iconName .. '.antialiasing', getPropertyFromClass('ClientPrefs', 'globalAntialiasing'))
    elseif stringStartsWith(version, '0.7') then
        setProperty('icon-' .. iconName .. '.antialiasing', getPropertyFromClass('backend.ClientPrefs', 'data.antialiasing'))
    end

    if stringEndsWith(iconName, '-pixel') then
        setProperty('icon-' .. iconName .. '.antialiasing', false)
    end

    addLuaSprite('icon-' .. iconName, true)
end

function updateOffset(obj)
    if not useXML then
        setProperty(obj .. '.offset.x', iconOffsets[1])
        setProperty(obj .. '.offset.y', iconOffsets[2])
    else
        setProperty(obj .. '.offset.x', iconOffsets[1] - XMLAnims[indexValOf(XMLAnims, getProperty('icon-' .. iconName .. '.animation.curAnim.name'))][3])
        setProperty(obj .. '.offset.y', iconOffsets[2] - XMLAnims[indexValOf(XMLAnims, getProperty('icon-' .. iconName .. '.animation.curAnim.name'))][4])
    end
end

function onBeatHit()
    if doIconBop then
        scaleObject('icon-' .. iconName, bopMultiplier * iconScale[1], bopMultiplier * iconScale[2]) -- could this cause issues?
        updateHitbox('icon-' .. iconName)
        updateOffset('icon-' .. iconName)
    end
end

function onUpdatePost(elapsed)
    --what the fuck
    if not useXML then
        if isPlayer then
            if not winningIcons then
                iconOffsets[1] = -(getProperty('icon-' .. iconName .. '.width') - 150) / 2
            else
                iconOffsets[1] = -(getProperty('icon-' .. iconName .. '.width') - 150) / 3
            end
        else
            if not winningIcons then
                iconOffsets[1] = (getProperty('icon-' .. iconName .. '.width') - 150) / 2
            else
                iconOffsets[1] = (getProperty('icon-' .. iconName .. '.width') - 150) / 3
            end
        end
    else
        if isPlayer then
            iconOffsets[1] = -(getProperty('icon-' .. iconName .. '.width') - getProperty('icon-' .. iconName .. '.width')/2) / numberOfIcons
        else
            iconOffsets[1] = (getProperty('icon-' .. iconName .. '.width') - getProperty('icon-' .. iconName .. '.width')/2) / numberOfIcons
        end
    end
    iconOffsets[2] = 0 -- what???

    local iconMultiplier = lerp(iconScale[1], getProperty('icon-' .. iconName .. '.scale.x'), clamp(1 - (elapsed * bopSpeed * playbackRate), 0, 1))
    if doIconBop then
        scaleObject('icon-' .. iconName, iconMultiplier, iconMultiplier)
        updateHitbox('icon-' .. iconName)
        updateOffset('icon-' .. iconName)
    end

    if not customizePos then
        if isPlayer then
            setProperty('icon-' .. iconName .. '.x', getProperty('healthBar.x') + (getProperty('healthBar.width') * (remapToRange(getProperty('healthBar.percent'), 0, 100, 100, 0) * 0.01) - (150 + getProperty('icon-' .. iconName .. '.scale.x') - 150) / 2 - 26 + iconPos[1]))
        else
            setProperty('icon-' .. iconName .. '.x', getProperty('healthBar.x') + (getProperty('healthBar.width') * (remapToRange(getProperty('healthBar.percent'), 0, 100, 100, 0) * 0.01) - (150 - getProperty('icon-' .. iconName .. '.scale.x')) / 2 - 26 * 2 + iconPos[1]))
        end
    end

    --Redone check (idk if this better)
    if not useXML then
        if not winningIcons then
            if isPlayer then
                if getProperty('healthBar.percent') < 20 then
                    setProperty('icon-' .. iconName .. '.animation.curAnim.curFrame', 2)
                else
                    setProperty('icon-' .. iconName .. '.animation.curAnim.curFrame', 0)
                end
            else
                if getProperty('healthBar.percent') > 80 then
                    setProperty('icon-' .. iconName .. '.animation.curAnim.curFrame', 2)
                else
                    setProperty('icon-' .. iconName .. '.animation.curAnim.curFrame', 0)
                end
            end
        else
            if isPlayer then
                if getProperty('healthBar.percent') < 20 then
                    setProperty('icon-' .. iconName .. '.animation.curAnim.curFrame', 1)
                elseif getProperty('healthBar.percent') > 80 then
                    setProperty('icon-' .. iconName .. '.animation.curAnim.curFrame', 2)
                else
                    setProperty('icon-' .. iconName .. '.animation.curAnim.curFrame', 0)
                end
            else
                if getProperty('healthBar.percent') > 80 then
                    setProperty('icon-' .. iconName .. '.animation.curAnim.curFrame', 1)
                elseif getProperty('healthBar.percent') < 20 then
                    setProperty('icon-' .. iconName .. '.animation.curAnim.curFrame', 2)
                else
                    setProperty('icon-' .. iconName .. '.animation.curAnim.curFrame', 0)
                end
            end
        end
    else
        if not winningIcons then
            if isPlayer then
                if getProperty('healthBar.percent') < 20 then
                    playAnim('icon-' .. iconName, XMLAnims[3][1], false)
                else
                    playAnim('icon-' .. iconName, XMLAnims[1][1], false)
                end
            else
                if getProperty('healthBar.percent') > 80 then
                    playAnim('icon-' .. iconName, XMLAnims[2][1], false)
                else
                    playAnim('icon-' .. iconName, XMLAnims[1][1], false)
                end
            end
        else
            if isPlayer then
                if getProperty('healthBar.percent') < 20 then
                    playAnim('icon-' .. iconName, XMLAnims[2][1], false)
                else
                    playAnim('icon-' .. iconName, XMLAnims[1][1], false)
                end
            else
                if getProperty('healthBar.percent') > 80 then
                    playAnim('icon-' .. iconName, XMLAnims[3][1], false)
                else
                    playAnim('icon-' .. iconName, XMLAnims[1][1], false)
                end
            end
        end
    end
end

function clamp(x,min,max) return math.max(min,math.min(x,max)) end
function lerp(from,to,i) return from+(to-from)*i end

function remapToRange(v, begin1, stop1, begin2, stop2) return begin2 + (v - begin1) * ((stop2 - begin2) / (stop1 - begin1)) end -- i definitely did not take this!111 (you technically dont need to remap but eh?)

function indexValOf(table, value)
    local incrVal = 0
    incrVal = incrVal + 1
    for i, v in ipairs(table) do
        if value == v[incrVal] then
            incrVal = 0
            return i
        end
    end
    return nil
end

--[[TODO:
1: Make icon name use character name and add as option? (Still unsure)
--]]