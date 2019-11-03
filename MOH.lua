script_name('Medic HELP')
script_version('1.1')
script_author('Evelyn_Ross')
local sf = require 'sampfuncs'
local key = require "vkeys"
local inicfg = require 'inicfg'
local sampev = require 'lib.samp.events'
local imgui = require 'imgui' -- ��������� ����������
local encoding = require 'encoding' -- ��������� ����������
local wm = require 'lib.windows.message'
local gk = require 'game.keys'
local dlstatus = require('moonloader').download_status
local lmem, memory = pcall(require, 'memory')
                     assert(lmem, 'Library \'memory\' not found')
local second_window = imgui.ImBool(false)
local third_window = imgui.ImBool(false)
local first_window = imgui.ImBool(false)
local btn_size = imgui.ImBool(false)
local bMainWindow = imgui.ImBool(false)                              
local sInputEdit = imgui.ImBuffer(128)
local bIsEnterEdit = imgui.ImBool(false)
local ystwindow = imgui.ImBool(false)
local memw = imgui.ImBool(false)
local tCarsName = {"Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus",
"Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BFInjection", "Hunter",
"Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie", "Stallion", "Rumpo",
"RCBandit", "Romero","Packer", "Monster", "Admiral", "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed",
"Yankee", "Caddy", "Solair", "Berkley'sRCVan", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RCBaron", "RCRaider", "Glendale", "Oceanic", "Sanchez", "Sparrow",
"Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage",
"Dozer", "Maverick", "NewsChopper", "Rancher", "FBIRancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "BlistaCompact", "PoliceMaverick",
"Boxvillde", "Benson", "Mesa", "RCGoblin", "HotringRacerA", "HotringRacerB", "BloodringBanger", "Rancher", "SuperGT", "Elegant", "Journey", "Bike",
"MountainBike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "hydra", "FCR-900", "NRG-500", "HPV1000",
"CementTruck", "TowTruck", "Fortune", "Cadrona", "FBITruck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan", "Blade", "Freight",
"Streak", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada",
"Yosemite", "Windsor", "Monster", "Monster", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RCTiger", "Flash", "Tahoma", "Savanna", "Bandito",
"FreightFlat", "StreakCarriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "NewsVan",
"Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club", "FreightBox", "Trailer", "Andromada", "Dodo", "RCCam", "Launch", "PoliceCar", "PoliceCar",
"PoliceCar", "PoliceRanger", "Picador", "S.W.A.T", "Alpha", "Phoenix", "GlendaleShit", "SadlerShit", "Luggage A", "Luggage B", "Stairs", "Boxville", "Tiller",
"UtilityTrailer"}
local tCarsTypeName = {"����������", "���������", "�������", "������", "������", "�����", "������", "�����", "���������"}
local tCarsSpeed = {43, 40, 51, 30, 36, 45, 30, 41, 27, 43, 36, 61, 46, 30, 29, 53, 42, 30, 32, 41, 40, 42, 38, 27, 37,
54, 48, 45, 43, 55, 51, 36, 26, 30, 46, 0, 41, 43, 39, 46, 37, 21, 38, 35, 30, 45, 60, 35, 30, 52, 0, 53, 43, 16, 33, 43,
29, 26, 43, 37, 48, 43, 30, 29, 14, 13, 40, 39, 40, 34, 43, 30, 34, 29, 41, 48, 69, 51, 32, 38, 51, 20, 43, 34, 18, 27,
17, 47, 40, 38, 43, 41, 39, 49, 59, 49, 45, 48, 29, 34, 39, 8, 58, 59, 48, 38, 49, 46, 29, 21, 27, 40, 36, 45, 33, 39, 43,
43, 45, 75, 75, 43, 48, 41, 36, 44, 43, 41, 48, 41, 16, 19, 30, 46, 46, 43, 47, -1, -1, 27, 41, 56, 45, 41, 41, 40, 41,
39, 37, 42, 40, 43, 33, 64, 39, 43, 30, 30, 43, 49, 46, 42, 49, 39, 24, 45, 44, 49, 40, -1, -1, 25, 22, 30, 30, 43, 43, 75,
36, 43, 42, 42, 37, 23, 0, 42, 38, 45, 29, 45, 0, 0, 75, 52, 17, 32, 48, 48, 48, 44, 41, 30, 47, 47, 40, 41, 0, 0, 0, 29, 0, 0
}
local tCarsType = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1,
3, 1, 1, 1, 1, 6, 1, 1, 1, 1, 5, 1, 1, 1, 1, 1, 7, 1, 1, 1, 1, 6, 3, 2, 8, 5, 1, 6, 6, 6, 1,
1, 1, 1, 1, 4, 2, 2, 2, 7, 7, 1, 1, 2, 3, 1, 7, 6, 6, 1, 1, 4, 1, 1, 1, 1, 9, 1, 1, 6, 1,
1, 3, 3, 1, 1, 1, 1, 6, 1, 1, 1, 3, 1, 1, 1, 7, 1, 1, 1, 1, 1, 1, 1, 9, 9, 4, 4, 4, 1, 1, 1,
1, 1, 4, 4, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 7, 1, 1, 1, 1, 8, 8, 7, 1, 1, 1, 1, 1, 1, 1,
1, 3, 1, 1, 1, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 7, 1, 1, 1, 1, 8, 8, 7, 1, 1, 1, 1, 1, 4,
1, 1, 1, 2, 1, 1, 5, 1, 2, 1, 1, 1, 7, 5, 4, 4, 7, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5, 5, 5, 1, 5, 5
}
local helps = imgui.ImBool(false)
local infbar = imgui.ImBool(false)
local updwindows = imgui.ImBool(false)
local tEditData = {
	id = -1,
	inputActive = false
}
encoding.default = 'CP1251' -- ��������� ��������� �� ���������, ��� ������ ��������� � ���������� �����. CP1251 - ��� Windows-1251
u8 = encoding.UTF8
require 'lib.sampfuncs'
seshsps = 1
govtime = "1"
ctag = "Medic HELP {ffffff}�"
players1 = {'{ffffff}���\t{ffffff}����'}
players2 = {'{ffffff}���� ��������\t{ffffff}���\t{ffffff}����\t{ffffff}������'}
frak = nil
rang = nil
ttt = nil
dostavka = false
rabden = false
tload = false
changetextpos = false
tLastKeys = {}
prava = 0
pilot = 0
kater = 0
gun = 0
ribolov = 0
biznes = 0
departament = {}
tMembers = {}
vixodid = {}
local config_keys = {
    fastsms = { v = {}}
}

function apply_custom_style() -- ������ ������ ���������, ������� ������ � ������� �����

	imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2

    style.WindowPadding = ImVec2(15, 15)
    style.WindowRounding = 5.0
    style.FramePadding = ImVec2(5, 5)
    style.FrameRounding = 4.0
    style.ItemSpacing = ImVec2(12, 8)
    style.ItemInnerSpacing = ImVec2(8, 6)
    style.IndentSpacing = 25.0
    style.ScrollbarSize = 15.0
    style.ScrollbarRounding = 9.0
    style.GrabMinSize = 5.0
	style.GrabRounding = 3.0
	style.WindowTitleAlign = ImVec2(0.5, 0.5)


	colors[clr.Text] = ImVec4(0.80, 0.80, 0.83, 1.00)
    colors[clr.TextDisabled] = ImVec4(0.24, 0.23, 0.29, 1.00)
    colors[clr.ChildWindowBg] = ImVec4(0.07, 0.07, 0.09, 0.50)
    colors[clr.PopupBg] = ImVec4(0.07, 0.07, 0.09, 0.80)
    colors[clr.Border] = ImVec4(0.80, 0.80, 0.83, 0.88)
    colors[clr.BorderShadow] = ImVec4(0.92, 0.91, 0.88, 0.00)
	--colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.00, 0.00, 0.51)
	colors[clr.TitleBgCollapsed] = ImVec4(0.24, 0.23, 0.29, 1.00)
    colors[clr.TitleBgActive] = ImVec4(0.07, 0.61, 0.92, 0.83)
	colors[clr.MenuBarBg] = ImVec4(0.10, 0.09, 0.12, 0.50) 	
    colors[clr.ScrollbarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.ScrollbarGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
    colors[clr.ScrollbarGrabHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.ScrollbarGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.ComboBg] = ImVec4(0.19, 0.18, 0.21, 0.50)
    colors[clr.CheckMark] = ImVec4(0.80, 0.80, 0.83, 0.31)
    colors[clr.SliderGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
    colors[clr.SliderGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.Button] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.ButtonHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
    colors[clr.ButtonActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.Header] = ImVec4(0.10, 0.09, 0.12, 1.00)
    --colors[clr.HeaderHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.HeaderHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
    colors[clr.HeaderActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.ResizeGrip] = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.ResizeGripHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
    colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
    colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
    colors[clr.PlotLines] = ImVec4(0.40, 0.39, 0.38, 0.63)
    colors[clr.PlotLinesHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
    colors[clr.PlotHistogram] = ImVec4(0.40, 0.39, 0.38, 0.63)
    colors[clr.PlotHistogramHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
    colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
    --colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.70)
    colors[clr.ModalWindowDarkening] = ImVec4(0.00, 0.00, 0.00, 0.80)

	colors[clr.WindowBg] = ImVec4(0.06, 0.05, 0.07, 0.98)
    --colors[clr.FrameBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.FrameBg] = ImVec4(0.13, 0.12, 0.15, 1.00)
    colors[clr.FrameBgHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
    colors[clr.FrameBgActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
	colors[clr.TitleBg] = ImVec4(0.07, 0.61, 0.92, 0.83)

end
apply_custom_style()

local fileb = getWorkingDirectory() .. "\\config\\medicHELP.bind"
local tBindList = {}
if doesFileExist(fileb) then
	local f = io.open(fileb, "r")
	if f then
		tBindList = decodeJson(f:read())
		f:close()
	end
else
	tBindList = {
        [1] = {
            text = "/time",
            v = {key.VK_F4}
        }
	}
end

function debug_log(text, print)
  local file = io.open('moonloader/medicHELP/debug.txt', 'a')
	file:write(('[%s || %s] %s\n'):format(os.date('%H:%M:%S'), os.date('%d.%m.%Y'), tostring(text)))
  file:close()
  file = nil
  if print then
    sampfuncsLog("[ML] {954F4F}(SFA-Helper){CCCCCC} "..tostring(text))
  end
end

local medicHELP =
{
  main =
  {
    posX = 1738,
    posY = 974,
    widehud = 370,
    male = true,
    wanted == false,
    clear == false,
    hud = false,
    tar = '������',
	tarr = '���',
	tarb = false,
	clistb = false,
	clisto = false,
	givra = false,
    clist = 0
  },
  commands = 
  {
    ticket = false,
	zaderjka = 5
  },
   keys =
  {
	tload = 97,
	tazer = 97,
	fastmenu = 113
  }
}
cfg = inicfg.load(nil, 'medicHELP/config.ini')

local libs = {'sphere.lua', 'rkeys.lua', 'imcustom/hotkey.lua', 'imgui.lua', 'MoonImGui.dll', 'imgui_addons.lua'}
function main()
  while not isSampAvailable() do wait(1000) end
  if seshsps == 1 then
    ftext("Medic HELP ������� ��������. �������: /moh ��� �������� ��������� ����", -1)
  end
  if not doesDirectoryExist('moonloader/config/medicHELP/') then createDirectory('moonloader/config/medicHELP/') end
  if cfg == nil then
    sampAddChatMessage("{E66E6E}Medic HELP {ffffff}� ���������� ���� �������, �������.", -1)
    if inicfg.save(medicHELP, 'medicHELP/config.ini') then
      sampAddChatMessage("{E66E6E}Medic HELP {ffffff}� ���� ������� ������� ������.", -1)
      cfg = inicfg.load(nil, 'medicHELP/config.ini')
    end
  end
  if not doesDirectoryExist('moonloader/lib/imcustom') then createDirectory('moonloader/lib/imcustom') end
  for k, v in pairs(libs) do
        if not doesFileExist('moonloader/lib/'..v) then
            downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/lib/'..v, getWorkingDirectory()..'\\lib\\'..v)
            print('����������� ���������� '..v)
        end
    end
	if not doesFileExist("moonloader/config/medicHELP/keys.json") then
        local fa = io.open("moonloader/config/medicHELP/keys.json", "w")
        fa:close()
    else
        local fa = io.open("moonloader/config/medicHELP/keys.json", 'r')
        if fa then
            config_keys = decodeJson(fa:read('*a'))
        end
    end
  while not doesFileExist('moonloader\\lib\\rkeys.lua') or not doesFileExist('moonloader\\lib\\imcustom\\hotkey.lua') or not doesFileExist('moonloader\\lib\\imgui.lua') or not doesFileExist('moonloader\\lib\\MoonImGui.dll') or not doesFileExist('moonloader\\lib\\imgui_addons.lua') do wait(0) end
  if not doesDirectoryExist('moonloader/medicHELP') then createDirectory('moonloader/medicHELP') end
  hk = require 'lib.imcustom.hotkey'
  imgui.HotKey = require('imgui_addons').HotKey
  rkeys = require 'rkeys'
  imgui.ToggleButton = require('imgui_addons').ToggleButton
  while not sampIsLocalPlayerSpawned() do wait(0) end
  local _, myid = sampGetPlayerIdByCharHandle(playerPed)
  local name, surname = string.match(sampGetPlayerNickname(myid), '(.+)_(.+)')
  sip, sport = sampGetCurrentServerAddress()
  sampSendChat('/stats')
  while not sampIsDialogActive() do wait(0) end
  proverkk = sampGetDialogText()
  local frakc = proverkk:match('.+�����������%:%s+(.+)%s+����')
  local rang = proverkk:match('.+����%:%s+(.+)%s+������')
  local telephone = proverkk:match('.+�������%:%s+(.+)%s+�����������������')
  rank = rang
  frac = frakc
  tel = telephone
  sampCloseCurrentDialogWithButton(1)
  print(frakc)
  print(rang)
  print(telephone)
  ystf()
  update()
  local spawned = sampIsLocalPlayerSpawned()
  for k, v in pairs(tBindList) do
		rkeys.registerHotKey(v.v, true, onHotKey)
  end
  fastsmskey = rkeys.registerHotKey(config_keys.fastsms.v, true, fastsmsk)
  sampRegisterChatCommand('r', r)
  sampRegisterChatCommand('f', f)
  sampRegisterChatCommand('dlog', dlog)
  sampRegisterChatCommand('dcol', cmd_color)
  sampRegisterChatCommand('dmb', dmb)
  sampRegisterChatCommand('smsjob', smsjob)
  sampRegisterChatCommand('where', where)
  sampRegisterChatCommand('moh', moh)
  sampRegisterChatCommand('mh', pkmmen)
  sampRegisterChatCommand('vig', vig)
  sampRegisterChatCommand('giverank', giverank)
  sampRegisterChatCommand('blag', blag)
  sampRegisterChatCommand('invite', invite)
  sampRegisterChatCommand('uninvite', uninvite)
  sampRegisterChatCommand('cchat', cmd_cchat)
  sampRegisterChatCommand('cnick', nick)
    sampRegisterChatCommand('sethud', function()
        if cfg.main.givra then
            if not changetextpos then
                changetextpos = true
                ftext('�� ���������� ������� ������� ��� ���.')
            else
                changetextpos = false
				inicfg.save(cfg, 'medicHELP/config.ini') -- ��������� ��� ����� �������� � �������
				ftext('�� ������� �������� �������������� HUD-����.')
            end
        else
            ftext('��� ������ �������� ����-���.')
        end
    end)
  sampRegisterChatCommand('yst', function() ystwindow.v = not ystwindow.v end)
  while true do wait(0)
  datetime = os.date("!*t",os.time()) 
if datetime.min == 00 and datetime.sec == 10 then 
sampAddChatMessage("{BF6868}�� ������ �������� {BF6868}TimeCard {F80505}�� ������.", -1) 
sampAddChatMessage("{BF6868}�� ����� ������� ��� {0CF513}��������� {BF6868}� ��������� ������!", -1)
sampAddChatMessage("{BF6868}� ��� �� ������� ��� {0CF513}������ ����.", -1)
sampAddChatMessage("{BF6868}��� ������� ���� - {0CF513}��� ���������!", -1)
wait(1000)
wait(1000)
end
    if #departament > 25 then table.remove(departament, 1) end
    if cfg == nil then
      sampAddChatMessage("{E66E6E}Medic HELP {ffffff}� ���������� ���� �������, �������.", -1)
      if inicfg.save(medicHELP, 'medicHELP/config.ini') then
        sampAddChatMessage("{E66E6E}Medic HELP {ffffff}� ���� ������� ������� ������.", -1)
        cfg = inicfg.load(nil, 'medicHELP/config.ini')
      end
    end
	    local myhp = getCharHealth(PLAYER_PED)
        local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
    if wasKeyPressed(cfg.keys.fastmenu) and not sampIsDialogActive() and not sampIsChatInputActive() then
	if frac == 'Hospital' then
    submenus_show(fastmenu(id), "{E66E6E}Medic HELP {ffffff}� ������� ����")
	else
	ftext('�������� �� �� �������� � MOH {ff0000}[ctrl+R]')
	end
    end
          if valid and doesCharExist(ped) then
            local result, id = sampGetPlayerIdByCharHandle(ped)
            if result and wasKeyPressed(key.VK_Z) then
			if frac == 'Hospital' then
                gmegafhandle = ped
                gmegafid = id
                gmegaflvl = sampGetPlayerScore(id)
                gmegaffrak = getFraktionBySkin(id)
			    local color = ("%06X"):format(bit.band(sampGetPlayerColor(id), 0xFFFFFF))
                --[[ftext(gmegafid)
                ftext(gmegaflvl)
                ftext(gmegaffrak)]]
				megaftimer = os.time() + 300
                submenus_show(pkmmenu(id), "{E66E6E}Medic HELP {ffffff}� {"..color.."}"..sampGetPlayerNickname(id).."["..id.."] {ffffff}������� - "..sampGetPlayerScore(id).." ")
				else
			ftext('�������� �� �� �������� � MOH {ff0000}[ctrl+R]')
				end
            end
        end
	if cfg.main.givra == true then
      infbar.v = true
      imgui.ShowCursor = false
    end
    if cfg.main.givra == false then
      infbar.v = false
      imgui.ShowCursor = false
    end
		if changetextpos then
            sampToggleCursor(true)
            local CPX, CPY = getCursorPos()
            cfg.main.posX = CPX
            cfg.main.posY = CPY
        end
		imgui.Process = second_window.v or third_window.v or bMainWindow.v or ystwindow.v or updwindows.v or infbar.v or memw.v
  end
  function rkeys.onHotKey(id, keys)
	if sampIsChatInputActive() or sampIsDialogActive() or isSampfuncsConsoleActive() then
		return false
	end
end
end

local fpt = [[

������ 1. ����� ���������

1.1 ����� ������������ ����� ���� ������, ������� ���������� � ���������� ����� ������������ �����������.
1.2 ���� �������� ������, ������������� � ������, ��������� ������ �� ������������� �������� �� ������������.
1.3 ������� ����� ������� ������� ������ ���������� �� ����������� ����������� �������.
1.4 ������ ����� �� ������� ������� �����, � ��� ����� ����������� � ���������� �������.
1.5 ������������ � ���� ����.����� ����� �������� ������ � ����������� �����, �� ������� ��� �����������. ��� ��������� � ������ � ���������� ����� ������ ���� �������� ����������� ����������� ��� ������������.
1.6 ��������� ������� ������ �������� �� ���� ��������� ��� ����������� �� ��������� ���������� �����������.
1.7 ������������ � ���� ����.����� ����� �� ����� �������� ������������� �������� ������, ��� ��� �������� ����� �����������.

������ 2. ����������� �����������

2.1 ��� ������ ����������� ��������� �������� �� ������ �����������, �������� �� ��� ���������� ������, ������� �������, ��������������.
2.2 ������ ��������� ������ ����� ���� ����������� � ��������� �� ����������.
2.3 ���������� ������� ����� ������ �����, ���� ��������������� �����, ��������� ������, ���������������� ������.
2.4 ������ ��������� ������ �������������� ����������� �������� ��������� � ������ ������, � �������� �������.
2.5 ��� ���������� ������� ������� �� ���������� ����������, ������� ����������, � ����� �� ���������� ����.
2.6 ��� ������ �� ������� ����������� ���������������, � ����� ���������� ��������� � ������ �� �����.
2.7 ����������� �� ����������:
- ������: �� ������ ��������� ��������� ������ ��������� �������� � �������� ���������. ��� ������� ����� � � ���������� �������� ��������� ����������� ������ ������������ ����.
- �������: �� ������ ��������� ���������, ��� ��������� ��� ������, ����� ����������� �� ��������� ���� ��� �������� �� �� ���.������ �����������, � ����� ���������� � ������� ������ �� �������. �������� �� ����� ��������� ������ ����� ��������� ������ � �������� �� ���.
- ���.����: ���������, ������� ������ ���������, ����� ��������� ������� ��� ������������� ������, ��� � ����� ����� � ��������������� ��������. ����� ������ ���������� �������� ��������� � �������� � �������� � �����������.
- ���������: ��� ��������� ������ ��������� ���������� ����� �������� �� ����������� �� � �����. ����� ����� ���������� �� ������������ ����� �� �������, ���� �������� ����� ������ ������� ������������.
- ��������: � ������ ���������� ���������� ���������������, ��� ��� ��������� �������� � ����������, ������� ������� � ������������. ������� � ����� ������ ������������ �������� ���� ������� � ������������ � ���������������� ������. ����� ��������� �������� �� ��������� �������, ������� �����������, �� ��������� ����� ������������.
- ������: ��������� ������������ � �������� ���������. � ����������� ������ ���������� ���� ��������������, � ����� ������ � ������� ���������� � ������ �������� ��������� � ���������� ��� ��� ���� �����������.
- ��������: ������ ������� �������� ���������. �������� �� ���������� � ����������, ��������� ����������� �� ����.����������� ��� ����������� ����������� �� ��������� ��������, ��������� ���������.
- ������: ���������� ��������� ������ �� ����������, � ����� ����� ���������� ��������� ������� � ��������� ������ �� ����������, �������� ����������� ����.����� � ����.����� ��� ������ ������� �����������.
- ����������� ����.�����: ������ ���� ������������. ��������� ��������� ����������� ������������ � ��� ����������, ������������ ������ ����������� � �������. ���������� ��������� ���������.

������ 3. ������� ������

3.1 ������� ������ ���������� ������ ��������. ����������� ���������� �������� ��� ��� ������ ������ �� ����� ��������������� �������, ��������� � ������� 
3.2 ������� ���� � ������ ��� ���������� � 9 ���� � ������������ �� 8 ������, � �������� - � 10 ���� �� 7 ������.
3.3 ����� ��������� �� ��������� �������� ��� ����� ����� ���������� ���� ������.
3.4 ���� �������� �� ��������� �������� ��� ������� � �����, �� ������ ���������� ������. � ������, ���� �� �����, ������ ����� ����� � ����� ���������� ������ ������.
3.5 ������ ��������� ����� ����� �� ��������� ������� c 12:00 �� 13:00.
3.6 ��������� ����� ������������� �� ������ �� ����� 15 �����. ����������: ��������� �� ���������� � ������� ����������� ������� �� �������� ���������.
3.7 �� ����� �� ������� �������� ����� ����� ������� �� ������ �����������, ������� �� ������ �������� � ����.
3.8 ����� �������� ������������� � ������������� � �� ����� 20 ����� � ��� � ��������������� ����������� � �����.

������ 4. �������/������������� �����

4.1 ��� ���������� ������� ���������� � ��������� � ����� �������� ������ �� ��. ���������� � ��� ������, ���� ���������� �� ������ ����� ���������.
4.2 ��� ��������� � �������� �� ������������ ����� �������. ��������� ��� ������ �� ������� � ���������� ���������. ������: �������� �������.
4.3 ���������� ������, ������� ���, ������� �������, ���� � ������ ������� �� ������ ������ �� �������� � ���������. ����� ����������� ��� �����.
4.4 ��� ����������� �� ������ ���������� ������ ���������� ����� � �����.
4.5 �� ����� ����� ��������� ���������� ������ ������ ���������� �� ������ � ������ �����.
4.6 ����� ������������ �������� ����������� � ��������� ���.����.
4.7 ��� ������������� ����� ������������ ���������� ��������� ����� �������.
4.8 �� ����� ����� ���������: �������, ���������� ����-��, ������������ ����������� �������.


������ 5. ���������

5.1 ���� ������������ ���� ��������� �������������� ����� ������������ � ������ �� ����������.
5.2 ������ ���������, ������������ ���������, �������� �� ��� ����������� � �����������������, � ����� �� ��������� ����.
5.3 ���������� ����� Stratum ��������� ������������ � ��������� ���.����.
5.4 ��������� ��������� Maverick ��������� ������������ ����������� � ��������� ��������, �� ��� ������� ���������� �������� ��������� � �������� �� ������.
5.5 ����.������� �� ������ ������ ������ ��������� ������������ ������ � ������ ������ ��� �������������� ��������.
5.6 �������� ��� ����������� ������ � ��� ������, ���� ��������� ���� �� ����� � ���������� ����.��������.
5.7 ��������� ��������� ��������� ���������� � ���������� ���������� ��� ����� ������.

������ 6. ��������/��������

6.1 ��� ���������� ������� ���������� ������� ������ ����������� ��������.
6.2 �������� �������� ������ �� ��������� ����������.
6.3 �������� ��������������� ��� ��� ������, ��� � ��� ������. 
6.4 ������ ��������� ������ ������ �����, ������������� � �����.
� ������� �� ���.�����, ��������� ������ ������ ������� - 13.
� ���.����� �� ���������, ��������� ������ ������ ������� - 31.
� ��������� �� �������, ��������� ������ ������ ������� - 19.
� ��������� ��������, ���������� ������� ������ ������� - 8
6.5 �������� ����� ����������� � ����������� �� ��������� � ���������� ������.

������ 7. ������/�������

7.1 ������ ��������������� �����������, ������� ��������� � ��������� ���������� ����� � ����� ���������.
7.2 ����������, ��������� ��������� ��������� � ����, ����� �������� ��������� �� ������ � ��������������� �������.
7.3 ������ ��������������� ������ �� 7 ����������� ����.
7.4 � ������� ��������� ����� ����� �������� �� ��������������� �������, � ���, �������.
7.5 ����������, ��������� ��������� ��������� � ����, ����� �������� ��������� �� ������� � ��������������� �������.

������ 8. �����������

8.1 ��������� ������� ������ � ����� �����.
8.2 ��������� ������������ �������� �����������, ������� ����� ���������� � �������� 24-7.
8.3 ��������� �������� ��������� ��������� ������ � ����� �����������.
8.4 ������������ �������� ����������� ��������� ����������� � ��������� ���.����.
8.5 ��������� ��������� �������� ��������� ������ ���������� � ������������� �������.


������ 9. ����������

9.1 ����������� ����������.

1. ����� �����.
Classic Hat

2. ����� �������.
Black Mafiosi Hat
Light Mafiosi Hat
Turquoise Mafiosi Hat
Cherry Mafiosi Hat
Yellow Mafiosi Hat
Green Mafiosi Hat

3.����� ������
Dark Hat
Brown Hat
Black sheriff's Hat
Red sheriff's Hat
Brown sheriff's Hat

4. ����� �������.
Cross Cylinder Hat
Crozny Cylinder Hat

5. ���������� ����� / �������.
����������: ����������� �������� � ���������� ������ ����. 

6. ������.
Red Beret
Dark Beret
Blue Beret
Color Beret

7. ���������� �����.
Cowboy Hat

8. �����.
White Cap
Red Cap
Yellow Cap
Lemon Cap

9.�������.
Blue Backpack

10. ����.
����������: ��������� ������ ����: Hypnosis Classes, Simple eyes Classes, Simple race Classes, X-Ray Classes

11. ����.
��������� ���� ������ �������. 

12. �������
Suitcase

�������: ���������� ������� �� ����� � ������, ������ ���������!
�� ��������� ����� ������, ����� ���������� �������. 


������ 10. ������� �� ���������

9.1 �������� - ��� ��������������, ���������� ����������� �� �� ����� ��������� ���������, �� ������� ������� ����� �������� � ���������� ( ��������� ��� ).
9.1.1 ���������, �� ������� ��������� ����� �������� �������:
1. ���������� �� ������ ����� 15 �����
2. ����� � �������� ���.������ ���������� �� ������ ���������.
3. �������� ������������� �������. ����������: ����� ������ �������� ������������ ����� ������� ����������� �������.
4. ��� � ������������ �����.
5. ������������ �������� ��������� (�������� � ���� / ����� ������)
6. ��������� ������ �������� � ����������.
7. ������������� ���������� ����������� � ������ �����.
8. ������������� ����.�������� � ����� ��������� ���.
9. ������������� �������� � ������ �� �� ���������.
10. ������������� ������� �������� ���������.
11. ����������� ���������� �������� ���.
12. ������� �� ���������� � ����� ���������� ����������� (�������, ��������, ���������� ����, �����, �����, ����, ����� ������, ��������� �����, ����� �����������, �������)
9.2 ��������� � ��������� - ������� �� ���������, ����������� ��� ��������� �� ����� ��������� ��������� � ��������� ������� �������.
9.2.1 ���������, �� ������� ��������� ����� �������� ��������� � ���������:
1. ��������� 2-� �������� ��������� � ������� 7 ����������� ����.
2. ���������� �� ������ ����� 30 ����� (������� ������ 9.1.2/1)
3. ����� � �������� ���.������ ���������� �� ������ ��������� (������� ������ 9.1.2/2)
9.3 ���������� - ������� �� ���������, ����������� ��� ��������� ���������� ������, ������� �����.
9.3.1 ���������, �� ������� ��������� ����� �������� ����������:
1. ��������� 3-� �������� ��������� � ������� 7 ����������� ����.
2. ���������� �� ������� ����� � ������� 1 ����.
3. ����� �� ������ �� ������.
4. ������������� ����������� �������.
5. �����������.
6. ���������� ��� � ������������ ����� (������� ������ 9.1.2/4)
7. ������������ �������� ��������� (������� 9.1.2/5)
8. ��������� ��������� �� ����� ��������� ��� ������������.
9. ������� ������ ���� �� ����� ��������� ��� ������������. ����������: ������� ����� ���������/���������.
10. ������������� �������� � ������ �� �� ��������� (������� ������ 9.1.2/9)
11. ����� �� ����� �����, ������� �� � ������������ � ����������.
12. ������������� ������� �������� �������� (������� ������ 9.1.2/10)
13. ������� ������ � �������� ����.
14. ������������� ��������� ���������� �� �� ����������.
9.4 �������� � ׸���� ������ - ����� ������� ���� ���������.
9.4.1 ���������, �� ������� ��������� �������� � ׸���� ������:
1. ������ �����������.
2. �������� � ����������� ����������.
3. �������� ����������� �������� ����� ������������.
4. �������� �����������.
5. ���������� � ������ ���� ���������������.
]]

function dmb()
	lua_thread.create(function()
		status = true
		players2 = {'{ffffff}���� ��������\t{ffffff}���\t{ffffff}����\t{ffffff}������'}
		players1 = {'{ffffff}���\t{ffffff}����'}
		sampSendChat('/members')
		while not gotovo do wait(0) end
		if gosmb then
			sampShowDialog(716, "{ffffff}� ����: "..gcount.." | {ae433d}����������� | {ffffff}Time: "..os.date("%H:%M:%S"), table.concat(players2, "\n"), "x", _, 5) -- ���������� ����������.
		elseif krimemb then
			sampShowDialog(716, "{ffffff}� ����: "..gcount.." | {ae433d}����������� | {ffffff}Time: "..os.date("%H:%M:%S"), table.concat(players1, "\n"), "x", _, 5) -- ���������� ����������.
		end
		gosmb = false
		krimemb = false
		gotovo = false
		status = false
		gcount = nil
	end)
end

function vig(pam)
  local id, pric = string.match(pam, '(%d+)%s+(.+)')
if rank == '��������' or rank == '������' or rank == '���.����.�����' or rank == '����.����' then
  if id == nil then
    sampAddChatMessage("{E66E6E}Medic HELP {ffffff}� �������: /vig [id] [�������]", -1)
  end
  if id ~=nil and not sampIsPlayerConnected(id) then
    sampAddChatMessage("{E66E6E}Medic HELP {ffffff}� ����� � ID: "..id.." �� ��������� � �������.", -1)
  end
  if id ~= nil and sampIsPlayerConnected(id) then
      if pric == nil then
        sampAddChatMessage("{E66E6E}Medic HELP {ffffff}� /vig [id] [�������]", -1)
      end
      if pric ~= nil then
	   if cfg.main.tarb then
        name = sampGetPlayerNickname(id)
        rpname = name:gsub('_', ' ')
        sampSendChat(string.format("/r [%s]: %s - �������� ������� �� �������: %s.", cfg.main.tarr, rpname, pric))
		else 
		name = sampGetPlayerNickname(id)
        rpname = name:gsub('_', ' ')
		sampSendChat(string.format("/r %s - �������� ������� �� �������: %s.", rpname, pric))
      end
  end
end
end
end

function where(params) -- ������ ��������������
   if rank == '��������' or rank == '������' or rank == '���.����.�����' or rank == '����.����' then
	if params:match("^%d+") then
		params = tonumber(params:match("^(%d+)"))
		if sampIsPlayerConnected(params) then
			local name = string.gsub(sampGetPlayerNickname(params), "_", " ")
			 if cfg.main.tarb then
			    sampSendChat(string.format("/r [%s]: %s, �������� ���� ��������������. �� ����� 20 ������.", cfg.main.tarr, name))
			else
			sampSendChat(string.format("/r %s, �������� ���� ��������������. �� ����� 20 ������.", name))
			end
			else
			ftext('{FFFFFF} ����� � ������ ID �� ��������� � ������� ��� ������ ��� ID.', 0x046D63)
		end
		else
		ftext('{FFFFFF} �����������: /where [ID].', 0x046D63)
		end
		else
		ftext('{FFFFFF}������ ������� �������� � 7 �����.', 0x046D63)
	end
end

        
function blag(pam)
    local id, frack, pric = pam:match('(%d+) (%a+) (.+)')
    if id and frack and pric and sampIsPlayerConnected(id) then
        name = sampGetPlayerNickname(id)
        rpname = name:gsub('_', ' ')
        sampSendChat(string.format("/d %s, ��������� %s �� %s. ������!", frack, rpname, pric))
    else
        ftext("�������: /blag [id] [�������] [�������]", -1)
    end
end

function string.split(inputstr, sep, limit)
  if limit == nil then limit = 0 end
  if sep == nil then sep = "%s" end
  local t={} ; i=1
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    if i >= limit and limit > 0 then
      if t[i] == nil then
        t[i] = ""..str
      else
        t[i] = t[i]..sep..str
      end
    else
      t[i] = str
      i = i + 1
    end
  end
  return t
end

function cmd_cchat()
  memory.fill(sampGetChatInfoPtr() + 306, 0x0, 25200)
  memory.write(sampGetChatInfoPtr() + 306, 25562, 4, 0x0)
  memory.write(sampGetChatInfoPtr() + 0x63DA, 1, 1)
end

function dmch()
	lua_thread.create(function()
		statusc = true
		players3 = {'{ffffff}���\t{ffffff}����\t{ffffff}������'}
		sampSendChat('/members')
		while not gotovo do wait(0) end
		if gosmb then
			sampShowDialog(716, "{E66E6E}Medic HELP {ffffff}� {ae433d}���������� ��� ����� {ffffff}| Time: "..os.date("%H:%M:%S"), table.concat(players3, "\n"), "x", _, 5) -- ���������� ����������.
		end
		gosmb = false
		krimemb = false
		gotovo = false
		statusc = false
	end)
end

function dlog()
    sampShowDialog(97987, '{E66E6E}Medic HELP {ffffff} | ��� ��������� ������������', table.concat(departament, '\n'), '�', 'x', 0)
end

function getrang(rangg)
local ranks = 
        {
		['1'] = '������',
		['2'] = '�������',
		['3'] = '���.����',
		['4'] = '���������',
		['5'] = '��������',
		['6'] = '������',
		['7'] = '��������',
		['8'] = '������',
		['9'] = '���.����.�����',
		['10'] = '����.����'
		}
	return ranks[rangg]
end



function giverank(pam)
    lua_thread.create(function()
    local id, rangg, plus = pam:match('(%d+) (%d+)%s+(.+)')
	if sampIsPlayerConnected(id) then
	  if rank == '��������' or rank == '������' or rank == '���.����.�����' or rank == '����.����' then
        if id and rangg then
		if plus == '-' or plus == '+' then
		ranks = getrang(rangg)
		        local _, handle = sampGetCharHandleBySampPlayerId(id)
				if doesCharExist(handle) then
				local x, y, z = getCharCoordinates(handle)
				local mx, my, mz = getCharCoordinates(PLAYER_PED)
				local dist = getDistanceBetweenCoords3d(mx, my, mz, x, y, z)	
				if dist <= 5 then
				sampSendChat('/me ���� ������ ������� � �������� �������� ��������')
				wait(1500)
				sampSendChat('/me ����� ������ ������� � ������')
				wait(1500)
                sampSendChat(string.format('/me %s ����� ������� %s', cfg.main.male and '������' or '�������', ranks))
				wait(1500)
				sampSendChat('/me �������� �� ������� �������� �������� ����� �������')
				wait(1500)
				else
				sampSendChat('/me ����� ������ ������� � �������� �������� ��������')
				wait(1500)
				sampSendChat('/me ������ ������ ������� � ������')
				wait(1500)
                sampSendChat(string.format('/me %s ����� ������� %s', cfg.main.male and '������' or '�������', ranks))
				wait(1500)
				sampSendChat('/me ��������� �� ������� �������� �������� ����� �������')
				wait(1500)
				end
				end
				sampSendChat(string.format('/giverank %s %s', id, rangg))
				wait(1500)
				if cfg.main.tarb then
                sampSendChat(string.format('/r [%s]: '..sampGetPlayerNickname(id):gsub('_', ' ')..' - %s � ��������� �� %s%s.', cfg.main.tarr, plus == '+' and '�������(�)' or '�������(�)', ranks, plus == '+' and ', ����������' or ''))
                else
				sampSendChat(string.format('/r '..sampGetPlayerNickname(id):gsub('_', ' ')..' - %s � ��������� �� %s%s.', plus == '+' and '�������(�)' or '�������(�)', ranks, plus == '+' and ', ����������' or ''))
            end
			else 
			ftext('�� ����� �������� ��� [+/-]')
		end
		else 
			ftext('�������: /giverank [id] [����] [+/-]')
		end
		else 
			ftext('������ ������� �������� � 7 �����')
	  end
	  else 
			ftext('����� � ������ ID �� ��������� � ������� ��� ������ ��� ID')
	  end
   end)
 end
   
function nick(args)
  if #args == 0 then ftext("�������: /cnick [id] [0 - RP nick, 1 - NonRP nick]") return end
  args = string.split(args, " ")
  if #args == 1 then
    cmd_nick(args[1].." 0")
  elseif #args == 2 then
    local getID = tonumber(args[1])
    if getID == nil then ftext("�������� ID ������!") return end
    if not sampIsPlayerConnected(getID) then ftext("����� �������!") return end 
    getID = sampGetPlayerNickname(getID)
    if tonumber(args[2]) == 1 then
      ftext("��� \""..getID.."\" ������� ���������� � ����� ������.")
    else
      getID = string.gsub(getID, "_", " ")
      ftext("�� ��� \""..getID.."\" ������� ���������� � ����� ������.")
    end
    setClipboardText(getID)
  else
    ftext("�������: /cnick [id] [0 - RP nick, 1 - NonRP nick]")
    return
  end 
end

function fastmenu(id)
 return
{
  {
   title = "{FFFFFF}���� {E66E6E}������",
    onclick = function()
	submenus_show(fthmenu(id), "{E66E6E}Medic HELP {ffffff}� ���� ������")
	end
   },
    {
   title = "{FFFFFF}���� {E66E6E}����.����� {11C420}(/gov)",
    onclick = function()
	if rank == '��������' or rank == '�������' or rank == '���.����.�����' or rank == '����.����' then
	submenus_show(govmenu(id), "{E66E6E}Medic HELP {ffffff}� ���� ������ (/gov)")
	else
	ftext('������ ���� �������� � 9 �����')
	end
	end
   },
    {
   title = "{FFFFFF}���� {E66E6E}����� {11C420}(/gov)",
    onclick = function()
	if rank == '��������' or rank == '��f���' or rank == '���.����.�����' or rank == '����.����' then
	submenus_show(menuaks(id), "{E66E6E}Medic HELP {ffffff}� ���� �����")
	else
	ftext('������ ���� �������� � 9 �����')
	end
	end
   },
   {
   title = "{ffffff}� �� �������� ���������{ff4040}TimeCard{ffffff} �� ������ ������ ���!",
    onclick = function()
	end
   }, 
   {
   title = "{ffffff}� ���� {ff4040}����� �����������",
    onclick = function()
	end
   },
}
end

function lwd(arg)
	kon = tostring(arg)
	sampSendChat(string.format('/d OG, %s ����� ��������������� ��������', cfg.main.male and '�����' or '������'))
	wait(5000)
	sampSendChat(string.format('/me %s ���, ����� ���� %s � ���. ����� ��������', cfg.main.male and '������' or '�������', cfg.main.male and '�����������' or '������������'))
	 wait(5000)
	sampSendChat("/gov [MOH]: ��������� ������ � ����� �����! � ������ � " .. nach .." �� ".. kon)
	wait(5000)
	sampSendChat("/gov [MOH]: � �������� ���-������ �������� ����� ������ ��� ����������!�.")
	wait(5000)
	sampSendChat("/gov [MOH]: ������ �� ���������������� ���������� ���������. ������� �� ��������!")
	wait(5000)
	sampSendChat(string.format('/d OG, %s ����� ��������������� ��������', cfg.main.male and '���������' or '����������'))
	wait(1200)
end
		
function govlwd(arg)
	nach = tostring(arg)
	sampShowDialog(5, "�����", "{ffffff}������� ����� {13E83E}����� {ffffff}���������� �����.\n������ ��:��" , "��", "������", 1)
	while sampIsDialogActive(5) do wait(100) end
	local result, button, _, input = sampHasDialogRespond(5)
	if button == 1 then lwd(input) end
end
function menuaks(id)
 return
{
  {
   title = "{FFFFFF}����� ��� ����������!{CC1515}(�� ������� �������� ������, {11C420}��� ������� ����� ������ � ����� �������� �����.)",
    onclick = function()
			sampShowDialog(5, "�����", "{ffffff}������� ����� {13E83E}������ {ffffff}���������� �����.\n������ ��:��" , "��", "������", 1)
			while sampIsDialogActive(5) do wait(100) end
			local result, button, _, input = sampHasDialogRespond(5)
			if button == 1 then govlwd(input) end
			if cfg.main.hud then
				sampSendChat("/time")
				wait(500)
				setVirtualKeyDown(key.VK_F8, true)
				wait(150)
				setVirtualKeyDown(key.VK_F8, false)
			end
			end
   },
   {
   title = "{FFFFFF}���������� ������ ������(������){CC1515}(���������! {11C420}������� �������� �����)",
    onclick = function()
	sampSendChat(string.format('/d OG, %s ����� ��������������� ��������', cfg.main.male and '�����' or '������'))
    wait(5000)
	 sampSendChat(string.format('/me %s ���, ����� ���� %s � ���. ����� ��������', cfg.main.male and '������' or '�������', cfg.main.male and '�����������' or '������������'))
	 wait(5000)
   sampSendChat("/gov [MOH]: ������� ������ �����! � ����� � ������������� �������������.")
    wait(5000)
    sampSendChat("/gov [MOH]: � �������� ��� ������, ���������� ����������")
    wait(5000)
     sampSendChat("/gov [MOH]: ������ ��� ������� � ��������� ����. �������� - � ����� �����!")
    wait(5000)
     sampSendChat(string.format('/d OG, %s ����� ��������������� ��������', cfg.main.male and '���������' or '����������'))
    wait(1200)
	if cfg.main.hud then
    sampSendChat("/time")
    wait(500)
    setVirtualKeyDown(key.VK_F8, true)
    wait(150)
    setVirtualKeyDown(key.VK_F8, false)
	end
	end
   },
 {
   title = "{FFFFFF}���������� ������ ������(�����){CC1515}(���������! {11C420}������� �������� �����)",
    onclick = function()
	sampSendChat(string.format('/d OG, %s ����� ��������������� ��������', cfg.main.male and '�����' or '������'))
    wait(5000)
	sampSendChat(string.format('/me %s ���, ����� ���� %s � ���. ����� ��������', cfg.main.male and '������' or '�������', cfg.main.male and '�����������' or '������������'))
	 wait(5000)
   sampSendChat("/gov [MOH]: ������� ������ �����! ������� ���� ������ ����������, ��������.")
    wait(5000)
    sampSendChat("/gov [MOH]: ���������� ���, ��� ������ �� ���������� �� ������.")
    wait(5000)
     sampSendChat("/gov [MOH]: �� ����, ��� ���� �������� ��������� � ����� ��������.")
    wait(5000)
     sampSendChat(string.format('/d OG, %s ����� ��������������� ��������', cfg.main.male and '���������' or '����������'))
    wait(1200)
	if cfg.main.hud then
    sampSendChat("/time")
    wait(500)
    setVirtualKeyDown(key.VK_F8, true)
    wait(150)
    setVirtualKeyDown(key.VK_F8, false)
	end
	end
   },
   {
   title = "{FFFFFF}����� ���� ����� �����.(c 12:00 �� 18:00){CC1515}(���������! {11C420}������� �������� �����)",
    onclick = function()
	sampSendChat(string.format('/d OG, %s ����� ��������������� ��������', cfg.main.male and '�����' or '������'))
    wait(5000)
	sampSendChat(string.format('/me %s ���, ����� ���� %s � ���. ����� ��������', cfg.main.male and '������' or '�������', cfg.main.male and '�����������' or '������������'))
	 wait(5000)
   sampSendChat("/gov [MOH]: ��������� ������ � ����� ������ �����, ��������� ��������.")
    wait(5000)
    sampSendChat("/gov [MOH]: ������� � 12:00 �� 18:00, �������� ����� ������ ��� ����� ������")
    wait(5000)
     sampSendChat("/gov [MOH]: ��� ����� �����, �� ��������� �������� �������������� � ����������� ����� �������!")
    wait(5000)
	 sampSendChat("/gov [MOH]: ���� �������� ���� � �������� ��� ������. ������� �� ��������!")
    wait(5000)
     sampSendChat(string.format('/d OG, %s ����� ��������������� ��������', cfg.main.male and '���������' or '����������'))
    wait(1200)
	if cfg.main.hud then
    sampSendChat("/time")
    wait(500)
    setVirtualKeyDown(key.VK_F8, true)
    wait(150)
    setVirtualKeyDown(key.VK_F8, false)
	end
	end
   },
   {
   title = "{FFFFFF}����� ���� ����� �����.(�����) {CC1515}(���������! {11C420}������� �������� �����)",
    onclick = function()
	sampSendChat("  OG, ����� ����� ��������������� ��������.")
    wait(5000)
	sampSendChat(string.format('/me %s ���, ����� ���� %s � ���. ����� ��������', cfg.main.male and '������' or '�������', cfg.main.male and '�����������' or '������������'))
	 wait(5000)
   sampSendChat("/gov [MOH]: ��������� ������ � ����� ������ �����, ��������� ��������.")
    wait(5000)
    sampSendChat("/gov [MOH]: ����� ������ ��� ����� ������ - �����������")
    wait(5000)
     sampSendChat("/gov [MOH]: ����� ����� 2.3 � ����� � ������ 94 ���.����")
    wait(5000)
	 sampSendChat("/gov [MOH]: � ���������, ������������ ���������������.")
    wait(5000)
     sampSendChat(string.format('/d OG, %s ����� ��������������� ��������', cfg.main.male and '���������' or '����������'))
    wait(1200)
	if cfg.main.hud then
    sampSendChat("/time")
    wait(500)
    setVirtualKeyDown(key.VK_F8, true)
    wait(150)
    setVirtualKeyDown(key.VK_F8, false)
	end
	end
   },
}
end
	
function gove(arg)
	inputgov = tostring(arg)
	sampSendChat(string.format('/d OG, %s ����� ��������������� ��������', cfg.main.male and '�����' or '������'))
	wait(5000)
	sampSendChat(string.format('/me %s ���, ����� ���� %s � ���. ����� ��������', cfg.main.male and '������' or '�������', cfg.main.male and '�����������' or '������������'))
	wait(5000)
	sampSendChat("/gov [MOH]: ��������� ������ � ����� ������ �����, ��������� ��������.")
	wait(5000)
	sampSendChat("/gov [MOH]: �������, ��� � " .. inputgov .. " ������ ������������� � ������������ ��������������� �� ��������� �������.")
	wait(5000)
	sampSendChat("/gov [MOH]: ����������: ��������� �� 3-� ��� � ����� � ������� ������� � ���.�����������.")
	wait(5000)
	sampSendChat('/gov [MOH]: ����� ����������: ���� �������� ���-������')
	wait(5000)
	sampSendChat(string.format('/d OG, %s ����� ��������������� ��������', cfg.main.male and '���������' or '����������'))
	wait(1200)
end

	
function govmenu(id)
 return
{
  {
   title = "{FFFFFF}������������� � ����������� {CC1515}(�� ������� �������� ������, {11C420}��� ������� ����� ������ ������.)",
    onclick = 
			function()
			sampShowDialog(4, "�����", "������� ����� ���������� �������������.\n������ ��:��" , "��", "������", 1)
			while sampIsDialogActive(4) do wait(100) end
			local result, button, _, input = sampHasDialogRespond(4)
			if button == 1 then gove(input) end
			if cfg.main.hud then
				sampSendChat("/time")
				wait(500)
				setVirtualKeyDown(key.VK_F8, true)
				wait(150)
				setVirtualKeyDown(key.VK_F8, false)
			end
			end
   },
  {
   title = "{FFFFFF}������������ ������������� {CC1515}(���������! {11C420}������� �������� �����)",
    onclick = function()
	sampSendChat(string.format('/d OG, %s ����� ��������������� ��������', cfg.main.male and '�����' or '������'))
        wait(5000)
		sampSendChat(string.format('/me %s ���, ����� ���� %s � ���. ����� ��������', cfg.main.male and '������' or '�������', cfg.main.male and '�����������' or '������������'))
	    wait(5000)
        sampSendChat("/gov [MOH]: ��������� ������ � ����� ������ �����, ��������� ��������.")
        wait(5000)
        sampSendChat('/gov [MOH]: �������, ��� ������������� � ������������ ��������������� �� ��������� ������� ������������.')
        wait(5000)
        sampSendChat("/gov [MOH]: ����������: ��������� �� 3-� ��� � ����� � ������� ������� � ���.�����������.")
        wait(5000)
		sampSendChat("/gov [MOH]: ����� ����������: ���� �������� ���-������.")
        wait(5000)
        sampSendChat(string.format('/d OG, %s ����� ��������������� ��������', cfg.main.male and '���������' or '����������'))
        wait(1200)
		if cfg.main.hud then
        sampSendChat("/time")
        wait(500)
        setVirtualKeyDown(key.VK_F8, true)
        wait(150)
        setVirtualKeyDown(key.VK_F8, false)
		end
	end
   },
   {
   title = "{FFFFFF}����� ������������� {CC1515}(���������! {11C420}������� �������� �����)",
    onclick = function()
	local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	local myname = sampGetPlayerNickname(myid)
	sampSendChat(string.format('/d OG, %s ����� ��������������� ��������', cfg.main.male and '�����' or '������'))
        wait(5000)
		sampSendChat(string.format('/me %s ���, ����� ���� %s � ���. ����� ��������', cfg.main.male and '������' or '�������', cfg.main.male and '�����������' or '������������'))
	    wait(5000)
        sampSendChat("/gov [MOH]: ��������� ������ � ����� ������ �����, ��������� ��������.")
        wait(5000)
        sampSendChat('/gov [MOH]: �������, ��� ������������� � ������������ ��������������� �� ��������� ������� ��������.')
        wait(5000)
        sampSendChat('/gov [MOH]: � ���������, '..rank..' ������������ ��������������� - '..myname:gsub('_', ' ')..'.')
        wait(5000)
        sampSendChat(string.format('/d OG, %s ����� ��������������� ��������', cfg.main.male and '���������' or '����������'))
        wait(1200)
		if cfg.main.hud then
        sampSendChat("/time")
        wait(500)
        setVirtualKeyDown(key.VK_F8, true)
        wait(150)
        setVirtualKeyDown(key.VK_F8, false)
		end
	end
   },
   {
   title = "{FFFFFF}���� ������ ���.����� {CC1515}(���������! {11C420}������� �������� �����)",
    onclick = function()
	local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	local myname = sampGetPlayerNickname(myid)
	sampSendChat(string.format('/d OG, %s ����� ��������������� ��������', cfg.main.male and '�����' or '������'))
        wait(5000)
        sampSendChat(string.format('/me %s ���, ����� ���� %s � ���. ����� ��������', cfg.main.male and '������' or '�������', cfg.main.male and '�����������' or '������������'))
	    wait(5000)
		sampSendChat("/gov [MOH]: ��������� ������ � ����� ������ �����, ��������� ��������.")
        wait(5000)
        sampSendChat('/gov [MOH]: �������, ��� �� ��.������� ������������ ��������������� ������� ������ �� ��������� ���.�����.')
        wait(5000)
        sampSendChat("/gov [MOH]: ����������: ��������� �� 4-�� ��� � ����� � ������� ������� � ���.�����������.")
        wait(5000)
		sampSendChat('/gov [MOH]: � ���������, '..rank..' ������������ ��������������� - '..myname:gsub('_', ' ')..'.')
        wait(5000)
        sampSendChat(string.format('/d OG, %s ����� ��������������� ��������', cfg.main.male and '���������' or '����������'))
        wait(1200)
		if cfg.main.hud then
        sampSendChat("/time")
        wait(500)
        setVirtualKeyDown(key.VK_F8, true)
        wait(150)
        setVirtualKeyDown(key.VK_F8, false)
		end
	end
   },
  {
   title = "{FFFFFF}���� ������ �������� {CC1515}(���������! {11C420}������� �������� �����)",
    onclick = function()
	local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	local myname = sampGetPlayerNickname(myid)
	    sampSendChat(string.format('/d OG, %s ����� ��������������� ��������', cfg.main.male and '�����' or '������'))
        wait(5000)
		sampSendChat(string.format('/me %s ���, ����� ���� %s � ���. ����� ��������', cfg.main.male and '������' or '�������', cfg.main.male and '�����������' or '������������'))
	    wait(5000)
        sampSendChat("/gov [MOH]: ��������� ������ � ����� ������ �����, ��������� ��������.")
        wait(5000)
        sampSendChat('/gov [MOH]: �������, ��� �� ��.������� ������������ ��������������� ������� ������ �� ��������� ���������.')
        wait(5000)
        sampSendChat("/gov [MOH]: ����������: ��������� �� 6-�� ��� � ����� � ������� ������� � ���.�����������.")
        wait(5000)
		sampSendChat('/gov [MOH]: � ���������, '..rank..' ������������ ��������������� - '..myname:gsub('_', ' ')..'.')
        wait(5000)
        sampSendChat(string.format('OG, %s ����� ��������������� ��������', cfg.main.male and '���������' or '����������'))
        wait(1200)
		if cfg.main.hud then
        sampSendChat("/time")
        wait(500)
        setVirtualKeyDown(key.VK_F8, true)
        wait(150)
        setVirtualKeyDown(key.VK_F8, false)
		end
	end
   },   
   {
   title = "{FFFFFF}��������� � ����� ���. ����� {CC1515}(�� ������� �������� ������,{11C420}��� ������ �����)",
    onclick = function()
	sampSetChatInputEnabled(true)
	sampSetChatInputText("/d OG, ���������, ��� ����� ���.�������� �� X - �� MOH.")
	end
   },
}
end

function fastsmsk()
	if lastnumber ~= nil then
		sampSetChatInputEnabled(true)
		sampSetChatInputText("/t "..lastnumber.." ")
	else
		ftext("�� ����� �� �������� �������� ���������.", 0x046D63)
	end
end

function fthmenu(id)
 return
{
  {
    title = "{bf6868}������ ��� �����������{13E83E} ��������.",
    onclick = function()
        sampSendChat("����� ���������� � ������������ ���������������.")
        wait(cfg.commands.zaderjka * 1000) 
        sampSendChat(" �� ��������� � ����� �� - Medical Academy.")
        wait(cfg.commands.zaderjka * 1000)
        sampSendChat("��� ������� - �13.")
        wait(cfg.commands.zaderjka * 1000)
        sampSendChat("/b ��� /r [MA], /clist 13")
        wait(cfg.commands.zaderjka * 1000)
        sampSendChat("������� ������� ������ �������� �������������� � ������������ ������. ����� ������, ������ �� ������.")
        wait(cfg.commands.zaderjka * 1000)
        sampSendChat("������ ������: �����, ������, ���������, ����, ����, ��������, ������� ������� � ����� � �����.")
        wait(cfg.commands.zaderjka * 1000)
        sampSendChat("� ������ ����� ������ ������� ������ 5 �����.")
        wait(cfg.commands.zaderjka * 1000)
        sampSendChat("� �������� ���������� ����, ���������� ��������� ��������� � �������� �������.") 
        wait(cfg.commands.zaderjka * 1000)
        sampSendChat("/b /r [MA] ����: - | ��������: - | �������: -")
        wait(cfg.commands.zaderjka * 1000)
        sampSendChat(" ������ �� ���������������� � ������� - � ���������.")
        wait(cfg.commands.zaderjka * 1000)
        sampSendChat(" ���� ����������, �� ��������������� � ��������� ��� ������")
        wait(cfg.commands.zaderjka * 1000)
        sampSendChat("� ���������� ��� �������� ������ � ���������� �������.")
        wait(cfg.commands.zaderjka * 1000)
        sampSendChat("��������� ����� ������ ��� ���� ������ � ����� �������� �� ������ ������.")
        wait(cfg.commands.zaderjka * 1000)
        sampSendChat("/b ��� ������� ����������� ������� ������ ���� �� ���������, � ����� ������ /heal id")
        wait(cfg.commands.zaderjka * 1000)
        sampSendChat("�����, ��� � ��������� �������� ��������. ���������� �� ��� ��������������.")
        wait(cfg.commands.zaderjka * 1000)
        sampSendChat("�� ���� ������ ��������. ���� ���� ������� - ���������, �� �����������.") 
        wait(cfg.commands.zaderjka * 1000)
		if cfg.main.hud then
        sampSendChat("/time")
        wait(500)
        setVirtualKeyDown(key.VK_F8, true)
        wait(150)
        setVirtualKeyDown(key.VK_F8, false)
		end
    end
  },
   {
    title = "{bf6868}������ ������ ��� {13E83E}���������",
    onclick = function()
       sampSendChat("�����������, �������. ������� � ������ ��� ������ �� ���� ������� ������ ��� ����������. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("�������� ���������������� �� ������ � �������� �� ������� ������� �����, �� ���������.. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat(".. � ��� �������� �� ������� �������� ���� �� ��������� � �����.. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat(".. �������� � �������� �� ������� ����������� ����.") 
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("�������� ��������: ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("������� ���� � ����� ������, ���������� ����������, �������������� ��������� ����������.. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat(".. ����, �������������. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("������ ������ ��� ��������� ������ �������� � ����: �������������� ����������� �����..") 
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat(".. ��������� ������������, ��������������� ��������� ����.. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat(".. ������������� ����������. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("�������� ���������� ����� ������� ���������������� � ����������� ���������� ��� ��������.. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat(".. ����������� ������.")
       wait(1200)
		if cfg.main.hud then
        sampSendChat("/time")
        wait(500)
        setVirtualKeyDown(key.VK_F8, true)
        wait(150)
        setVirtualKeyDown(key.VK_F8, false)
		end
    end
  },
  {
   title = "{bf6868}������ ������ ��� {13E83E}���������� �����",
    onclick = function()
       sampSendChat("�����������, �������. ������� � ������ ��� ������ �� ���� ������� ������ ��� ���������� �����.")
       wait(cfg.commands.zaderjka * 1000) 
       sampSendChat("��� ���������� �������� ��������������, �������� ����, ��������� ������, �����������.. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat(".. ����� ������ ������. �������� ������ ������.. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat(".. ������ ����� ����� ���������� ������������ ����������� �����. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("��� ����� ����������� ������������� �� ���. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("� ����� ��������� ���������� ��������� ����� ������.. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat(".. � ������������� - ����������, �� �������� ����. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("���� ������� �� �������� � �������� ����� 30 �����..") 
       wait(cfg.commands.zaderjka * 1000) 
       sampSendChat(".. ����� ����������� ������� �������-�������� ������ � ���� �����. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("� ���� ������ ���������� ������ ������� ����� � ��������� ������������� � �������� ����������. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("������� �� ��������.")
       wait(1200)
		if cfg.main.hud then
        sampSendChat("/time")
        wait(500)
        setVirtualKeyDown(key.VK_F8, true)
        wait(150)
        setVirtualKeyDown(key.VK_F8, false)
		end
    end
  },
  {
   title = "{bf6868}������ ������ ��� {13E83E}���������",
    onclick = function()
      sampSendChat("�����������, �������. ������� � ������ ��� ������ �� ���� ������� ������ ��� ����������. ")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("�������� �������������� ��������������� ������� ��������, ���������.. ")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat(".. ������������� ��������������� �����. ")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("������� ����� �������: ������ ����, ������������� ������, ��� � ��� �����. ")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("���������������� ��������� ������ ������������ ������ ��������� ������������: ")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("��������� ��������, ���������� �������, ��������������, ��� ��� ���� � ����. ")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("����� ������� ��������, ����������� �������� ����� � �������� ������ ��������. ")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("������ ������ ������ ���� ���������� �� ��������� �������������� �����.. ")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat(".. � ����������� ���������� �������. ")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("���� ������������ ��������� � ������, ����� ������������ ���������, ��.. ")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat(".. �������� ����, �������� ���������� ��� �������� ����������� �������� �� ������.")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("�������� ��� ���� � ��� �������� �����, ���������� �� ����� �.. ")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat(".. ����� ������������� �������� �����, ��������� ���������� �������. ")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("������� �� ��������.")
       wait(1200)
		if cfg.main.hud then
        sampSendChat("/time")
        wait(500)
        setVirtualKeyDown(key.VK_F8, true)
        wait(150)
        setVirtualKeyDown(key.VK_F8, false)
		end
    end
  },
  {
    title = "{bf6868}������ ������ ��� {13E83E}������������",
    onclick = function()
       sampSendChat("�����������, �������. ������� � ������ ��� ������ �� ���� ������� ������ ��� ������������. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("����� ����� ��������, ��� ������������ ������������ ������������ ����������� ��������� ��� �����. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("������, ��� ��������� � ��������� ����� ���� ������������� �����. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("��� ����� �������� ������� �������� � ������ �������� ����. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("����������� � ����� ������ ����� ���������� ��������: ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("����, ������, ������, �������� ������� ����� ������.") 
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("���������� ���� �� ��� ���, ���� ����� �� ���������� �������� �� ����. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("� ������ ��������� ������������ �������� �����������, �� ����������� ����, ���..") 
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat(".. ���� ������������� ���� ���� ������������� �����. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("������� �������, ��� ��� ����� ����� ������������ ���� ������������� �� ����� ���� �����..") 
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat(".. � ������ ������ � �� ����� ���� � ��������. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("��� ����������� ������������ ������� ���������� ������������ ����� ��������� ��������.. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat(".. � �������� ��������, ���� ������������� ����. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("������� �� ��������.")
       wait(1200)
       if cfg.main.hud then
        sampSendChat("/time")
        wait(500)
        setVirtualKeyDown(key.VK_F8, true)
        wait(150)
        setVirtualKeyDown(key.VK_F8, false)
		end
    end
  },
  
  {
   title = "{bf6868}� ������� ��������� ��� {13E83E}��������� ",
    onclick = function()
      sampSendChat("������� �������, � ����������� ������, � ���� ��� ���������� � �������� ������, �� ")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("�� ������ ������ ����������� ������� ������� ���������. ")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("����� ������ ��������� ����� ������� ���������: �������������, ����������������,")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("�����������, ������������, ��������������, �������������.")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("� ������, ��������� � ������ �� ���:")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("������������� - ���� � � ���, ����� ������� �������� �� ����, ���� ����������� �������,")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("��� ������. ���� �� ����������� ������� - ������� ��� ���� ������� �������.")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("�� �������� ��������� � ������� ������. � �����, ��� ����� ����� ��� ������� ���������. ")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("�����, ���������������� - ���� � ����������� � ���, ����� �������� ��������� ���� ����,")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("���� �������� ������, ��� ����� ���������� ��������� ������� ����������,")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("� ��� ����, ������� ������������ �������������, ��� ��� ��������� ����...")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("������������� �������� ��������� � ��������")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("��������� - �����������. ���� � ����������� � ���, �����")
      wait(cfg.commands.zaderjka * 1000)
	  sampSendChat("���������� ������� ����������� �������, ��������� � 0.25% ����������.")
      wait(cfg.commands.zaderjka * 1000)
	  sampSendChat("�����, ���������� ��������� ���������������� � �������� ����� ���������. ")
      wait(cfg.commands.zaderjka * 1000)
	  sampSendChat("������� ��� ����� ��������� �������: �������������� �������� ��������� �� ������������ �������,")
      wait(cfg.commands.zaderjka * 1000)
	  sampSendChat("������� ������ � ������ ����������� ����")
      wait(cfg.commands.zaderjka * 1000)
	  sampSendChat("�� ����������� ������������ �������. ���� ������� �����������")
      wait(cfg.commands.zaderjka * 1000)
	  sampSendChat(" ����������� - ������ ���� ���������.")
      wait(cfg.commands.zaderjka * 1000)
	  sampSendChat("����� ��� ������������ ���������. ���� � ����������� � ���, ����� ������ �������� ������ ��������.")
      wait(cfg.commands.zaderjka * 1000)
	   sampSendChat("��������� - ��������������, ���� ��������. ���� ������ ����� � ����������.")
      wait(cfg.commands.zaderjka * 1000)
	   sampSendChat("������ ����������� �� ������ ��������, � � ������� �����. ")
      wait(cfg.commands.zaderjka * 1000)
	   sampSendChat("� ��������� - �������������. ������ ��������� ������������ ���")
      wait(cfg.commands.zaderjka * 1000)
	   sampSendChat("����� ������ ������������ ������������ ������.")
      wait(cfg.commands.zaderjka * 1000)
	   sampSendChat("�� ������� �������� �� ���� ����������� ������������. ")
      wait(cfg.commands.zaderjka * 1000)
	   sampSendChat("������� �� ������ �� ��������� ���������.")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("������� �� ��������.")
       wait(1200)
		if cfg.main.hud then
        sampSendChat("/time")
        wait(500)
        setVirtualKeyDown(key.VK_F8, true)
        wait(150)
        setVirtualKeyDown(key.VK_F8, false)
		end
    end
  },
  
  {
    title = "{bf6868}������ ������ ��� {13E83E}���",
    onclick = function()
       sampSendChat("�����������, �������. ������� � ������ ��� ������ �� ���� ������� ������ ��� ��ϻ. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("�������� ������ ������, ���������� ����������� �� ��������. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("���������� ���������� �������� � �������� ������. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("�������� ������ ������ � ������ ��� - ��������� ����������� ������.. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat(".. � ������ ����������� � ������� ������. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("���������� ������� ������������� �� ����������, ��������� ���. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("����� ������� ������� ������ ������ � ������������ � ����������� ��������. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("������ ��, ��������� ��������� ������������� � ���������� �����.. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat(".. ������ �� ������, ���� ��� ����� � ������� �����, � �����.. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat(".. ������������ ��������������� ������������� � �������� ����������.") 
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("������� �� ��������.")
       wait(1200)
		if cfg.main.hud then
        sampSendChat("/time")
        wait(500)
        setVirtualKeyDown(key.VK_F8, true)
        wait(150)
        setVirtualKeyDown(key.VK_F8, false)
		end
    end
   }
   
}
end

do

function imgui.OnDrawFrame()
   if first_window.v then
	local tagfr = imgui.ImBuffer(u8(cfg.main.tarr), 256)
	local tagb = imgui.ImBool(cfg.main.tarb)
	local clistb = imgui.ImBool(cfg.main.clistb)
	local autoscr = imgui.ImBool(cfg.main.hud)
	local hudik = imgui.ImBool(cfg.main.givra)
	local clisto = imgui.ImBool(cfg.main.clisto)
	local stateb = imgui.ImBool(cfg.main.male)
	local waitbuffer = imgui.ImInt(cfg.commands.zaderjka)
	local clistbuffer = imgui.ImInt(cfg.main.clist)
    local iScreenWidth, iScreenHeight = getScreenResolution()
	local btn_size = imgui.ImVec2(-0.1, 0)
    imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(7, 3))
    imgui.Begin(u8'���������##1', first_window, btn_size, imgui.WindowFlags.NoResize)
	imgui.PushItemWidth(200)
	imgui.AlignTextToFramePadding(); imgui.Text(u8("������������ �������"))
	imgui.SameLine()
	if imgui.ToggleButton(u8'������������ �������', tagb) then
    cfg.main.tarb = not cfg.main.tarb
    end
	if tagb.v then
	if imgui.InputText(u8'������� ��� ���.', tagfr) then
    cfg.main.tarr = u8:decode(tagfr.v)
    end
	imgui.Text(u8("����-���"))
	imgui.SameLine()
	if imgui.ToggleButton(u8'��������/��������� ����-���', hudik) then
        cfg.main.givra = not cfg.main.givra
		ftext(cfg.main.givra and '����-��� �������, ���������� ��������� /sethud' or '����-��� ��������')
    end
	end
	imgui.Text(u8("������� ����� �� ��������� ���"))
	imgui.SameLine()
    if imgui.HotKey(u8'##������� ����� ���', config_keys.fastsms, tLastKeys, 100) then
	    rkeys.changeHotKey(fastsmskey, config_keys.fastsms.v)
		ftext('������� ������� ��������. ������ ��������: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | ����� ��������: '.. table.concat(rkeys.getKeysName(config_keys.fastsms.v), " + "))
		saveData(config_keys, 'moonloader/config/medicHELP/keys.json')
	end
	imgui.Text(u8("������������ ���������"))
	imgui.SameLine()
	if imgui.ToggleButton(u8'������������ ���������', clistb) then
        cfg.main.clistb = not cfg.main.clistb
    end
    if clistb.v then
        if imgui.SliderInt(u8"�������� �������� ������", clistbuffer, 0, 33) then
            cfg.main.clist = clistbuffer.v
        end
		imgui.Text(u8("������������ ��������� ����������"))
	    imgui.SameLine()
		if imgui.ToggleButton(u8'������������ ��������� ����������', clisto) then
        cfg.main.clisto = not cfg.main.clisto
        end
    end
	imgui.Text(u8("������� ���������"))
	imgui.SameLine()
	if imgui.ToggleButton(u8'������� ���������', stateb) then
        cfg.main.male = not cfg.main.male
    end
	if imgui.SliderInt(u8'�������� � ������� � ����������(���)', waitbuffer,  1, 10) then
     cfg.commands.zaderjka = waitbuffer.v
    end
	imgui.Text(u8("��������� ������/���.��������"))
	imgui.SameLine()
	if imgui.ToggleButton(u8'��������� ������', autoscr) then
        cfg.main.hud = not cfg.main.hud
    end
    if imgui.CustomButton(u8('��������� ���������'), imgui.ImVec4(0.68, 0.25, 0.25, 1.00), imgui.ImVec4(0.68, 0.25, 0.25, 1.00), imgui.ImVec4(0.68, 0.25, 0.25, 1.00), btn_size) then
	ftext('��������� ������� ���������.', -1)
    inicfg.save(cfg, 'medicHELP/config.ini') -- ��������� ��� ����� �������� � �������
    end
    imgui.End()
   end
    if ystwindow.v then
                imgui.LockPlayer = true
                imgui.ShowCursor = true
                local iScreenWidth, iScreenHeight = getScreenResolution()
                imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
                imgui.SetNextWindowSize(imgui.ImVec2(iScreenWidth/2, iScreenHeight / 2), imgui.Cond.FirstUseEver)
                imgui.Begin(u8('Medic HELP | ����� MOH'), ystwindow)
                for line in io.lines('moonloader\\medicHELP\\ystav.txt') do
                    imgui.TextWrapped(u8(line))
                end
                imgui.End()
            end
  if second_window.v then
    imgui.LockPlayer = true
    imgui.ShowCursor = true
    local iScreenWidth, iScreenHeight = getScreenResolution()
    local btn_size1 = imgui.ImVec2(70, 0)
	local btn_size = imgui.ImVec2(130, 0)
	local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(7, 5))
    imgui.Begin('Medic HELP. | Main Menu | Version: '..thisScript().version, second_window, mainw,  imgui.WindowFlags.NoResize)
	local text = '  �����:'
    imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8(text)).x)/3)
    imgui.Text(u8(text))
	imgui.SameLine()
	imgui.TextColored(imgui.ImVec4(0.43, 0.65 , 0.44, 2.0), 'Evelyn Ross')
	local text = '������ � ����������:'
	imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8(text)).x)/5)
    imgui.Text(u8(text))
	imgui.SameLine()
	imgui.TextColored(imgui.ImVec4(0.43, 0.65 , 0.44, 2.0), 'Luis Barton')
	local text = '   �� ������ ����:'
	imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8(text)).x)/4)
    imgui.Text(u8(text))
	imgui.SameLine()
	imgui.TextColored(imgui.ImVec4(0.43, 0.65 , 0.44, 2.0), ' FBI Tools')
    imgui.Separator()
	if imgui.Button(u8'������', imgui.ImVec2(50, 30)) then
      bMainWindow.v = not bMainWindow.v
    end
	imgui.SameLine()
    if imgui.Button(u8'��������� �������', imgui.ImVec2(120, 30)) then
      first_window.v = not first_window.v
    end
    imgui.SameLine()
    if imgui.Button(u8 '�������� �� ������/����', imgui.ImVec2(170, 30)) then os.execute('explorer "https://vk.com/john_wake"')
    btn_size = not btn_size
    end
	imgui.SameLine()
    if imgui.Button(u8'������������� ������', imgui.ImVec2(150, 30)) then
      showCursor(false)
      thisScript():reload()
    end
    if imgui.Button(u8 '��������� ������', imgui.ImVec2(120, 30), btn_size) then
      showCursor(false)
      thisScript():unload()
    end
	imgui.SameLine()
    if imgui.Button(u8'������', imgui.ImVec2(55, 30)) then
      helps.v = not helps.v
    end
	imgui.Separator()
	imgui.BeginChild("����������", imgui.ImVec2(410, 150), true)
	imgui.Text(u8 '��� � �������:   '..sampGetPlayerNickname(myid):gsub('_', ' ')..'')
	imgui.Text(u8 '���������:') imgui.SameLine() imgui.Text(u8(rank))
	imgui.Text(u8 '����� ��������:   '..tel..'')
	if cfg.main.tarb then
	imgui.Text(u8 '��� � �����:') imgui.SameLine() imgui.Text(u8(cfg.main.tarr))
	end
	if cfg.main.clistb then
	imgui.Text(u8 '����� ��������:   '..cfg.main.clist..'')
	end
	imgui.EndChild()
	imgui.Separator()
	imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8("������� ����: %s")).x)/1.5)
	imgui.Text(u8(string.format("������� ����: %s", os.date())))
    imgui.End()
  end
	        if infbar.v then
            _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
            local myname = sampGetPlayerNickname(myid)
            local myping = sampGetPlayerPing(myid)
            local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
            imgui.SetNextWindowPos(imgui.ImVec2(cfg.main.posX, cfg.main.posY), imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(cfg.main.widehud, 155), imgui.Cond.FirstUseEver)
            imgui.Begin('medic HELP', infbar, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar)
            imgui.CentrText('medic HELP')
            imgui.Separator()
            imgui.Text((u8"����������: %s [%s] | ����: %s"):format(myname, myid, myping))
            if isCharInAnyCar(playerPed) then
                local vHandle = storeCarCharIsInNoSave(playerPed)
                local result, vID = sampGetVehicleIdByCarHandle(vHandle)
                local vHP = getCarHealth(vHandle)
                local carspeed = getCarSpeed(vHandle)
                local speed = math.floor(carspeed)
                local vehName = tCarsName[getCarModel(storeCarCharIsInNoSave(playerPed))-399]
                local ncspeed = math.floor(carspeed*2)
                imgui.Text((u8 '���������: %s [%s]|HP: %s|��������: %s'):format(vehName, vID, vHP, ncspeed))
            else
                imgui.Text(u8 '���������: ���')
            end
			    imgui.Text((u8 '�����: %s'):format(os.date('%H:%M:%S')))
            if valid and doesCharExist(ped) then 
                local result, id = sampGetPlayerIdByCharHandle(ped)
                if result then
                    local targetname = sampGetPlayerNickname(id)
                    local targetscore = sampGetPlayerScore(id)
                    imgui.Text((u8 '����: %s [%s] | �������: %s'):format(targetname, id, targetscore))
                else
                    imgui.Text(u8 '����: ���')
                end
            else
                imgui.Text(u8 '����: ���')
            end
			imgui.Text((u8 '�������: %s'):format(u8(kvadrat())))
            saveData(cfg, 'moonloader/config/medicHELP/config.json')
            imgui.End()
        end
    if helps.v then
                local iScreenWidth, iScreenHeight = getScreenResolution()
                imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(3, 7))
                imgui.Begin(u8 '������ �� �������', helps, imgui.WindowFlags.NoResize, imgui.WindowFlags.NoCollapse)
				imgui.BeginChild("������ ������", imgui.ImVec2(525, 385), true, imgui.WindowFlags.VerticalScrollbar)
                imgui.TextColoredRGB('{FF6868}/moh{CCCCCC} - ������� ���� �������')
                imgui.Separator()
                imgui.TextColoredRGB('{FF6868}/vig [id] [�������]{CCCCCC} - ������ ������� �� �����')
                imgui.TextColoredRGB('{FF6868}/dmb{CCCCCC} - ������� /members � �������')
                imgui.TextColoredRGB('{FF6868}/yst{CCCCCC} - ������� ����� MOH')
				imgui.TextColoredRGB('{FF6868}/smsjob{CCCCCC} - ������� �� ������ ���� ��.������ �� ���')
                imgui.TextColoredRGB('{FF6868}/dlog{CCCCCC} - ������� ��� 25 ��������� ��������� � �����������')
				imgui.TextColoredRGB('{FF6868}/cchat{CCCCCC} - ������� ���')
				imgui.TextColoredRGB('{FF6868}/blag [��] [�������] [���]{CCCCCC} - �������� ������ ������������� � �����������')
				imgui.Separator()
                imgui.TextColoredRGB('�������: ')
                imgui.TextColoredRGB('{FF6868}���+Z �� ������{CCCCCC} - ���� �������������� � �������')
				 imgui.TextColoredRGB('{FF6868}/mh ID{CCCCCC} - ���� �������������� � ������� � ������')
                imgui.TextColoredRGB('{FF6868}F2{CCCCCC} - "������� ����"')
				imgui.EndChild()
                imgui.End()
    end
    if updwindows.v then
                local updlist = ttt
                imgui.LockPlayer = true
                imgui.ShowCursor = true
                local iScreenWidth, iScreenHeight = getScreenResolution()
                imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
                imgui.SetNextWindowSize(imgui.ImVec2(700, 330), imgui.Cond.FirstUseEver)
                imgui.Begin(u8('Medic HELP | ����������'), updwindows, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
                imgui.Text(u8('����� ���������� ������� Medic HELP �� ������ '..updversion..'. ��� �� ���������� ������� ������ �����.'))
                imgui.Separator()
                imgui.BeginChild("uuupdate", imgui.ImVec2(690, 200))
                for line in ttt:gmatch('[^\r\n]+') do
                    imgui.Text(line)
                end
                imgui.EndChild()
                imgui.Separator()
                imgui.PushItemWidth(305)
                if imgui.Button(u8("��������"), imgui.ImVec2(339, 25)) then
                    lua_thread.create(goupdate)
                    updwindows.v = false
                end
                imgui.SameLine()
                if imgui.Button(u8("�������� ����������"), imgui.ImVec2(339, 25)) then
                    updwindows.v = false
                end
                imgui.End()
            end
  if bMainWindow.v then
  local iScreenWidth, iScreenHeight = getScreenResolution()
	local tLastKeys = {}
   
   imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
   imgui.SetNextWindowSize(imgui.ImVec2(800, 530), imgui.Cond.FirstUseEver)

   imgui.Begin(u8("IT | ������##main"), bMainWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
	imgui.BeginChild("##bindlist", imgui.ImVec2(795, 442))
	for k, v in ipairs(tBindList) do
		if hk.HotKey("##HK" .. k, v, tLastKeys, 100) then
			if not rkeys.isHotKeyDefined(v.v) then
				if rkeys.isHotKeyDefined(tLastKeys.v) then
					rkeys.unRegisterHotKey(tLastKeys.v)
				end
				rkeys.registerHotKey(v.v, true, onHotKey)
			end
		end
		imgui.SameLine()
		if tEditData.id ~= k then
			local sText = v.text:gsub("%[enter%]$", "")
			imgui.BeginChild("##cliclzone" .. k, imgui.ImVec2(500, 21))
			imgui.AlignTextToFramePadding()
			if sText:len() > 0 then
				imgui.Text(u8(sText))
			else
				imgui.TextDisabled(u8("������ ��������� ..."))
			end
			imgui.EndChild()
			if imgui.IsItemClicked() then
				sInputEdit.v = sText:len() > 0 and u8(sText) or ""
				bIsEnterEdit.v = string.match(v.text, "(.)%[enter%]$") ~= nil
				tEditData.id = k
				tEditData.inputActve = true
			end
		else
			imgui.PushAllowKeyboardFocus(false)
			imgui.PushItemWidth(500)
			local save = imgui.InputText("##Edit" .. k, sInputEdit, imgui.InputTextFlags.EnterReturnsTrue)
			imgui.PopItemWidth()
			imgui.PopAllowKeyboardFocus()
			imgui.SameLine()
			imgui.Checkbox(u8("����") .. "##editCH" .. k, bIsEnterEdit)
			if save then
				tBindList[tEditData.id].text = u8:decode(sInputEdit.v) .. (bIsEnterEdit.v and "[enter]" or "")
				tEditData.id = -1
			end
			if tEditData.inputActve then
				tEditData.inputActve = false
				imgui.SetKeyboardFocusHere(-1)
			end
		end
	end
	imgui.EndChild()

	imgui.Separator()

	if imgui.Button(u8"�������� �������") then
		tBindList[#tBindList + 1] = {text = "", v = {}}
	end

   imgui.End()
  end
  end
end

function onHotKey(id, keys)
	local sKeys = tostring(table.concat(keys, " "))
	for k, v in pairs(tBindList) do
		if sKeys == tostring(table.concat(v.v, " ")) then
			if tostring(v.text):len() > 0 then
				local bIsEnter = string.match(v.text, "(.)%[enter%]$") ~= nil
				if bIsEnter then
					sampProcessChatInput(v.text:gsub("%[enter%]$", ""))
				else
					sampSetChatInputText(v.text)
					sampSetChatInputEnabled(true)
				end
			end
		end
	end
end

function showHelp(param) -- "��������" ��� �������
    imgui.TextDisabled('(?)')
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(imgui.GetFontSize() * 35.0)
        imgui.TextUnformatted(param)
        imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
end

function onScriptTerminate(scr)
	if scr == script.this then
		if doesFileExist(fileb) then
			os.remove(fileb)
		end
		local f = io.open(fileb, "w")
		if f then
			f:write(encodeJson(tBindList))
			f:close()
		end
		local fa = io.open("moonloader/config/medicHELP/keys.json", "w")
        if fa then
            fa:write(encodeJson(config_keys))
            fa:close()
        end
	end
end

addEventHandler("onWindowMessage", function (msg, wparam, lparam)
	if msg == wm.WM_KEYDOWN or msg == wm.WM_SYSKEYDOWN then
		if tEditData.id > -1 then
			if wparam == key.VK_ESCAPE then
				tEditData.id = -1
				consumeWindowMessage(true, true)
			elseif wparam == key.VK_TAB then
				bIsEnterEdit.v = not bIsEnterEdit.v
				consumeWindowMessage(true, true)
			end
		end
	end
end)

function submenus_show(menu, caption, select_button, close_button, back_button)
    select_button, close_button, back_button = select_button or '�', close_button or 'x', back_button or '�'
    prev_menus = {}
    function display(menu, id, caption)
        local string_list = {}
        for i, v in ipairs(menu) do
            table.insert(string_list, type(v.submenu) == 'table' and v.title .. ' �' or v.title)
        end
        sampShowDialog(id, caption, table.concat(string_list, '\n'), select_button, (#prev_menus > 0) and back_button or close_button, sf.DIALOG_STYLE_LIST)
        repeat
            wait(0)
            local result, button, list = sampHasDialogRespond(id)
            if result then
                if button == 1 and list ~= -1 then
                    local item = menu[list + 1]
                    if type(item.submenu) == 'table' then -- submenu
                        table.insert(prev_menus, {menu = menu, caption = caption})
                        if type(item.onclick) == 'function' then
                            item.onclick(menu, list + 1, item.submenu)
                        end
                        return display(item.submenu, id + 1, item.submenu.title and item.submenu.title or item.title)
                    elseif type(item.onclick) == 'function' then
                        local result = item.onclick(menu, list + 1)
                        if not result then return result end
                        return display(menu, id, caption)
                    end
                else -- if button == 0
                    if #prev_menus > 0 then
                        local prev_menu = prev_menus[#prev_menus]
                        prev_menus[#prev_menus] = nil
                        return display(prev_menu.menu, id - 1, prev_menu.caption)
                    end
                    return false
                end
            end
        until result
    end
    return display(menu, 31337, caption or menu.title)
end

function r(pam)
    if #pam ~= 0 then
        if cfg.main.tarb then
            sampSendChat(string.format('/r [%s]: %s', cfg.main.tarr, pam))
        else
            sampSendChat(string.format('/r %s', pam))
        end
    else
        ftext('������� /r [�����]')
    end
end
function f(pam)
    if #pam ~= 0 then
        if cfg.main.tarb then
            sampSendChat(string.format('/f [%s]: %s', cfg.main.tarr, pam))
        else
            sampSendChat(string.format('/f %s', pam))
        end
    else
        ftext('������� /f [�����]')
    end
end
function ftext(message)
    sampAddChatMessage(string.format('%s %s', ctag, message), 0xE66E6E)
end

function moh()
  if frac == 'Hospital' then
  second_window.v = not second_window.v
  else
  ftext('�������� �� �� �������� � MOH {ff0000}[ctrl+R]')
  end
end	

function tloadtk()
    if tload == true then
     sampSendChat('/tload'..u8(cfg.main.norma))
    else if tload == false then
     sampSendChat("/tunload")
    end
  end
end
function imgui.CentrText(text)
            local width = imgui.GetWindowWidth()
            local calc = imgui.CalcTextSize(text)
            imgui.SetCursorPosX( width / 2 - calc.x / 2 )
            imgui.Text(text)
        end
            function imgui.CustomButton(name, color, colorHovered, colorActive, size)
            local clr = imgui.Col
            imgui.PushStyleColor(clr.Button, color)
            imgui.PushStyleColor(clr.ButtonHovered, colorHovered)
            imgui.PushStyleColor(clr.ButtonActive, colorActive)
            if not size then size = imgui.ImVec2(0, 0) end
            local result = imgui.Button(name, size)
            imgui.PopStyleColor(3)
            return result
        end
        
function imgui.TextColoredRGB(text)
  local style = imgui.GetStyle()
  local colors = style.Colors
  local ImVec4 = imgui.ImVec4

  local explode_argb = function(argb)
    local a = bit.band(bit.rshift(argb, 24), 0xFF)
    local r = bit.band(bit.rshift(argb, 16), 0xFF)
    local g = bit.band(bit.rshift(argb, 8), 0xFF)
    local b = bit.band(argb, 0xFF)
    return a, r, g, b
  end

  local getcolor = function(color)
      if color:sub(1, 6):upper() == 'SSSSSS' then
          local r, g, b = colors[1].x, colors[1].y, colors[1].z
          local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
          return ImVec4(r, g, b, a / 255)
      end
      local color = type(color) == 'string' and tonumber(color, 16) or color
      if type(color) ~= 'number' then return end
      local r, g, b, a = explode_argb(color)
      return imgui.ImColor(r, g, b, a):GetVec4()
  end

  local render_text = function(text_)
      for w in text_:gmatch('[^\r\n]+') do
          local text, colors_, m = {}, {}, 1
          w = w:gsub('{(......)}', '{%1FF}')
          while w:find('{........}') do
              local n, k = w:find('{........}')
              local color = getcolor(w:sub(n + 1, k - 1))
              if color then
                  text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                  colors_[#colors_ + 1] = color
                  m = n
              end
              w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
          end
          if text[0] then
              for i = 0, #text do
                  imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
                  imgui.SameLine(nil, 0)
              end
              imgui.NewLine()
          else imgui.Text(u8(w)) end
      end
  end
  render_text(text)
end

function pkmmen(arg)
	ID = tonumber(arg)
	lua_thread.create(function()
	local color = ("%06X"):format(bit.band(sampGetPlayerColor(ID), 0xFFFFFF))
	submenus_show(pkmmenu(ID), "{E66E6E}Medic HELP {ffffff}� {"..color.."}"..sampGetPlayerNickname(ID).."["..ID.."] {ffffff}������� - "..sampGetPlayerScore(ID).." ")
	end)
end


function pkmmenu(id)
    local color = ("%06X"):format(bit.band(sampGetPlayerColor(id), 0xFFFFFF))
    return
    {
      {
        title = "{bf6868}� ���� {13E83E}������.",
        onclick = function()
        pID = tonumber(args)
        submenus_show(mediccmenu(id), "{E66E6E}Medic HELP {ffffff}� {"..color.."}"..sampGetPlayerNickname(id).."["..id.."] ")
        end
      },
	   {
        title = "{bf6868}� ���� ������ {13E83E}������� � ������ �� �������.",
        onclick = function()
        pID = tonumber(args)
        submenus_show(spravkamenu(id), "{E66E6E}Medic HELP {ffffff}� {"..color.."}"..sampGetPlayerNickname(id).."["..id.."] ")
        end
      },
	  {
        title = "{bf6868}� ���� {13E83E}��������, �������, ���������",
        onclick = function()
        pID = tonumber(args)
        submenus_show(renmenu(id), "{E66E6E}Medic HELP {ffffff}� {"..color.."}"..sampGetPlayerNickname(id).."["..id.."] ")
        end
      },
	  {
	 
        title = "{bf6868}� ������� ��� {13E83E}�������� ���� � ���� � ������.",
        onclick = function()
        pID = tonumber(args)
        submenus_show(medicmenu(id), "{E66E6E}Medic HELP {ffffff}� {"..color.."}"..sampGetPlayerNickname(id).."["..id.."] ")
        end
      },
	  {
        title = "{bf6868}� ������� ��� {13E83E}���� � �����.",
        onclick = function()
        pID = tonumber(args)
        submenus_show(gorlomenu(id), "{E66E6E}Medic HELP {ffffff}� {"..color.."}"..sampGetPlayerNickname(id).."["..id.."] ")
        end
      },
      {
        title = "{bf6868}� �������� ��� {13E83E}��������",
        onclick = function()
        pID = tonumber(args)
        submenus_show(nawmenu(id), "{E66E6E}Medic HELP {ffffff}� {"..color.."}"..sampGetPlayerNickname(id).."["..id.."] ")
        end
      },
      {
        title = "{bf6868}� ����� �� {13E83E}����������������",
        onclick = function()
        pID = tonumber(args)
        submenus_show(narkomenu(id), "{E66E6E}Medic HELP {ffffff}� {"..color.."}"..sampGetPlayerNickname(id).."["..id.."] ")
        end
      },
    }
end

function gorlomenu(id)
    return
    {
      {
        title = '{ffffff}� ������ �����',
        onclick = function()
		local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
        sampSendChat("������, �������� ���.")
        wait(cfg.commands.zaderjka * 1200) 
		sampSendChat(string.format('/me %s �����', cfg.main.male and '��������' or '���������'))
        wait(cfg.commands.zaderjka * 500) 
		sampSendChat("/do �� ����� �������� ���.�����")
        wait(cfg.commands.zaderjka * 500) 
		sampSendChat(string.format('/me %s �������', cfg.main.male and '������' or '�������'))
        wait(cfg.commands.zaderjka * 500) 
		sampSendChat(string.format('/me %s ����������� ��������', cfg.main.male and '�����' or '�����'))
        wait(cfg.commands.zaderjka * 500) 
        sampSendChat("/do ��������� � ����.")
        wait(cfg.commands.zaderjka * 500) 
		sampSendChat(string.format('/me %s ����� ����������', cfg.main.male and '���������' or '����������'))
        sampSendChat("/me ��������� ����� ������������� ����������")
        wait(cfg.commands.zaderjka * 500) 
        sampSendChat("/heal "..id)
        wait(cfg.commands.zaderjka * 1500) 
        sampSendChat("�������� ���, �� �������.") 
		end
      }
    }
end

function narkomenu(id)
    return
    {
      {
        title = '{ffffff}� ������ ������',
        onclick = function()
		local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
        sampSendChat("�������������� �� ������� � ��������� �����.")
        wait(cfg.commands.zaderjka * 700) 
        sampSendChat("/do ����� � ����.")
        wait(cfg.commands.zaderjka * 700) 
		sampSendChat(string.format('/me %s ����� ��������� ���.������� � %s ����� �����', cfg.main.male and '����' or '�����', cfg.main.male and '���������' or '����������'))
        wait(cfg.commands.zaderjka * 700) 
		sampSendChat(string.format('/me %s ���� �� ���� ��������, ����� ���� %s ��������', cfg.main.male and '�������' or '��������', cfg.main.male and '����' or '�����'))
        wait(cfg.commands.zaderjka * 700)  
		sampSendChat(string.format('/me %s ���� � %s ����� � ����� �����', cfg.main.male and '����' or '�����', cfg.main.male and '��������' or '���������'))
        wait(cfg.commands.zaderjka * 700) 
        sampSendChat("/healaddict "..id.." 10000 ", id)
        wait(cfg.commands.zaderjka * 700) 
        sampSendChat("����� ���������� ������� ������ ����������� ������������� �������� ������������� ���������")
        wait(cfg.commands.zaderjka * 700)
        sampSendChat("����� �������.") 
		end
      }
    }
end

function renmenu(args)
    return
    {
      {
        title = '{5b83c2}� ������ �������� �',
        onclick = function()
        end
      },
      {
        title = '{ffffff}� ������������� �������',
        onclick = function()
        sampSendChat("�������� �� ������� � ������ ������.")
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s ������������� �������', cfg.main.male and '�������' or '��������'))
        wait(cfg.commands.zaderjka * 1000) 
        sampSendChat("/do ������������� ������� �������.")
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s ������������� ��������� �� ������������� �������', cfg.main.male and '��������' or '���������'))
        wait(cfg.commands.zaderjka * 1000) 
        sampSendChat("/me ������������� ������")
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/try %s �������', cfg.main.male and '���������' or '����������'))       
      end
	  },
	  
	 
      {
        title = '{5b83c2}� ���� � �������� ������� ����������� �',
        onclick = function()
        end
      },
      {
        title = '{ffffff}� ������� �����������',
        onclick = function()
        sampSendChat("�������� �� �������.")
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s �� ����� �������� � %s ��.', cfg.main.male and '����' or '�����', cfg.main.male and '�����' or '������'))  
        wait(cfg.commands.zaderjka * 1000) 
        sampSendChat("/do ������������� ������� �������.")
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s ����� � ��������������, ����� ���� %s ������������ �������', cfg.main.male and '����' or '�����', cfg.main.male and '���������' or '����������'))
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s ��������� ������������� ������� ', cfg.main.male and '��������' or '���������'))
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s �������� �������', cfg.main.male and '����������' or '�����������'))
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s ���� ����� �����, ����� ���� %s �������� �������', cfg.main.male and '��������' or '���������', cfg.main.male and '����' or '������'))
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s ���� � %s �������', cfg.main.male and '�������' or '��������', cfg.main.male and '������������' or '�������������'))
        wait(cfg.commands.zaderjka * 1000) 
        sampSendChat("��������� ����� �����. ����� �������!")
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s �������� � %s �� � ����', cfg.main.male and '����' or '�����', cfg.main.male and '������' or '�������'))
		end
      },
      {
        title = '{5b83c2}� ���� � �������� ������� ������������/����� �',
        onclick = function()
        end
      },
      {
        title = '{ffffff}� ������� ������������/�����',
        onclick = function()
		sampSendChat(string.format('/me ��������� %s ������������� �� ������������ ����', cfg.main.male and '�����' or '������'))
        wait(cfg.commands.zaderjka * 1000) 
        sampSendChat(string.format('/me %s �� ����� �������� � %s ��.', cfg.main.male and '����' or '�����', cfg.main.male and '�����' or '������'))  
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s ������������� � ����������.', cfg.main.male and '���������' or '����������'))
        wait(cfg.commands.zaderjka * 1000)
        sampSendChat(string.format('/me %s ����� ������� � %s ���� �� ���� ��������', cfg.main.male and '�������' or '��������', cfg.main.male and '���������' or '����������'))		
        wait(cfg.commands.zaderjka * 1000)
		sampSendChat(string.format('/me ����������� %s ��������.', cfg.main.male and '����' or '�����'))
        wait(cfg.commands.zaderjka * 1000) 
        sampSendChat("/do ������ �������� �����������, ������� ������� ��������.")
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s ��������� � ������', cfg.main.male and '������' or '�������'))
        wait(cfg.commands.zaderjka * 1000)
		sampSendChat(string.format('/me � ������� ��������� ������������ %s ��������� ������������� �������', cfg.main.male and '��������' or '���������'))
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s ������ �� �������� ����������� ������', cfg.main.male and '������' or '�������'))
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s ������������ ������� � ������� �������', cfg.main.male and '������������' or '�������������'))
        wait(cfg.commands.zaderjka * 1000) 
        sampSendChat(string.format('/me %s �������� � %s �� � ����', cfg.main.male and '����' or '�����', cfg.main.male and '������' or '�������'))
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s � ��������� ��������� ������� ��������������', cfg.main.male and '�����' or '������'))
        wait(cfg.commands.zaderjka * 1000) 
        sampSendChat("/do ������ ��������� �����, ������� ������ � ��������.") 
		end
      },
      {
        title = '{5b83c2}� ���� � �������� �������� ����� �',
        onclick = function()
        end
      },
      {
        title = '{ffffff}� �������� �����',
        onclick = function()
        sampSendChat(string.format('/me %s �� ����� �������� � %s ��.', cfg.main.male and '����' or '�����', cfg.main.male and '�����' or '������'))  
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s ������ ��������', cfg.main.male and '������' or '�������'))
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s ������� ������� ������ � ��������', cfg.main.male and '���������' or '����������'))
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s ������������ �������', cfg.main.male and '���������' or '����������'))
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s �� ���. ����� ���� � %s ��� ������ �����������', cfg.main.male and '������' or '�������', cfg.main.male and '�������' or '��������'))
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s ������������� ����������� �� �����', cfg.main.male and '��������' or '��������a'))
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s ����������� ���� � ����', cfg.main.male and '����' or '����a'))
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s ����������� ����� � %s �����', cfg.main.male and '�����' or '������', cfg.main.male and '��������' or '���������'))
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s ����� � %s ����� ������', cfg.main.male and '������' or '��������', cfg.main.male and '�����' or '������'))
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s ���� � ���� � �������', cfg.main.male and '�������' or '�������a'))
        wait(cfg.commands.zaderjka * 1000)
				sampSendChat(string.format('/me %s ����, %s ����� � %s ������������ ������� ����', cfg.main.male and '����' or '����a', cfg.main.male and '����' or '����a', cfg.main.male and '������������' or '������������a'))
        wait(cfg.commands.zaderjka * 1000) 
        sampSendChat("�� ������� �������, �������� ���, �� �������.")
        wait(cfg.commands.zaderjka * 1000) 
        sampSendChat(string.format('/me %s � ��������� ��������� ������� ��������������', cfg.main.male and '�����' or '������')) 
		end
      },
    }
end



function spravkamenu(args)
    return
    {
      {
        title = '{5b83c2}� ������� �',
        onclick = function()
        end
      },
      {
        title = '{ffffff}� ��������� �[1]',
        onclick = function()
        sampAddChatMessage("{D91111}���������: {bf8080} ��������� � ��������.", -1)
	    wait(8000)
	    sampSendChat("�������� ���� ��� � �������.")
		wait(125)
		sampAddChatMessage("{ffffff}{D91111}���������: {bf8080} ����� ����, ��� ��� ������� - ����� � �����.", -1)
	wait(8000)
	sampSendChat("/do �� ����� ����� ���� � ���.������� � ��������������� ����������.")
	wait(6000)
	sampSendChat(string.format('/me %s �� ����� ���.����� �� ��� ��������', cfg.main.male and '������' or '�������'))
	wait(6000)
	sampAddChatMessage("{D91111}���������: {bf8080} �������������� ����� � ��������.", -1)
	wait(8000)
	sampSendChat("������ �� �� ������ �� ��������?")
	wait(5000)
	sampAddChatMessage("{D91111}���������: {bf8080} ���� ������ � ��������� � ��������� �[2].", -1)
	wait(8000)
	   
		end
      },
	  {
        title = '{ffffff}� ��������� �[2]',
        onclick = function()
        sampSendChat("������, ���������.")
		wait(150)
	sampAddChatMessage("{D91111}���������: {bf8080} �������������� ����� � �����.", -1)
	wait(8000)
	sampSendChat("/do � ����� ���� ������ �����.")
	wait(6000)
	sampSendChat(string.format('/me %s ������ � ���.�����', cfg.main.male and '������' or '�������'))
	wait(6000)
	sampSendChat(string.format('/me %s �� ����� ��������������� ���������', cfg.main.male and '������' or '�������'))
	wait(6000)
	sampAddChatMessage("{D91111}���������: {bf8080} �������� � ��������.", -1)
	sampSendChat("��������������, ������ ������������.")
	wait(15000)
	sampSendChat("/me ����� ���������� ����� ������� �������� ")
	wait(6000)
	sampSendChat(string.format('/me %s, ��� ������ �������� �������������� � ������� � �����', cfg.main.male and '��������' or '���������'))
	wait(6000)
	sampSendChat("������. �������� ������ � �����.")
	wait(6000)
	sampSendChat(string.format('/me %s ������ � ���.�����', cfg.main.male and '������' or '�������'))
	wait(6000)
	sampSendChat(string.format('/me %s ���������� �� ������ ������ ��������', cfg.main.male and '������' or '�������'))
	wait(6000)
	sampSendChat(string.format('/me %s ���������� �� ������� ������ ��������', cfg.main.male and '������' or '�������'))
	wait(6000)
	sampSendChat("����� ���� ��� ��������. ������ �������� ���� �����.")
	wait(125)
	sampAddChatMessage("{D91111}���������: {bf8080} �������� � ����� � ��������� ��������� �[3]", -1)
	   
		end
      },
	    {
        title = '{ffffff}� ��������� �[3]',
        onclick = function()
        sampSendChat("/do �� ���� ����� ����-�����������.")
	wait(6000)
	sampSendChat("/do ����� ����� ����� �������� ���.����� �� �����")
	wait(6000)
	
	sampSendChat(string.format('/me %s �� ���.����� ����, �����, ����� � ����������� ��������', cfg.main.male and '������' or '�������'))
	wait(6000)
	sampSendChat(string.format('/me %s ���� �������', cfg.main.male and '��������' or '���������'))
	wait(6000)
	sampSendChat("/do ����������� ������� ���� � ����� ����.")
	wait(6000)
	sampSendChat(string.format('/me %s ����� ����� ����� �� ���� ��������', cfg.main.male and '���������' or '����������'))
	wait(6000)
	sampAddChatMessage('{D91111}���������: {bf8080} �������� ����� � ��������.', -1)
	sampSendChat("/do ����� � ����������� �������� � ������ ����.")
	wait(6000)
	sampSendChat("/me ���������� ��������� ������ ����� � ���� ��������")
	wait(6000)
	sampSendChat(string.format('/me � ������� ������ %s ������� ����� ��� ������� ', cfg.main.male and '����' or '�����'))
	wait(125)
	sampAddChatMessage("{D91111}���������: {bf8080} ���� ������� � �����.", -1)
	wait(6000)
	sampSendChat(string.format('/me %s ����� �� ������ � ����.�����, ����� %s �� � ����-�����������', cfg.main.male and '�������' or '��������', cfg.main.male and '��������' or '���������'))
	wait(125)
	sampAddChatMessage("{D91111}���������: {bf8080} �����, ������ {D91111}/checkheal 'id', {bf8080}���� �������� {D91111}'���' - ", -1)
    sampAddChatMessage("{bf8080}��������� ����� {D91111}��������� �[4]. � ���� �������� {D91111}'��'")
	sampAddChatMessage("- {bf8080}�������� ����� �� ����������������. � ��� �� ��������� {D91111}��������� �[4]")
	   
		end
      },
	   {
        title = '{ffffff}� ��������� �[4]',
        onclick = function()
        sampAddChatMessage("{D91111}���������:{bf8080} �������� � ����� � ���� ���������� ���������.", -1)
		wait(8000)
	sampSendChat("/do �� ������ ������� ������������� ��������� ����� ����� ��������. ")
	wait(6000)
	sampSendChat("/do ������� ������.")
	wait(6000)
	sampSendChat("/do � �������� ����� ������ �������.")
	wait(6000)
	sampSendChat(string.format('/me %s �� �������� ����� �������', cfg.main.male and '������' or '�������'))
	wait(6000)
	sampSendChat(string.format('/me %s ������� � ���, ��� ������ ������� �� ����� ���������������� � ����� � ������', cfg.main.male and '�������' or '��������'))
	wait(125)
	sampAddChatMessage("{D91111}���������: {bf8080} ��������� � ��������.", -1)
	wait(8000)
	sampSendChat(string.format('/me %s ������� �������� � ����', cfg.main.male and '�������' or '��������'))
	wait(5000)
	sampSendChat("����� �������, �� ��������.")
		end
      },
	   {
        title = '{5b83c2}� �������� ����������� �',
        onclick = function()
        end
      },
      {
        title = '� ������� ��������.',
        onclick = function()
	sampSendChat("������������. ������ �� �������� ��� �� ������� ����������������. ")
	wait(3500)
	sampSendChat("/do ����� ����� ����� �������� ���.����� �� �����. ")
	wait(3500)
	sampSendChat(string.format('/me %s �� ���.����� ����, �����, ����� � ����������� ��������', cfg.main.male and '������' or '�������'))
	wait(3500)
	sampSendChat(string.format('/me %s ���� �������', cfg.main.male and '��������' or '���������'))
	wait(3500)
	sampSendChat("/do ����������� ������� ���� � ����� ����.")
	wait(3500)
	sampSendChat(string.format('/me %s ����� ����� ����� �� ���� �������', cfg.main.male and '���������' or '����������'))
	wait(3500)
	sampSendChat("/do ����� � ����������� �������� � ������ ����.")
	wait(3500)
	sampSendChat("/me ���������� ��������� ������ ����� � ���� ������� ")
	wait(3500)
	sampSendChat(string.format('/me � ������� ������ %s ������� ����� ��� ������� ', cfg.main.male and '����' or '�����'))
	wait(3500)
	sampSendChat(string.format('/me %s ����� �� ������ � ����.�����, ����� %s �� � ����-�����������', cfg.main.male and '�������' or '��������', cfg.main.male and '��������' or '���������'))
	wait(1000)
	sampAddChatMessage("{D91111}���������:{bf8080} ������� {D91111}/checkheal id.", -1)
		sampAddChatMessage('{D91111}���������:{bf8080} ���� �������� "���" - ������ ������ "�����".', -1)
		sampAddChatMessage('{D91111}���������:{bf8080} ���� "��" - ������ "�� �����".', -1)
		sampAddChatMessage('{D91111}���������:{bf8080} �������� ������ ����� � ���� ���������.', -1)
       end
      },
	 {
        title = '{ffffff}� ��������� {13E83E}�����',
        onclick = function()
	sampSendChat("/do �� ������ ������� ������������� ��������� ����� ����� ��������. ")
	wait(3005)
	sampSendChat(string.format('/me %s ������ "�����" � ���.����� �������', cfg.main.male and '��������' or '���������'))
	wait(3500)
		end
    },
	 {
        title = '{ffffff}� ��������� {D91111}�� �����',
        onclick = function()
	sampSendChat("/do �� ������ ������� ������������� ��������� ����� ����� ��������. ")
	wait(3500)
	sampSendChat(string.format('/me %s ������ "�� �����" � ���.����� �������', cfg.main.male and '��������' or '���������'))
	wait(3500)
		end
    },
	}
end


function invite(pam)
    lua_thread.create(function()
        local id = pam:match('(%d+)')
      if rank == '��������' or rank == '������' or rank == '���.����.�����' or rank == '����.����' then
        if id then
		if sampIsPlayerConnected(id) then
                sampSendChat('/me ������(�) ������� � �������(�) ��� '..sampGetPlayerNickname(id):gsub('_', ' ')..'')
				wait(1500)
				sampSendChat(string.format('/invite %s', id))
				wait(2000)
				if cfg.main.tarb then
                sampSendChat(string.format('/r [%s]: ����� ��������� ������������ ��������������� - '..sampGetPlayerNickname(id):gsub('_', ' ')..'. ����� ����������.', cfg.main.tarr))
                else
				sampSendChat('/r ����� ��������� ������������ ��������������� - '..sampGetPlayerNickname(id):gsub('_', ' ')..'. ����� ����������.')
            end
			else 
			ftext('����� � ������ ID �� ��������� � ������� ��� ������ ��� ID')
		end
		else 
			ftext('�������: /invite [id]')
		end
		else 
			ftext('������ ������� �������� � 9 �����')
	  end
   end)
 end
 
function uninvite(pam)
   lua_thread.create(function()
      local id, pri4ina = pam:match('(%d+)%s+(.+)')
      if rank == '������' or rank == '���.����.�����' or rank == '����.����' then
        if id and pri4ina then
		if sampIsPlayerConnected(id) then
                sampSendChat('/me ������(�) ������� � '..sampGetPlayerNickname(id):gsub('_', ' ')..'')
				wait(2000)
				sampSendChat(string.format('/uninvite %s %s', id, pri4ina))
				wait(2000)
				if cfg.main.tarb then
                sampSendChat(string.format('/r [%s]: '..sampGetPlayerNickname(id):gsub('_', ' ')..' - ������(�) �� ������� "%s".', cfg.main.tarr, pri4ina))
                else
				sampSendChat(string.format('/r '..sampGetPlayerNickname(id):gsub('_', ' ')..' - ������(�) �� ������� "%s".', pri4ina))
            end
			else 
			ftext('����� � ������ ID �� ��������� � ������� ��� ������ ��� ID')
		end
		else 
			ftext('�������: /uninvite [id] [�������]')
		end
		else 
			ftext('������ ������� �������� � 8 �����')
	 end
  end)
end
 
 function mediccmenu(args)
    return
    {
       {
        title = '{bf6868}� {13E83E}����������������.',
        onclick = function()
		sampSendChat("������������, ��� ��� ���������?") 
		end
      },
	  
	    {
        title = '{bf6868}� {13E83E}�����������.',
        onclick = function()
        sampSendChat("����� �������, �� ������ ������") 
		end
      },
	     {
        title = '{bf6868}� {13E83E}��������� �����',
        onclick = function()
        sampSendChat("����� ���������������� - 10.000$, �������� - 100.000$, ������� - 5.000$") 
		end
      },
	  
    }
end

function nawmenu(args)
    return
    {
      {
        title = '{ffffff}� ��������� ����� ��������',
        onclick = function()
		sampSendChat("/do �� ����� �������� ���.�����")
		wait(cfg.commands.zaderjka * 800) 
        sampSendChat(string.format('/me %s �������', cfg.main.male and '������' or '�������'))
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s �� ������ ����� � ��������', cfg.main.male and '������' or '�������'))   
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s ����� ��������� � %s � ���� �������������', cfg.main.male and '���������' or '����������', cfg.main.male and '������' or '��������'))
        wait(cfg.commands.zaderjka * 1000) 
        sampSendChat("/me ����� ������ ������ ����.")
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat("/do ������������ ������ � ����.")
		 wait(cfg.commands.zaderjka * 1200) 
        sampSendChat("�� ����������, � ��� �������� � �������.")
        wait(cfg.commands.zaderjka * 1000) 
        sampSendChat("������ �� �������� ��� � ��������, ��� ���������� � �������� ������� ������.") 
		wait(cfg.commands.zaderjka * 1000) 
		end
      }
    }
end

function saveData(table, path)
	if doesFileExist(path) then os.remove(path) end
    local sfa = io.open(path, "w")
    if sfa then
        sfa:write(encodeJson(table))
        sfa:close()
    end
end

function medicmenu(id)
    return
    { 
    {
        title = '{ffffff}� ���� ��������',
        onclick = function()
		local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
        sampSendChat("�������, ������ ������ ��� �������!")
		wait(cfg.commands.zaderjka * 800)
		sampSendChat("/do �� ����� �������� ���.�����")
		wait(cfg.commands.zaderjka * 500) 
		sampSendChat(string.format('/me %s �������', cfg.main.male and '������' or '�������'))
		wait(cfg.commands.zaderjka * 500) 
		sampSendChat(string.format('/me %s ����������� ��������', cfg.main.male and '�����' or '�����'))
		wait(cfg.commands.zaderjka * 500) 
		sampSendChat("/do ���������� � ����")
		wait(cfg.commands.zaderjka * 500) 
		sampSendChat(string.format('/me %s �������� ��������� � %s ������ �����', cfg.main.male and '�����' or '�����', cfg.main.male and '���' or '���a'))
		wait(cfg.commands.zaderjka * 500) 
		sampSendChat("/heal "..id)
		wait(cfg.commands.zaderjka * 500) 
		sampSendChat("�������� ���, �� �������!")                                        		
        end
      }
    }
end

function ystf()
    if not doesFileExist('moonloader/medicHELP/ystav.txt') then
        local file = io.open("moonloader/medicHELP/ystav.txt", "w")
        file:write(fpt)
        file:close()
        file = nil
    end
end

function getFraktionBySkin(playerid)
    fraks = {
        [0] = '�����������',
        [1] = '�����������',
        [2] = '�����������',
        [3] = '�����������',
        [4] = '�����������',
        [5] = '�����������',
        [6] = '�����������',
        [7] = '�����������',
        [8] = '�����������',
        [9] = '�����������',
        [10] = '�����������',
        [11] = '�����������',
        [12] = '�����������',
        [13] = '�����������',
        [14] = '�����������',
        [15] = '�����������',
        [16] = '�����������',
        [17] = '�����������',
        [18] = '�����������',
        [19] = '�����������',
        [20] = '�����������',
        [21] = 'Ballas',
        [22] = '�����������',
        [23] = '�����������',
        [24] = '�����������',
        [25] = '�����������',
        [26] = '�����������',
        [27] = '�����������',
        [28] = '�����������',
        [29] = '�����������',
        [30] = 'Rifa',
        [31] = '�����������',
        [32] = '�����������',
        [33] = '�����������',
        [34] = '�����������',
        [35] = '�����������',
        [36] = '�����������',
        [37] = '�����������',
        [38] = '�����������',
        [39] = '�����������',
        [40] = '�����������',
        [41] = 'Aztec',
        [42] = '�����������',
        [43] = '�����������',
        [44] = 'Aztec',
        [45] = '�����������',
        [46] = '�����������',
        [47] = 'Vagos',
        [48] = 'Aztec',
        [49] = '�����������',
        [50] = '�����������',
        [51] = '�����������',
        [52] = '�����������',
        [53] = '�����������',
        [54] = '�����������',
        [55] = '�����������',
        [56] = 'Grove',
        [57] = '�����',
        [58] = '�����������',
        [59] = '���������',
        [60] = '�����������',
        [61] = '�����',
        [62] = '�����������',
        [63] = '�����������',
        [64] = '�����������',
        [65] = '�����������', -- ��� ��������
        [66] = '�����������',
        [67] = '�����������',
        [68] = '�����������',
        [69] = '�����������',
        [70] = '���',
        [71] = '�����������',
        [72] = '�����������',
        [73] = 'Army',
        [74] = '�����������',
        [75] = '�����������',
        [76] = '�����������',
        [77] = '�����������',
        [78] = '�����������',
        [79] = '�����������',
        [80] = '�����������',
        [81] = '�����������',
        [82] = '�����������',
        [83] = '�����������',
        [84] = '�����������',
        [85] = '�����������',
        [86] = 'Grove',
        [87] = '�����������',
        [88] = '�����������',
        [89] = '�����������',
        [90] = '�����������',
        [91] = '�����������', -- ��� ��������
        [92] = '�����������',
        [93] = '�����������',
        [94] = '�����������',
        [95] = '�����������',
        [96] = '�����������',
        [97] = '�����������',
        [98] = '�����',
        [99] = '�����������',
        [100] = '������',
        [101] = '�����������',
        [102] = 'Ballas',
        [103] = 'Ballas',
        [104] = 'Ballas',
        [105] = 'Grove',
        [106] = 'Grove',
        [107] = 'Grove',
        [108] = 'Vagos',
        [109] = 'Vagos',
        [110] = 'Vagos',
        [111] = 'RM',
        [112] = 'RM',
        [113] = 'LCN',
        [114] = 'Aztec',
        [115] = 'Aztec',
        [116] = 'Aztec',
        [117] = 'Yakuza',
        [118] = 'Yakuza',
        [119] = 'Rifa',
        [120] = 'Yakuza',
        [121] = '�����������',
        [122] = '�����������',
        [123] = 'Yakuza',
        [124] = 'LCN',
        [125] = 'RM',
        [126] = 'RM',
        [127] = 'LCN',
        [128] = '�����������',
        [129] = '�����������',
        [130] = '�����������',
        [131] = '�����������',
        [132] = '�����������',
        [133] = '�����������',
        [134] = '�����������',
        [135] = '�����������',
        [136] = '�����������',
        [137] = '�����������',
        [138] = '�����������',
        [139] = '�����������',
        [140] = '�����������',
        [141] = 'FBI',
        [142] = '�����������',
        [143] = '�����������',
        [144] = '�����������',
        [145] = '�����������',
        [146] = '�����������',
        [147] = '�����',
        [148] = '�����������',
        [149] = 'Grove',
        [150] = '�����',
        [151] = '�����������',
        [152] = '�����������',
        [153] = '�����������',
        [154] = '�����������',
        [155] = '�����������',
        [156] = '�����������',
        [157] = '�����������',
        [158] = '�����������',
        [159] = '�����������',
        [160] = '�����������',
        [161] = '�����������',
        [162] = '�����������',
        [163] = 'FBI',
        [164] = 'FBI',
        [165] = 'FBI',
        [166] = 'FBI',
        [167] = '�����������',
        [168] = '�����������',
        [169] = 'Yakuza',
        [170] = '�����������',
        [171] = '�����������',
        [172] = '�����������',
        [173] = 'Rifa',
        [174] = 'Rifa',
        [175] = 'Rifa',
        [176] = '�����������',
        [177] = '�����������',
        [178] = '�����������',
        [179] = 'Army',
        [180] = '�����������',
        [181] = '������',
        [182] = '�����������',
        [183] = '�����������',
        [184] = '�����������',
        [185] = '�����������',
        [186] = 'Yakuza',
        [187] = '�����',
        [188] = '���',
        [189] = '�����������',
        [190] = 'Vagos',
        [191] = 'Army',
        [192] = '�����������',
        [193] = 'Aztec',
        [194] = '�����������',
        [195] = 'Ballas',
        [196] = '�����������',
        [197] = '�����������',
        [198] = '�����������',
        [199] = '�����������',
        [200] = '�����������',
        [201] = '�����������',
        [202] = '�����������',
        [203] = '�����������',
        [204] = '�����������',
        [205] = '�����������',
        [206] = '�����������',
        [207] = '�����������',
        [208] = 'Yakuza',
        [209] = '�����������',
        [210] = '�����������',
        [211] = '���',
        [212] = '�����������',
        [213] = '�����������',
        [214] = 'LCN',
        [215] = '�����������',
        [216] = '�����������',
        [217] = '���',
        [218] = '�����������',
        [219] = '���',
        [220] = '�����������',
        [221] = '�����������',
        [222] = '�����������',
        [223] = 'LCN',
        [224] = '�����������',
        [225] = '�����������',
        [226] = 'Rifa',
        [227] = '�����',
        [228] = '�����������',
        [229] = '�����������',
        [230] = '�����������',
        [231] = '�����������',
        [232] = '�����������',
        [233] = '�����������',
        [234] = '�����������',
        [235] = '�����������',
        [236] = '�����������',
        [237] = '�����������',
        [238] = '�����������',
        [239] = '�����������',
        [240] = '���������',
        [241] = '�����������',
        [242] = '�����������',
        [243] = '�����������',
        [244] = '�����������',
        [245] = '�����������',
        [246] = '������',
        [247] = '������',
        [248] = '������',
        [249] = '�����������',
        [250] = '���',
        [251] = '�����������',
        [252] = 'Army',
        [253] = '�����������',
        [254] = '������',
        [255] = 'Army',
        [256] = '�����������',
        [257] = '�����������',
        [258] = '�����������',
        [259] = '�����������',
        [260] = '�����������',
        [261] = '���',
        [262] = '�����������',
        [263] = '�����������',
        [264] = '�����������',
        [265] = '�������',
        [266] = '�������',
        [267] = '�������',
        [268] = '�����������',
        [269] = 'Grove',
        [270] = 'Grove',
        [271] = 'Grove',
        [272] = 'RM',
        [273] = '�����������', -- ���� ��������
        [274] = '���',
        [275] = '���',
        [276] = '���',
        [277] = '�����������',
        [278] = '�����������',
        [279] = '�����������',
        [280] = '�������',
        [281] = '�������',
        [282] = '�������',
        [283] = '�������',
        [284] = '�������',
        [285] = '�������',
        [286] = 'FBI',
        [287] = 'Army',
        [288] = '�������',
        [289] = '�����������',
        [290] = '�����������',
        [291] = '�����������',
        [292] = 'Aztec',
        [293] = '�����������',
        [294] = '�����������',
        [295] = '�����������',
        [296] = '�����������',
        [297] = 'Grove',
        [298] = '�����������',
        [299] = '�����������',
        [300] = '�������',
        [301] = '�������',
        [302] = '�������',
        [303] = '�������',
        [304] = '�������',
        [305] = '�������',
        [306] = '�������',
        [307] = '�������',
        [308] = '���',
        [309] = '�������',
        [310] = '�������',
        [311] = '�������'
    }
    if sampIsPlayerConnected(playerid) then
        local result, handle = sampGetCharHandleBySampPlayerId(playerid)
        local skin = getCharModel(handle)
        return fraks[skin]
    end
end

function update()
	local fpath = os.getenv('TEMP') .. '\\update.json'
	downloadUrlToFile('https://raw.githubusercontent.com/L-Barton/Medichelper/master/updatemedic.json', fpath, function(id, status, p1, p2)
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            local f = io.open(fpath, 'r')
            if f then
			    local info = decodeJson(f:read('*a'))
                updatelink = info.updateurl
                updlist1 = info.updlist
				updversion = info.latest
                ttt = updlist1
			    if info and info.latest then
                    version = tonumber(info.latest)
                    if version > tonumber(thisScript().version) then
                        ftext('���������� ���������� �� ������ '..updversion..'.')
					    updwindows.v = f
                    else
                        ftext('���������� ������� �� ����������. �������� ����.', -1)
                        update = false
				    end
			    end
		    end
	    end
    end)
end


function smsjob()
  if rank == '��������' or rank == '������' or rank == '���.����.�����' or rank == '����.����' then
    lua_thread.create(function()
        vixodid = {}
		status = true
		sampSendChat('/members')
        while not gotovo do wait(0) end
        wait(1200)
        for k, v in pairs(vixodid) do
            sampSendChat('/sms '..v..' �� ������')
            wait(1200)
        end
        players2 = {'{ffffff}���\t{ffffff}����\t{ffffff}������'}
		players1 = {'{ffffff}���\t{ffffff}����'}
		gotovo = false
        status = false
        vixodid = {}
	end)
	else 
	ftext('������ ������� �������� � 7 �����')
	end
end

function goupdate()
    ftext('�������� ���������� ����������. ������ �������������� ����� ���� ������.', -1)
    wait(300)
    downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23)
    if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
        showCursor(false)
	    thisScript():reload()
    end
end)
end

function cmd_color() -- ������� ��������� ����� ������, �� ����� ��� ���, �� ����� �� ����
	local text, prefix, color, pcolor = sampGetChatString(99)
	sampAddChatMessage(string.format("���� ��������� ������ ���� - {934054}[%d] (���������� � ����� ������)",color),-1)
	setClipboardText(color)
end

function getcolor(id)
local colors = 
        {
		[1] = '������',
		[2] = '������-������',
		[3] = '����-������',
		[4] = '���������',
		[5] = 'Ƹ���-������',
		[6] = '�����-������',
		[7] = '����-������',
		[8] = '�������',
		[9] = '����-�������',
		[10] = '���������',
		[11] = '����������',
		[12] = 'Ҹ���-�������',
		[13] = '����-�������',
		[14] = 'Ƹ���-���������',
		[15] = '���������',
		[16] = '�������',
		[17] = '�����',
		[18] = '�������',
		[19] = '����� �����',
		[20] = '����-������',
		[21] = 'Ҹ���-�����',
		[22] = '����������',
		[23] = '������',
		[24] = '����-�����',
		[25] = 'Ƹ����',
		[26] = '����������',
		[27] = '�������',
		[28] = '������ ������',
		[29] = '���������',
		[30] = '�����',
		[31] = '�������',
		[32] = '������',
		[33] = '�����',
		}
	return colors[id]
end

function sampev.onSendSpawn()
    pX, pY, pZ = getCharCoordinates(playerPed)
    if cfg.main.clistb and getDistanceBetweenCoords3d(pX, pY, pZ, 2337.3574,1666.1699,3040.9524) < 20 then
        lua_thread.create(function()
            wait(1200)
			sampSendChat('/clist '..tonumber(cfg.main.clist))
			wait(500)
			local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
			local color = ("%06X"):format(bit.band(sampGetPlayerColor(myid), 0xFFFFFF))
			colors = getcolor(cfg.main.clist)
            ftext('���� ���� ������ ��: {'..color..'}'..cfg.main.clist..' ['..colors..']')
        end)
    end
end

function sampev.onServerMessage(color, text)
        if text:find('������� ���� �����') and color ~= -1 then
        if cfg.main.clistb then
		if rabden == false then
            lua_thread.create(function()
                wait(100)
				sampSendChat('/clist '..tonumber(cfg.main.clist))
				wait(1000)
				ftext('�� ��������� ��������� TimeCard ������ ��� � 9:00 �� 20:00, ��� �����!')
				wait(1000)
                local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
			    local color = ("%06X"):format(bit.band(sampGetPlayerColor(myid), 0xFFFFFF))
                colors = getcolor(cfg.main.clist)
                ftext('���� ���� ������ ��: {'..color..'}'..cfg.main.clist..' ['..colors..']')
                rabden = true
				wait(1000)
				if cfg.main.clisto then
				local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
                local myname = sampGetPlayerNickname(myid)
				if cfg.main.male == true then
				sampSendChat("/me ������ �������")
                wait(1500)
                sampSendChat("/me ���� ���� ������, ����� ���� ������ �� � ����")
                wait(1500)
                sampSendChat("/me ���� ������� ������, ����� ���������� � ���")
                wait(1500)
                sampSendChat("/me ������� ������� �� �������")
                wait(1500)
                sampSendChat('/do �� ������� ������� � �������� "'..rank..' | '..myname:gsub('_', ' ')..'".')  
				end
				if cfg.main.male == false then
				sampSendChat("/me ������� �������")
                wait(1500)
                sampSendChat("/me ����� ���� ������, ����� ���� ������� �� � ����")
                wait(1500)
                sampSendChat("/me ����� ������� ������, ����� ����������� � ���")
                wait(1500)
                sampSendChat("/me �������� ������� �� �������")
                wait(1500)
                sampSendChat('/do �� ������� ������� � �������� "'..rank..' | '..myname:gsub('_', ' ')..'".')
				end
			end
            end)
        end
	  end
    end
	if text:find('SMS:') and text:find('�����������:') then
		wordsSMS, nickSMS = string.match(text, 'SMS: (.+) �����������: (.+)');
		local idsms = nickSMS:match('.+%[(%d+)%]')
		lastnumber = idsms
	end
    if text:find('������� ���� �������') and color ~= -1 then
        rabden = false
    end
	if color == -8224086 then
        local colors = ("{%06X}"):format(bit.rshift(color, 8))
        table.insert(departament, os.date(colors.."[%H:%M:%S] ") .. text)
    end
	if statusc then
		if text:match('ID: .+ | .+: .+ %- .+') and not fstatus then
			gosmb = true
			local id, nick, rang, stat = text:match('ID: (%d+) | (.+): (.+) %- (.+)')
			local color = ("%06X"):format(bit.band(sampGetPlayerColor(id), 0xFFFFFF))
		    src_good = ""
            src_bad = ""
			local _, myid = sampGetPlayerIdByCharHandle(playerPed)
			local _, handle = sampGetCharHandleBySampPlayerId(id)
			local myname = sampGetPlayerNickname(myid)
				if doesCharExist(handle) then
					local x, y, z = getCharCoordinates(handle)
					local mx, my, mz = getCharCoordinates(PLAYER_PED)
					local dist = getDistanceBetweenCoords3d(mx, my, mz, x, y, z)
					
					if dist <= 50 then
						src_good = src_good ..sampGetPlayerNickname(id).. ""
					end
					else
						src_bad = src_bad ..sampGetPlayerNickname(id).. ""
			if src_bad ~= myname then
			table.insert(players3, string.format('{'..color..'}%s[%s]{ffffff}\t%s\t%s', src_bad, id, rang, stat))
			return false
		end
		end
		end
		if text:match('�����: %d+ �������') then
			local count = text:match('�����: (%d+) �������')
			gcount = count
			gotovo = true
			return false
		end
		if color == -1 then
			return false
		end
		if color == 647175338 then
			return false
        end
        if text:match('ID: .+ | .+: .+') and not fstatus then
			krimemb = true
			local id, nick, rang = text:match('ID: (%d+) | (.+): (.+)')
			local color = ("%06X"):format(bit.band(sampGetPlayerColor(id), 0xFFFFFF))
			table.insert(players1, string.format('{'..color..'}%s[%s]{ffffff}\t%s', nick, id, rang))
			return false
        end
    end
	if status then
		if text:match('ID: .+ | .+ | .+: .+ %- .+') and not fstatus then
			gosmb = true
			local id, data, nick, rang, stat = text:match('ID: (%d+) | (.+) | (.+): (.+) %- (.+)')
			local color = ("%06X"):format(bit.band(sampGetPlayerColor(id), 0xFFFFFF))
			local nmrang = rang:match('.+%[(%d+)%]')
            if stat:find('��������') and tonumber(nmrang) < 7 then
                table.insert(vixodid, id)
            end
			table.insert(players2, string.format('{ffffff}%s\t {'..color..'}%s[%s]{ffffff}\t%s\t%s', data, nick, id, rang, stat))
			return false
		end
		if text:match('�����: %d+ �������') then
			local count = text:match('�����: (%d+) �������')
			gcount = count
			gotovo = true
			return false
		end
		if color == -1 then
			return false
		end
		if color == 647175338 then
			return false
        end
        if text:match('ID: .+ | .+: .+') and not fstatus then
			krimemb = true
			local id, nick, rang = text:match('ID: (%d+) | (.+): (.+)')
			local color = ("%06X"):format(bit.band(sampGetPlayerColor(id), 0xFFFFFF))
			table.insert(players1, string.format('{'..color..'}%s[%s]{ffffff}\t%s', nick, id, rang))
			return false
        end
    end
end

function kvadrat()
    local KV = {
        [1] = "�",
        [2] = "�",
        [3] = "�",
        [4] = "�",
        [5] = "�",
        [6] = "�",
        [7] = "�",
        [8] = "�",
        [9] = "�",
        [10] = "�",
        [11] = "�",
        [12] = "�",
        [13] = "�",
        [14] = "�",
        [15] = "�",
        [16] = "�",
        [17] = "�",
        [18] = "�",
        [19] = "�",
        [20] = "�",
        [21] = "�",
        [22] = "�",
        [23] = "�",
        [24] = "�",
    }
    local X, Y, Z = getCharCoordinates(playerPed)
    X = math.ceil((X + 3000) / 250)
    Y = math.ceil((Y * - 1 + 3000) / 250)
    Y = KV[Y]
    local KVX = (Y.."-"..X)
    return KVX
end
