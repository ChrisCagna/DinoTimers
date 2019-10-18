DinoTimersVariables = {

}
local DinoTimersFont = "Fonts\\ARIALN.ttf"
local version = 1.0
local dtClr = "|cff009F00"
local gryClr = "|cffA9A9A9"

local width = 100
local height = 100

local xpos1 = 0
local ypos1 = 0
local xpos2 = 0
local ypos2 = 0
local xpos3 = 0
local ypos3 = 0
local updateInterval = 1

local tStart = time() -- time when logged on
local sessionTime = 0
local timeSinceUpdate = 0;
local updateNow = false;

-- local values
local NW = 0;
local N = 0;
local E = 0;
local W = 0;
local SW = 0;
local SE = 0;


SLASH_DINOTIMERS1 = "/dt"
-- SLASH_DINOTIMERS2 = "/DT"
-- SLASH_DINOTIMERS3 = "/Dt"
local function handler(msg, editBox)
	if(msg == "test") then
		--DEFAULT_CHAT_FRAME:AddMessage("Current Time: " .. sessionTime)
	elseif(msg == "NW" or msg == "N" or msg == "E" or msg == "W" or msg == "SW" or msg == "SE") then
		diedAt(msg)
	else
		DEFAULT_CHAT_FRAME:AddMessage(dtClr .. "Dino Timers Commands: |r")
	end
end
SlashCmdList["DINOTIMERS"] = handler;

local Init_Frame = CreateFrame("Frame")
Init_Frame:RegisterEvent("ADDON_LOADED")
Init_Frame:SetScript("OnEvent",
	function(self, event, ...)
		local arg1 = ...
		if(arg1 == "DinoTimers") then
			DEFAULT_CHAT_FRAME:AddMessage("|TInterface\\Icons\\Inv_misc_pelt_03:16|t" .. dtClr .. "Dino Timers Loaded!|r|TInterface\\Icons\\Inv_misc_pelt_03:16|t")
		end
		
end)

createFrames = function()
MainFrame=CreateFrame("Frame","MainFrame",UIParent)

text=MainFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
text1=MainFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
text2=MainFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
text3=MainFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
text4=MainFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
text5=MainFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
text6=MainFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")

timer=MainFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
timer1=MainFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
timer2=MainFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
timer3=MainFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
timer4=MainFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
timer5=MainFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
timer6=MainFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")

resetButton = CreateFrame("Button","startButton1",UIParent,"UIPanelButtonGrayTemplate")
startButton1 = CreateFrame("Button","startButton1",UIParent,"UIPanelButtonGrayTemplate")
startButton2 = CreateFrame("Button","startButton1",UIParent,"UIPanelButtonGrayTemplate")
startButton3 = CreateFrame("Button","startButton1",UIParent,"UIPanelButtonGrayTemplate")
startButton4 = CreateFrame("Button","startButton1",UIParent,"UIPanelButtonGrayTemplate")
startButton5 = CreateFrame("Button","startButton1",UIParent,"UIPanelButtonGrayTemplate")
startButton6 = CreateFrame("Button","startButton1",UIParent,"UIPanelButtonGrayTemplate")
end

setDefaults = function()
MainFrame:SetPoint("CENTER")
MainFrame:SetSize(200,200)
MainFrame:RegisterForDrag("LeftButton")
MainFrame:SetMovable(true)
MainFrame:SetAlpha(1)
MainFrame:SetClampedToScreen(true)
MainFrame:SetUserPlaced(true)
MainFrame:EnableMouse()
MainFrame:SetScript("OnUpdate", MainFrame.OnUpdate)


text:SetPoint("TOPLEFT")
text:SetJustifyH("LEFT")
--text:SetFont(DinoTimersFont, 10, "OUTLINE")
text:SetText(dtClr .. "|TInterface\\Icons\\Inv_misc_pelt_03:16|tSession:            \n ")



text1:SetPoint("TOPLEFT",text,"BOTTOMLEFT",0,0)
text1:SetText(gryClr .. "North West")

text2:SetPoint("TOPLEFT",text1,"BOTTOMLEFT",0,-3)
text2:SetText(gryClr .. "North")

text3:SetPoint("TOPLEFT",text2,"BOTTOMLEFT",0,-3)
text3:SetText(gryClr .. "East")

text4:SetPoint("TOPLEFT",text3,"BOTTOMLEFT",0,-3)
text4:SetText(gryClr .. "West")

text5:SetPoint("TOPLEFT",text4,"BOTTOMLEFT",0,-3)
text5:SetText(gryClr .. "South West")

text6:SetPoint("TOPLEFT",text5,"BOTTOMLEFT",0,-3)
text6:SetText(gryClr .. "South East")

timer:SetPoint("TOPLEFT",text,"TOPRIGHT")
timer:SetText(gryClr .. "00:00")

timer1:SetPoint("TOPLEFT",text,"BOTTOMRIGHT",0,-3)
timer1:SetText(gryClr .. "00:00")

timer2:SetPoint("TOPLEFT",timer1,"BOTTOMLEFT",0,-3)
timer2:SetText(gryClr .. "00:00")

timer3:SetPoint("TOPLEFT",timer2,"BOTTOMLEFT",0,-3)
timer3:SetText(gryClr .. "00:00")

timer4:SetPoint("TOPLEFT",timer3,"BOTTOMLEFT",0,-3)
timer4:SetText(gryClr .. "00:00")

timer5:SetPoint("TOPLEFT",timer4,"BOTTOMLEFT",0,-3)
timer5:SetText(gryClr .. "00:00")

timer6:SetPoint("TOPLEFT",timer5,"BOTTOMLEFT",0,-3)
timer6:SetText(gryClr .. "00:00")

resetButton:SetPoint("TOPRIGHT",text, "TOPLEFT",-2,0)
resetButton:SetWidth(40)
resetButton:SetHeight(20)
resetButton:SetText("Reset")
resetButton:RegisterForClicks("LeftButtonUp")

startButton1:SetPoint("TOPRIGHT",text1, "TOPLEFT",-2,0)
startButton1:SetWidth(40)
startButton1:SetHeight(15)
startButton1:SetText("Start")
startButton1:RegisterForClicks("LeftButtonUp")
--startButton1:CreateFontString(nil,"OVERLAY","GameFontNormal")
--startButton1:SetFont(DinoTimersFont, 10, "OUTLINE")

startButton2:SetPoint("TOPRIGHT",text2, "TOPLEFT",-2,0)
startButton2:SetWidth(40)
startButton2:SetHeight(15)
startButton2:SetText("Start")
startButton2:RegisterForClicks("LeftButtonUp")

startButton3:SetPoint("TOPRIGHT",text3, "TOPLEFT",-2,0)
startButton3:SetWidth(40)
startButton3:SetHeight(15)
startButton3:SetText("Start")
startButton3:RegisterForClicks("LeftButtonUp")

startButton4:SetPoint("TOPRIGHT",text4, "TOPLEFT",-2,0)
startButton4:SetWidth(40)
startButton4:SetHeight(15)
startButton4:SetText("Start")
startButton4:RegisterForClicks("LeftButtonUp")

startButton5:SetPoint("TOPRIGHT",text5, "TOPLEFT",-2,0)
startButton5:SetWidth(40)
startButton5:SetHeight(15)
startButton5:SetText("Start")
startButton5:RegisterForClicks("LeftButtonUp")

startButton6:SetPoint("TOPRIGHT",text6, "TOPLEFT",-2,0)
startButton6:SetWidth(40)
startButton6:SetHeight(15)
startButton6:SetText("Start")
startButton6:RegisterForClicks("LeftButtonUp")

end

backdropDefault = function()

background = "Interface\\TutorialFrame\\TutorialFrameBackground"
edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border"
backdrop =
{
    bgFile = background,
    edgeFile = edge,
    tile = false, tileSize = 16, edgeSize = 16,
    insets = { left = 0, right = 0, top = 0, bottom = -10 }
}

end

resetNW = function()
	NW = 0;
	text1:SetPoint("TOPLEFT",text,"BOTTOMLEFT",0,0)
	text1:SetText(gryClr .. "North West")

	timer1:SetPoint("TOPLEFT",text,"BOTTOMRIGHT",0,-3)
	timer1:SetText(gryClr .. "00:00")
	
	startButton1:SetText("Start")
end

resetN = function()
	N = 0;
	text2:SetPoint("TOPLEFT",text1,"BOTTOMLEFT",0,-3)
	text2:SetText(gryClr .. "North")

	timer2:SetPoint("TOPLEFT",timer1,"BOTTOMLEFT",0,-3)
	timer2:SetText(gryClr .. "00:00")
	
	startButton2:SetText("Start")
end

resetE = function()
	E = 0
	text3:SetPoint("TOPLEFT",text2,"BOTTOMLEFT",0,-3)
	text3:SetText(gryClr .. "East")

	timer3:SetPoint("TOPLEFT",timer2,"BOTTOMLEFT",0,-3)
	timer3:SetText(gryClr .. "00:00")
	
	startButton3:SetText("Start")
end

resetW = function()
	W = 0
	text4:SetPoint("TOPLEFT",text3,"BOTTOMLEFT",0,-3)
	text4:SetText(gryClr .. "West")

	timer4:SetPoint("TOPLEFT",timer3,"BOTTOMLEFT",0,-3)
	timer4:SetText(gryClr .. "00:00")
	
	startButton4:SetText("Start")
end

resetSW = function()
	SW = 0
	text5:SetPoint("TOPLEFT",text4,"BOTTOMLEFT",0,-3)
	text5:SetText(gryClr .. "South West")

	timer5:SetPoint("TOPLEFT",timer4,"BOTTOMLEFT",0,-3)
	timer5:SetText(gryClr .. "00:00")
	
	startButton5:SetText("Start")
end

resetSE = function()
	SE = 0
	text6:SetPoint("TOPLEFT",text5,"BOTTOMLEFT",0,-3)
	text6:SetText(gryClr .. "South East")
	
	timer6:SetPoint("TOPLEFT",timer5,"BOTTOMLEFT",0,-3)
	timer6:SetText(gryClr .. "00:00")
	
	startButton6:SetText("Start")
end

reset = function()

resetNW()
resetN()
resetE()
resetW()
resetSW()
resetSE()

tStart = time()
updateCurrentTime()

end

adjustSize = function()
	width = text:GetStringWidth() + timer:GetStringWidth()
	height = text:GetStringHeight() + (text1:GetStringHeight() * 6) + 9
	MainFrame:SetSize(width,height)
end

createFrames()
backdropDefault()
setDefaults()
adjustSize()

MainFrame:SetScript('OnEnter', function() 
	MainFrame:SetBackdrop(backdrop)
end)

MainFrame:SetScript('OnLeave', function()
	MainFrame:SetBackdropColor(1,1,1,0)
end)

function MainFrame:OnUpdate(arg1)
	timeSinceUpdate = timeSinceUpdate + arg1
	if(updateInterval<timeSinceUpdate or updateNow == true) then
-- actual code on update here
		updateCurrentTime()
		timer:SetText(dtClr .. secondsFormat(sessionTime))
		
		printController(NW)
		printController(N)
		printController(E)
		printController(W)
		printController(SW)
		printController(SE)

			
-- actual code end
		if(updateNow == false) then
			timeSinceUpdate = 0
		else
			updateNow = false
		end

	end
end

MainFrame:SetScript("OnUpdate", MainFrame.OnUpdate)

resetButton:SetScript("OnMouseUp", function(self, button)
	resetButton:SetText("Reset")
	reset()
	updateNow = true
end)

startButton1:SetScript("OnMouseUp", function(self, button)
	local targetName = "/target Vanishd"
	DEFAULT_CHAT_FRAME.editBox:SetText(targetName) ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox, 0)
	
	if(startButton1:GetText() ==  "Start") then
		diedAt("NW")
		startButton1:SetText("Reset")
		updateNow = true
	elseif(startButton1:GetText() == "Reset") then
		resetNW()
		end
end)

startButton2:SetScript("OnMouseUp", function(self, button)
	if(startButton2:GetText() ==  "Start") then
		diedAt("N")
		startButton2:SetText("Reset")
		updateNow = true
	elseif(startButton2:GetText() == "Reset") then
		resetN()
		end
end)

startButton3:SetScript("OnMouseUp", function(self, button)
	if(startButton3:GetText() ==  "Start") then
		diedAt("E")
		startButton3:SetText("Reset")
		updateNow = true
	elseif(startButton3:GetText() == "Reset") then
		resetE()
		end
end)

startButton4:SetScript("OnMouseUp", function(self, button)
	if(startButton4:GetText() ==  "Start") then
		diedAt("W")
		startButton4:SetText("Reset")
		updateNow = true
	elseif(startButton4:GetText() == "Reset") then
		resetW()
		end
end)

startButton5:SetScript("OnMouseUp", function(self, button)
	if(startButton5:GetText() ==  "Start") then
		diedAt("SW")
		startButton5:SetText("Reset")
		updateNow = true
	elseif(startButton5:GetText() == "Reset") then
		resetSW()
		end
end)

startButton6:SetScript("OnMouseUp", function(self, button)
	if(startButton6:GetText() ==  "Start") then
		diedAt("SE")
		startButton6:SetText("Reset")
		updateNow = true
	elseif(startButton6:GetText() == "Reset") then
		resetSE()
		end
end)

MainFrame:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" and not self.isMoving then
		_, _, _, xpos1, ypos1 = MainFrame:GetPoint(1)
		self:StartMoving();
		_, _, _, xpos2, ypos2 = MainFrame:GetPoint(1)
		self.isMoving = true;
	end
end)

MainFrame:SetScript("OnMouseUp", function(self, button)
	if button == "LeftButton" and self.isMoving then
		_, _, _, xpos3, ypos3 = MainFrame:GetPoint(1)
		self:StopMovingOrSizing()
		self.isMoving = false;
	end
end)

updateCurrentTime = function()
	sessionTime = time() - tStart
end

secondsFormat = function(t)
	local days = floor(t/86400)
	local hours = floor(mod(t, 86400)/3600)
	local minutes = floor(mod(t,3600)/60)
	local seconds = floor(mod(t,60))
	return format("%02d:%02d",minutes,seconds)
end

diedAt = function(dino)
	if(dino == "NW") then
		NW = sessionTime
	end
	if(dino == "N") then
		N = sessionTime
	end
	if(dino == "E") then
		E = sessionTime
	end
	if(dino == "W") then
		W = sessionTime
	end
	if(dino == "SW") then
		SW = sessionTime
	end
	if(dino == "SE") then
		SE = sessionTime
	end
end

timeDead = function(dino)
	return sessionTime - dino
end

printController = function(dino)
	-- set color of text
	local clr = ""
	if(timeDead(dino) >= 600 and timeDead(dino) <960 ) then
		clr = "|cff00ff00"
	elseif(timeDead(dino)>=960) then
		clr = "|cffff0000"
	end
	
	
	if(dino > 0 and dino == NW) then
		text1:SetText(clr .. "North West")
		timer1:SetText(secondsFormat(timeDead(NW)))
	end
	if(dino > 0 and dino == N) then
		text2:SetText(clr .. "North")
		timer2:SetText(secondsFormat(timeDead(N)))
	end
	if(dino > 0 and dino == E) then
		text3:SetText(clr .. "East")
		timer3:SetText(secondsFormat(timeDead(E)))
	end
	if(dino > 0 and dino == W) then
		text4:SetText(clr .. "West")
		timer4:SetText(secondsFormat(timeDead(W)))
	end
	if(dino > 0 and dino == SW) then
		text5:SetText(clr .. "South West")
		timer5:SetText(secondsFormat(timeDead(SW)))
	end
	if(dino > 0 and dino == SE) then
		text6:SetText(clr .. "South East")
		timer6:SetText(secondsFormat(timeDead(SE)))
	end	
	
	
end




















