local lg = love.graphics

fixcolor = {}

function fixcolor:setColor(r, g, b, a)
    a = a or 255;

    if type(r) == "table" then
        lg.setColor(r[1] / 255, r[2] / 255, r[3] / 255, r[4] / 255)
    else
        lg.setColor(r / 255, g / 255, b / 255, a / 255)
    end
end