local component = require("component")
local term = require("term")
local text = require("text")
local event = require("event")
local computer = require("computer")
 
local im = component.induction_matrix
local charts = require("charts")
 
local function printXY(row, col, s, ...)
  term.setCursor(row, col)
  print(s:format(...))
end
 
 
function comma_value(n) -- credit http://richard.warburton.it
  local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
  return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end
 
term.clear()
 
local container = charts.Container()
container.width = 120
container.x = 20
container.height = 20
local payload = charts.Histogram()
payload.min = -im.getTransferCap()/2.5
payload.max = im.getTransferCap()/2.5
payload.level.y = 10
payload.level.value = 0
payload.align = charts.sides.RIGHT
payload.colorFunc = function(index, norm, value, self, container)
  return 0x20ff20
end
container.payload = payload
 
printXY(13,1,"65.53",...)
printXY(17,10,"0",...)
printXY(12,20,"-65.53",...)
 
local cleft = charts.Container()
cleft.x, cleft.y, cleft.width, cleft.height = 1, 30, 160, 2
local pleft = charts.ProgressBar()
pleft.direction = charts.sides.RIGHT
pleft.value = 0
pleft.colorFunc = function(_, perc)
  if perc >= .9 then
    return 0x20afff
  elseif perc >= .75 then
    return 0x20ff20
  elseif perc >= .5 then
    return 0xafff20
  elseif perc >= .25 then
    return 0xffff20
  elseif perc >= .1 then
    return 0xffaf20
  else
    return 0xff2020
  end
end
cleft.payload = pleft
 
 
while true do
  local rate = (im.getInput())/2.5
  table.insert(payload.values,rate)
  container:draw()
  printXY(142,10,comma_value(tostring(math.ceil(rate))) .. " rf/t",...)
 
 
 
  pleft.value = im.getEnergy() / im.getMaxEnergy()
  cleft:draw()
 
  os.sleep(0.5)
end
