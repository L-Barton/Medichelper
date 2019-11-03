script_name('Medic HELP')
script_version('1.1')
script_author('Evelyn_Ross')
local sf = require 'sampfuncs'
local key = require "vkeys"
local inicfg = require 'inicfg'
local sampev = require 'lib.samp.events'
local imgui = require 'imgui' -- загружаем библиотеку
local encoding = require 'encoding' -- загружаем библиотеку
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
local tCarsTypeName = {"Автомобиль", "Мотоицикл", "Вертолёт", "Самолёт", "Прицеп", "Лодка", "Другое", "Поезд", "Велосипед"}
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
encoding.default = 'CP1251' -- указываем кодировку по умолчанию, она должна совпадать с кодировкой файла. CP1251 - это Windows-1251
u8 = encoding.UTF8
require 'lib.sampfuncs'
seshsps = 1
govtime = "1"
ctag = "Medic HELP {ffffff}»"
players1 = {'{ffffff}Ник\t{ffffff}Ранг'}
players2 = {'{ffffff}Дата принятия\t{ffffff}Ник\t{ffffff}Ранг\t{ffffff}Статус'}
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

function apply_custom_style() -- паблик дизайн андровиры, который юзался в скрипте ранее

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
    tar = 'Стажер',
	tarr = 'тэг',
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
    ftext("Medic HELP успешно загружен. Введите: /moh для открытия основного меню", -1)
  end
  if not doesDirectoryExist('moonloader/config/medicHELP/') then createDirectory('moonloader/config/medicHELP/') end
  if cfg == nil then
    sampAddChatMessage("{E66E6E}Medic HELP {ffffff}» Отсутсвует файл конфига, создаем.", -1)
    if inicfg.save(medicHELP, 'medicHELP/config.ini') then
      sampAddChatMessage("{E66E6E}Medic HELP {ffffff}» Файл конфига успешно создан.", -1)
      cfg = inicfg.load(nil, 'medicHELP/config.ini')
    end
  end
  if not doesDirectoryExist('moonloader/lib/imcustom') then createDirectory('moonloader/lib/imcustom') end
  for k, v in pairs(libs) do
        if not doesFileExist('moonloader/lib/'..v) then
            downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/lib/'..v, getWorkingDirectory()..'\\lib\\'..v)
            print('Загружается библиотека '..v)
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
  local frakc = proverkk:match('.+Организация%:%s+(.+)%s+Ранг')
  local rang = proverkk:match('.+Ранг%:%s+(.+)%s+Работа')
  local telephone = proverkk:match('.+Телефон%:%s+(.+)%s+Законопослушность')
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
                ftext('По завершению введите команду еще раз.')
            else
                changetextpos = false
				inicfg.save(cfg, 'medicHELP/config.ini') -- сохраняем все новые значения в конфиге
				ftext('Вы успешно изменили местоположение HUD-Бара.')
            end
        else
            ftext('Для начала включите инфо-бар.')
        end
    end)
  sampRegisterChatCommand('yst', function() ystwindow.v = not ystwindow.v end)
  while true do wait(0)
  datetime = os.date("!*t",os.time()) 
if datetime.min == 00 and datetime.sec == 10 then 
sampAddChatMessage("{BF6868}Не забудь оставить {BF6868}TimeCard {F80505}на форуме.", -1) 
sampAddChatMessage("{BF6868}От этого зависит твоё {0CF513}повышение {BF6868}и повышение коллег!", -1)
sampAddChatMessage("{BF6868}И еще не забывай про {0CF513}личное дело.", -1)
sampAddChatMessage("{BF6868}Нет личного дела - {0CF513}нет повышения!", -1)
wait(1000)
wait(1000)
end
    if #departament > 25 then table.remove(departament, 1) end
    if cfg == nil then
      sampAddChatMessage("{E66E6E}Medic HELP {ffffff}» Отсутсвует файл конфига, создаем.", -1)
      if inicfg.save(medicHELP, 'medicHELP/config.ini') then
        sampAddChatMessage("{E66E6E}Medic HELP {ffffff}» Файл конфига успешно создан.", -1)
        cfg = inicfg.load(nil, 'medicHELP/config.ini')
      end
    end
	    local myhp = getCharHealth(PLAYER_PED)
        local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
    if wasKeyPressed(cfg.keys.fastmenu) and not sampIsDialogActive() and not sampIsChatInputActive() then
	if frac == 'Hospital' then
    submenus_show(fastmenu(id), "{E66E6E}Medic HELP {ffffff}» Быстрое меню")
	else
	ftext('Возможно вы не состоите в MOH {ff0000}[ctrl+R]')
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
                submenus_show(pkmmenu(id), "{E66E6E}Medic HELP {ffffff}» {"..color.."}"..sampGetPlayerNickname(id).."["..id.."] {ffffff}Уровень - "..sampGetPlayerScore(id).." ")
				else
			ftext('Возможно вы не состоите в MOH {ff0000}[ctrl+R]')
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

РАЗДЕЛ 1. ОБЩИЕ ПОЛОЖЕНИЯ

1.1 Устав представляет собой свод правил, который обязателен к исполнению всеми сотрудниками организации.
1.2 Весь перечень правил, обусловленных в уставе, составлен исходя из необходимости контроля за сотрудниками.
1.3 Большая часть пунктов данного устава направлена на поддержание внутреннего порядка.
1.4 Данный устав не перечит законам штата, в том числе Конституции и Уголовному Кодексу.
1.5 Руководитель в лице Глав.Врача может добавить правки в действующий устав, не нарушая его целостности. Все изменения в уставе в кратчайшие сроки должны быть переданы сотрудникам организации для ознакомления.
1.6 Нарушение пунктов устава карается по всей строгости вне зависимости от должности сотрудника организации.
1.7 Руководитель в лице Глав.Врача также не может нарушать установленный перечень правил, так как является лицом организации.

РАЗДЕЛ 2. ОБЯЗАННОСТИ СОТРУДНИКОВ

2.1 Вся работа сотрудников Минздрава основана на помощи нуждающимся, невзирая на его социальный статус, половой признак, национальность.
2.2 Каждый сотрудник обязан знать свои обязанности и выполнять их безупречно.
2.3 Сотрудники обязаны знать Законы Штата, свои конституционные права, Уголовный Кодекс, Административный Кодекс.
2.4 Каждый сотрудник обязан беспрекословно подчиняться старшему персоналу и главам отдела, в которого состоят.
2.5 Все сотрудники обязаны следить за состоянием транспорта, который используют, а также за состоянием бака.
2.6 Все вызовы от граждан принимаются незамедлительно, а также необходимо оповещать о выезде на вызов.
2.7 Обязанности по должностям:
- Интерн: На данной должности сотрудник обязан проходить обучение у старшего персонала. При наличии опыта и с разрешения старшего персонала разрешается занять определенный пост.
- Санитар: На данной должности сотрудник, уже прошедший азы работы, может выдвигаться на выбранный пост для оказания на нём мед.помощи нуждающимся, а также находиться в патруле одного из городов. Находясь на посту сотрудник обязан также принимать вызовы и выезжать на них.
- Мед.брат: Сотрудник, имеющий данную должность, может выполнять патруль как определенного города, так и всего штата с соответствующим докладом. Также данные сотрудники помогают санитарам и интернам в освоении в организации.
- Спасатель: При получении данной должности сотрудники могут работать на возникающих ЧС в штате. Также могут находиться на регистратуре одной из больниц, если основные посты заняты другими сотрудниками.
- Нарколог: С данной должностью повышается ответственность, так как наркологи работают с пациентами, которые борются с зависимостью. Главной и самой важной обязанностью является приём граждан с зависимостью и профессиональная помощь. Также наркологи работают на призывных пунктах, выявляя призывников, не прошедших курсы реабилитации.
- Доктор: Должность приближенная к старшему персоналу. В обязанности входит выполнение выше перечисленного, а также работа с младшим персоналом и помощь старшему персоналу в проведении тех или иных мероприятий.
- Психолог: Первая ступень старшего персонала. Отвечает за дисциплину в коллективе, проверяет сотрудников на проф.пригодность для дальнейшего продвижения по карьерной лестнице, фиксирует нарушения.
- Хирург: Аналогично Психологу следит за персоналом, а также имеет полномочия применять санкции к персоналу вплоть до увольнения, помогает Заместителю Глав.Врача и Глав.Врачу при отборе будущих сотрудников.
- Заместитель Глав.Врача: Правая рука Руководителя. Полностью выполняет обязанности Руководителя в его отсутствие, координирует работу сотрудников и отделов. Занимается кадровыми вопросами.

РАЗДЕЛ 3. РАБОЧИЙ ГРАФИК

3.1 Рабочий график обусловлен данным разделом. Самовольное завершение рабочего дня или прогул влекут за собой соответствующие санкции, описанные в разделе 
3.2 Рабочий день в будние дни начинается с 9 утра и продолжается до 8 вечера, в выходные - с 10 утра до 7 вечера.
3.3 Любой сотрудник по окончанию рабочего дня имеет право продолжить свою работу.
3.4 Если работник по окончанию рабочего дня остаётся в форме, то обязан продолжить работу. В случае, если не хочет, обязан снять форму и может заниматься своими делами.
3.5 Каждый сотрудник имеет право на обеденный перерыв c 12:00 до 13:00.
3.6 Сотрудник может отсутствовать на работе не более 15 минут. Исключение: получение на отсутствие в течение длительного времени от старшего персонала.
3.7 Во время ЧС старший персонал имеет право вызвать на работу сотрудников, которые не вправе отказать в явке.
3.8 Отдых разрешен исключительно в ординаторской и не более 20 минут в час с предварительным оповещением в рацию.

РАЗДЕЛ 4. ОБЩЕНИЕ/ИСПОЛЬЗОВАНИЕ РАЦИИ

4.1 Все сотрудники обязаны обращаться к гражданам и своим коллегам строго на Вы. Исключение в том случае, если собеседник не против иного обращения.
4.2 При обращении к коллегам не используется слово Товарищ. Обращение идёт строго по фамилии с уточнением должности. Пример: Психолог Лобанов.
4.3 Социальный статус, внешний вид, половой признак, раса и другие факторы не должны влиять на разговор с пациентом. Перед сотрудником все равны.
4.4 При заступлении на работу обязателен запрос свободного поста в рацию.
4.5 На волне рации Минздрава необходимо вещать только информацию по работе и ничего более.
4.6 Волна департамента доступна сотрудникам с должности Мед.брат.
4.7 При использовании волны департамента необходимо соблюдать общие правила.
4.8 На волне рации запрещено: спорить, оскорблять кого-то, использовать нецензурную лексику.


РАЗДЕЛ 5. ТРАНСПОРТ

5.1 Весь транспортный парк Минздрава распределяется между сотрудниками с учетом их должностей.
5.2 Каждый сотрудник, использующий транспорт, отвечает за его целостность и работоспособность, а также за состояние бака.
5.3 Автомобиль марки Stratum разрешено использовать с должности Мед.брат.
5.4 Воздушный транспорт Maverick разрешено использовать сотрудникам с должности Психолог, но при наличии разрешения старшего персонала и лицензии на пилота.
5.5 Спец.сигналы на карете скорой помощи разрешено использовать только в случае вызова или госпитализации пациента.
5.6 Нарушить ПДД разрешается только в том случае, если сотрудник едет на вызов с включенным спец.сигналом.
5.7 Парковать транспорт Минздрава необходимо в специально отведенных для этого местах.

РАЗДЕЛ 6. УНИФОРМА/БЕЙДЖИКИ

6.1 Для соблюдения порядка сотрудники обязаны носить специальную униформу.
6.2 Униформа меняется исходя из должности сотрудника.
6.3 Униформа предоставляется как для мужчин, так и для женщин. 
6.4 Каждый сотрудник обязан носить бейдж, прикрепленный к форме.
С Интерна до Мед.брата, сотрудник обязан носить бейджик - 13.
С Мед.брата до Нарколога, сотрудник обязан носить бейджик - 31.
С Нарколога до Доктора, сотрудник обязан носить бейджик - 19.
С должности Психолог, сотрудники обязаны носить бейджик - 8
6.5 Бейджики могут различаться в зависимости от должности и выбранного отдела.

РАЗДЕЛ 7. ОТПУСК/НЕАКТИВ

7.1 Отпуск предоставляется сотрудникам, которые находятся в Минздраве длительное время и хотят отдохнуть.
7.2 Сотрудники, достигшие должности Спасатель и выше, могут оставить заявление на отпуск в соответствующем разделе.
7.3 Отпуск предоставляется только на 7 календарных дней.
7.4 В отпуске сотрудник имеет право работать на государственных работах, в СМИ, юристом.
7.5 Сотрудники, достигшие должности Спасатель и выше, могут оставить заявление на неактив в соответствующем разделе.

РАЗДЕЛ 8. САМООБОРОНА

8.1 Запрещено ношение оружия в любых целях.
8.2 Разрешено пользоваться перцовым баллончиком, который можно приобрести в магазине 24-7.
8.3 Применять перцовый баллончик разрешено только в целях самообороны.
8.4 Пользоваться перцовым баллончиком разрешено сотрудникам с должности Мед.брат.
8.5 Запрещено применять перцовый баллончик против нарушителя с огнестрельным оружием.


РАЗДЕЛ 9. АКСЕССУАРЫ

9.1 Разрешенные аксессуары.

1. РЕТРО ШЛЯПЫ.
Classic Hat

2. ШЛЯПЫ МАФИОЗИ.
Black Mafiosi Hat
Light Mafiosi Hat
Turquoise Mafiosi Hat
Cherry Mafiosi Hat
Yellow Mafiosi Hat
Green Mafiosi Hat

3.ШЛЯПЫ ШЕРИФА
Dark Hat
Brown Hat
Black sheriff's Hat
Red sheriff's Hat
Brown sheriff's Hat

4. ШЛЯПЫ ЦИЛИНДР.
Cross Cylinder Hat
Crozny Cylinder Hat

5. НОВОГОДНИЕ ШАПКИ / ПОДАРКИ.
Примечание: Разрешается надевать в преддверии Нового года. 

6. БЕРЕТЫ.
Red Beret
Dark Beret
Blue Beret
Color Beret

7. КОВБОЙСКАЯ ШЛЯПА.
Cowboy Hat

8. КЕПКИ.
White Cap
Red Cap
Yellow Cap
Lemon Cap

9.РЮКЗАКИ.
Blue Backpack

10. ОЧКИ.
Примечание: Запрещено носить очки: Hypnosis Classes, Simple eyes Classes, Simple race Classes, X-Ray Classes

11. ЧАСЫ.
Разрешены часы любого формата. 

12. ЧЕМОДАН
Suitcase

ЗАМЕТКА: Аксессуары которые не вошли в список, носить запрещено!
За нарушение формы одежды, будет выдаваться выговор. 


РАЗДЕЛ 10. САНКЦИИ ЗА НАРУШЕНИЯ

9.1 Выговоры - это предупреждения, получаемые сотрудником за не столь серьёзные нарушения, но рецидив которых может привести к увольнению ( подробнее тут ).
9.1.1 Нарушения, за которые сотрудник может получить выговор:
1. Отсутствие на работе более 15 минут
2. Отказ в оказании мед.помощи гражданину из личной неприязни.
3. Хранение наркотических веществ. Дополнение: После выдачи выговора обязательная сдача веществ сотрудникам полиции.
4. Сон в неположенном месте.
5. Неподчинение старшему персоналу (Психолог и выше / Глава отдела)
6. Нарушение правил парковки у Госпиталей.
7. Использование транспорта организации в личных целях.
8. Использование спец.сигналов с целью нарушения ПДД.
9. Использование униформы и бейджа не по должности.
10. Использование женской униформы мужчинами.
11. Самовольное завершение рабочего дня.
12. Ношение не подходящих к форме сотрудника аксессуаров (коробки, портфели, несуразные очки, шлемы, маски, ёлки, шапка петуха, бургерная шапка, шляпы полицейских, банданы)
9.2 Понижение в должности - санкция за нарушение, применяемая при рецидивах не столь серьёзных нарушений и нарушений средней тяжести.
9.2.1 Нарушения, за которые сотрудник может получить понижение в должности:
1. Получение 2-х активных выговоров в течение 7 календарных дней.
2. Отсутствие на работе более 30 минут (рецидив пункта 9.1.2/1)
3. Отказ в оказании мед.помощи гражданину из личной неприязни (рецидив пункта 9.1.2/2)
9.3 Увольнение - санкция за нарушение, применяемая при серьёзных нарушениях устава, законов штата.
9.3.1 Нарушения, за которые сотрудник может получить увольнение:
1. Получение 3-х активных выговоров в течение 7 календарных дней.
2. Отсутствие на рабочем месте в течение 1 часа.
3. Отказ от выхода на работу.
4. Использование нецензурной лексики.
5. Оскорбления.
6. Длительный сон в неположенном месте (рецидив пункта 9.1.2/4)
7. Неподчинение старшему персоналу (рецидив 9.1.2/5)
8. Выяснение отношений на волне Минздрава или Департамента.
9. Реклама любого вида на волне Минздрава или Департамента. Исключение: реклама услуг нарколога/психолога.
10. Использование униформы и бейджа не по должности (рецидив пункта 9.1.2/9)
11. Отказ от смены формы, надетой не в соответствии с должностью.
12. Использование женской униформы мужчинам (рецидив пункта 9.1.2/10)
13. Ношение оружия в открытом виде.
14. Использование перцового баллончика не по назначению.
9.4 Внесение в Чёрный список - самая строгая мера наказания.
9.4.1 Нарушения, за которые сотрудник вносится в Чёрный список:
1. Грубые оскорбления.
2. Введение в заблуждение начальства.
3. Создание конфликтных ситуаций между сотрудниками.
4. Подстава сотрудников.
5. Увольнение в первый день трудоустройства.
]]

function dmb()
	lua_thread.create(function()
		status = true
		players2 = {'{ffffff}Дата принятия\t{ffffff}Ник\t{ffffff}Ранг\t{ffffff}Статус'}
		players1 = {'{ffffff}Ник\t{ffffff}Ранг'}
		sampSendChat('/members')
		while not gotovo do wait(0) end
		if gosmb then
			sampShowDialog(716, "{ffffff}В сети: "..gcount.." | {ae433d}Организация | {ffffff}Time: "..os.date("%H:%M:%S"), table.concat(players2, "\n"), "x", _, 5) -- Показываем информацию.
		elseif krimemb then
			sampShowDialog(716, "{ffffff}В сети: "..gcount.." | {ae433d}Организация | {ffffff}Time: "..os.date("%H:%M:%S"), table.concat(players1, "\n"), "x", _, 5) -- Показываем информацию.
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
if rank == 'Психолог' or rank == 'Хирург' or rank == 'Зам.Глав.Врача' or rank == 'Глав.Врач' then
  if id == nil then
    sampAddChatMessage("{E66E6E}Medic HELP {ffffff}» Введите: /vig [id] [причина]", -1)
  end
  if id ~=nil and not sampIsPlayerConnected(id) then
    sampAddChatMessage("{E66E6E}Medic HELP {ffffff}» Игрок с ID: "..id.." не подключен к серверу.", -1)
  end
  if id ~= nil and sampIsPlayerConnected(id) then
      if pric == nil then
        sampAddChatMessage("{E66E6E}Medic HELP {ffffff}» /vig [id] [причина]", -1)
      end
      if pric ~= nil then
	   if cfg.main.tarb then
        name = sampGetPlayerNickname(id)
        rpname = name:gsub('_', ' ')
        sampSendChat(string.format("/r [%s]: %s - Получает выговор по причине: %s.", cfg.main.tarr, rpname, pric))
		else 
		name = sampGetPlayerNickname(id)
        rpname = name:gsub('_', ' ')
		sampSendChat(string.format("/r %s - Получает выговор по причине: %s.", rpname, pric))
      end
  end
end
end
end

function where(params) -- запрос местоположения
   if rank == 'Психолог' or rank == 'Хирург' or rank == 'Зам.Глав.Врача' or rank == 'Глав.Врач' then
	if params:match("^%d+") then
		params = tonumber(params:match("^(%d+)"))
		if sampIsPlayerConnected(params) then
			local name = string.gsub(sampGetPlayerNickname(params), "_", " ")
			 if cfg.main.tarb then
			    sampSendChat(string.format("/r [%s]: %s, доложите свое местоположение. На ответ 20 секунд.", cfg.main.tarr, name))
			else
			sampSendChat(string.format("/r %s, доложите свое местоположение. На ответ 20 секунд.", name))
			end
			else
			ftext('{FFFFFF} Игрок с данным ID не подключен к серверу или указан ваш ID.', 0x046D63)
		end
		else
		ftext('{FFFFFF} Используйте: /where [ID].', 0x046D63)
		end
		else
		ftext('{FFFFFF}Данная команда доступна с 7 ранга.', 0x046D63)
	end
end

        
function blag(pam)
    local id, frack, pric = pam:match('(%d+) (%a+) (.+)')
    if id and frack and pric and sampIsPlayerConnected(id) then
        name = sampGetPlayerNickname(id)
        rpname = name:gsub('_', ' ')
        sampSendChat(string.format("/d %s, благодарю %s за %s. Цените!", frack, rpname, pric))
    else
        ftext("Введите: /blag [id] [Фракция] [Причина]", -1)
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
		players3 = {'{ffffff}Ник\t{ffffff}Ранг\t{ffffff}Статус'}
		sampSendChat('/members')
		while not gotovo do wait(0) end
		if gosmb then
			sampShowDialog(716, "{E66E6E}Medic HELP {ffffff}» {ae433d}Сотрудники вне офиса {ffffff}| Time: "..os.date("%H:%M:%S"), table.concat(players3, "\n"), "x", _, 5) -- Показываем информацию.
		end
		gosmb = false
		krimemb = false
		gotovo = false
		statusc = false
	end)
end

function dlog()
    sampShowDialog(97987, '{E66E6E}Medic HELP {ffffff} | Лог сообщений департамента', table.concat(departament, '\n'), '»', 'x', 0)
end

function getrang(rangg)
local ranks = 
        {
		['1'] = 'Интерн',
		['2'] = 'Санитар',
		['3'] = 'Мед.брат',
		['4'] = 'Спасатель',
		['5'] = 'Нарколог',
		['6'] = 'Доктор',
		['7'] = 'Психолог',
		['8'] = 'Хирург',
		['9'] = 'Зам.Глав.Врача',
		['10'] = 'Глав.Врач'
		}
	return ranks[rangg]
end



function giverank(pam)
    lua_thread.create(function()
    local id, rangg, plus = pam:match('(%d+) (%d+)%s+(.+)')
	if sampIsPlayerConnected(id) then
	  if rank == 'Психолог' or rank == 'Хирург' or rank == 'Зам.Глав.Врача' or rank == 'Глав.Врач' then
        if id and rangg then
		if plus == '-' or plus == '+' then
		ranks = getrang(rangg)
		        local _, handle = sampGetCharHandleBySampPlayerId(id)
				if doesCharExist(handle) then
				local x, y, z = getCharCoordinates(handle)
				local mx, my, mz = getCharCoordinates(PLAYER_PED)
				local dist = getDistanceBetweenCoords3d(mx, my, mz, x, y, z)	
				if dist <= 5 then
				sampSendChat('/me снял старый бейджик с человека напротив стоящего')
				wait(1500)
				sampSendChat('/me убрал старый бейджик в карман')
				wait(1500)
                sampSendChat(string.format('/me %s новый бейджик %s', cfg.main.male and 'достал' or 'достала', ranks))
				wait(1500)
				sampSendChat('/me закрепил на рубашку человеку напротив новый бейджик')
				wait(1500)
				else
				sampSendChat('/me сняла старый бейджик с человека напротив стоящего')
				wait(1500)
				sampSendChat('/me убрала старый бейджик в карман')
				wait(1500)
                sampSendChat(string.format('/me %s новый бейджик %s', cfg.main.male and 'достал' or 'достала', ranks))
				wait(1500)
				sampSendChat('/me закрепила на рубашку человеку напротив новый бейджик')
				wait(1500)
				end
				end
				sampSendChat(string.format('/giverank %s %s', id, rangg))
				wait(1500)
				if cfg.main.tarb then
                sampSendChat(string.format('/r [%s]: '..sampGetPlayerNickname(id):gsub('_', ' ')..' - %s в должности до %s%s.', cfg.main.tarr, plus == '+' and 'Повышен(а)' or 'Понижен(а)', ranks, plus == '+' and ', поздравляю' or ''))
                else
				sampSendChat(string.format('/r '..sampGetPlayerNickname(id):gsub('_', ' ')..' - %s в должности до %s%s.', plus == '+' and 'Повышен(а)' or 'Понижен(а)', ranks, plus == '+' and ', поздравляю' or ''))
            end
			else 
			ftext('Вы ввели неверный тип [+/-]')
		end
		else 
			ftext('Введите: /giverank [id] [ранг] [+/-]')
		end
		else 
			ftext('Данная команда доступна с 7 ранга')
	  end
	  else 
			ftext('Игрок с данным ID не подключен к серверу или указан ваш ID')
	  end
   end)
 end
   
function nick(args)
  if #args == 0 then ftext("Введите: /cnick [id] [0 - RP nick, 1 - NonRP nick]") return end
  args = string.split(args, " ")
  if #args == 1 then
    cmd_nick(args[1].." 0")
  elseif #args == 2 then
    local getID = tonumber(args[1])
    if getID == nil then ftext("Неверный ID игрока!") return end
    if not sampIsPlayerConnected(getID) then ftext("Игрок оффлайн!") return end 
    getID = sampGetPlayerNickname(getID)
    if tonumber(args[2]) == 1 then
      ftext("Ник \""..getID.."\" успешно скопирован в буфер обмена.")
    else
      getID = string.gsub(getID, "_", " ")
      ftext("РП Ник \""..getID.."\" успешно скопирован в буфер обмена.")
    end
    setClipboardText(getID)
  else
    ftext("Введите: /cnick [id] [0 - RP nick, 1 - NonRP nick]")
    return
  end 
end

function fastmenu(id)
 return
{
  {
   title = "{FFFFFF}Меню {E66E6E}лекций",
    onclick = function()
	submenus_show(fthmenu(id), "{E66E6E}Medic HELP {ffffff}» Меню лекций")
	end
   },
    {
   title = "{FFFFFF}Меню {E66E6E}Глав.Врача {11C420}(/gov)",
    onclick = function()
	if rank == 'Психолог' or rank == 'Хирургг' or rank == 'Зам.Глав.Врача' or rank == 'Глав.Врач' then
	submenus_show(govmenu(id), "{E66E6E}Medic HELP {ffffff}» Меню лидера (/gov)")
	else
	ftext('Данное меню доступно с 9 ранга')
	end
	end
   },
    {
   title = "{FFFFFF}Меню {E66E6E}акций {11C420}(/gov)",
    onclick = function()
	if rank == 'Психолог' or rank == 'Хиfург' or rank == 'Зам.Глав.Врача' or rank == 'Глав.Врач' then
	submenus_show(menuaks(id), "{E66E6E}Medic HELP {ffffff}» Меню акций")
	else
	ftext('Данное меню доступно с 9 ранга')
	end
	end
   },
   {
   title = "{ffffff}» Не забываем оставлять{ff4040}TimeCard{ffffff} на форуме каждый час!",
    onclick = function()
	end
   }, 
   {
   title = "{ffffff}» Меню {ff4040}будет дополняться",
    onclick = function()
	end
   },
}
end

function lwd(arg)
	kon = tostring(arg)
	sampSendChat(string.format('/d OG, %s волну государственных новостей', cfg.main.male and 'занял' or 'заняла'))
	wait(5000)
	sampSendChat(string.format('/me %s КПК, после чего %s к гос. волне новостей', cfg.main.male and 'достал' or 'достала', cfg.main.male and 'подключился' or 'подключилась'))
	 wait(5000)
	sampSendChat("/gov [MOH]: Уважаемые жители и гости штата! В период с " .. nach .." по ".. kon)
	wait(5000)
	sampSendChat("/gov [MOH]: В больнице Лос-Сантос проходит акция «Жизнь без наркотиков!».")
	wait(5000)
	sampSendChat("/gov [MOH]: Сеансы от наркозависимости совершенно бесплатны. Спасибо за внимание!")
	wait(5000)
	sampSendChat(string.format('/d OG, %s волну государственных новостей', cfg.main.male and 'освободил' or 'освободила'))
	wait(1200)
end
		
function govlwd(arg)
	nach = tostring(arg)
	sampShowDialog(5, "Время", "{ffffff}Введите время {13E83E}конца {ffffff}проведения акции.\nФормат ЧЧ:ММ" , "ОК", "Отмена", 1)
	while sampIsDialogActive(5) do wait(100) end
	local result, button, _, input = sampHasDialogRespond(5)
	if button == 1 then lwd(input) end
end
function menuaks(id)
 return
{
  {
   title = "{FFFFFF}Жизнь без наркотиков!{CC1515}(По нажатию появится диалог, {11C420}там укажите время начала и конца действия акции.)",
    onclick = function()
			sampShowDialog(5, "Время", "{ffffff}Введите время {13E83E}начала {ffffff}проведения акции.\nФормат ЧЧ:ММ" , "ОК", "Отмена", 1)
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
   title = "{FFFFFF}Вакцинация против гриппа(начало){CC1515}(ОСТОРОЖНО! {11C420}Вещание начнется сразу)",
    onclick = function()
	sampSendChat(string.format('/d OG, %s волну государственных новостей', cfg.main.male and 'занял' or 'заняла'))
    wait(5000)
	 sampSendChat(string.format('/me %s КПК, после чего %s к гос. волне новостей', cfg.main.male and 'достал' or 'достала', cfg.main.male and 'подключился' or 'подключилась'))
	 wait(5000)
   sampSendChat("/gov [MOH]: Дорогие жители штата! В связи с участившимися заболеваниями.")
    wait(5000)
    sampSendChat("/gov [MOH]: В больнице Лос Сантос, проводится вакцинация")
    wait(5000)
     sampSendChat("/gov [MOH]: Просим Вас явиться и поставить укол. Здоровье - в ваших руках!")
    wait(5000)
     sampSendChat(string.format('/d OG, %s волну государственных новостей', cfg.main.male and 'освободил' or 'освободила'))
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
   title = "{FFFFFF}Вакцинация против гриппа(конец){CC1515}(ОСТОРОЖНО! {11C420}Вещание начнется сразу)",
    onclick = function()
	sampSendChat(string.format('/d OG, %s волну государственных новостей', cfg.main.male and 'занял' or 'заняла'))
    wait(5000)
	sampSendChat(string.format('/me %s КПК, после чего %s к гос. волне новостей', cfg.main.male and 'достал' or 'достала', cfg.main.male and 'подключился' or 'подключилась'))
	 wait(5000)
   sampSendChat("/gov [MOH]: Дорогие жители штата! Рабочий день пункта вакцинации, закончен.")
    wait(5000)
    sampSendChat("/gov [MOH]: Благодарим тех, кто пришел на вакцинацию от гриппа.")
    wait(5000)
     sampSendChat("/gov [MOH]: Мы рады, что наши граждане заботятся о своем здоровье.")
    wait(5000)
     sampSendChat(string.format('/d OG, %s волну государственных новостей', cfg.main.male and 'освободил' or 'освободила'))
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
   title = "{FFFFFF}Донор дает новую жизнь.(c 12:00 по 18:00){CC1515}(ОСТОРОЖНО! {11C420}Вещание начнется сразу)",
    onclick = function()
	sampSendChat(string.format('/d OG, %s волну государственных новостей', cfg.main.male and 'занял' or 'заняла'))
    wait(5000)
	sampSendChat(string.format('/me %s КПК, после чего %s к гос. волне новостей', cfg.main.male and 'достал' or 'достала', cfg.main.male and 'подключился' or 'подключилась'))
	 wait(5000)
   sampSendChat("/gov [MOH]: Уважаемые жители и гости нашего штата, минуточку внимания.")
    wait(5000)
    sampSendChat("/gov [MOH]: Сегодня с 12:00 до 18:00, проходит акция «Донор даёт новую жизнь»")
    wait(5000)
     sampSendChat("/gov [MOH]: При сдачи крови, вы получаете денежное вознаграждение и продлеваете жизнь больным!")
    wait(5000)
	 sampSendChat("/gov [MOH]: Всех желающих ждем в больнице Лос Сантос. Спасибо за внимание!")
    wait(5000)
     sampSendChat(string.format('/d OG, %s волну государственных новостей', cfg.main.male and 'освободил' or 'освободила'))
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
   title = "{FFFFFF}Донор дает новую жизнь.(конец) {CC1515}(ОСТОРОЖНО! {11C420}Вещание начнется сразу)",
    onclick = function()
	sampSendChat("  OG, занял волну государственных новостей.")
    wait(5000)
	sampSendChat(string.format('/me %s КПК, после чего %s к гос. волне новостей', cfg.main.male and 'достал' or 'достала', cfg.main.male and 'подключился' or 'подключилась'))
	 wait(5000)
   sampSendChat("/gov [MOH]: Уважаемые жители и гости нашего штата, минуточку внимания.")
    wait(5000)
    sampSendChat("/gov [MOH]: Акция «Донор даёт новую жизнь» - завершилась")
    wait(5000)
     sampSendChat("/gov [MOH]: Всего сдано 2.3 л крови и выдано 94 тыс.вирт")
    wait(5000)
	 sampSendChat("/gov [MOH]: С Уважением, Министерство Здравоохранения.")
    wait(5000)
     sampSendChat(string.format('/d OG, %s волну государственных новостей', cfg.main.male and 'освободил' or 'освободила'))
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
	sampSendChat(string.format('/d OG, %s волну государственных новостей', cfg.main.male and 'занял' or 'заняла'))
	wait(5000)
	sampSendChat(string.format('/me %s КПК, после чего %s к гос. волне новостей', cfg.main.male and 'достал' or 'достала', cfg.main.male and 'подключился' or 'подключилась'))
	wait(5000)
	sampSendChat("/gov [MOH]: Уважаемые жители и гости нашего штата, минуточку внимания.")
	wait(5000)
	sampSendChat("/gov [MOH]: Сообщаю, что в " .. inputgov .. " пройдёт собеседование в Министрество Здравоохранения на должность Интерна.")
	wait(5000)
	sampSendChat("/gov [MOH]: Требования: проживать от 3-х лет в штате и наличие диплома о мед.образовании.")
	wait(5000)
	sampSendChat('/gov [MOH]: Место проведения: Холл Больницы Лос-Сантос')
	wait(5000)
	sampSendChat(string.format('/d OG, %s волну государственных новостей', cfg.main.male and 'освободил' or 'освободила'))
	wait(1200)
end

	
function govmenu(id)
 return
{
  {
   title = "{FFFFFF}Собеседование в интернатуру {CC1515}(По нажатию появится диалог, {11C420}там укажите время начала собеса.)",
    onclick = 
			function()
			sampShowDialog(4, "Время", "Введите время проведения собеседования.\nФормат ЧЧ:ММ" , "ОК", "Отмена", 1)
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
   title = "{FFFFFF}Продолжается собеседование {CC1515}(ОСТОРОЖНО! {11C420}Вещание начнется сразу)",
    onclick = function()
	sampSendChat(string.format('/d OG, %s волну государственных новостей', cfg.main.male and 'занял' or 'заняла'))
        wait(5000)
		sampSendChat(string.format('/me %s КПК, после чего %s к гос. волне новостей', cfg.main.male and 'достал' or 'достала', cfg.main.male and 'подключился' or 'подключилась'))
	    wait(5000)
        sampSendChat("/gov [MOH]: Уважаемые жители и гости нашего штата, минуточку внимания.")
        wait(5000)
        sampSendChat('/gov [MOH]: Сообщаю, что собеседование в Министрество Здравоохранения на должность Интерна продолжается.')
        wait(5000)
        sampSendChat("/gov [MOH]: Требования: проживать от 3-х лет в штате и наличие диплома о мед.образовании.")
        wait(5000)
		sampSendChat("/gov [MOH]: Место проведения: Холл Больницы Лос-Сантос.")
        wait(5000)
        sampSendChat(string.format('/d OG, %s волну государственных новостей', cfg.main.male and 'освободил' or 'освободила'))
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
   title = "{FFFFFF}Конец собеседования {CC1515}(ОСТОРОЖНО! {11C420}Вещание начнется сразу)",
    onclick = function()
	local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	local myname = sampGetPlayerNickname(myid)
	sampSendChat(string.format('/d OG, %s волну государственных новостей', cfg.main.male and 'занял' or 'заняла'))
        wait(5000)
		sampSendChat(string.format('/me %s КПК, после чего %s к гос. волне новостей', cfg.main.male and 'достал' or 'достала', cfg.main.male and 'подключился' or 'подключилась'))
	    wait(5000)
        sampSendChat("/gov [MOH]: Уважаемые жители и гости нашего штата, минуточку внимания.")
        wait(5000)
        sampSendChat('/gov [MOH]: Сообщаю, что собеседование в Министрество Здравоохранения на должность Интерна окончено.')
        wait(5000)
        sampSendChat('/gov [MOH]: С уважением, '..rank..' Министерства Здравоохранения - '..myname:gsub('_', ' ')..'.')
        wait(5000)
        sampSendChat(string.format('/d OG, %s волну государственных новостей', cfg.main.male and 'освободил' or 'освободила'))
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
   title = "{FFFFFF}Пиар заявок Мед.Брата {CC1515}(ОСТОРОЖНО! {11C420}Вещание начнется сразу)",
    onclick = function()
	local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	local myname = sampGetPlayerNickname(myid)
	sampSendChat(string.format('/d OG, %s волну государственных новостей', cfg.main.male and 'занял' or 'заняла'))
        wait(5000)
        sampSendChat(string.format('/me %s КПК, после чего %s к гос. волне новостей', cfg.main.male and 'достал' or 'достала', cfg.main.male and 'подключился' or 'подключилась'))
	    wait(5000)
		sampSendChat("/gov [MOH]: Уважаемые жители и гости нашего штата, минуточку внимания.")
        wait(5000)
        sampSendChat('/gov [MOH]: Сообщаю, что на оф.портале Минестерства Здравоохранения открыты заявки на должность Мед.Брата.')
        wait(5000)
        sampSendChat("/gov [MOH]: Требования: проживать от 4-ех лет в штате и наличие диплома о мед.образовании.")
        wait(5000)
		sampSendChat('/gov [MOH]: С уважением, '..rank..' Министерства Здравоохранения - '..myname:gsub('_', ' ')..'.')
        wait(5000)
        sampSendChat(string.format('/d OG, %s волну государственных новостей', cfg.main.male and 'освободил' or 'освободила'))
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
   title = "{FFFFFF}Пиар заявок нарколог {CC1515}(ОСТОРОЖНО! {11C420}Вещание начнется сразу)",
    onclick = function()
	local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	local myname = sampGetPlayerNickname(myid)
	    sampSendChat(string.format('/d OG, %s волну государственных новостей', cfg.main.male and 'занял' or 'заняла'))
        wait(5000)
		sampSendChat(string.format('/me %s КПК, после чего %s к гос. волне новостей', cfg.main.male and 'достал' or 'достала', cfg.main.male and 'подключился' or 'подключилась'))
	    wait(5000)
        sampSendChat("/gov [MOH]: Уважаемые жители и гости нашего штата, минуточку внимания.")
        wait(5000)
        sampSendChat('/gov [MOH]: Сообщаю, что на оф.портале Министерства Здравоохранения открыты заявки на должность Нарколога.')
        wait(5000)
        sampSendChat("/gov [MOH]: Требования: проживать от 6-ти лет в штате и наличие диплома о мед.образовании.")
        wait(5000)
		sampSendChat('/gov [MOH]: С уважением, '..rank..' Министерства Здравоохранения - '..myname:gsub('_', ' ')..'.')
        wait(5000)
        sampSendChat(string.format('OG, %s волну государственных новостей', cfg.main.male and 'освободил' or 'освободила'))
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
   title = "{FFFFFF}Напомнить о займе гос. волны {CC1515}(По нажатию появится диалог,{11C420}там вводим время)",
    onclick = function()
	sampSetChatInputEnabled(true)
	sampSetChatInputText("/d OG, Напоминаю, что волна гос.новостей на X - за MOH.")
	end
   },
}
end

function fastsmsk()
	if lastnumber ~= nil then
		sampSetChatInputEnabled(true)
		sampSetChatInputText("/t "..lastnumber.." ")
	else
		ftext("Вы ранее не получали входящих сообщений.", 0x046D63)
	end
end

function fthmenu(id)
 return
{
  {
    title = "{bf6868}Лекция для поступивших{13E83E} интернов.",
    onclick = function()
        sampSendChat("Добро пожаловать в министерство здравоохранения.")
        wait(cfg.commands.zaderjka * 1000) 
        sampSendChat(" Вы попадаете в отдел МА - Medical Academy.")
        wait(cfg.commands.zaderjka * 1000)
        sampSendChat("Ваш бейджик - №13.")
        wait(cfg.commands.zaderjka * 1000)
        sampSendChat("/b тэг /r [MA], /clist 13")
        wait(cfg.commands.zaderjka * 1000)
        sampSendChat("Главной задачей отдела является патрулирование в общественных местах. Проще говоря, стоять на постах.")
        wait(cfg.commands.zaderjka * 1000)
        sampSendChat("Пример постов: мэрия, казино, автошкола, АВСФ, АВЛВ, грузчики, патрули городов и штата в целом.")
        wait(cfg.commands.zaderjka * 1000)
        sampSendChat("С постов нужно делать доклады каждые 5 минут.")
        wait(cfg.commands.zaderjka * 1000)
        sampSendChat("В докладах указывайте пост, количество вылеченых пациентов и принятых вызовов.") 
        wait(cfg.commands.zaderjka * 1000)
        sampSendChat("/b /r [MA] Пост: - | Вылечено: - | Вызовов: -")
        wait(cfg.commands.zaderjka * 1000)
        sampSendChat(" Сеансы от наркозависимости и справки - с нарколога.")
        wait(cfg.commands.zaderjka * 1000)
        sampSendChat(" Если обращаются, то перенаправляйте к наркологу или старше")
        wait(cfg.commands.zaderjka * 1000)
        sampSendChat("С транспорта вам доступны карета и автомобиль Стратум.")
        wait(cfg.commands.zaderjka * 1000)
        sampSendChat("Повышение будет спустя три часа работы и сдачи экзамена на знание устава.")
        wait(cfg.commands.zaderjka * 1000)
        sampSendChat("/b При лечении обязательно сначала должна быть РП отыгровка, а потом только /heal id")
        wait(cfg.commands.zaderjka * 1000)
        sampSendChat("Также, раз в несколько проходят собрания. Желательно на них присутствовать.")
        wait(cfg.commands.zaderjka * 1000)
        sampSendChat("На этом лекция окончена. Если есть вопросы - задавайте, не стесняйтесь.") 
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
    title = "{bf6868}Первая помощь при {13E83E}переломах",
    onclick = function()
       sampSendChat("Приветствую, коллеги. Сегодня я прочту Вам лекцию на тему «Первая помощь при переломах». ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("Переломы классифицируются на полный и неполный по полноте разрыва кости, со смещением.. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat(".. и без смещения по позиции обломков друг по отношению к другу.. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat(".. открытый и закрытый по наличию повреждения кожи.") 
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("Симптомы перелома: ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("сильная боль в месте травмы, деформация конечности, неестественное положение конечности.. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat(".. отек, кровоизлияние. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("Первая помощь при переломах всегда включает в себя: восстановление целостности кости..") 
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat(".. остановку кровотечения, антисептическую обработку раны.. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat(".. иммобилизацию конечности. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("Больного необходимо очень бережно транспортировать в медицинское учреждение для оказания.. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat(".. медицинской помощи.")
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
   title = "{bf6868}Первая помощь при {13E83E}сотрясении мозга",
    onclick = function()
       sampSendChat("Приветствую, коллеги. Сегодня я прочту Вам лекцию на тему «Первая помощь при сотрясении мозга».")
       wait(cfg.commands.zaderjka * 1000) 
       sampSendChat("Его признаками являются головокружение, головная боль, нарушение памяти, возникающие.. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat(".. после травмы черепа. Оказывая первую помощь.. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat(".. прежде всего нужно обеспечить проходимость дыхательных путей. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("Для этого переверните пострадавшего на бок. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("В таком положении улучшается снабжение мозга кровью.. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat(".. а следовательно - кислородом, не западает язык. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("Если человек не приходит в сознание более 30 минут..") 
       wait(cfg.commands.zaderjka * 1000) 
       sampSendChat(".. можно заподозрить тяжелую черепно-мозговую травму — ушиб мозга. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("В этом случае необходимо срочно вызвать врача и доставить пострадавшего в лечебное учреждение. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("Спасибо за внимание.")
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
   title = "{bf6868}Первая помощь при {13E83E}обмороках",
    onclick = function()
      sampSendChat("Приветствую, коллеги. Сегодня я прочту Вам лекцию на тему «Первая помощь при обмороках». ")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("Обмороки сопровождаются кратковременной потерей сознания, вызванной.. ")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat(".. недостаточным кровоснабжением мозга. ")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("Обморок могут вызвать: резкая боль, эмоциональный стресс, ССБ и так далее. ")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("Бессознательному состоянию обычно предшествует резкое ухудшение самочувствия: ")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("нарастает слабость, появляются тошнота, головокружение, шум или звон в ушах. ")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("Затем человек бледнеет, покрывается холодным потом и внезапно теряет сознание. ")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("Первая помощь должна быть направлена на улучшение кровоснабжения мозга.. ")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat(".. и обеспечение свободного дыхания. ")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("Если пострадавший находится в душном, плохо проветренном помещении, то.. ")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat(".. откройте окно, включите вентилятор или вынесите потерявшего сознание на воздух.")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("Протрите его лицо и шею холодной водой, похлопайте по щекам и.. ")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat(".. дайте пострадавшему понюхать ватку, смоченную нашатырным спиртом. ")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("Спасибо за внимание.")
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
    title = "{bf6868}Первая помощь при {13E83E}кровотечении",
    onclick = function()
       sampSendChat("Приветствую, коллеги. Сегодня я прочту Вам лекцию на тему «Первая помощь при кровотечении». ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("Нужно четко понимать, что артериальное кровотечение представляет смертельную опасность для жизни. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("Первое, что требуется – перекрыть сосуд выше поврежденного места. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("Для этого прижмите артерию пальцами и срочно готовьте жгут. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("Используйте в таком случае любые подходящие средства: ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("шарф, платок, ремень, оторвите длинный кусок одежды.") 
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("Стягивайте жгут до тех пор, пока кровь не перестанет сочиться из раны. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("В случае венозного кровотечения действия повторяются, за исключением того, что..") 
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat(".. жгут накладывается чуть ниже поврежденного места. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("Следует помнить, что при обоих видах кровотечения жгут накладывается не более двух часов..") 
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat(".. в жаркую погоду и не более часа в холодную. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("При капиллярном кровотечении следует обработать поврежденное место перекисью водорода.. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat(".. и наложить пластырь, либо перебинтовать рану. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("Спасибо за внимание.")
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
   title = "{bf6868}О местной анестезии при {13E83E}операциях ",
    onclick = function()
      sampSendChat("Дорогие коллеги, в сегодняшней лекции, я хочу вам рассказать о довольно старых, но ")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("На данный момент эффективных методах местной анестезии. ")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("Всего бывает несколько видов местной анестезии: поверхностная, инфильтрационная,")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("Циркулярная, эпидуральная, паранефральная, проводниковая.")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("А теперь, подробнее о каждой из них:")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("Поверхностная - суть её в том, чтобы нанести новокаин на глаз, либо повреждённый участок,")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("Без иголки. Если же повреждённый участок - область рта либо носовой полости.")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("То новокаин наносится с помощью иголки. К слову, это самый лёгкий тип местной анестезии. ")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("Далее, инфильтрационная - суть её заключается в том, чтобы послойно проколоть слои кожи,")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("либо участков органа, тем самым пропитывая поражённый участок новокаином,")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("и при этом, делаете качественное обезболивание, что даёт маленький шанс...")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("Возникновения шокового состояния у пациента")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("Следующая - циркулярная. Суть её заключается в том, чтобы")
      wait(cfg.commands.zaderjka * 1000)
	  sampSendChat("Обезболить участок определённой области, обкалывая её 0.25% новокаином.")
      wait(cfg.commands.zaderjka * 1000)
	  sampSendChat("Также, необходимо проверить чувствительность у пациента после анестезии. ")
      wait(cfg.commands.zaderjka * 1000)
	  sampSendChat("Сделать это можно следующим образом: предварительно поставив анестезию на поврежденный участок,")
      wait(cfg.commands.zaderjka * 1000)
	  sampSendChat("Достаёте иголку и слегка покалываете кожу")
      wait(cfg.commands.zaderjka * 1000)
	  sampSendChat("По поверхности повреждённого участка. Если заметны подёргивания")
      wait(cfg.commands.zaderjka * 1000)
	  sampSendChat(" Конечностей - слабая доза новокаина.")
      wait(cfg.commands.zaderjka * 1000)
	  sampSendChat("Далее идёт эпидуральная анестезия. Суть её заключается в том, чтобы ввести новокаин вокруг поясницы.")
      wait(cfg.commands.zaderjka * 1000)
	   sampSendChat("Следующая - паранефральная, либо почечная. Суть данной схожа с предыдущей.")
      wait(cfg.commands.zaderjka * 1000)
	   sampSendChat("Только обхватывает не только поясницу, а и область почек. ")
      wait(cfg.commands.zaderjka * 1000)
	   sampSendChat("И последняя - проводниковая. Данная анестезия используется при")
      wait(cfg.commands.zaderjka * 1000)
	   sampSendChat("Более тяжёлых повреждениях позвоночного столба.")
      wait(cfg.commands.zaderjka * 1000)
	   sampSendChat("Вы вводите новокаин по всей поверхности позвоночника. ")
      wait(cfg.commands.zaderjka * 1000)
	   sampSendChat("Начиная от шейных до кресцовых позвонков.")
      wait(cfg.commands.zaderjka * 1000)
      sampSendChat("Спасибо за внимание.")
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
    title = "{bf6868}Первая помощь при {13E83E}ДТП",
    onclick = function()
       sampSendChat("Приветствую, коллеги. Сегодня я прочту Вам лекцию на тему «Первая помощь при ДТП». ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("Оказывая первую помощь, необходимо действовать по правилам. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("Немедленно определите характер и источник травмы. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("Наиболее частые травмы в случае ДТП - сочетание повреждений черепа.. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat(".. и нижних конечностей и грудной клетки. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("Необходимо извлечь пострадавшего из автомобиля, осмотреть его. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("Далее следует оказать первую помощь в соответствии с выявленными травмами. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("Выявив их, требуется перенести пострадавшего в безопасное место.. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat(".. укрыть от холода, зноя или дождя и вызвать врача, а затем.. ")
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat(".. организовать транспортировку пострадавшего в лечебное учреждение.") 
       wait(cfg.commands.zaderjka * 1000)
       sampSendChat("Спасибо за внимание.")
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
    imgui.Begin(u8'Настройки##1', first_window, btn_size, imgui.WindowFlags.NoResize)
	imgui.PushItemWidth(200)
	imgui.AlignTextToFramePadding(); imgui.Text(u8("Использовать автотег"))
	imgui.SameLine()
	if imgui.ToggleButton(u8'Использовать автотег', tagb) then
    cfg.main.tarb = not cfg.main.tarb
    end
	if tagb.v then
	if imgui.InputText(u8'Введите ваш Тег.', tagfr) then
    cfg.main.tarr = u8:decode(tagfr.v)
    end
	imgui.Text(u8("Инфо-бар"))
	imgui.SameLine()
	if imgui.ToggleButton(u8'Включить/Выключить инфо-бар', hudik) then
        cfg.main.givra = not cfg.main.givra
		ftext(cfg.main.givra and 'Инфо-бар включен, установить положение /sethud' or 'Инфо-бар выключен')
    end
	end
	imgui.Text(u8("Быстрый ответ на последнее смс"))
	imgui.SameLine()
    if imgui.HotKey(u8'##Быстрый ответ смс', config_keys.fastsms, tLastKeys, 100) then
	    rkeys.changeHotKey(fastsmskey, config_keys.fastsms.v)
		ftext('Клавиша успешно изменена. Старое значение: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Новое значение: '.. table.concat(rkeys.getKeysName(config_keys.fastsms.v), " + "))
		saveData(config_keys, 'moonloader/config/medicHELP/keys.json')
	end
	imgui.Text(u8("Использовать автоклист"))
	imgui.SameLine()
	if imgui.ToggleButton(u8'Использовать автоклист', clistb) then
        cfg.main.clistb = not cfg.main.clistb
    end
    if clistb.v then
        if imgui.SliderInt(u8"Выберите значение клиста", clistbuffer, 0, 33) then
            cfg.main.clist = clistbuffer.v
        end
		imgui.Text(u8("Использовать отыгровку раздевалки"))
	    imgui.SameLine()
		if imgui.ToggleButton(u8'Использовать отыгровку раздевалки', clisto) then
        cfg.main.clisto = not cfg.main.clisto
        end
    end
	imgui.Text(u8("Мужские отыгровки"))
	imgui.SameLine()
	if imgui.ToggleButton(u8'Мужские отыгровки', stateb) then
        cfg.main.male = not cfg.main.male
    end
	if imgui.SliderInt(u8'Задержка в лекциях и отыгровках(сек)', waitbuffer,  1, 10) then
     cfg.commands.zaderjka = waitbuffer.v
    end
	imgui.Text(u8("Автоскрин лекций/гос.новостей"))
	imgui.SameLine()
	if imgui.ToggleButton(u8'Автоскрин лекций', autoscr) then
        cfg.main.hud = not cfg.main.hud
    end
    if imgui.CustomButton(u8('Сохранить настройки'), imgui.ImVec4(0.68, 0.25, 0.25, 1.00), imgui.ImVec4(0.68, 0.25, 0.25, 1.00), imgui.ImVec4(0.68, 0.25, 0.25, 1.00), btn_size) then
	ftext('Настройки успешно сохранены.', -1)
    inicfg.save(cfg, 'medicHELP/config.ini') -- сохраняем все новые значения в конфиге
    end
    imgui.End()
   end
    if ystwindow.v then
                imgui.LockPlayer = true
                imgui.ShowCursor = true
                local iScreenWidth, iScreenHeight = getScreenResolution()
                imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
                imgui.SetNextWindowSize(imgui.ImVec2(iScreenWidth/2, iScreenHeight / 2), imgui.Cond.FirstUseEver)
                imgui.Begin(u8('Medic HELP | Устав MOH'), ystwindow)
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
	local text = '  Автор:'
    imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8(text)).x)/3)
    imgui.Text(u8(text))
	imgui.SameLine()
	imgui.TextColored(imgui.ImVec4(0.43, 0.65 , 0.44, 2.0), 'Evelyn Ross')
	local text = 'Помощь в разработке:'
	imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8(text)).x)/5)
    imgui.Text(u8(text))
	imgui.SameLine()
	imgui.TextColored(imgui.ImVec4(0.43, 0.65 , 0.44, 2.0), 'Luis Barton')
	local text = '   За основу взят:'
	imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8(text)).x)/4)
    imgui.Text(u8(text))
	imgui.SameLine()
	imgui.TextColored(imgui.ImVec4(0.43, 0.65 , 0.44, 2.0), ' FBI Tools')
    imgui.Separator()
	if imgui.Button(u8'Биндер', imgui.ImVec2(50, 30)) then
      bMainWindow.v = not bMainWindow.v
    end
	imgui.SameLine()
    if imgui.Button(u8'Настройки скрипта', imgui.ImVec2(120, 30)) then
      first_window.v = not first_window.v
    end
    imgui.SameLine()
    if imgui.Button(u8 'Сообщить об ошибке/баге', imgui.ImVec2(170, 30)) then os.execute('explorer "https://vk.com/john_wake"')
    btn_size = not btn_size
    end
	imgui.SameLine()
    if imgui.Button(u8'Перезагрузить скрипт', imgui.ImVec2(150, 30)) then
      showCursor(false)
      thisScript():reload()
    end
    if imgui.Button(u8 'Отключить скрипт', imgui.ImVec2(120, 30), btn_size) then
      showCursor(false)
      thisScript():unload()
    end
	imgui.SameLine()
    if imgui.Button(u8'Помощь', imgui.ImVec2(55, 30)) then
      helps.v = not helps.v
    end
	imgui.Separator()
	imgui.BeginChild("Информация", imgui.ImVec2(410, 150), true)
	imgui.Text(u8 'Имя и Фамилия:   '..sampGetPlayerNickname(myid):gsub('_', ' ')..'')
	imgui.Text(u8 'Должность:') imgui.SameLine() imgui.Text(u8(rank))
	imgui.Text(u8 'Номер телефона:   '..tel..'')
	if cfg.main.tarb then
	imgui.Text(u8 'Тег в рацию:') imgui.SameLine() imgui.Text(u8(cfg.main.tarr))
	end
	if cfg.main.clistb then
	imgui.Text(u8 'Номер бейджика:   '..cfg.main.clist..'')
	end
	imgui.EndChild()
	imgui.Separator()
	imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8("Текущая дата: %s")).x)/1.5)
	imgui.Text(u8(string.format("Текущая дата: %s", os.date())))
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
            imgui.Text((u8"Информация: %s [%s] | Пинг: %s"):format(myname, myid, myping))
            if isCharInAnyCar(playerPed) then
                local vHandle = storeCarCharIsInNoSave(playerPed)
                local result, vID = sampGetVehicleIdByCarHandle(vHandle)
                local vHP = getCarHealth(vHandle)
                local carspeed = getCarSpeed(vHandle)
                local speed = math.floor(carspeed)
                local vehName = tCarsName[getCarModel(storeCarCharIsInNoSave(playerPed))-399]
                local ncspeed = math.floor(carspeed*2)
                imgui.Text((u8 'Транспорт: %s [%s]|HP: %s|Скорость: %s'):format(vehName, vID, vHP, ncspeed))
            else
                imgui.Text(u8 'Транспорт: Нет')
            end
			    imgui.Text((u8 'Время: %s'):format(os.date('%H:%M:%S')))
            if valid and doesCharExist(ped) then 
                local result, id = sampGetPlayerIdByCharHandle(ped)
                if result then
                    local targetname = sampGetPlayerNickname(id)
                    local targetscore = sampGetPlayerScore(id)
                    imgui.Text((u8 'Цель: %s [%s] | Уровень: %s'):format(targetname, id, targetscore))
                else
                    imgui.Text(u8 'Цель: Нет')
                end
            else
                imgui.Text(u8 'Цель: Нет')
            end
			imgui.Text((u8 'Квадрат: %s'):format(u8(kvadrat())))
            saveData(cfg, 'moonloader/config/medicHELP/config.json')
            imgui.End()
        end
    if helps.v then
                local iScreenWidth, iScreenHeight = getScreenResolution()
                imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(3, 7))
                imgui.Begin(u8 'Помощь по скрипту', helps, imgui.WindowFlags.NoResize, imgui.WindowFlags.NoCollapse)
				imgui.BeginChild("Список команд", imgui.ImVec2(525, 385), true, imgui.WindowFlags.VerticalScrollbar)
                imgui.TextColoredRGB('{FF6868}/moh{CCCCCC} - Открыть меню скрипта')
                imgui.Separator()
                imgui.TextColoredRGB('{FF6868}/vig [id] [Причина]{CCCCCC} - Выдать выговор по рации')
                imgui.TextColoredRGB('{FF6868}/dmb{CCCCCC} - Открыть /members в диалоге')
                imgui.TextColoredRGB('{FF6868}/yst{CCCCCC} - Открыть устав MOH')
				imgui.TextColoredRGB('{FF6868}/smsjob{CCCCCC} - Вызвать на работу весь мл.состав по смс')
                imgui.TextColoredRGB('{FF6868}/dlog{CCCCCC} - Открыть лог 25 последних сообщений в департамент')
				imgui.TextColoredRGB('{FF6868}/cchat{CCCCCC} - Очищает чат')
				imgui.TextColoredRGB('{FF6868}/blag [ид] [фракция] [тип]{CCCCCC} - Выразить игроку благодарность в департамент')
				imgui.Separator()
                imgui.TextColoredRGB('Клавиши: ')
                imgui.TextColoredRGB('{FF6868}ПКМ+Z на игрока{CCCCCC} - Меню взаимодействия с игроком')
				 imgui.TextColoredRGB('{FF6868}/mh ID{CCCCCC} - Меню взаимодействия с игроком в карете')
                imgui.TextColoredRGB('{FF6868}F2{CCCCCC} - "Быстрое меню"')
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
                imgui.Begin(u8('Medic HELP | Обновление'), updwindows, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
                imgui.Text(u8('Вышло обновление скрипта Medic HELP до версии '..updversion..'. Что бы обновиться нажмите кнопку внизу.'))
                imgui.Separator()
                imgui.BeginChild("uuupdate", imgui.ImVec2(690, 200))
                for line in ttt:gmatch('[^\r\n]+') do
                    imgui.Text(line)
                end
                imgui.EndChild()
                imgui.Separator()
                imgui.PushItemWidth(305)
                if imgui.Button(u8("Обновить"), imgui.ImVec2(339, 25)) then
                    lua_thread.create(goupdate)
                    updwindows.v = false
                end
                imgui.SameLine()
                if imgui.Button(u8("Отложить обновление"), imgui.ImVec2(339, 25)) then
                    updwindows.v = false
                end
                imgui.End()
            end
  if bMainWindow.v then
  local iScreenWidth, iScreenHeight = getScreenResolution()
	local tLastKeys = {}
   
   imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
   imgui.SetNextWindowSize(imgui.ImVec2(800, 530), imgui.Cond.FirstUseEver)

   imgui.Begin(u8("IT | Биндер##main"), bMainWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
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
				imgui.TextDisabled(u8("Пустое сообщение ..."))
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
			imgui.Checkbox(u8("Ввод") .. "##editCH" .. k, bIsEnterEdit)
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

	if imgui.Button(u8"Добавить клавишу") then
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

function showHelp(param) -- "вопросик" для скрипта
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
    select_button, close_button, back_button = select_button or '»', close_button or 'x', back_button or '«'
    prev_menus = {}
    function display(menu, id, caption)
        local string_list = {}
        for i, v in ipairs(menu) do
            table.insert(string_list, type(v.submenu) == 'table' and v.title .. ' »' or v.title)
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
        ftext('Введите /r [текст]')
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
        ftext('Введите /f [текст]')
    end
end
function ftext(message)
    sampAddChatMessage(string.format('%s %s', ctag, message), 0xE66E6E)
end

function moh()
  if frac == 'Hospital' then
  second_window.v = not second_window.v
  else
  ftext('Возможно вы не состоите в MOH {ff0000}[ctrl+R]')
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
	submenus_show(pkmmenu(ID), "{E66E6E}Medic HELP {ffffff}» {"..color.."}"..sampGetPlayerNickname(ID).."["..ID.."] {ffffff}Уровень - "..sampGetPlayerScore(ID).." ")
	end)
end


function pkmmenu(id)
    local color = ("%06X"):format(bit.band(sampGetPlayerColor(id), 0xFFFFFF))
    return
    {
      {
        title = "{bf6868}» Меню {13E83E}медика.",
        onclick = function()
        pID = tonumber(args)
        submenus_show(mediccmenu(id), "{E66E6E}Medic HELP {ffffff}» {"..color.."}"..sampGetPlayerNickname(id).."["..id.."] ")
        end
      },
	   {
        title = "{bf6868}» Меню выдачи {13E83E}справок и осмотр на призыве.",
        onclick = function()
        pID = tonumber(args)
        submenus_show(spravkamenu(id), "{E66E6E}Medic HELP {ffffff}» {"..color.."}"..sampGetPlayerNickname(id).."["..id.."] ")
        end
      },
	  {
        title = "{bf6868}» Меню {13E83E}рентгена, порезов, переломов",
        onclick = function()
        pID = tonumber(args)
        submenus_show(renmenu(id), "{E66E6E}Medic HELP {ffffff}» {"..color.."}"..sampGetPlayerNickname(id).."["..id.."] ")
        end
      },
	  {
	 
        title = "{bf6868}» Лечение при {13E83E}головной боли и боли в животе.",
        onclick = function()
        pID = tonumber(args)
        submenus_show(medicmenu(id), "{E66E6E}Medic HELP {ffffff}» {"..color.."}"..sampGetPlayerNickname(id).."["..id.."] ")
        end
      },
	  {
        title = "{bf6868}» Лечение при {13E83E}боли в горле.",
        onclick = function()
        pID = tonumber(args)
        submenus_show(gorlomenu(id), "{E66E6E}Medic HELP {ffffff}» {"..color.."}"..sampGetPlayerNickname(id).."["..id.."] ")
        end
      },
      {
        title = "{bf6868}» Нашатырь при {13E83E}обмороке",
        onclick = function()
        pID = tonumber(args)
        submenus_show(nawmenu(id), "{E66E6E}Medic HELP {ffffff}» {"..color.."}"..sampGetPlayerNickname(id).."["..id.."] ")
        end
      },
      {
        title = "{bf6868}» Сеанс от {13E83E}наркозависимости",
        onclick = function()
        pID = tonumber(args)
        submenus_show(narkomenu(id), "{E66E6E}Medic HELP {ffffff}» {"..color.."}"..sampGetPlayerNickname(id).."["..id.."] ")
        end
      },
    }
end

function gorlomenu(id)
    return
    {
      {
        title = '{ffffff}» Осмотр горла',
        onclick = function()
		local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
        sampSendChat("Хорошо, откройте рот.")
        wait(cfg.commands.zaderjka * 1200) 
		sampSendChat(string.format('/me %s горло', cfg.main.male and 'осмотрел' or 'осмотрела'))
        wait(cfg.commands.zaderjka * 500) 
		sampSendChat("/do на плече накинута мед.сумка")
        wait(cfg.commands.zaderjka * 500) 
		sampSendChat(string.format('/me %s аптечку', cfg.main.male and 'достал' or 'достала'))
        wait(cfg.commands.zaderjka * 500) 
		sampSendChat(string.format('/me %s необходимый препарат', cfg.main.male and 'нашел' or 'нашла'))
        wait(cfg.commands.zaderjka * 500) 
        sampSendChat("/do Стопангин в руке.")
        wait(cfg.commands.zaderjka * 500) 
		sampSendChat(string.format('/me %s горло Наклофеном', cfg.main.male and 'побрызгал' or 'побрызгала'))
        sampSendChat("/me побрызгал горло пострадавшего Наклофеном")
        wait(cfg.commands.zaderjka * 500) 
        sampSendChat("/heal "..id)
        wait(cfg.commands.zaderjka * 1500) 
        sampSendChat("Удачного дня, не болейте.") 
		end
      }
    }
end

function narkomenu(id)
    return
    {
      {
        title = '{ffffff}» Начало сеанса',
        onclick = function()
		local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
        sampSendChat("Присаживайтесь на кушетку и закатайте рукав.")
        wait(cfg.commands.zaderjka * 700) 
        sampSendChat("/do Шприц в руке.")
        wait(cfg.commands.zaderjka * 700) 
		sampSendChat(string.format('/me %s ватку смоченную мед.спиртом и %s место укола', cfg.main.male and 'взял' or 'взяла', cfg.main.male and 'обработал' or 'обработала'))
        wait(cfg.commands.zaderjka * 700) 
		sampSendChat(string.format('/me %s жгут на руке пациента, после чего %s инъекцию', cfg.main.male and 'затянул' or 'затянула', cfg.main.male and 'ввел' or 'ввела'))
        wait(cfg.commands.zaderjka * 700)  
		sampSendChat(string.format('/me %s жгут и %s ватку к месту укола', cfg.main.male and 'снял' or 'сняла', cfg.main.male and 'приложил' or 'приложила'))
        wait(cfg.commands.zaderjka * 700) 
        sampSendChat("/healaddict "..id.." 10000 ", id)
        wait(cfg.commands.zaderjka * 700) 
        sampSendChat("После проведения данного сеанса употреблять наркотические вещества категорически запрещено")
        wait(cfg.commands.zaderjka * 700)
        sampSendChat("Всего доброго.") 
		end
      }
    }
end

function renmenu(args)
    return
    {
      {
        title = '{5b83c2}« Список процедур »',
        onclick = function()
        end
      },
      {
        title = '{ffffff}» Рентгеновский аппарат',
        onclick = function()
        sampSendChat("Ложитесь на кушетку и лежите смирно.")
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s рентгеновский аппарат', cfg.main.male and 'включил' or 'включила'))
        wait(cfg.commands.zaderjka * 1000) 
        sampSendChat("/do Рентгеновский аппарат зашумел.")
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s рентгеновским аппаратом по поврежденному участку', cfg.main.male and 'проверил' or 'проверила'))
        wait(cfg.commands.zaderjka * 1000) 
        sampSendChat("/me рассматривает снимок")
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/try %s перелом', cfg.main.male and 'обнаружил' or 'обнаружила'))       
      end
	  },
	  
	 
      {
        title = '{5b83c2}« Если у пациента перелом конечностей »',
        onclick = function()
        end
      },
      {
        title = '{ffffff}» Перелом конечностей',
        onclick = function()
        sampSendChat("Садитесь на кушетку.")
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s со стола перчатки и %s их.', cfg.main.male and 'взял' or 'взяла', cfg.main.male and 'надел' or 'надела'))  
        wait(cfg.commands.zaderjka * 1000) 
        sampSendChat("/do Рентгеновский аппарат зашумел.")
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s шприц с обезбаливающим, после чего %s поврежденный участок', cfg.main.male and 'взял' or 'взяла', cfg.main.male and 'обезболил' or 'обезболила'))
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s репозицию поврежденного участка ', cfg.main.male and 'проверил' or 'проверила'))
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s гипсовый порошек', cfg.main.male and 'подготовил' or 'подготовила'))
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s бинт вдоль стола, после чего %s гипсовый раствор', cfg.main.male and 'раскатил' or 'раскатила', cfg.main.male and 'втер' or 'втерла'))
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s бинт и %s перелом', cfg.main.male and 'свернул' or 'свернула', cfg.main.male and 'зафиксировал' or 'зафиксировала'))
        wait(cfg.commands.zaderjka * 1000) 
        sampSendChat("Приходите через месяц. Всего доброго!")
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s перчатки и %s их в урну', cfg.main.male and 'снял' or 'сняла', cfg.main.male and 'бросил' or 'бросила'))
		end
      },
      {
        title = '{5b83c2}« Если у пациента перелом позвоночника/ребер »',
        onclick = function()
        end
      },
      {
        title = '{ffffff}» Перелом позвоночника/ребер',
        onclick = function()
		sampSendChat(string.format('/me осторожно %s пострадавшего на операционный стол', cfg.main.male and 'уклал' or 'уклала'))
        wait(cfg.commands.zaderjka * 1000) 
        sampSendChat(string.format('/me %s со стола перчатки и %s их.', cfg.main.male and 'взял' or 'взяла', cfg.main.male and 'надел' or 'надела'))  
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s пострадавшего к капельнице.', cfg.main.male and 'подключил' or 'подключила'))
        wait(cfg.commands.zaderjka * 1000)
        sampSendChat(string.format('/me %s ватку спиртом и %s кожу на руке пациента', cfg.main.male and 'намочил' or 'намочила', cfg.main.male and 'обработал' or 'обработала'))		
        wait(cfg.commands.zaderjka * 1000)
		sampSendChat(string.format('/me внутривенно %s фторотан.', cfg.main.male and 'ввел' or 'ввела'))
        wait(cfg.commands.zaderjka * 1000) 
        sampSendChat("/do Наркоз начинает действовать, пациент потерял сознание.")
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s скальпель и пинцет', cfg.main.male and 'достал' or 'достала'))
        wait(cfg.commands.zaderjka * 1000)
		sampSendChat(string.format('/me с помощью различных инструментов %s репозицию поврежденного участка', cfg.main.male and 'произвел' or 'произвела'))
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s достал из тумбочки специальный корсет', cfg.main.male and 'достал' or 'достала'))
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s поврежденный участок с помощью карсета', cfg.main.male and 'зафиксировал' or 'зафиксировала'))
        wait(cfg.commands.zaderjka * 1000) 
        sampSendChat(string.format('/me %s перчатки и %s их в урну', cfg.main.male and 'снял' or 'сняла', cfg.main.male and 'бросил' or 'бросила'))
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s в отдельный контейнер грязный инструментарий', cfg.main.male and 'убрал' or 'убрала'))
        wait(cfg.commands.zaderjka * 1000) 
        sampSendChat("/do Прошло некоторое время, пациент пришел в сознание.") 
		end
      },
      {
        title = '{5b83c2}« Если у пациента глубокий порез »',
        onclick = function()
        end
      },
      {
        title = '{ffffff}» Глубокий порез',
        onclick = function()
        sampSendChat(string.format('/me %s со стола перчатки и %s их.', cfg.main.male and 'взял' or 'взяла', cfg.main.male and 'надел' or 'надела'))  
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s осмотр пациента', cfg.main.male and 'провел' or 'провела'))
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s степень тяжести пореза у пациента', cfg.main.male and 'определил' or 'определила'))
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s поврежденный участок', cfg.main.male and 'обезболил' or 'обезболила'))
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s из мед. сумки жгут и %s его поверх повреждения', cfg.main.male and 'достал' or 'достала', cfg.main.male and 'наложил' or 'наложила'))
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s хирургические инструменты на столе', cfg.main.male and 'разложил' or 'разложилa'))
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s специальные иглу и нити', cfg.main.male and 'взял' or 'взялa'))
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s кровеносный сосуд и %s пульс', cfg.main.male and 'зашил' or 'зашила', cfg.main.male and 'проверил' or 'проверила'))
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s кровь и %s место пореза', cfg.main.male and 'протер' or 'протерла', cfg.main.male and 'зашил' or 'зашила'))
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s иглу и нити в сторону', cfg.main.male and 'отложил' or 'отложилa'))
        wait(cfg.commands.zaderjka * 1000)
				sampSendChat(string.format('/me %s жгут, %s бинты и %s поврежденный участок кожи', cfg.main.male and 'снял' or 'снялa', cfg.main.male and 'взял' or 'взялa', cfg.main.male and 'перебинтовал' or 'перебинтовалa'))
        wait(cfg.commands.zaderjka * 1000) 
        sampSendChat("До свадьбы заживет, удачного дня, не болейте.")
        wait(cfg.commands.zaderjka * 1000) 
        sampSendChat(string.format('/me %s в отдельный контейнер грязный инструментарий', cfg.main.male and 'убрал' or 'убрала')) 
		end
      },
    }
end



function spravkamenu(args)
    return
    {
      {
        title = '{5b83c2}« Справки »',
        onclick = function()
        end
      },
      {
        title = '{ffffff}» Отыгровка №[1]',
        onclick = function()
        sampAddChatMessage("{D91111}Подсказка: {bf8080} подойдите к пациенту.", -1)
	    wait(8000)
	    sampSendChat("Назовите Ваше имя и фамилию.")
		wait(125)
		sampAddChatMessage("{ffffff}{D91111}Подсказка: {bf8080} после того, как имя названо - идете к столу.", -1)
	wait(8000)
	sampSendChat("/do На столе стоит ящик с мед.картами и неврологическим молоточком.")
	wait(6000)
	sampSendChat(string.format('/me %s из ящика мед.карту на имя пациента', cfg.main.male and 'достал' or 'достала'))
	wait(6000)
	sampAddChatMessage("{D91111}Подсказка: {bf8080} поворачиваемся лицом к пациенту.", -1)
	wait(8000)
	sampSendChat("Имеете ли Вы жалобы на здоровье?")
	wait(5000)
	sampAddChatMessage("{D91111}Подсказка: {bf8080} ждем ответа и переходим к отыгровке №[2].", -1)
	wait(8000)
	   
		end
      },
	  {
        title = '{ffffff}» Отыгровка №[2]',
        onclick = function()
        sampSendChat("Хорошо, продолжим.")
		wait(150)
	sampAddChatMessage("{D91111}Подсказка: {bf8080} поворачиваемся лицом к столу.", -1)
	wait(8000)
	sampSendChat("/do В левой руке чёрная ручка.")
	wait(6000)
	sampSendChat(string.format('/me %s запись в мед.карте', cfg.main.male and 'сделал' or 'сделала'))
	wait(6000)
	sampSendChat(string.format('/me %s из ящика неврологический молоточек', cfg.main.male and 'достал' or 'достала'))
	wait(6000)
	sampAddChatMessage("{D91111}Подсказка: {bf8080} подходим к пациенту.", -1)
	sampSendChat("Присаживайтесь, начнем обследование.")
	wait(15000)
	sampSendChat("/me водит молоточком перед глазами пациента ")
	wait(6000)
	sampSendChat(string.format('/me %s, что зрачки движутся содружественно и рефлекс в норме', cfg.main.male and 'убедился' or 'убедилась'))
	wait(6000)
	sampSendChat("Хорошо. Рефлексы зрения в норме.")
	wait(6000)
	sampSendChat(string.format('/me %s запись в мед.карте', cfg.main.male and 'сделал' or 'сделала'))
	wait(6000)
	sampSendChat(string.format('/me %s молоточком по левому колену пациента', cfg.main.male and 'ударил' or 'ударила'))
	wait(6000)
	sampSendChat(string.format('/me %s молоточком по правому колену пациента', cfg.main.male and 'ударил' or 'ударила'))
	wait(6000)
	sampSendChat("Здесь тоже все впорядке. Теперь проверим Вашу кровь.")
	wait(125)
	sampAddChatMessage("{D91111}Подсказка: {bf8080} подходим к столу и запускаем Отыгровку №[3]", -1)
	   
		end
      },
	    {
        title = '{ffffff}» Отыгровка №[3]',
        onclick = function()
        sampSendChat("/do На полу стоит мини-лаборатория.")
	wait(6000)
	sampSendChat("/do Через плечо врача накинута мед.сумка на ремне")
	wait(6000)
	
	sampSendChat(string.format('/me %s из мед.сумки вату, спирт, шприц и специальную колбочку', cfg.main.male and 'достал' or 'достала'))
	wait(6000)
	sampSendChat(string.format('/me %s вату спиртом', cfg.main.male and 'пропитал' or 'пропитала'))
	wait(6000)
	sampSendChat("/do Пропитанная спиртом вата в левой руке.")
	wait(6000)
	sampSendChat(string.format('/me %s ватой место укола на вене пациента', cfg.main.male and 'обработал' or 'обработала'))
	wait(6000)
	sampAddChatMessage('{D91111}Подсказка: {bf8080} подходим назад к пациенту.', -1)
	sampSendChat("/do Шприц и специальная колбочка в правой руке.")
	wait(6000)
	sampSendChat("/me аккуратным движением вводит шприц в вену пациента")
	wait(6000)
	sampSendChat(string.format('/me с помощью шприца %s немного крови для анализа ', cfg.main.male and 'взял' or 'взяла'))
	wait(125)
	sampAddChatMessage("{D91111}Подсказка: {bf8080} идем обратно к столу.", -1)
	wait(6000)
	sampSendChat(string.format('/me %s кровь из шприца в спец.колбу, затем %s ее в мини-лабораторию', cfg.main.male and 'перелил' or 'перелила', cfg.main.male and 'поместил' or 'поместила'))
	wait(125)
	sampAddChatMessage("{D91111}Подсказка: {bf8080} далее, вводим {D91111}/checkheal 'id', {bf8080}если написано {D91111}'нет' - ", -1)
    sampAddChatMessage("{bf8080}запускаем сразу {D91111}Отыгровку №[4]. А если написано {D91111}'Да'")
	sampAddChatMessage("- {bf8080}проводим сеанс от наркозависимости. И так же запускаем {D91111}Отыгровку №[4]")
	   
		end
      },
	   {
        title = '{ffffff}» Отыгровка №[4]',
        onclick = function()
        sampAddChatMessage("{D91111}Подсказка:{bf8080} подходим к столу и ждем дальнейших подсказок.", -1)
		wait(8000)
	sampSendChat("/do На экране показан отрицательный результат теста крови пациента. ")
	wait(6000)
	sampSendChat("/do Шкафчик открыт.")
	wait(6000)
	sampSendChat("/do В шкафчике стоят бланки справок.")
	wait(6000)
	sampSendChat(string.format('/me %s из шкафчика бланк справки', cfg.main.male and 'достал' or 'достала'))
	wait(6000)
	sampSendChat(string.format('/me %s справку о том, что данный человек не имеет наркозависимости и годен к службе', cfg.main.male and 'выписал' or 'выписала'))
	wait(125)
	sampAddChatMessage("{D91111}Подсказка: {bf8080} подойдите к пациенту.", -1)
	wait(8000)
	sampSendChat(string.format('/me %s справку пациенту в руки', cfg.main.male and 'передал' or 'передала'))
	wait(5000)
	sampSendChat("Всего доброго, до свидания.")
		end
      },
	   {
        title = '{5b83c2}« Проверка призывников »',
        onclick = function()
        end
      },
      {
        title = '» Процесс проверки.',
        onclick = function()
	sampSendChat("Здравствуйте. Сейчас мы проверим Вас на наличие наркозависимости. ")
	wait(3500)
	sampSendChat("/do Через плечо врача накинута мед.сумка на ремне. ")
	wait(3500)
	sampSendChat(string.format('/me %s из мед.сумки вату, спирт, шприц и специальную колбочку', cfg.main.male and 'достал' or 'достала'))
	wait(3500)
	sampSendChat(string.format('/me %s вату спиртом', cfg.main.male and 'пропитал' or 'пропитала'))
	wait(3500)
	sampSendChat("/do Пропитанная спиртом вата в левой руке.")
	wait(3500)
	sampSendChat(string.format('/me %s ватой место укола на вене рекрута', cfg.main.male and 'обработал' or 'обработала'))
	wait(3500)
	sampSendChat("/do Шприц и специальная колбочка в правой руке.")
	wait(3500)
	sampSendChat("/me аккуратным движением вводит шприц в вену рекрута ")
	wait(3500)
	sampSendChat(string.format('/me с помощью шприца %s немного крови для анализа ', cfg.main.male and 'взял' or 'взяла'))
	wait(3500)
	sampSendChat(string.format('/me %s кровь из шприца в спец.колбу, затем %s ее в мини-лабораторию', cfg.main.male and 'перелил' or 'перелила', cfg.main.male and 'поместил' or 'поместила'))
	wait(1000)
	sampAddChatMessage("{D91111}Подсказка:{bf8080} вводите {D91111}/checkheal id.", -1)
		sampAddChatMessage('{D91111}Подсказка:{bf8080} если написано "Нет" - ставим печать "Годен".', -1)
		sampAddChatMessage('{D91111}Подсказка:{bf8080} если "Да" - ставим "Не годен".', -1)
		sampAddChatMessage('{D91111}Подсказка:{bf8080} выбираем нужный пункт в меню отыгровки.', -1)
       end
      },
	 {
        title = '{ffffff}» Призывник {13E83E}годен',
        onclick = function()
	sampSendChat("/do На экране показан отрицательный результат теста крови пациента. ")
	wait(3005)
	sampSendChat(string.format('/me %s печать "Годен" в мед.карту рекрута', cfg.main.male and 'поставил' or 'поставила'))
	wait(3500)
		end
    },
	 {
        title = '{ffffff}» Призывник {D91111}не годен',
        onclick = function()
	sampSendChat("/do На экране показан положительный результат теста крови пациента. ")
	wait(3500)
	sampSendChat(string.format('/me %s печать "Не годен" в мед.карту рекрута', cfg.main.male and 'поставил' or 'поставила'))
	wait(3500)
		end
    },
	}
end


function invite(pam)
    lua_thread.create(function()
        local id = pam:match('(%d+)')
      if rank == 'Психолог' or rank == 'Хирург' or rank == 'Зам.Глав.Врача' or rank == 'Глав.Врач' then
        if id then
		if sampIsPlayerConnected(id) then
                sampSendChat('/me достал(а) бейджик и передал(а) его '..sampGetPlayerNickname(id):gsub('_', ' ')..'')
				wait(1500)
				sampSendChat(string.format('/invite %s', id))
				wait(2000)
				if cfg.main.tarb then
                sampSendChat(string.format('/r [%s]: Новый сотрудник Министерства Здравоохранения - '..sampGetPlayerNickname(id):gsub('_', ' ')..'. Добро пожаловать.', cfg.main.tarr))
                else
				sampSendChat('/r Новый сотрудник Министерства Здравоохранения - '..sampGetPlayerNickname(id):gsub('_', ' ')..'. Добро пожаловать.')
            end
			else 
			ftext('Игрок с данным ID не подключен к серверу или указан ваш ID')
		end
		else 
			ftext('Введите: /invite [id]')
		end
		else 
			ftext('Данная команда доступна с 9 ранга')
	  end
   end)
 end
 
function uninvite(pam)
   lua_thread.create(function()
      local id, pri4ina = pam:match('(%d+)%s+(.+)')
      if rank == 'Хирург' or rank == 'Зам.Глав.Врача' or rank == 'Глав.Врач' then
        if id and pri4ina then
		if sampIsPlayerConnected(id) then
                sampSendChat('/me забрал(а) бейджик у '..sampGetPlayerNickname(id):gsub('_', ' ')..'')
				wait(2000)
				sampSendChat(string.format('/uninvite %s %s', id, pri4ina))
				wait(2000)
				if cfg.main.tarb then
                sampSendChat(string.format('/r [%s]: '..sampGetPlayerNickname(id):gsub('_', ' ')..' - Уволен(а) по причине "%s".', cfg.main.tarr, pri4ina))
                else
				sampSendChat(string.format('/r '..sampGetPlayerNickname(id):gsub('_', ' ')..' - Уволен(а) по причине "%s".', pri4ina))
            end
			else 
			ftext('Игрок с данным ID не подключен к серверу или указан ваш ID')
		end
		else 
			ftext('Введите: /uninvite [id] [причина]')
		end
		else 
			ftext('Данная команда доступна с 8 ранга')
	 end
  end)
end
 
 function mediccmenu(args)
    return
    {
       {
        title = '{bf6868}» {13E83E}Поприветствовать.',
        onclick = function()
		sampSendChat("Здравствуйте, что вас беспокоит?") 
		end
      },
	  
	    {
        title = '{bf6868}» {13E83E}Попрощаться.',
        onclick = function()
        sampSendChat("Всего доброго, до скорых встреч") 
		end
      },
	     {
        title = '{bf6868}» {13E83E}Стоимость услуг',
        onclick = function()
        sampSendChat("Сеанс наркозависимости - 10.000$, операция - 100.000$, справка - 5.000$") 
		end
      },
	  
    }
end

function nawmenu(args)
    return
    {
      {
        title = '{ffffff}» Обработка ватки нашатырём',
        onclick = function()
		sampSendChat("/do на плече накинута мед.сумка")
		wait(cfg.commands.zaderjka * 800) 
        sampSendChat(string.format('/me %s аптечку', cfg.main.male and 'открыл' or 'открыла'))
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s из аптеки ватку и нашатырь', cfg.main.male and 'достал' or 'достала'))   
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat(string.format('/me %s ватку нашатырем и %s к носу пострадавшего', cfg.main.male and 'обработал' or 'обработала', cfg.main.male and 'поднес' or 'поднесла'))
        wait(cfg.commands.zaderjka * 1000) 
        sampSendChat("/me водит ваткой вокруг носа.")
        wait(cfg.commands.zaderjka * 1000) 
		sampSendChat("/do пострадавший пришел в себя.")
		 wait(cfg.commands.zaderjka * 1200) 
        sampSendChat("Не волнуйтесь, у вас случился в обморок.")
        wait(cfg.commands.zaderjka * 1000) 
        sampSendChat("Сейчас мы доставим вас в больницу, где разберемся с причиной данного недуга.") 
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
        title = '{ffffff}» Дать препарат',
        onclick = function()
		local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
        sampSendChat("Секунду, сейчас будете как огурчик!")
		wait(cfg.commands.zaderjka * 800)
		sampSendChat("/do на плече накинута мед.сумка")
		wait(cfg.commands.zaderjka * 500) 
		sampSendChat(string.format('/me %s аптечку', cfg.main.male and 'достал' or 'достала'))
		wait(cfg.commands.zaderjka * 500) 
		sampSendChat(string.format('/me %s необходимый препарат', cfg.main.male and 'нашел' or 'нашла'))
		wait(cfg.commands.zaderjka * 500) 
		sampSendChat("/do Диклофенак в руке")
		wait(cfg.commands.zaderjka * 500) 
		sampSendChat(string.format('/me %s пациенту лекарство и %s запить водой', cfg.main.male and 'нашел' or 'нашла', cfg.main.male and 'дал' or 'далa'))
		wait(cfg.commands.zaderjka * 500) 
		sampSendChat("/heal "..id)
		wait(cfg.commands.zaderjka * 500) 
		sampSendChat("Удачного дня, не болейте!")                                        		
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
        [0] = 'Гражданский',
        [1] = 'Гражданский',
        [2] = 'Гражданский',
        [3] = 'Гражданский',
        [4] = 'Гражданский',
        [5] = 'Гражданский',
        [6] = 'Гражданский',
        [7] = 'Гражданский',
        [8] = 'Гражданский',
        [9] = 'Гражданский',
        [10] = 'Гражданский',
        [11] = 'Гражданский',
        [12] = 'Гражданский',
        [13] = 'Гражданский',
        [14] = 'Гражданский',
        [15] = 'Гражданский',
        [16] = 'Гражданский',
        [17] = 'Гражданский',
        [18] = 'Гражданский',
        [19] = 'Гражданский',
        [20] = 'Гражданский',
        [21] = 'Ballas',
        [22] = 'Гражданский',
        [23] = 'Гражданский',
        [24] = 'Гражданский',
        [25] = 'Гражданский',
        [26] = 'Гражданский',
        [27] = 'Гражданский',
        [28] = 'Гражданский',
        [29] = 'Гражданский',
        [30] = 'Rifa',
        [31] = 'Гражданский',
        [32] = 'Гражданский',
        [33] = 'Гражданский',
        [34] = 'Гражданский',
        [35] = 'Гражданский',
        [36] = 'Гражданский',
        [37] = 'Гражданский',
        [38] = 'Гражданский',
        [39] = 'Гражданский',
        [40] = 'Гражданский',
        [41] = 'Aztec',
        [42] = 'Гражданский',
        [43] = 'Гражданский',
        [44] = 'Aztec',
        [45] = 'Гражданский',
        [46] = 'Гражданский',
        [47] = 'Vagos',
        [48] = 'Aztec',
        [49] = 'Гражданский',
        [50] = 'Гражданский',
        [51] = 'Гражданский',
        [52] = 'Гражданский',
        [53] = 'Гражданский',
        [54] = 'Гражданский',
        [55] = 'Гражданский',
        [56] = 'Grove',
        [57] = 'Мэрия',
        [58] = 'Гражданский',
        [59] = 'Автошкола',
        [60] = 'Гражданский',
        [61] = 'Армия',
        [62] = 'Гражданский',
        [63] = 'Гражданский',
        [64] = 'Гражданский',
        [65] = 'Гражданский', -- над подумать
        [66] = 'Гражданский',
        [67] = 'Гражданский',
        [68] = 'Гражданский',
        [69] = 'Гражданский',
        [70] = 'МОН',
        [71] = 'Гражданский',
        [72] = 'Гражданский',
        [73] = 'Army',
        [74] = 'Гражданский',
        [75] = 'Гражданский',
        [76] = 'Гражданский',
        [77] = 'Гражданский',
        [78] = 'Гражданский',
        [79] = 'Гражданский',
        [80] = 'Гражданский',
        [81] = 'Гражданский',
        [82] = 'Гражданский',
        [83] = 'Гражданский',
        [84] = 'Гражданский',
        [85] = 'Гражданский',
        [86] = 'Grove',
        [87] = 'Гражданский',
        [88] = 'Гражданский',
        [89] = 'Гражданский',
        [90] = 'Гражданский',
        [91] = 'Гражданский', -- под вопросом
        [92] = 'Гражданский',
        [93] = 'Гражданский',
        [94] = 'Гражданский',
        [95] = 'Гражданский',
        [96] = 'Гражданский',
        [97] = 'Гражданский',
        [98] = 'Мэрия',
        [99] = 'Гражданский',
        [100] = 'Байкер',
        [101] = 'Гражданский',
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
        [121] = 'Гражданский',
        [122] = 'Гражданский',
        [123] = 'Yakuza',
        [124] = 'LCN',
        [125] = 'RM',
        [126] = 'RM',
        [127] = 'LCN',
        [128] = 'Гражданский',
        [129] = 'Гражданский',
        [130] = 'Гражданский',
        [131] = 'Гражданский',
        [132] = 'Гражданский',
        [133] = 'Гражданский',
        [134] = 'Гражданский',
        [135] = 'Гражданский',
        [136] = 'Гражданский',
        [137] = 'Гражданский',
        [138] = 'Гражданский',
        [139] = 'Гражданский',
        [140] = 'Гражданский',
        [141] = 'FBI',
        [142] = 'Гражданский',
        [143] = 'Гражданский',
        [144] = 'Гражданский',
        [145] = 'Гражданский',
        [146] = 'Гражданский',
        [147] = 'Мэрия',
        [148] = 'Гражданский',
        [149] = 'Grove',
        [150] = 'Мэрия',
        [151] = 'Гражданский',
        [152] = 'Гражданский',
        [153] = 'Гражданский',
        [154] = 'Гражданский',
        [155] = 'Гражданский',
        [156] = 'Гражданский',
        [157] = 'Гражданский',
        [158] = 'Гражданский',
        [159] = 'Гражданский',
        [160] = 'Гражданский',
        [161] = 'Гражданский',
        [162] = 'Гражданский',
        [163] = 'FBI',
        [164] = 'FBI',
        [165] = 'FBI',
        [166] = 'FBI',
        [167] = 'Гражданский',
        [168] = 'Гражданский',
        [169] = 'Yakuza',
        [170] = 'Гражданский',
        [171] = 'Гражданский',
        [172] = 'Гражданский',
        [173] = 'Rifa',
        [174] = 'Rifa',
        [175] = 'Rifa',
        [176] = 'Гражданский',
        [177] = 'Гражданский',
        [178] = 'Гражданский',
        [179] = 'Army',
        [180] = 'Гражданский',
        [181] = 'Байкер',
        [182] = 'Гражданский',
        [183] = 'Гражданский',
        [184] = 'Гражданский',
        [185] = 'Гражданский',
        [186] = 'Yakuza',
        [187] = 'Мэрия',
        [188] = 'СМИ',
        [189] = 'Гражданский',
        [190] = 'Vagos',
        [191] = 'Army',
        [192] = 'Гражданский',
        [193] = 'Aztec',
        [194] = 'Гражданский',
        [195] = 'Ballas',
        [196] = 'Гражданский',
        [197] = 'Гражданский',
        [198] = 'Гражданский',
        [199] = 'Гражданский',
        [200] = 'Гражданский',
        [201] = 'Гражданский',
        [202] = 'Гражданский',
        [203] = 'Гражданский',
        [204] = 'Гражданский',
        [205] = 'Гражданский',
        [206] = 'Гражданский',
        [207] = 'Гражданский',
        [208] = 'Yakuza',
        [209] = 'Гражданский',
        [210] = 'Гражданский',
        [211] = 'СМИ',
        [212] = 'Гражданский',
        [213] = 'Гражданский',
        [214] = 'LCN',
        [215] = 'Гражданский',
        [216] = 'Гражданский',
        [217] = 'СМИ',
        [218] = 'Гражданский',
        [219] = 'МОН',
        [220] = 'Гражданский',
        [221] = 'Гражданский',
        [222] = 'Гражданский',
        [223] = 'LCN',
        [224] = 'Гражданский',
        [225] = 'Гражданский',
        [226] = 'Rifa',
        [227] = 'Мэрия',
        [228] = 'Гражданский',
        [229] = 'Гражданский',
        [230] = 'Гражданский',
        [231] = 'Гражданский',
        [232] = 'Гражданский',
        [233] = 'Гражданский',
        [234] = 'Гражданский',
        [235] = 'Гражданский',
        [236] = 'Гражданский',
        [237] = 'Гражданский',
        [238] = 'Гражданский',
        [239] = 'Гражданский',
        [240] = 'Автошкола',
        [241] = 'Гражданский',
        [242] = 'Гражданский',
        [243] = 'Гражданский',
        [244] = 'Гражданский',
        [245] = 'Гражданский',
        [246] = 'Байкер',
        [247] = 'Байкер',
        [248] = 'Байкер',
        [249] = 'Гражданский',
        [250] = 'СМИ',
        [251] = 'Гражданский',
        [252] = 'Army',
        [253] = 'Гражданский',
        [254] = 'Байкер',
        [255] = 'Army',
        [256] = 'Гражданский',
        [257] = 'Гражданский',
        [258] = 'Гражданский',
        [259] = 'Гражданский',
        [260] = 'Гражданский',
        [261] = 'СМИ',
        [262] = 'Гражданский',
        [263] = 'Гражданский',
        [264] = 'Гражданский',
        [265] = 'Полиция',
        [266] = 'Полиция',
        [267] = 'Полиция',
        [268] = 'Гражданский',
        [269] = 'Grove',
        [270] = 'Grove',
        [271] = 'Grove',
        [272] = 'RM',
        [273] = 'Гражданский', -- надо подумать
        [274] = 'МОН',
        [275] = 'МОН',
        [276] = 'МОН',
        [277] = 'Гражданский',
        [278] = 'Гражданский',
        [279] = 'Гражданский',
        [280] = 'Полиция',
        [281] = 'Полиция',
        [282] = 'Полиция',
        [283] = 'Полиция',
        [284] = 'Полиция',
        [285] = 'Полиция',
        [286] = 'FBI',
        [287] = 'Army',
        [288] = 'Полиция',
        [289] = 'Гражданский',
        [290] = 'Гражданский',
        [291] = 'Гражданский',
        [292] = 'Aztec',
        [293] = 'Гражданский',
        [294] = 'Гражданский',
        [295] = 'Гражданский',
        [296] = 'Гражданский',
        [297] = 'Grove',
        [298] = 'Гражданский',
        [299] = 'Гражданский',
        [300] = 'Полиция',
        [301] = 'Полиция',
        [302] = 'Полиция',
        [303] = 'Полиция',
        [304] = 'Полиция',
        [305] = 'Полиция',
        [306] = 'Полиция',
        [307] = 'Полиция',
        [308] = 'МОН',
        [309] = 'Полиция',
        [310] = 'Полиция',
        [311] = 'Полиция'
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
                        ftext('Обнаружено обновление до версии '..updversion..'.')
					    updwindows.v = f
                    else
                        ftext('Обновлений скрипта не обнаружено. Приятной игры.', -1)
                        update = false
				    end
			    end
		    end
	    end
    end)
end


function smsjob()
  if rank == 'Психолог' or rank == 'Хирург' or rank == 'Зам.Глав.Врача' or rank == 'Глав.Врач' then
    lua_thread.create(function()
        vixodid = {}
		status = true
		sampSendChat('/members')
        while not gotovo do wait(0) end
        wait(1200)
        for k, v in pairs(vixodid) do
            sampSendChat('/sms '..v..' На работу')
            wait(1200)
        end
        players2 = {'{ffffff}Ник\t{ffffff}Ранг\t{ffffff}Статус'}
		players1 = {'{ffffff}Ник\t{ffffff}Ранг'}
		gotovo = false
        status = false
        vixodid = {}
	end)
	else 
	ftext('Данная команда доступна с 7 ранга')
	end
end

function goupdate()
    ftext('Началось скачивание обновления. Скрипт перезагрузится через пару секунд.', -1)
    wait(300)
    downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23)
    if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
        showCursor(false)
	    thisScript():reload()
    end
end)
end

function cmd_color() -- функция получения цвета строки, хз зачем она мне, но когда то юзал
	local text, prefix, color, pcolor = sampGetChatString(99)
	sampAddChatMessage(string.format("Цвет последней строки чата - {934054}[%d] (скопирован в буфер обмена)",color),-1)
	setClipboardText(color)
end

function getcolor(id)
local colors = 
        {
		[1] = 'Зелёный',
		[2] = 'Светло-зелёный',
		[3] = 'Ярко-зелёный',
		[4] = 'Бирюзовый',
		[5] = 'Жёлто-зелёный',
		[6] = 'Темно-зелёный',
		[7] = 'Серо-зелёный',
		[8] = 'Красный',
		[9] = 'Ярко-красный',
		[10] = 'Оранжевый',
		[11] = 'Коричневый',
		[12] = 'Тёмно-красный',
		[13] = 'Серо-красный',
		[14] = 'Жёлто-оранжевый',
		[15] = 'Малиновый',
		[16] = 'Розовый',
		[17] = 'Синий',
		[18] = 'Голубой',
		[19] = 'Синяя сталь',
		[20] = 'Сине-зелёный',
		[21] = 'Тёмно-синий',
		[22] = 'Фиолетовый',
		[23] = 'Индиго',
		[24] = 'Серо-синий',
		[25] = 'Жёлтый',
		[26] = 'Кукурузный',
		[27] = 'Золотой',
		[28] = 'Старое золото',
		[29] = 'Оливковый',
		[30] = 'Серый',
		[31] = 'Серебро',
		[32] = 'Черный',
		[33] = 'Белый',
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
            ftext('Цвет ника сменен на: {'..color..'}'..cfg.main.clist..' ['..colors..']')
        end)
    end
end

function sampev.onServerMessage(color, text)
        if text:find('Рабочий день начат') and color ~= -1 then
        if cfg.main.clistb then
		if rabden == false then
            lua_thread.create(function()
                wait(100)
				sampSendChat('/clist '..tonumber(cfg.main.clist))
				wait(1000)
				ftext('Не забывайте оставлять TimeCard каждый час с 9:00 до 20:00, это важно!')
				wait(1000)
                local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
			    local color = ("%06X"):format(bit.band(sampGetPlayerColor(myid), 0xFFFFFF))
                colors = getcolor(cfg.main.clist)
                ftext('Цвет ника сменен на: {'..color..'}'..cfg.main.clist..' ['..colors..']')
                rabden = true
				wait(1000)
				if cfg.main.clisto then
				local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
                local myname = sampGetPlayerNickname(myid)
				if cfg.main.male == true then
				sampSendChat("/me открыл шкафчик")
                wait(1500)
                sampSendChat("/me снял свою одежду, после чего сложил ее в шкаф")
                wait(1500)
                sampSendChat("/me взял рабочую одежду, затем переоделся в нее")
                wait(1500)
                sampSendChat("/me нацепил бейджик на рубашку")
                wait(1500)
                sampSendChat('/do На рубашке бейджик с надписью "'..rank..' | '..myname:gsub('_', ' ')..'".')  
				end
				if cfg.main.male == false then
				sampSendChat("/me открыла шкафчик")
                wait(1500)
                sampSendChat("/me сняла свою одежду, после чего сложила ее в шкаф")
                wait(1500)
                sampSendChat("/me взяла рабочую одежду, затем переоделась в нее")
                wait(1500)
                sampSendChat("/me нацепила бейджик на рубашку")
                wait(1500)
                sampSendChat('/do На рубашке бейджик с надписью "'..rank..' | '..myname:gsub('_', ' ')..'".')
				end
			end
            end)
        end
	  end
    end
	if text:find('SMS:') and text:find('Отправитель:') then
		wordsSMS, nickSMS = string.match(text, 'SMS: (.+) Отправитель: (.+)');
		local idsms = nickSMS:match('.+%[(%d+)%]')
		lastnumber = idsms
	end
    if text:find('Рабочий день окончен') and color ~= -1 then
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
		if text:match('Всего: %d+ человек') then
			local count = text:match('Всего: (%d+) человек')
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
            if stat:find('Выходной') and tonumber(nmrang) < 7 then
                table.insert(vixodid, id)
            end
			table.insert(players2, string.format('{ffffff}%s\t {'..color..'}%s[%s]{ffffff}\t%s\t%s', data, nick, id, rang, stat))
			return false
		end
		if text:match('Всего: %d+ человек') then
			local count = text:match('Всего: (%d+) человек')
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
        [1] = "А",
        [2] = "Б",
        [3] = "В",
        [4] = "Г",
        [5] = "Д",
        [6] = "Ж",
        [7] = "З",
        [8] = "И",
        [9] = "К",
        [10] = "Л",
        [11] = "М",
        [12] = "Н",
        [13] = "О",
        [14] = "П",
        [15] = "Р",
        [16] = "С",
        [17] = "Т",
        [18] = "У",
        [19] = "Ф",
        [20] = "Х",
        [21] = "Ц",
        [22] = "Ч",
        [23] = "Ш",
        [24] = "Я",
    }
    local X, Y, Z = getCharCoordinates(playerPed)
    X = math.ceil((X + 3000) / 250)
    Y = math.ceil((Y * - 1 + 3000) / 250)
    Y = KV[Y]
    local KVX = (Y.."-"..X)
    return KVX
end
