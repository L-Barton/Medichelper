script_name("FBI Tools")
script_authors("Thomas Lawson, Sesh Jefferson")
script_version(3.32)

require 'lib.moonloader'
require 'lib.sampfuncs'

local lsg, sf               = pcall(require, 'sampfuncs')
local lkey, key             = pcall(require, 'vkeys')
local lmemory, memory       = pcall(require, 'memory')
local lsampev, sp           = pcall(require, 'lib.samp.events')
local lsphere, Sphere       = pcall(require, 'Sphere')
local lrkeys, rkeys         = pcall(require, 'rkeys')
local limadd, imadd         = pcall(require, 'imgui_addons')
local limgui, imgui         = pcall(require, 'imgui')
local lrequests, requests   = pcall(require, 'requests')
local lsha1, sha1           = pcall(require, 'sha1')
local lbasexx, basexx       = pcall(require, 'basexx')
local dlstatus              = require('moonloader').download_status
local wm                    = require 'lib.windows.message'
local gk                    = require 'game.keys'
local encoding              = require 'encoding'
local band                  = bit.band
encoding.default            = 'CP1251'
u8 = encoding.UTF8

local groupNames = {
    u8'ПД/ФБР', u8'Инструкторы', u8'Медики', u8'Мэрия
}

local cfg =
{
    main = {
        posX = 1566,
        posY = 916,
        widehud = 350,
        male = true,
        clear = false,
        hud = false,
        tar = 'òýã',
        parol = 'ïàðîëü',
        parolb = false,
        tarb = false,
        clistb = false,
        spzamen = false,
        clist = 0,
        offptrl = false,
        offwntd = false,
        tchat = false,
        autocar = false,
        strobs = true,
        megaf = true,
        autobp = false,
        googlecode = '',
        googlecodeb = false,
        group = 'unknown',
        nwanted = false,
        nclear = false
    },
    commands = {
        cput = true,
        ceject = true,
        deject = true,
        ftazer = true,
        zaderjka = 1400,
        ticket = true,
        kmdctime = true
    },
    autobp = {
        deagle = true,
        dvadeagle = true,
        shot = true,
        dvashot = true,
        smg = true,
        dvasmg = true,
        m4 = true,
        dvam4 = true,
        rifle = true,
        dvarifle = true,
        armour = true,
        spec = true
    }
}

if limgui then 
    mainw           = imgui.ImBool(false)
    setwindows      = imgui.ImBool(false)
    shpwindow       = imgui.ImBool(false)
    ykwindow        = imgui.ImBool(false)
    fpwindow        = imgui.ImBool(false)
    akwindow        = imgui.ImBool(false)
    pozivn          = imgui.ImBool(false)
    updwindows      = imgui.ImBool(false)
    bMainWindow     = imgui.ImBool(false)
    bindkey         = imgui.ImBool(false)
    cmdwind         = imgui.ImBool(false)
    memw            = imgui.ImBool(false)
    sInputEdit      = imgui.ImBuffer(256)
    bIsEnterEdit    = imgui.ImBool(false)
    piew            = imgui.ImBool(false)
    imegaf          = imgui.ImBool(false)
    bindname        = imgui.ImBuffer(256)
    bindtext        = imgui.ImBuffer(20480)
    groupInt        = imgui.ImInt(0)
    vars = {
        menuselect  = 0,
        mainwindow  = imgui.ImBool(false),
        cmdbuf      = imgui.ImBuffer(256),
        cmdparams   = imgui.ImInt(0),
        cmdtext     = imgui.ImBuffer(20480)
    }
end

function ftext(text)
    sampAddChatMessage((' %s | {ffffff}%s'):format(script.this.name, text),0x9966CC)
end

local config_keys = {
    oopda = { v = {key.VK_F12}},
    oopnet = { v = {key.VK_F11}},
    tazerkey = { v = {key.VK_X}},
    fastmenukey = { v = {key.VK_F2}},
    megafkey = { v = {18,77}},
    dkldkey = { v = {18,80}},
    cuffkey = { v = {}},
    followkey = { v = {}},
    cputkey = { v = {}},
    cejectkey = { v = {}},
    takekey = { v = {}},
    arrestkey = { v = {}},
    uncuffkey = { v = {}},
    dejectkey = { v = {}},
    sirenkey = { v = {}},
    hikey = {v = {key.VK_I}},
	summakey = {v = {key.VK_L}},
	freenalkey = {v = {key.VK_Y}},
    freebankkey = {v = {key.VK_U}},
    vzaimkey = {v = {key.VK_Z}}
}

local mcheckb = false
local stazer = false
local rabden = false
local frak = -1
local rang = -1
local warnst = false
local changetextpos = false
local opyatstat = false
local gmegafid = -1
local targetid = -1
local smsid = -1
local smstoid = -1
local mcid = -1
local vixodid = {}
local ins = {}
local ooplistt = {}
local tLastKeys = {}
local departament = {}
local radio = {}
local sms = {}
local wanted = {}
local incar = {}
local suz = {}
local show = 1
local autoBP = 1
local checkstat = false
local fileb = getWorkingDirectory() .. "\\config\\fbitools.bind"
local tMembers = {}
local Player = {}
local tBindList = {}
local commands = {}
local fthelp = {
    {
        cmd = '/ft',
        desc = 'Îòêðûòü ìåíþ ñêðèïòà',
        use = '/ft'
    },
    {
        cmd = '/st',
        desc = 'Ïîïðîñèòü èãðîêà çàãëóøèòü ñâîå Ò/Ñ ÷åðåç ìåãàôîí [/m]',
        use = '/st [id]'
    },
    {
        cmd = '/oop',
        desc = 'Íàïèñàòü â âîëíó äåïàðòàìåíòà îá ÎÎÏ',
        use = '/oop [id]'
    },
    {
        cmd = '/warn',
        desc = 'Ïðåäóïðåäèòü èãðîêà â âîëíó äåïàðòàìåíòà î íàðóøåíèè ïîäà÷è â ðîçûñê',
        use = '/warn [id]'
    },
    {
        cmd = '/su',
        desc = 'Âûäàòü ðîçûñê ÷åðåç äèàëîã',
        use = '/su [id]'
    },
    {
        cmd = '/ssu',
        desc = 'Âûäàòü ðîçûñê ÷åðåç ñåðâåðíóþ êîìàíäó',
        use = '/ssu [id] [êîë-âî çâåçä] [ïðè÷èíà]'
    },
    {
        cmd = '/cput',
        desc = 'ÐÏ îòûãðîâêà ïîñàäêè ïðåñòóïíèêà â àâòîìîáèëü/ìîòî',
        use = '/cput [id] [ñèäåíüå(íå îáÿçàòåëüíî)]'
    },
    {
        cmd = '/ceject',
        desc = 'ÐÏ îòûãðîâêà âûñàäêè ïðåñòóïíèêà èç àâòîìîáèëÿ/ìîòî',
        use = '/ceject [id]'
    },
    {
        cmd = '/deject',
        desc = 'ÐÏ îòûãðîâêà âûòàñêèâàíèÿ ïðåñòóïíèêà èç àâòîìîáèëÿ/ìîòî',
        use = '/deject [id]'
    },
    {
        cmd = '/ms',
        desc = 'ÐÏ îòûãðîâêà âçÿòèÿ ìàñêèðîâêè',
        use = '/ms [òèï]'
    },
    {
        cmd = '/keys',
        desc = "ÐÏ îòûãðîâêà ñðàâíåíèÿ êëþ÷åé îò ÊÏÇ",
        use = '/keys'
    },
    {
        cmd = '/rh',
        desc = "Çàïðîñèòü ïàòðóëüíûé ýêèïàæ â òåêóùèé êâàäðàò",
        use = "/rh [äåïàðòàìåíò(1 - LSPD, 2 - SFPD, 3 - LVPD)]"
    },
    {
        cmd = '/tazer',
        desc = "ÐÏ òàçåð",
        use = '/tazer'
    },
    {
        cmd = "/gr",
        desc = "Íàïèñàòü â âîëíó äåïàðòàìåíòà î ïåðåñå÷åíèè þðèñäèêöèè",
        use = "/gr [äåïàðòàìåíò(1 - LSPD, 2 - SFPD, 3 - LVPD)] [ïðè÷èíà]"
    },
    {
        cmd = '/df',
        desc = "Îòêðûòü äèàëîã ñ ðàçìèíèðîâàíèåì áîìá",
        use = '/df'
    },
    {
        cmd = '/dmb',
        desc = 'Îòêðûòü /members â äèàëîãå',
        use = '/dmb'
    },
    {
        cmd = '/ar',
        desc = 'Ïîïðîñèòü ðàçðåøåíèå íà âúåçä íà âîåííóþ òåððèòîðèþ â âîëíó äåïàðòàìåíòà',
        use = '/ar [àðìèÿ(1 - LVA, 2 - SFA)]'
    },
    {
        cmd = '/pr',
        desc = 'Ïðàâèëà ìèðàíäû',
        use = '/pr'
    },
    {
        cmd = '/kmdc',
        desc = 'Ïî ÐÏ ïðîáèòü èãðîêà â ÊÏÊ',
        use = '/kmdc [id]'
    },
    {
        cmd = '/ftazer',
        desc = 'ÐÏ îòûãðîâêà /ftazer',
        use = '/ftazer [òèï]'
    },
    {
        cmd = '/fvz',
        desc = 'Âûçâàòü èãðîêà â îôèñ ÔÁÐ ñî ñòàðøèìè',
        use = '/fvz [id]'
    },
    {
        cmd = '/fbd',
        desc = 'Çàïðîñèòü ïðè÷èíó èçìåíåíèÿ ÁÄ ïî âîëíå äåïàðòàìåíòà',
        use = '/fbd [id]'
    },
    {
        cmd = '/blg',
        desc = 'Âûðàçèòü áëàãîäàðíîñòü ïî âîëíå äåïàðòàìåíòà',
        use = "/blg [id] [ôðàêöèÿ] [ïðè÷èíà]"
    },
    {
        cmd = '/yk',
        desc = "Îòêðûòü øïîðó ÓÊ (Òåêñò øïîðû ìîæíî èçìåíèòü â ôàéëå moonloader/fbitools/yk.txt)",
        use = "/yk"
    },
    {
        cmd = '/ak',
        desc = "Îòêðûòü øïîðó ÀÊ (Òåêñò øïîðû ìîæíî èçìåíèòü â ôàéëå moonloader/fbitools/ak.txt)",
        use = "/ak"
    },
    {
        cmd = '/fp',
        desc = "Îòêðûòü øïîðó ÔÏ (Òåêñò øïîðû ìîæíî èçìåíèòü â ôàéëå moonloader/fbitools/fp.txt)",
        use = "/fp"
    },
    {
        cmd = '/shp',
        desc = "Îòêðûòü øïîðó (Òåêñò øïîðû ìîæíî èçìåíèòü â ôàéëå moonloader/fbitools/shp.txt)",
        use = "/shp"
    },
    {
        cmd = '/fyk',
        desc = 'Ïîèñê ïî øïîðå ÓÊ',
        use = '/fyk [òåêñò]'
    },
    {
        cmd = '/fak',
        desc = 'Ïîèñê ïî øïîðå ÀÊ',
        use = '/fak [òåêñò]'
    },
    {
        cmd = '/ffp',
        desc = 'Ïîèñê ïî øïîðå ÔÏ',
        use = '/ffp [òåêñò]'
    },
    {
        cmd = '/fshp',
        desc = 'Ïîèñê ïî øïîðå',
        use = '/fshp [òåêñò]'
    },
    {
        cmd = '/fst',
        desc = 'Èçìåíèòü âðåìÿ',
        use = '/fst [âðåìÿ]'
    },
    {
        cmd = '/fsw',
        desc = 'Èçìåíèòü ïîãîäó',
        use = '/fsw [ïîãîäà]'
    },
    {
        cmd = '/cc',
        desc = 'Î÷èñòèòü ÷àò',
        use = '/cc'
    },
    {
        cmd = '/dkld',
        desc = 'Ñäåëàòü äîêëàä',
        use = '/dkld'
    },
    {
        cmd = '/mcheck',
        desc = 'Ïðîáèòü ïî /mdc âñåõ íà ðàññòîÿíèè 200 ìåòðîâ',
        use = '/mcheck'
    },
    {
        cmd = '/megaf',
        desc = 'Ìåãàôîí ñ àâòîîòïðåäåëåíèåì àâòî',
        use = '/megaf'
    },
    {
        cmd = '/rlog',
        desc = 'Îòêðûòü ëîã 25 ïîñëåäíèõ ñîîáùåíèé â ðàöèþ',
        use = '/rlog'
    },
    {
        cmd = '/dlog',
        desc = 'Îòêðûòü ëîã 25 ïîñëåäíèõ ñîîáùåíèé â äåïàðòàìåíò',
        use = '/dlog'
    },
    {
        cmd = '/sulog',
        desc = 'Îòêðûòü ëîã 25 ïîñëåäíèõ âûäà÷è ðîçûñêà',
        use = '/sulog'
    },
    {
        cmd = '/smslog',
        desc = 'Îòêðûòü ëîã 25 ïîñëåäíèõ SMS',
        use = '/smslog'
    },
    {
        cmd = '/z',
        desc = 'Âûäàòü ðîçûñê ïî çàãîòîâëåíûì ñòàòüÿì',
        use = '/z [id] [ïàðàìåòð(íå îáÿçàòåëüíî)]'
    },
    {
        cmd = '/rt',
        desc = 'Ñîîáùåíèå â ðàöèþ áåç òýãà',
        use = '/rt [òåêñò]'
    },
    {
        cmd = '/ooplist',
        desc = 'Ñïèñîê ÎÎÏ',
        use = '/ooplist [id(íå îáÿçàòåëüíî)]'
    },
    {
        cmd = '/fkv',
        desc = 'Ïîñòàâèòü ìåòêó íà êâàäðàò íà êàðòå',
        use = '/fkv [êâàäðàò]'
    },
    {
        cmd = '/fnr',
        desc = 'Ñîçâàòü ñîòðóäíèêîâ íà ðàáîòó',
        use = '/fnr'
    }
}
local tEditData = {
	id = -1,
	inputActive = false
}
local quitReason = {
    [1] = 'Âûõîä',
    [2] = 'Êèê/Áàí',
    [0] = 'Êðàø/Âûëåò'
}
local sut = [[
Íàíåñåíèå òåëåñíûõ ïîâðåæäåíèé - 2 ãîäà
Âîîðóæåííîå íàïàäåíèå íà ãðàæäàíñêèõ - 3 ãîäà
Âîîðóæåííîå íàïàäåíèå íà ãîñ - 6 ëåò, çàïðåò íà àäâîêàòà
Õóëèãàíñòâî - 1 ãîä
Íåàäåêâàòíîå ïîâåäåíèå - 1 ãîä
Ïîïðîøàéíè÷åñòâî - 1 ãîä
Îñêîðáëåíèå - 2 ãîäà
Óãîí òðàíñïîðòíîãî ñðåäñòâà - 2 ãîäà
Íåïîä÷èíåíèå ñîòðóäíèêàì ÏÎ - 1 ãîä
Óõîä îò ñîòðóäíèêîâ ÏÎ - 2 ãîäà
Ïîáåã ñ ìåñòà çàêëþ÷åíèÿ - 6 ëåò
Íîøåíèå îðóæèÿ áåç ëèöåíçèè - 1 ãîä è øòðàô â ðàçìåðå 2000$.
Èçãîòîâëåíèå íåëåãàëüíîãî îðóæèÿ - 3 ãîäà è èçúÿòèå
Ïðèîáðåòåíèå íåëåãàëüíîãî îðóæèÿ - 3 ãîäà è èçúÿòèå
Ïðîäàæà íåëåãàëüíîãî îðóæèÿ - 3 ãîäà è èçúÿòèå
Õðàíåíèå íàðêîòèêîâ - 3 ãîäà è èçúÿòèå
Õðàíåíèå ìàòåðèàëîâ - 3 ãîäà è èçúÿòèå
Óïîòðåáëåíèå íàðêîòèêîâ - 3 ãîäà è èçúÿòèå
Ïîð÷à ÷óæîãî èìóùåñòâà - 1 ãîä è øòðàô â ðàçìåðå 5000$
Óíè÷òîæåíèå ÷óæîãî èìóùåñòâà - 4 ãîäà è øòðàô â ðàçìåðå 15000$
Ïðîíèêíîâåíèå íà îõð. òåððèòîðèþ - 2 ãîäà
Ïðîíèêíîâåíèå íà ÷àñò. òåððèòîðèþ - 1 ãîä
Âûìîãàòåëüñòâî - 2 ãîäà
Óãðîçû - 1 ãîä
Ïðîâîêàöèè - 2 ãîäà
Ìîøåííè÷åñòâî - 2 ãîäà
Ïðåäëîæåíèå èíòèìíûõ óñëóã - 1 ãîä
Èçíàñèëîâàíèå ãðàæäàíèíà - 3 ãîä
Óêðûâàòåëüñòâî ïðåñòóïëåíèé - 2 ãîäà
Èñïîëüçîâàíèå ôàëüøèâûõ äîêóìåíòîâ - 1 ãîä
Êëåâåòà íà ãîñ. ëèöî - 1 ãîä
Êëåâåòà íà ãîñ. îðãàíèçàöèè - 2 ãîäà
Íîøåíèå âîåííîé ôîðìû - 2 ãîäà, ôîðìà ïîäëåæèò èçúÿòèþ.
Ïîêóïêà êëþ÷åé îò êàìåðû - 6 ëåò
Ïðåäëîæåíèå âçÿòêè - 2 ãîäà
Ñîâåðøåíèå òåðàêòà - 6 ëåò, ëèøåíèå âñåõ ëèöåíçèé
Íåóïëàòà øòðàôà - 2 ãîäà
Èãíîðèðîâàíèå ñïåö. ñèðåí - 1 ãîä
Ïðåâûøåíèå ïîëíîìî÷èé àäâîêàòà - 3 ãîäà
Ïîõèùåíèå ãîñ. ñîòðóäíèêà - 4 ãîäà
×èñòîñåðäå÷íîå ïðèçíàíèå - 1 ãîä
Íàåçä íà ïåøåõîäà - 2 ãîäà
Óõîä ñ ìåñòà ÄÒÏ - 3 ãîäà
Îãðàáëåíèå - 3 ãîäà
ÎÎÏ - 6 ëåò
Óõîä - 6 ëåò
]]

local shpt = [[
Ïîêà ÷òî âû íå íàñòðîèëè øïîðó.
×òî áû âñòàâèòü ñþäà ñâîé òåêñò âàì íóæíî âûïîëíèòü ðÿä äåéòñâèé:
1. Îòêðûòü ïàïêó fbitools êîòîðàÿ íàõîäèòñÿ â ïàïêå moonloader
2. Îòêðûòü ôàéë shp.txt ëþáûì áëîêíîòîì
3. Èçìåíèòü òåêñò â íåì íà êàêîé âàì íóæåí
4. Ñîõðàíèòü ôàéë
]]

function sampGetStreamedPlayers()
	local t = {}
	for i = 0, sampGetMaxPlayerId(false) do
		if sampIsPlayerConnected(i) then
			local result, sped = sampGetCharHandleBySampPlayerId(i)
			if result then
				if doesCharExist(sped) then
					table.insert(t, i)
                end
			end
		end
    end
	return t
end

function sirenk()
    if cfg.main.group == 'ÏÄ/ÔÁÐ' then 
        if isCharInAnyCar(PLAYER_PED) then
            local car = storeCarCharIsInNoSave(PLAYER_PED)
            switchCarSiren(car, not isCarSirenOn(car))
        end
    end
end

function getClosestPlayerId()
    local minDist = 9999
    local closestId = -1
    local x, y, z = getCharCoordinates(PLAYER_PED)
    for i = 0, 999 do
        local streamed, pedID = sampGetCharHandleBySampPlayerId(i)
        if streamed then
            local xi, yi, zi = getCharCoordinates(pedID)
            local dist = math.sqrt( (xi - x) ^ 2 + (yi - y) ^ 2 + (zi - z) ^ 2 )
            if dist < minDist and sampGetFraktionBySkin(i) ~= 'Ïîëèöèÿ' and sampGetFraktionBySkin(i) ~= 'FBI' then
                minDist = dist
                closestId = i
            end
        end
    end
    return closestId
end
function getClosestPlayerIDinCar()
    local minDist = 9999
    local closestId = -1
    local x, y, z = getCharCoordinates(PLAYER_PED)
    local veh = storeCarCharIsInNoSave(PLAYER_PED)
    for i = 0, 999 do
        local streamed, pedID = sampGetCharHandleBySampPlayerId(i)
        if streamed then
            local xi, yi, zi = getCharCoordinates(pedID)
            local dist = math.sqrt( (xi - x) ^ 2 + (yi - y) ^ 2 + (zi - z) ^ 2 )
            if dist < minDist and sampGetFraktionBySkin(i) ~= 'Ïîëèöèÿ' and sampGetFraktionBySkin(i) ~= 'FBI' and isCharInAnyCar(pedID) then
                if storeCarCharIsInNoSave(pedID) == veh then
                    minDist = dist
                    closestId = i
                end
            end
        end
    end
    return closestId
end

function getClosestPlayerIDinCarD()
    local minDist = 9999
    local closestId = -1
    local x, y, z = getCharCoordinates(PLAYER_PED)
    for i = 0, 999 do
        local streamed, pedID = sampGetCharHandleBySampPlayerId(i)
        if streamed then
            local xi, yi, zi = getCharCoordinates(pedID)
            local dist = math.sqrt( (xi - x) ^ 2 + (yi - y) ^ 2 + (zi - z) ^ 2 )
            if dist < minDist and sampGetFraktionBySkin(i) ~= 'Ïîëèöèÿ' and sampGetFraktionBySkin(i) ~= 'FBI' and isCharInAnyCar(pedID) then
                minDist = dist
                closestId = i
            end
        end
    end
    return closestId
end

function cuffk()
    if cfg.main.group == 'ÏÄ/ÔÁÐ' then 
        local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
        if valid then
            result, targetid = sampGetPlayerIdByCharHandle(ped)
            if result then
                lua_thread.create(function()
                    sampSendChat(string.format('/me %s ðóêè ïðåñòóïíèêà è %s íàðó÷íèêè', cfg.main.male and 'çàëîìàë' or 'çàëîìàëà', cfg.main.male and 'äîñòàë' or 'äîñòàëà'))
                    wait(1400)
                    sampSendChat('/cuff '..targetid)
                    gmegafhandle = ped
                    gmegafid = targetid
                    gmegaflvl = sampGetPlayerScore(targetid)
                    gmegaffrak = sampGetFraktionBySkin(targetid)
                end)
            end
        else
            local closeid = getClosestPlayerId()
            if closeid ~= -1 then 
                local result, closehandle = sampGetCharHandleBySampPlayerId(closeid)
                if doesCharExist(closehandle) then
                    lua_thread.create(function()
                        sampSendChat(string.format('/me %s ðóêè ïðåñòóïíèêà è %s íàðó÷íèêè', cfg.main.male and 'çàëîìàë' or 'çàëîìàëà', cfg.main.male and 'äîñòàë' or 'äîñòàëà'))
                        wait(1400)
                        sampSendChat('/cuff '..closeid)
                        gmegafhandle = closehandle
                        gmegafid = closeid
                        gmegaflvl = sampGetPlayerScore(closeid)
                        gmegaffrak = sampGetFraktionBySkin(closeid)
                    end)
                end
            end
        end
    end
end

function uncuffk()
    if cfg.main.group == 'ÏÄ/ÔÁÐ' then 
        local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
        if valid then
            local result, targetid = sampGetPlayerIdByCharHandle(ped)
            if result then
                lua_thread.create(function()
                    sampSendChat(string.format('/me %s íàðó÷íèêè ñ ïðåñòóïíèêà', cfg.main.male and 'ñíÿë' or 'ñíÿëà'))
                    wait(1400)
                    sampSendChat('/uncuff '..targetid)
                    gmegafhandle = nil
                    gmegafid = -1
                    gmegaflvl = nil
                    gmegaffrak = nil
                end)
            end
        else
            local closeid = getClosestPlayerId()
            if sampIsPlayerConnected(closeid) then
                if closeid ~= -1 then
                    local result, closehandle = sampGetCharHandleBySampPlayerId(closeid)
                    if doesCharExist(closehandle) then
                        lua_thread.create(function()
                            sampSendChat(string.format('/me %s íàðó÷íèêè ñ ïðåñòóïíèêà', cfg.main.male and 'ñíÿë' or 'ñíÿëà'))
                            wait(1400)
                            sampSendChat('/uncuff '..closeid)
                            gmegafhandle = nil
                            gmegafid = -1
                            gmegaflvl = nil
                            gmegaffrak = nil
                        end)
                    end
                end
            end
        end
    end
end

function followk()
    if cfg.main.group == 'ÏÄ/ÔÁÐ' then 
        local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
        if valid then
            result, targetid = sampGetPlayerIdByCharHandle(ped)
            if result then
                lua_thread.create(function()
                    sampSendChat(string.format('/me %s îäèí èç êîíöîâ íàðó÷íèêîâ ê ñåáå, ïîñëå ÷åãî %s çà ñîáîé ïðåñòóïíèêà', cfg.main.male and 'ïðèñòåãíóë' or 'ïðèñòåãíóëà', cfg.main.male and 'ïîâåë' or 'ïîâåëà'))
                    wait(1400)
                    sampSendChat('/follow '..targetid)
                    gmegafhandle = ped
                    gmegafid = targetid
                    gmegaflvl = sampGetPlayerScore(targetid)
                    gmegaffrak = sampGetFraktionBySkin(targetid)
                end)
            end
        else
            local closeid = getClosestPlayerId()
            if closeid ~= -1 then 
                local result, closehandle = sampGetCharHandleBySampPlayerId(closeid)
                if doesCharExist(closehandle) then
                    lua_thread.create(function()
                        sampSendChat(string.format('/me %s îäèí èç êîíöîâ íàðó÷íèêîâ ê ñåáå, ïîñëå ÷åãî %s çà ñîáîé ïðåñòóïíèêà', cfg.main.male and 'ïðèñòåãíóë' or 'ïðèñòåãíóëà', cfg.main.male and 'ïîâåë' or 'ïîâåëà'))
                        wait(1400)
                        sampSendChat('/follow '..closeid)
                        gmegafhandle = closehandle
                        gmegafid = closeid
                        gmegaflvl = sampGetPlayerScore(closeid)
                        gmegaffrak = sampGetFraktionBySkin(closeid)
                    end)
                end
            end
        end
    end
end

function cputk()
    if cfg.main.group == 'ÏÄ/ÔÁÐ' then 
        local closeid = getClosestPlayerId()
        if closeid ~= -1 then
            local result, closehandle = sampGetCharHandleBySampPlayerId(closeid)
            if doesCharExist(closehandle) then
                lua_thread.create(function()
                    if isCharOnAnyBike(PLAYER_PED) then
                        sampSendChat(string.format("/me %s ïðåñòóïíèêà íà ñèäåíüå ìîòîöèêëà", cfg.main.male and 'ïîñàäèë' or 'ïîñàäèëà'))
                        wait(1400)
                        sampSendChat("/cput "..closeid.." 1", -1)
                    else
                        sampSendChat(string.format("/me %s äâåðü àâòîìîáèëÿ è %s òóäà ïðåñòóïíèêà", cfg.main.male and 'îòêðûë' or 'îòêðûëà', cfg.main.male and 'çàòîëêíóë' or 'çàòîëêíóëà'))
                        wait(1400)
                        sampSendChat("/cput "..closeid.." "..getFreeSeat(), -1)
                    end
                    gmegafhandle = closehandle
                    gmegafid = closeid
                    gmegaflvl = sampGetPlayerScore(closeid)
                    gmegaffrak = sampGetFraktionBySkin(closeid)
                end)
            end
        end
    end
end

function cejectk()
    if cfg.main.group == 'ÏÄ/ÔÁÐ' then 
        if isCharInAnyCar(PLAYER_PED) then
            local closestId = getClosestPlayerIDinCar()
            if closestId ~= -1 then
                local result, closehandle = sampGetCharHandleBySampPlayerId(closestId)
                lua_thread.create(function()
                    if isCharOnAnyBike(PLAYER_PED) then
                        sampSendChat(string.format("/me %s ïðåñòóïíèêà ñ ìîòîöèêëà", cfg.main.male and 'âûñàäèë' or 'âûñàäèëà'))
                        wait(1400)
                        sampSendChat("/ceject "..closestId, -1)
                    else
                        sampSendChat(string.format("/me %s äâåðü àâòîìîáèëÿ è %s ïðåñòóïíèêà", cfg.main.male and 'îòêðûë' or 'îòêðûë', cfg.main.male and 'âûñàäèë' or 'âûñàäèëà'))
                        wait(1400)
                        sampSendChat("/ceject "..closestId)
                    end
                    gmegafhandle = closehandle
                    gmegafid = closestId
                    gmegaflvl = sampGetPlayerScore(closestId)
                    gmegaffrak = sampGetFraktionBySkin(closestId)
                end)
            end
        end
    end
end

function takek()
    if cfg.main.group == 'ÏÄ/ÔÁÐ' then 
        local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
        if valid then
            result, targetid = sampGetPlayerIdByCharHandle(ped)
            if result then
                lua_thread.create(function()
                    sampSendChat(string.format('/me íàäåâ ïåð÷àòêè, %s ðóêàìè ïî òîðñó', cfg.main.male and 'ïðîâåë' or 'ïðîâåëà'))
                    wait(1400)
                    sampSendChat('/take '..targetid)
                    gmegafhandle = ped
                    gmegafid = targetid
                    gmegaflvl = sampGetPlayerScore(targetid)
                    gmegaffrak = sampGetFraktionBySkin(targetid)
                end)
            end
        else
            local closeid = getClosestPlayerId()
            if closeid ~= -1 then 
                local result, closehandle = sampGetCharHandleBySampPlayerId(closeid)
                if doesCharExist(closehandle) then
                    lua_thread.create(function()
                        sampSendChat(string.format('/me íàäåâ ïåð÷àòêè, %s ðóêàìè ïî òîðñó', cfg.main.male and 'ïðîâåë' or 'ïðîâåëà'))
                        wait(cfg.commands.zaderjka)
                        sampSendChat('/take '..closeid)
                        gmegafhandle = closehandle
                        gmegafid = closeid
                        gmegaflvl = sampGetPlayerScore(closeid)
                        gmegaffrak = sampGetFraktionBySkin(closeid)
                    end)
                end
            end
        end
    end
end

function arrestk()
    if cfg.main.group == 'ÏÄ/ÔÁÐ' then 
        local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
        if valid then
            result, targetid = sampGetPlayerIdByCharHandle(ped)
            if result then
                lua_thread.create(function()
                    --[[sampSendChat(string.format('/me %s êàìåðó', cfg.main.male and 'îòêðûë' or 'îòêðûëà'))
                    wait(cfg.commands.zaderjka)
                    sampSendChat(string.format('/me %s ïðåñòóïíèêà â êàìåðó', cfg.main.male and 'ïðîâåë' or 'ïðîâåëà'))
                    wait(cfg.commands.zaderjka)
                    sampSendChat('/arrest '..targetid)
                    wait(cfg.commands.zaderjka)
                    sampSendChat(string.format('/me %s êàìåðó', cfg.main.male and 'çàêðûë' or 'çàêðûëà'))]]
                    sampSendChat("/do Êëþ÷è îò êàìåðû âèñÿò íà ïîÿñå.")
                    wait(cfg.commands.zaderjka)
                    sampSendChat(string.format("/me %s êëþ÷è ñ ïîÿñà è %s êàìåðó, ïîñëå %s òóäà ïðåñòóïíèêà", cfg.main.male and 'ñíÿë' or 'ñíÿëà', cfg.main.male and 'îòêðûë' or 'îòêðûëà', cfg.main.male and 'çàòîëêíóë' or 'çàòîëêíóëà'))
                    wait(cfg.commands.zaderjka)
                    sampSendChat('/arrest '..targetid)
                    wait(cfg.commands.zaderjka)
                    sampSendChat(string.format("/me %s äâåðü êàìåðû è %s êëþ÷è íà ïîÿñ", cfg.main.male and 'çàêðûë' or 'çàêðûëà', cfg.main.male and 'ïîâåñèë' or 'ïîâåñèëà'))
                    gmegafhandle = nil
                    gmegafid = -1
                    gmegaflvl = nil
                    gmegaffrak = nil
                end)
            end
        else
            local closeid = getClosestPlayerId()
            if closeid ~= -1 then 
                local result, closehandle = sampGetCharHandleBySampPlayerId(closeid)
                if doesCharExist(closehandle) then
                    lua_thread.create(function()
                        --[[sampSendChat(string.format('/me %s êàìåðó', cfg.main.male and 'îòêðûë' or 'îòêðûëà'))
                        wait(cfg.commands.zaderjka)
                        sampSendChat(string.format('/me %s ïðåñòóïíèêà â êàìåðó', cfg.main.male and 'ïðîâåë' or 'ïðîâåëà'))
                        wait(cfg.commands.zaderjka)
                        sampSendChat('/arrest '..closeid)
                        wait(cfg.commands.zaderjka)
                        sampSendChat(string.format('/me %s êàìåðó', cfg.main.male and 'çàêðûë' or 'çàêðûëà'))]]
                        sampSendChat("/do Êëþ÷è îò êàìåðû âèñÿò íà ïîÿñå.")
                        wait(cfg.commands.zaderjka)
                        sampSendChat(string.format("/me %s êëþ÷è ñ ïîÿñà è %s êàìåðó, ïîñëå %s òóäà ïðåñòóïíèêà", cfg.main.male and 'ñíÿë' or 'ñíÿëà', cfg.main.male and 'îòêðûë' or 'îòêðûëà', cfg.main.male and 'çàòîëêíóë' or 'çàòîëêíóëà'))
                        wait(cfg.commands.zaderjka)
                        sampSendChat('/arrest '..closeid)
                        wait(cfg.commands.zaderjka)
                        sampSendChat(string.format("/me %s äâåðü êàìåðû è %s êëþ÷è íà ïîÿñ", cfg.main.male and 'çàêðûë' or 'çàêðûëà', cfg.main.male and 'ïîâåñèë' or 'ïîâåñèëà'))
                        gmegafhandle = nil
                        gmegafid = -1
                        gmegaflvl = nil
                        gmegaffrak = nil
                    end)
                end
            end
        end
    end
end

function dejectk()
    if cfg.main.group == 'ÏÄ/ÔÁÐ' then 
        local closestId = getClosestPlayerIDinCarD()
        if closestId ~= -1 then
            local result, closehandle = sampGetCharHandleBySampPlayerId(closestId)
            if result then
                lua_thread.create(function()
                    if isCharInFlyingVehicle(closehandle) then
                        sampSendChat(string.format("/me %s äâåðü âåðòîë¸òà è %s ïðåñòóïíèêà", cfg.main.male and 'îòêðûë' or 'îòêðûëà', cfg.main.male and 'âûòàùèë' or 'âûòàùèëà'))
                        wait(1400)
                        sampSendChat("/deject "..closestId)
                    elseif isCharInModel(closehandle, 481) or isCharInModel(closehandle, 510) then
                        sampSendChat(string.format("/me ñêèíóë ïðåñòóïíèêà ñ âåëîñèïåäà", cfg.main.male and 'ñêèíóë' or 'ñêèíóëà'))
                        wait(1400)
                        sampSendChat("/deject "..closestId)
                    elseif isCharInModel(closehandle, 462) then
                        sampSendChat(string.format("/me %s ïðåñòóïíèêà ñî ñêóòåðà", cfg.main.male and 'ñêèíóë' or 'ñêèíóëà'))
                        wait(1400)
                        sampSendChat("/deject "..closestId)
                    elseif isCharOnAnyBike(closehandle) then
                        sampSendChat(string.format("/me %s ïðåñòóïíèêà ñ ìîòîöèêëà", cfg.main.male and 'ñêèíóë' or 'ñêèíóëà'))
                        wait(1400)
                        sampSendChat("/deject "..closestId)
                    elseif isCharInAnyCar(closehandle) then
                        sampSendChat(string.format("/me %s îêíî è %s ïðåñòóïíèêà èç ìàøèíû", cfg.main.male and 'ðàçáèë' or 'ðàçáèëà', cfg.main.male and 'âûòîëêíóë' or 'âûòîëêíóëà'))
                        wait(1400)
                        sampSendChat("/deject "..closestId)
                    end
                end)
            end
        end
    end
end

function hikeyk()
	if cfg.main.group == 'Ìýðèÿ' then
		lua_thread.create(function()
			sampSendChat(string.format('Ïðèâåòñòâóþ, ÿ àäâîêàò %s. Êòî íóæäàåòñÿ â ìîèõ óñëóãàõ?', sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub('_', ' ')))
			wait(1400)
			sampSendChat(string.format('/b /showpass %s', select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))))
		end)
	end
end

function summakeyk()
	if cfg.main.group == 'Ìýðèÿ' then
		lua_thread.create(function()
			local valid, tped = getCharPlayerIsTargeting(PLAYER_HANDLE)
			if valid and doesCharExist(tped) then
				local result, tid = sampGetPlayerIdByCharHandle(tped)
				if result then
					local tlvl = sampGetPlayerScore(tid)
					sampSendChat(string.format('Ñóììà âàøåãî âûçâîëåíèÿ ñîñòàâëÿåò %s.', getFreeCost(tlvl)))
					wait(1400)
					sampSendChat('×åì æåëàåòå îïëàòèòü, áàíêîì èëè íàëè÷íûìè?')
				end
			end
		end)
	end
end

function freenalkeyk()
	if cfg.main.group == 'Ìýðèÿ' then
		lua_thread.create(function()
			local valid, tped = getCharPlayerIsTargeting(PLAYER_HANDLE)
			if valid and doesCharExist(tped) then
				local result, tid = sampGetPlayerIdByCharHandle(tped)
				if result then
					local tlvl = sampGetPlayerScore(tid)
					sampSendChat('/me äîñòàë áëàíê èç êåéñà è íà÷àë åãî çàïîëíÿòü')
					wait(1400)
					sampSendChat('/me ïîñòàâèë ïå÷àòü â áëàíêå è ïåðåäàë çàêëþ÷åííîìó')
					wait(1400)
					sampSendChat(string.format('/free %s 1 %s', tid, getFreeCost(tlvl)))
				end
			end
		end)
	end
end

function freebankkeyk()
	if cfg.main.group == 'Ìýðèÿ' then
		lua_thread.create(function()
			local valid, tped = getCharPlayerIsTargeting(PLAYER_HANDLE)
			if valid and doesCharExist(tped) then
				local result, tid = sampGetPlayerIdByCharHandle(tped)
				if result then
					local tlvl = sampGetPlayerScore(tid)
					sampSendChat('/me äîñòàë áëàíê èç êåéñà è íà÷àë åãî çàïîëíÿòü')
					wait(1400)
					sampSendChat('/me ïîñòàâèë ïå÷àòü â áëàíêå è ïåðåäàë çàêëþ÷åííîìó')
					wait(1400)
					sampSendChat(string.format('/free %s 2 %s', tid, getFreeCost(tlvl)))
				end
			end
		end)
	end
end

function vzaimk()
    local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
    if valid and doesCharExist(ped) then
        local result, id = sampGetPlayerIdByCharHandle(ped)
        --targetid = id
        if result then
            if cfg.main.group == 'ÏÄ/ÔÁÐ' then
                gmegafhandle = ped
                gmegafid = id
                gmegaflvl = sampGetPlayerScore(id)
                gmegaffrak = sampGetFraktionBySkin(id)
                submenus_show(pkmmenuPD(id), "{9966cc}"..script.this.name.." {ffffff}| "..sampGetPlayerNickname(id).." ["..id.."] ")
            elseif cfg.main.group == "Àâòîøêîëà" then
                submenus_show(pkmmenuAS(id), "{9966cc}"..script.this.name.." {ffffff}| "..sampGetPlayerNickname(id).." ["..id.."] ")
            elseif cfg.main.group == "Ìåäèêè" then
                submenus_show(pkmmenuMOH(id), "{9966cc}"..script.this.name.." {ffffff}| "..sampGetPlayerNickname(id).." ["..id.."] ")
            end
        end
    end
end

function sampGetFraktionBySkin(id)
    local skin = 0
    local t = 'Ãðàæäàíñêèé'
    --if sampIsPlayerConnected(id) then
        local result, ped = sampGetCharHandleBySampPlayerId(id)
        if result then
            skin = getCharModel(ped)
        else
            skin = getCharModel(PLAYER_PED)
        end
        if skin == 102 or skin == 103 or skin == 104 or skin == 195 or skin == 21 then t = 'Ballas Gang' end
        if skin == 105 or skin == 106 or skin == 107 or skin == 269 or skin == 270 or skin == 271 or skin == 86 or skin == 149 or skin == 297 then t = 'Grove Gang' end
        if skin == 108 or skin == 109 or skin == 110 or skin == 190 or skin == 47 then t = 'Vagos Gang' end
        if skin == 114 or skin == 115 or skin == 116 or skin == 48 or skin == 44 or skin == 41 or skin == 292 then t = 'Aztec Gang' end
        if skin == 173 or skin == 174 or skin == 175 or skin == 193 or skin == 226 or skin == 30 or skin == 119 then t = 'Rifa Gang' end
        if skin == 191 or skin == 252 or skin == 287 or skin == 61 or skin == 179 or skin == 255 then t = 'Army' end
        if skin == 57 or skin == 98 or skin == 147 or skin == 150 or skin == 187 or skin == 216 then t = 'Ìýðèÿ' end
        if skin == 59 or skin == 172 or skin == 189 or skin == 240 then t = 'Àâòîøêîëà' end
        if skin == 201 or skin == 247 or skin == 248 or skin == 254 or skin == 248 or skin == 298 then t = 'Áàéêåðû' end
        if skin == 272 or skin == 112 or skin == 125 or skin == 214 or skin == 111  or skin == 126 then t = 'Ðóññêàÿ ìàôèÿ' end
        if skin == 113 or skin == 124 or skin == 214 or skin == 223 then t = 'La Cosa Nostra' end
        if skin == 120 or skin == 123 or skin == 169 or skin == 186 then t = 'Yakuza' end
        if skin == 211 or skin == 217 or skin == 250 or skin == 261 then t = 'News' end
        if skin == 70 or skin == 219 or skin == 274 or skin == 275 or skin == 276 or skin == 70 then t = 'Ìåäèêè' end
        if skin == 286 or skin == 141 or skin == 163 or skin == 164 or skin == 165 or skin == 166 then t = 'FBI' end
        if skin == 280 or skin == 265 or skin == 266 or skin == 267 or skin == 281 or skin == 282 or skin == 288 or skin == 284 or skin == 285 or skin == 304 or skin == 305 or skin == 306 or skin == 307 or skin == 309 or skin == 283 or skin == 303 then t = 'Ïîëèöèÿ' end
    --end
    return t
end

function sampGetPlayerIdByNickname(nick)
    local _, myid = sampGetPlayerIdByCharHandle(playerPed)
    if tostring(nick) == sampGetPlayerNickname(myid) then return myid end
    for i = 0, 1000 do if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == tostring(nick) then return i end end
end

function getMaskList(forma)
	local mask = {
		['ãðàæäàíñêîãî'] = 0,
		['ïîëèöåéñêîãî'] = 1,
		['âîåííîãî'] = 2,
		['ëàáîðàòîðèÿ'] = 3,
		['ìåäèêà'] = 3,
		['ñîòðóäíèêà ìýðèè'] = 4,
		['ðàáîòíèêà àâòîøêîëû'] = 5,
		['ðàáîòíèêà íîâîñòåé'] = 6,
		['×ÎÏ LCN'] = 7,
		['×ÎÏ Yakuza'] = 8,
		['×ÎÏ Russian Mafia'] = 9,
		['ÁÊ Rifa'] = 10,
		['ÁÊ Grove'] = 11,
		['ÁÊ Ballas'] = 12,
		['ÁÊ Vagos'] = 13,
		['ÁÊ Aztec'] = 14,
		['áàéêåðîâ'] = 15
	}
	return mask[forma]
end

local russian_characters = {
    [168] = '¨', [184] = '¸', [192] = 'À', [193] = 'Á', [194] = 'Â', [195] = 'Ã', [196] = 'Ä', [197] = 'Å', [198] = 'Æ', [199] = 'Ç', [200] = 'È', [201] = 'É', [202] = 'Ê', [203] = 'Ë', [204] = 'Ì', [205] = 'Í', [206] = 'Î', [207] = 'Ï', [208] = 'Ð', [209] = 'Ñ', [210] = 'Ò', [211] = 'Ó', [212] = 'Ô', [213] = 'Õ', [214] = 'Ö', [215] = '×', [216] = 'Ø', [217] = 'Ù', [218] = 'Ú', [219] = 'Û', [220] = 'Ü', [221] = 'Ý', [222] = 'Þ', [223] = 'ß', [224] = 'à', [225] = 'á', [226] = 'â', [227] = 'ã', [228] = 'ä', [229] = 'å', [230] = 'æ', [231] = 'ç', [232] = 'è', [233] = 'é', [234] = 'ê', [235] = 'ë', [236] = 'ì', [237] = 'í', [238] = 'î', [239] = 'ï', [240] = 'ð', [241] = 'ñ', [242] = 'ò', [243] = 'ó', [244] = 'ô', [245] = 'õ', [246] = 'ö', [247] = '÷', [248] = 'ø', [249] = 'ù', [250] = 'ú', [251] = 'û', [252] = 'ü', [253] = 'ý', [254] = 'þ', [255] = 'ÿ',
}
function string.rlower(s)
    s = s:lower()
    local strlen = s:len()
    if strlen == 0 then return s end
    s = s:lower()
    local output = ''
    for i = 1, strlen do
        local ch = s:byte(i)
        if ch >= 192 and ch <= 223 then
            output = output .. russian_characters[ch + 32]
        elseif ch == 168 then
            output = output .. russian_characters[184]
        else
            output = output .. string.char(ch)
        end
    end
    return output
end
function string.rupper(s)
    s = s:upper()
    local strlen = s:len()
    if strlen == 0 then return s end
    s = s:upper()
    local output = ''
    for i = 1, strlen do
        local ch = s:byte(i)
        if ch >= 224 and ch <= 255 then
            output = output .. russian_characters[ch - 32]
        elseif ch == 184 then
            output = output .. russian_characters[168]
        else
            output = output .. string.char(ch)
        end
    end
    return output
end
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
                    if type(item.submenu) == 'table' then
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
                else
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

local dfmenu = {
    {
        title = 'Áîìáà ñ ÷àñîâûì ìåõàíèçìîì',
        onclick = function()
            sampSendChat(("/me %s ñàïåðíûé íàáîð"):format(cfg.main.male and 'äîñòàë' or 'äîñòàëà'))
            wait(3500)
            sampSendChat(("/me %s ñàïåðíûé íàáîð"):format(cfg.main.male and 'îòêðûë' or 'îòêðûëà'))
            wait(3500)
            sampSendChat(("/me %s âçðûâíîå óñòðîéñòâî"):format(cfg.main.male and 'îñìîòðåë' or 'îñìîòðåëà'))
            wait(3500)
            sampSendChat(("/do %s òèï âçðûâíîãî óñòðîéñòâà. Áîìáà ñ ÷àñîâûì ìåõàíèçìîì."):format(cfg.main.male and 'Îïðåäåëèë' or 'Îïðåäåëèëà'))
            wait(3500)
            sampSendChat(("/do %s òðè ïðîâîäà âûõîäÿùèõ ñ ìåõàíèçìà."):format(cfg.main.male and 'Óâèäåë' or 'Óâèäåëà'))
            wait(3500)
            sampSendChat(("/me %s íîæ èç ñàïåðíîãî íàáîðà"):format(cfg.main.male and 'äîñòàë' or 'äîñòàëà'))
            wait(3500)
            sampSendChat(("/me àêêóðàòíî %s ïåðâûé ïðîâîä"):format(cfg.main.male and 'çà÷èñòèë' or 'çà÷èñòèëà'))
            wait(3500)
            sampSendChat(("/try %s îòâåðòêó ñ èíäèêàòîðîì è %s êðàé îòâåðòêè ê îãîë¸ííîì ïðîâîäó"):format(cfg.main.male and 'äîñòàë' or 'äîñòàëà', cfg.main.male and 'ïðèñëîíèë' or 'ïðèñëîíèëà'))
        end
    },
    {
        title = 'Áîìáà ñ ÷àñîâûì ìåõàíèçìîì åñëè {63c600}[Óäà÷íî]',
        onclick = function()
            sampSendChat(("/me %s ïðîâîäîê"):format(cfg.main.male and 'ïåðåðåçàë' or 'ïåðåðåçàëà'))
            wait(3500)
            sampSendChat(("/me %s ê óñòðîéñòâó"):format(cfg.main.male and 'ïðèñëóøàëñÿ' or 'ïðèñëóøàëàñü'))
            wait(3500)
            sampSendChat("/do Ìåõàíèçì ïåðåñòàë èçäàâàòü òèêàþùèå çâóêè.")
            wait(3500)
            sampSendChat("/do Áîìáà îáåçâðåæåíà.")
            wait(3500)
            sampSendChat(("/me %s èíñòðóìåíòû îáðàòíî â ñàïåðíûé íàáîð"):format(cfg.main.male and 'ñëîæèë' or 'ñëîæèëà'))
            wait(3500)
            sampSendChat(("/me %s áðîíèðîâàííûé êåéñ è àêêóðàòíî %s òóäà áîìáó"):format(cfg.main.male and 'äîñòàë' or 'äîñòàëà', cfg.main.male and 'ñëîæèë' or 'ñëîæèëà'))
        end
    },
    {
        title = 'Áîìáà ñ ÷àñîâûì ìåõàíèçìîì åñëè {bf0000}[Íåóäà÷íî]',
        onclick = function()
            sampSendChat(("/me àêêóðàòíî %s âòîðîé ïðîâîä"):format(cfg.main.male and 'çà÷èñòèë' or 'çà÷èñòèëà'))
            wait(3500)
            sampSendChat(("/me %s ïðîâîäîê"):format(cfg.main.male and 'ïåðåðåçàë' or 'ïåðåðåçàëà'))
            wait(3500)
            sampSendChat(("/me %s ê óñòðîéñòâó"):format(cfg.main.male and 'ïðèñëóøàëñÿ' or 'ïðèñëóøàëàñü'))
            wait(3500)
            sampSendChat("/do Ìåõàíèçì ïåðåñòàë èçäàâàòü òèêàþùèå çâóêè.")
            wait(3500)
            sampSendChat("/do Áîìáà îáåçâðåæåíà.")
            wait(3500)
            sampSendChat(("/me %s èíñòðóìåíòû îáðàòíî â ñàïåðíûé íàáîð"):format(cfg.main.male and 'ñëîæèë' or 'ñëîæèëà'))
            wait(3500)
            sampSendChat(("/me %s áðîíèðîâàííûé êåéñ è àêêóðàòíî %s òóäà áîìáó"):format(cfg.main.male and 'äîñòàë' or 'äîñòàëà', cfg.main.male and 'ñëîæèë' or 'ñëîæèëà'))
        end
    },
    {
        title = 'Áîìáà ñ äèñòàíöèîííûì óïðàâëåíèåì',
        onclick = function()
            sampSendChat(("/me %s ñàïåðíûé íàáîð"):format(cfg.main.male and 'äîñòàë' or 'äîñòàëà'))
            wait(3500)
            sampSendChat(("/me %s ñàïåðíûé íàáîð"):format(cfg.main.male and 'îòêðûë' or 'îòêðûëà'))
            wait(3500)
            sampSendChat(("/me %s âçðûâíîå óñòðîéñòâî"):format(cfg.main.male and 'îñìîòðåë' or 'îñìîòðåëà'))
            wait(3500)
            sampSendChat(("/do %s òèï âçðûâíîãî óñòðîéñòâà. Áîìáà ñ äèñòàíöèîííûì óïðàâëåíèåì."):format(cfg.main.male and 'Îïðåäåëèë' or 'Îïðåäåëèëà'))
            wait(3500)
            sampSendChat(("/do %s äâà øóðóïà íà áëîêå ñ ìåõàíèçìîì."):format(cfg.main.male and 'Óâèäåë' or 'Óâèäåëà'))
            wait(3500)
            sampSendChat(("/me %s îòâåðòêó èç ñàïåðíîãî íàáîðà"):format(cfg.main.male and 'äîñòàë' or 'äîñòàëà'))
            wait(3500)
            sampSendChat("/me àêêóðàòíî âûêðó÷èâàåò øóðóï")
            wait(3500)
            sampSendChat(("/me %s êðûøêó áëîêà è %s àíòåííó"):format(cfg.main.male and 'îòîäâèíóë' or 'îòîäâèíóëà', cfg.main.male and 'óâèäåë' or 'óâèäåëà'))
            wait(3500)
            sampSendChat(("/do %s êðàñíûé ìèãàþùèé èíäèêàòîð."):format(cfg.main.male and 'Óâèäåë' or 'Óâèäåëà'))
            wait(3500)
            sampSendChat(("/me %s ïóòü ìèêðîñõåìû îò àíòåííû ê äåòîíàòîðó"):format(cfg.main.male and 'ïðîñìîòðåë' or 'ïðîñìîòðåëà'))
            wait(3500)
            sampSendChat(("/me %s äâà ïðîâîäà"):format(cfg.main.male and 'Óâèäåë' or 'Óâèäåëà'))
            wait(3500)
            sampSendChat(("/try %s ïåðâûé ïðîâîä. Èíäèêàòîð ïåðåñòàë ìèãàòü."):format(cfg.main.male and 'ïåðåðåçàë' or 'ïåðåðåçàëà'))
        end
    },
    {
        title = 'Áîìáà ñ äèñòàíöèîííûì óïðàâëåíèåì åñëè {63c600}[Óäà÷íî]',
        onclick = function()
            sampSendChat("/do Áîìáà îáåçâðåæåíà.")
            wait(3500)
            sampSendChat(("/me %s èíñòðóìåíòû îáðàòíî â ñàïåðíûé íàáîð"):format(cfg.main.male and 'ñëîæèë' or 'ñëîæèëà'))
            wait(3500)
            sampSendChat(("/me %s áðîíèðîâàííûé êåéñ è àêêóðàòíî %s òóäà áîìáó"):format(cfg.main.male and 'äîñòàë' or 'äîñòàëà', cfg.main.male and 'ñëîæèë' or 'ñëîæèëà'))
        end
    },
    {
        title = 'Áîìáà ñ äèñòàíöèîííûì óïðàâëåíèåì åñëè {bf0000}[Íåóäà÷íî]',
        onclick = function()
            sampSendChat(("/me %s âòîðîé ïðîâîä"):format(cfg.main.male and 'ïåðåðåçàë' or 'ïåðåðåçàëà'))
            wait(3500)
            sampSendChat("/do Èíäèêàòîð ïåðåñòàë ìèãàòü.")
            wait(3500)
            sampSendChat("/do Áîìáà îáåçâðåæåíà.")
            wait(3500)
            sampSendChat(("/me %s èíñòðóìåíòû îáðàòíî â ñàïåðíûé íàáîð"):format(cfg.main.male and 'ñëîæèë' or 'ñëîæèëà'))
            wait(3500)
            sampSendChat(("/me %s áðîíèðîâàííûé êåéñ è àêêóðàòíî %s òóäà áîìáó"):format(cfg.main.male and 'äîñòàë' or 'äîñòàëà', cfg.main.male and 'ñëîæèë' or 'ñëîæèëà'))
        end
    },
    {
        title = 'Áîìáà ñ àêòèâàöèîííûì êîäîì',
        onclick = function()
            sampSendChat(("/me %s ñàïåðíûé íàáîð"):format(cfg.main.male and 'äîñòàë' or 'äîñòàëà'))
            wait(3500)
            sampSendChat(("/me %s ñàïåðíûé íàáîð"):format(cfg.main.male and 'îòêðûë' or 'îòêðûëà'))
            wait(3500)
            sampSendChat(("/me %s âçðûâíîå óñòðîéñòâî"):format(cfg.main.male and 'îñìîòðåë' or 'îñìîòðåëà'))
            wait(3500)
            sampSendChat(("/do %s òèï âçðûâíîãî óñòðîéñòâà. Áîìáà ñ àêòèâàöèîííûì êîäîì."):format(cfg.main.male and 'Îïðåäåëèë' or 'Îïðåäåëèëà'))
            wait(3500)
            sampSendChat(("/me %s èç ñàïåðíîãî íàáîðà ïðèáîð äëÿ ïîäáîðà êîäà"):format(cfg.main.male and 'äîñòàë' or 'äîñòàëà'))
            wait(3500)
            sampSendChat(("/me %s ïðèáîð ê áîìáå"):format(cfg.main.male and 'ïîäêëþ÷èë' or 'ïîäêëþ÷èëà'))
            wait(3500)
            sampSendChat("/do Íà ïðèáîðå âûñâåòèëîñü: Îæèäàíèå ïîëó÷åíèÿ ïàðîëÿ.")
            wait(3500)
            sampSendChat("/do Íà ïðèáîðå âûñâåòèëîñü: Ïàðîëü 5326.")
            wait(3500)
            sampSendChat(("/try %s ïîëó÷åííûé ïàðîëü. Ýêðàí áîìáû âûêëþ÷èëñÿ"):format(cfg.main.male and 'ââ¸ë' or 'ââ¸ëà'))
        end
    },
    {
        title = 'Áîìáà ñ àêòèâàöèîííûì êîäîì åñëè {63c600}[Óäà÷íî]',
        onclick = function()
            sampSendChat("/do Áîìáà îáåçâðåæåíà.")
            wait(3500)
            sampSendChat(("/me %s èíñòðóìåíòû îáðàòíî â ñàïåðíûé íàáîð"):format(cfg.main.male and 'ñëîæèë' or 'ñëîæèëà'))
            wait(3500)
            sampSendChat(("/me %s áðîíèðîâàííûé êåéñ è àêêóðàòíî %s òóäà áîìáó"):format(cfg.main.male and 'äîñòàë' or 'äîñòàëà', cfg.main.male and 'ñëîæèë' or 'ñëîæèëà'))
        end
    },
    {
        title = 'Áîìáà ñ àêòèâàöèîííûì êîäîì åñëè {bf0000}[Íåóäà÷íî]',
        onclick = function()
            sampSendChat(("/me ïåðåçàãðóçèëà ïðèáîð"):format(cfg.main.male and 'ïåðåçàãðóçèë' or 'ïåðåçàãðóçèëà'))
            wait(3500)
            sampSendChat("/do Íà ïðèáîðå âûñâåòèëîñü: Îæèäàíèå ïîëó÷åíèÿ ïàðîëÿ.")
            wait(3500)
            sampSendChat("/do Íà ïðèáîðå âûñâåòèëîñü: Ïàðîëü 3789.")
            wait(3500)
            sampSendChat(("/me %s ïîëó÷åííûé ïàðîëü"):format(cfg.main.male and 'ââ¸ë' or 'ââ¸ëà'))
            wait(3500)
            sampSendChat("/Ýêðàí áîìáû âûêëþ÷èëñÿ")
            wait(3500)
            sampSendChat("/do Áîìáà îáåçâðåæåíà.")
            wait(3500)
            sampSendChat(("/me %s èíñòðóìåíòû îáðàòíî â ñàïåðíûé íàáîð"):format(cfg.main.male and 'ñëîæèë' or 'ñëîæèëà'))
            wait(3500)
            sampSendChat(("/me %s áðîíèðîâàííûé êåéñ è àêêóðàòíî %s òóäà áîìáó"):format(cfg.main.male and 'äîñòàë' or 'äîñòàëà', cfg.main.male and 'ñëîæèë' or 'ñëîæèëà'))
        end
    }
}

local fcmenu =
{
  {
    title = 'Òåðàêòû',
    submenu =
    {
      {
        title = '{00BFFF}« Ìýðèÿ »'
      },
      {
        title = '{00BFFF}Çàõâàò ìýðèè áåç çàëîæíèêîâ  {ff0000}100.000$'
      },
      {
        title = '{00BFFF}Çàõâàò ìýðèè c çàëîæíèêàìè  {ff0000}150.000$'
      },
      {
        title = '{9A9593}« Îôèñ ÔÁÐ »'
      },
      {
        title = '{9A9593}Çàõâàò îôèñà ôåäåðàëüíîãî áþðî áåç çàëîæíèêîâ  {ff0000}100.000$'
      },
      {
        title = '{9A9593}Çàõâàò îôèñà ôåäåðàëüíîãî áþðî c çàëîæíèêàìè  {ff0000}150.000$'
      },
      {
        title = '{0080FF}« Ó÷àñòîê SFPD »'
      },
      {
        title = '{0080FF}Çàõâàò ó÷àñòêà SAPD áåç çàëîæíèêîâ  {ff0000}100.000$'
      },
      {
        title = '{0080FF}Çàõâàò ó÷àñòêà SAPD c çàëîæíèêàìè  {ff0000}150.000$'
      },
      {
        title = '{BF4040}« Áîëüíèöà »'
      },
      {
        title = '{BF4040}Çàõâàò áîëüíèöû áåç çàëîæíèêîâ  {ff0000}75.000$'
      },
      {
        title = '{BF4040}Çàõâàò áîëüíèöû ñ çàëîæíèêàìè  {ff0000}100.000$'
      },
      {
        title = '{00BFFF}« Àâòîøêîëà »'
      },
      {
        title = '{00BFFF}Çàõâàò àâòîøêîëû áåç çàëîæíèêîâ  {ff0000}50.000$'
      },
      {
        title = '{00BFFF}Çàõâàò àâòîøêîëû ñ çàëîæíèêàìè  {ff0000}75.000$'
      },
      {
        title = '{40BFBF}« CÌÈ »'
      },
      {
        title = '{40BFBF}Çàõâàò ÑÌÈ áåç çàëîæíèêîâ  {ff0000}50.000$'
      },
      {
        title = '{40BFBF}Çàõâàò ÑÌÈ ñ çàëîæíèêàìè  {ff0000}75.000$'
      },
      {
        title = '« Îñòàëüíîå »'
      },
      {
        title = 'Çàõâàò ðàçâëåêàòåëüíûõ/ðàáî÷èõ çàâåäåíèé áåç çàëîæíèêîâ  {ff0000}50.000$'
      },
      {
        title = 'Çàõâàò ðàçâëåêàòåëüíûõ/ðàáî÷èõ çàâåäåíèé ñ çàëîæíèêàìè  {ff0000}75.000$'
      }
    }
  },
  {
    title = 'Ïîõèùåíèÿ',
    submenu =
    {
      {
        title = 'Ìýðèÿ',
        submenu =
        {
          {
            title = '{0040BF}Ìýð{ffffff} [6] - {ff0000}100.000$'
          },
          {
            title = '{0040BF}Çàì.Ìýðà{ffffff} [5] - {ff0000}80.000$'
          },
          {
            title = '{0040BF}Íà÷àëüíèê îõðàíû{ffffff} [4] - {ff0000}60.000$'
          },
          {
            title = '{0040BF}Îõðàííèê{ffffff} [3] - {ff0000}40.000$'
          },
          {
            title = '{0040BF}Àäâîêàò{ffffff} [2] - {ff0000}30.000$'
          },
          {
            title = '{0040BF}Ñåêðåòàðü{ffffff} [1] - {ff0000}20.000$'
          }
        }
      },
      {
        title = 'ÔÁÐ',
        submenu =
        {
          {
            title = '{9A9593}Äèðåêòîð{ffffff} [10] - {ff0000}100.000$'
          },
          {
            title = '{9A9593}Çàì.Äèðåêòîðà{FFFFFF} [9] - {ff0000}80.000$'
          },
          {
            title = '{9A9593}Èíñïåêòîð{ffffff} [8] - {ff0000}70.000$'
          },
          {
            title = '{9A9593}Ãëàâà CID{ffffff} [7] - {ff0000}60.000$'
          },
          {
            title = '{9A9593}Ãëàâà DEA{ffffff} [6] - {ff0000}50.000$'
          },
          {
            title = '{9A9593}Àãåíò CID{ffffff} [5] - {ff0000}40.000$'
          },
          {
            title = '{9A9593}Àãåíò DEA{ffffff} [4] - {ff0000}30.000$'
          },
          {
            title = '{9A9593}Ìë.Àãåíò{ffffff} [3] - {ff0000}25.000$'
          },
          {
            title = '{9A9593}Äåæóðíûé{ffffff} [2] - {ff0000}20.000$'
          },
          {
            title = '{9A9593}Ñòàæåð{ffffff} [1] - {ff0000}15.000$'
          }
        }
      },
      {
        title = 'Ïîëèöèÿ',
        submenu =
        {
          {
            title = '{0000FF}Øåðèô{ffffff} [14] - {ff0000}80.000$'
          },
          {
            title = '{0000FF}Ïîëêîâíèê{ffffff} [13] - {ff0000}70.000$'
          },
          {
            title = '{0000FF}Ïîäïîëêîâíèê{ffffff} [12] - {ff0000}65.000$'
          },
          {
            title = '{0000FF}Ìàéîð{ffffff} [11] - {ff0000}60.000$'
          },
          {
            title = '{0000FF}Êàïèòàí{ffffff} [10] - {ff0000}55.000$'
          },
          {
            title = '{0000FF}Ñò.Ëåéòåíàíò{ffffff} [9] - {ff0000}50.000$'
          },
          {
            title = '{0000FF}Ëåéòåíàíò{ffffff} [8] - {ff0000}45.000$'
          },
          {
            title = '{0000FF}Ìë.Ëåéòåíàíò{ffffff} [7] - {ff0000}40.000$'
          },
          {
            title = '{0000FF}Ñò.Ïðàïîðùèê{ffffff} [6] - {ff0000}35.000$'
          },
          {
            title = '{0000FF}Ïðàïîðùèê{ffffff} [5] - {ff0000}30.000$'
          },
          {
            title = '{0000FF}Ñåðæàíò{ffffff} [4] - {ff0000}25.000$'
          },
          {
            title = '{0000FF}Ìë.Ñåðæàíò{ffffff} [3] - {ff0000}20.000$'
          },
          {
            title = '{0000FF}Îôèöåð{ffffff} [2] - {ff0000}15.000$'
          },
          {
            title = '{0000FF}Êàäåò{ffffff} [1] - {ff0000}10.000$'
          }
        }
      },
      {
        title = 'Àðìèÿ',
        submenu =
        {
          {
            title = '{008040}Ãåíåðàë{ffffff} [15] - {ff0000}80.000$'
          },
          {
            title = '{008040}Ïîëêîâíèê{ffffff} [14] - {ff0000}75.000$'
          },
          {
            title = '{008040}Ïîäïîëêîâíèê{ffffff} [13] - {ff0000}70.000$'
          },
          {
            title = '{008040}Ìàéîð{ffffff} [12] - {ff0000}65.000$'
          },
          {
            title = '{008040}Êàïèòàí{ffffff} [11] - {ff0000}60.000$'
          },
          {
            title = '{008040}Ñò.Ëåéòåíàíò{ffffff} [10] - {ff0000}55.000$'
          },
          {
            title = '{008040}Ëåéòåíàíò{ffffff} [9] - {ff0000}50.000$'
          },
          {
            title = '{008040}Ìë.Ëåéòåíàíò{ffffff} [8] - {ff0000}45.000$'
          },
          {
            title = '{008040}Ïðàïîðùèê{ffffff} [7] - {ff0000}40.000$'
          },
          {
            title = '{008040}Ñòàðøèíà{ffffff} [6] - {ff0000}35.000$'
          },
          {
            title = '{008040}Ñò.ñåðæàíò{ffffff} [5] - {ff0000}30.000$'
          },
          {
            title = '{008040}Ñåðæàíò{ffffff} [4] - {ff0000}25.000$'
          },
          {
            title = '{008040}Ìë.Ñåðæàíò{ffffff} [3] - {ff0000}20.000$'
          },
          {
            title = '{008040}Åôðåéòîð{ffffff} [2] - {ff0000}15.000$'
          },
          {
            title = '{008040}Ðÿäîâîé{ffffff} [1] - {ff0000}10.000$'
          }
        }
      },
      {
        title = 'Ìåäèêè',
        submenu =
        {
          {
            title = '{BF4040}Ãëàâ.Âðà÷{ffffff} [10] - {ff0000}80.000$'
          },
          {
            title = '{BF4040}Çàì.Ãëàâ.Âðà÷à{ffffff} [9] - {ff0000}75.000$'
          },
          {
            title = '{BF4040}Õèðóðã{ffffff} [8] - {ff0000}70.000$'
          },
          {
            title = '{BF4040}Ïñèõîëîã{ffffff} [7] - {ff0000}60.000$'
          },
          {
            title = '{BF4040}Äîêòîð{ffffff} [6] - {ff0000}40.000$'
          },
          {
            title = '{BF4040}Íàðêîëîã{ffffff} [5] - {ff0000}35.000$'
          },
          {
            title = '{BF4040}Ñïàñàòåëü{ffffff} [4] - {ff0000}30.000$'
          },
          {
            title = '{BF4040}Ìåä.Áðàò{ffffff} [3] - {ff0000}25.000$'
          },
          {
            title = '{BF4040}Ñàíèòàð{ffffff} [2] - {ff0000}20.000$'
          },
          {
            title = '{BF4040}Èíòåðí{ffffff} [1] - {ff0000}15.000$'
          }
        }
      },
      {
        title = 'Àâòîøêîëà',
        submenu =
        {
          {
            title = '{40BFFF}Óïðàâëÿþùèé{ffffff} [10] - {ff0000}80.000$'
          },
          {
            title = '{40BFFF}Äèðåêòîð{ffffff} [9] - {ff0000}75.000$'
          },
          {
            title = '{40BFFF}Ñò.Ìåíåäæåð{ffffff} [8] - {ff0000}70.000$'
          },
          {
            title = '{40BFFF}Ìë.Ìåíåäæåð{ffffff} [7] - {ff0000}60.000$'
          },
          {
            title = '{40BFFF}Êîîðäèíàòîð{ffffff} [6] - {ff0000}55.000$'
          },
          {
            title = '{40BFFF}Èíñòðóêòîð{FFFFFF} [5] - {ff0000}50.000$'
          },
          {
            title = '{40BFFF}Ìë.Èíñòðóêòîð{ffffff} [4] - {ff0000}45.000$'
          },
          {
            title = '{40BFFF}Ýêçàìåíàòîð{ffffff} [3] - {ff0000}30.000$'
          },
          {
            title = '{40BFFF}Êîíñóëüòàíò{ffffff} [2] - {ff0000}25.000$'
          },
          {
            title = '{40BFFF}Ñòàæåð{ffffff} [1] - {ff0000}20.000$'
          }
        }
      },
      {
        title = 'Íîâîñòè',
        submenu =
        {
          {
            title = '{FFFF80}Ãåíåðàëüíûé äèðåêòîð{ffffff} [10] - {ff0000}70.000$'
          },
          {
            title = '{FFFF80}Ïðîãðàìíûé äèðåêòîð{ffffff} [9] - {ff0000}60.000$'
          },
          {
            title = '{FFFF80}Òåõíè÷åñêèé äèðåêòîð{ffffff} [8] - {ff0000}55.000$'
          },
          {
            title = '{FFFF80}Ãëàâíûé ðåäàêòîð{ffffff} [7] - {ff0000}50.000$'
          },
          {
            title = '{FFFF80}Ðåäàêòîð{ffffff} [6] - {ff0000}45.000$'
          },
          {
            title = '{FFFF80}Âåäóùèé{ffffff} [5] - {ff0000}40.000$'
          },
          {
            title = '{FFFF80}Ðåïîðòåð{ffffff} [4] - {ff0000}30.000$'
          },
          {
            title = '{FFFF80}Çâóêîðåæèññåð{ffffff} [3] - {ff0000}25.000$'
          },
          {
            title = '{FFFF80}Çâóêîîïåðàòîð{ffffff} [2] - {ff0000}20.000$'
          },
          {
            title = '{FFFF80}Ñòàæåð{ffffff} [1] - {ff0000}15.000$'
          }
        }
      }
    }
  }
}

local fthmenuPD = {
    {
        title = '{ffffff}» Çàïðîñèòü ïîääåðæêó â òåêóùèé êâàäðàò',
        onclick = function()
            if cfg.main.tarb then
                sampSendChat(string.format('/r [%s]: Íóæíà ïîääåðæêà â êâàäðàò %s', cfg.main.tar, kvadrat()))
            else
                sampSendChat(string.format('/r Íóæíà ïîääåðæêà â êâàäðàò %s', kvadrat()))
            end
        end
    },
    {
        title = '{ffffff}» Çàïðîñèòü ýâàêóàöèþ â òåêóùèé êâàäðàò',
        onclick = function()
            sampShowDialog(1401, '{9966cc}'..script.this.name..' {ffffff}| Ýâàêóàöèÿ', '{ffffff}Ââåäèòå: êîë-âî ìåñò\nÏðèìåð: 3 ìåñòà', 'Îòïðàâèòü', 'Îòìåíà', 1)
        end
    },
    {
        title = '{ffffff}» Öåíû âûêóïà',
        onclick = function()
            submenus_show(fcmenu, '{9966cc}'..script.this.name..' {ffffff}| Öåíû âûêóïà')
        end
    }
}

local fthmenuAS = {
    {
        title = "{FFFFFF}» Ïðèâåòñòâèå",
        onclick = function() 
            sampSendChat(("Äîáðûé äåíü. ß ñîòðóäíèê Àâòîøêîëû %s, ÷åì ìîãó ïîìî÷ü?"):format(sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub("_", " ")))
        end
    },
    {
        title = "{FFFFFF}» Ïîïðîñèòü ïàñïîðò",
        onclick = function()
            sampSendChat("Âàø ïàñïîðò, ïîæàëóéñòà.")
            wait(1400)
            sampSendChat(("/b /showpass %s"):format(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))))
        end
    },
    {
        title = "{FFFFFF}» Ïîïðîùàòüñÿ",
        onclick = function() sampSendChat("Õîðîøåãî äíÿ!") end
    },
    {
        title = "{FFFFFF}» Óäàðèòü øîêåðîì (áëèçæàéøåãî èãðîêà)",
        onclick = function()
            sampSendChat(("/me %s øîêåð ñ ïîÿñà"):format(cfg.main.male and 'ñíÿë' or 'ñíÿëà'))
            wait(cfg.commands.zaderjka)
            sampSendChat("/itazer")
            wait(cfg.commands.zaderjka)
            sampSendChat(("/me %s øîêåð íà ïîÿñ"):format(cfg.main.male and 'ïîâåñèë' or 'ïîâåñèëà'))
        end
    }
}

local fthmenuMOH = {
    {
        title = "» Ïðèâåòñòâèå",
        onclick = function()
            sampSendChat("Çäðàâñòâóéòå, ÷òî âàñ áåñïîêîèò? ")
        end
    },
    {
        title = "» Ïîïðîùàòüñÿ",
        onclick = function()
            sampSendChat("Óäà÷íîãî äíÿ, íå áîëåéòå.")
        end
    },
    {
        title = "» Îãëàñèòü ñòîèìîñòü ñåàíñà îò íàðêîçàâèñèìîñòè",
        onclick = function()
            sampSendChat("Ñòîèìîñòü ñåàíñà îò íàðêîçàâèñèìîñòè ñîñòàâëÿåò 10.000$.")
        end
    }
}

function getweaponname(weapon)
    local names = {
    [0] = "Fist",
    [1] = "Brass Knuckles",
    [2] = "Golf Club",
    [3] = "Nightstick",
    [4] = "Knife",
    [5] = "Baseball Bat",
    [6] = "Shovel",
    [7] = "Pool Cue",
    [8] = "Katana",
    [9] = "Chainsaw",
    [10] = "Purple Dildo",
    [11] = "Dildo",
    [12] = "Vibrator",
    [13] = "Silver Vibrator",
    [14] = "Flowers",
    [15] = "Cane",
    [16] = "Grenade",
    [17] = "Tear Gas",
    [18] = "Molotov Cocktail",
    [22] = "9mm",
    [23] = "Silenced 9mm",
    [24] = "Desert Eagle",
    [25] = "Shotgun",
    [26] = "Sawnoff Shotgun",
    [27] = "Combat Shotgun",
    [28] = "Micro SMG/Uzi",
    [29] = "MP5",
    [30] = "AK-47",
    [31] = "M4",
    [32] = "Tec-9",
    [33] = "Country Rifle",
    [34] = "Sniper Rifle",
    [35] = "RPG",
    [36] = "HS Rocket",
    [37] = "Flamethrower",
    [38] = "Minigun",
    [39] = "Satchel Charge",
    [40] = "Detonator",
    [41] = "Spraycan",
    [42] = "Fire Extinguisher",
    [43] = "Camera",
    [44] = "Night Vis Goggles",
    [45] = "Thermal Goggles",
    [46] = "Parachute" }
    return names[weapon]
end

function naparnik()
    local v = {}
    if isCharInAnyCar(PLAYER_PED) then
        local veh = storeCarCharIsInNoSave(PLAYER_PED)
        for i = 0, 999 do
            if sampIsPlayerConnected(i) then
                local ichar = select(2, sampGetCharHandleBySampPlayerId(i))
                if doesCharExist(ichar) then
                    if isCharInAnyCar(ichar) then
                        local iveh = storeCarCharIsInNoSave(ichar)
                        if veh == iveh then
                            if sampGetFraktionBySkin(i) == 'Ïîëèöèÿ' or sampGetFraktionBySkin(i) == 'FBI' then
                                local inick, ifam = sampGetPlayerNickname(i):match('(.+)_(.+)')
                                if inick and ifam then
                                    table.insert(v, string.format('%s.%s', inick:sub(1,1), ifam))
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        local myposx, myposy, myposz = getCharCoordinates(PLAYER_PED)
        for i = 0, 999 do
            if sampIsPlayerConnected(i) then
                local ichar = select(2, sampGetCharHandleBySampPlayerId(i))
                if doesCharExist(ichar) then
                    local ix, iy, iz = getCharCoordinates(ichar)
                    if getDistanceBetweenCoords3d(myposx, myposy, myposz, ix, iy, iz) <= 30 then
                        if sampGetFraktionBySkin(i) == 'Ïîëèöèÿ' or sampGetFraktionBySkin(i) == 'FBI' then
                            local inick, ifam = sampGetPlayerNickname(i):match('(.+)_(.+)')
                            if inick and ifam then
                                table.insert(v, string.format('%s.%s', inick:sub(1,1), ifam))
                            end
                        end
                    end
                end
            end
        end
    end
    if #v == 0 then
        return 'Íàïàðíèêîâ íåò.'
    elseif #v == 1 then
        return 'Íàïàðíèê: '..table.concat(v, ', ').. '.'
    elseif #v >=2 then
        return 'Íàïàðíèêè: '..table.concat(v, ', ').. '.'
    end
end

function onHotKey(id, keys)
    lua_thread.create(function()
        local sKeys = tostring(table.concat(keys, " "))
        for k, v in pairs(tBindList) do
            if sKeys == tostring(table.concat(v.v, " ")) then
                local tostr = tostring(v.text)
                if tostr:len() > 0 then
                    for line in tostr:gmatch('[^\r\n]+') do
                        if line:match("^{wait%:%d+}$") then
                            wait(line:match("^%{wait%:(%d+)}$"))
                        elseif line:match("^{screen}$") then
                            screen()
                        else
                            local bIsEnter = string.match(line, "^{noe}(.+)") ~= nil
                            local bIsF6 = string.match(line, "^{f6}(.+)") ~= nil
                            local keys = {
                                ["{f6}"] = "",
                                ["{noe}"] = "",
                                ["{myid}"] = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)),
                                ["{kv}"] = kvadrat(),
                                ["{targetid}"] = targetid,
                                ["{targetrpnick}"] = sampGetPlayerNicknameForBinder(targetid):gsub('_', ' '),
                                ["{naparnik}"] = naparnik(),
                                ["{myrpnick}"] = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub("_", " "),
                                ["{smsid}"] = smsid,
                                ["{smstoid}"] = smstoid,
                                ["{rang}"] = rang,
                                ["{frak}"] = frak,
                                ["{megafid}"] = gmegafid,
                                ["{dl}"] = mcid
                            }
                            for k1, v1 in pairs(keys) do
                                line = line:gsub(k1, v1)
                            end

                            if not bIsEnter then
                                if bIsF6 then
                                    sampProcessChatInput(line)
                                else
                                    sampSendChat(line)
                                end
                            else
                                sampSetChatInputText(line)
                                sampSetChatInputEnabled(true)
                            end
                        end
                    end
                end
            end
        end
    end)
end
function kvadrat()
    local KV = {
        [1] = "À",
        [2] = "Á",
        [3] = "Â",
        [4] = "Ã",
        [5] = "Ä",
        [6] = "Æ",
        [7] = "Ç",
        [8] = "È",
        [9] = "Ê",
        [10] = "Ë",
        [11] = "Ì",
        [12] = "Í",
        [13] = "Î",
        [14] = "Ï",
        [15] = "Ð",
        [16] = "Ñ",
        [17] = "Ò",
        [18] = "Ó",
        [19] = "Ô",
        [20] = "Õ",
        [21] = "Ö",
        [22] = "×",
        [23] = "Ø",
        [24] = "ß",
    }
    local X, Y, Z = getCharCoordinates(playerPed)
    X = math.ceil((X + 3000) / 250)
    Y = math.ceil((Y * - 1 + 3000) / 250)
    Y = KV[Y]
    local KVX = (Y.."-"..X)
    return KVX
end

function isHudEnabled()
    local value = memory.read(0xBA6769, 1, true)
    if value == 1 then return true else return false end
end

function genCode(skey)
    skey = basexx.from_base32(skey)
    value = math.floor(os.time() / 30)
    value = string.char(
    0, 0, 0, 0,
    band(value, 0xFF000000) / 0x1000000,
    band(value, 0xFF0000) / 0x10000,
    band(value, 0xFF00) / 0x100,
    band(value, 0xFF))
    local hash = sha1.hmac_binary(skey, value)
    local offset = band(hash:sub(-1):byte(1, 1), 0xF)
    local function bytesToInt(a,b,c,d)
      return a*0x1000000 + b*0x10000 + c*0x100 + d
    end
    hash = bytesToInt(hash:byte(offset + 1, offset + 4))
    hash = band(hash, 0x7FFFFFFF) % 1000000
    return ('%06d'):format(hash)
end

function kvadrat1(param)
    local KV = {
        ["À"] = 1,
        ["Á"] = 2,
        ["Â"] = 3,
        ["Ã"] = 4,
        ["Ä"] = 5,
        ["Æ"] = 6,
        ["Ç"] = 7,
        ["È"] = 8,
        ["Ê"] = 9,
        ["Ë"] = 10,
        ["Ì"] = 11,
        ["Í"] = 12,
        ["Î"] = 13,
        ["Ï"] = 14,
        ["Ð"] = 15,
        ["Ñ"] = 16,
        ["Ò"] = 17,
        ["Ó"] = 18,
        ["Ô"] = 19,
        ["Õ"] = 20,
        ["Ö"] = 21,
        ["×"] = 22,
        ["Ø"] = 23,
        ["ß"] = 24,
        ["à"] = 1,
        ["á"] = 2,
        ["â"] = 3,
        ["ã"] = 4,
        ["ä"] = 5,
        ["æ"] = 6,
        ["ç"] = 7,
        ["è"] = 8,
        ["ê"] = 9,
        ["ë"] = 10,
        ["ì"] = 11,
        ["í"] = 12,
        ["î"] = 13,
        ["ï"] = 14,
        ["ð"] = 15,
        ["ñ"] = 16,
        ["ò"] = 17,
        ["ó"] = 18,
        ["ô"] = 19,
        ["õ"] = 20,
        ["ö"] = 21,
        ["÷"] = 22,
        ["ø"] = 23,
        ["ÿ"] = 24,
    }
    return KV[param]
end

function saveData(table, path)
	if doesFileExist(path) then os.remove(path) end
    local sfa = io.open(path, "w")
    if sfa then
        sfa:write(encodeJson(table))
        sfa:close()
    end
end

function getFreeSeat()
    seat = 3
    if isCharInAnyCar(PLAYER_PED) then
        local veh = storeCarCharIsInNoSave(PLAYER_PED)
        for i = 1, 3 do
            if isCarPassengerSeatFree(veh, i) then
                seat = i
            end
        end
    end
    return seat
end

function getNameSphere(id)
    local names =
    {
      [1] = 'ÀÂ',
      [2] = 'ÀØ',
      [3] = 'ÑÔà',
      [4] = 'Â',
      [5] = 'À',
      [6] = 'ÑÔí',
      [7] = 'Òîííåëü',
      [8] = 'Ìýðèÿ',
      [9] = 'Õîò-Äîãè',
      [10] = 'Áîëüíèöà ËÑ',
      [11] = 'ÀÂ',
      [12] = 'Ìîñò',
      [13] = 'Ïåðåêðåñòîê',
      [14] = 'Ðàçâèëêà',
      [15] = 'Â',
      [16] = 'À',
      [17] = 'Â',
      [18] = 'Ñ',
      [19] = 'ÊÏÏ',
      [20] = 'Ïîðò ËÑ',
      [21] = 'Îïàñíûé ðàéîí',
      [32] = 'ÊÏÏ',
      [33] = 'D',
      [34] = 'Õîëë Ìýðèè',
      [35] = 'Àâòîðûíîê'
    }
    return names[id]
end

function longtoshort(long)
    local short =
    {
      ['Àðìèÿ ËÂ'] = 'LVa',
      ['Àðìèÿ ÑÔ'] = 'SFa',
      ['ÔÁÐ'] = 'FBI'
    }
    return short[long]
end
local osnova = {
	{
		title = 'Ëàáîðàòîðèÿ',
		onclick = function()
			local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
			sampSendChat(("/r %s â ñîòðóäíèêà ëàáîðàòîðèè."):format(cfg.main.male and 'Ïåðåîäåëñÿ' or 'Ïåðåîäåëàñü'))
	        wait(1400)
	        sampSendChat("/rb "..myid)
		end
	},
	{
		title = 'Ãðàæäàíñêèé',
		onclick = function()
			mstype = 'ãðàæäàíñêîãî'
			sampShowDialog(1385, '{9966cc}'..script.this.name..' {ffffff}| Ìàñêèðîâêà', 'Ââåäèòå: ïðè÷èíó', '»', 'x', 1)
		end
	},
	{
		title = 'Ïîëèöèÿ',
		onclick = function()
			mstype = 'ïîëèöåéñêîãî'
			sampShowDialog(1385, '{9966cc}'..script.this.name..' {ffffff}| Ìàñêèðîâêà', 'Ââåäèòå: ïðè÷èíó', '»', 'x', 1)
		end
	},
	{
		title = 'Àðìèÿ',
		onclick = function()
			mstype = 'âîåííîãî'
			sampShowDialog(1385, '{9966cc}'..script.this.name..' {ffffff}| Ìàñêèðîâêà', 'Ââåäèòå: ïðè÷èíó', '»', 'x', 1)
		end
	},
	{
		title = 'Ì×Ñ',
		onclick = function()
			mstype = 'ìåäèêà'
			sampShowDialog(1385, '{9966cc}'..script.this.name..' {ffffff}| Ìàñêèðîâêà', 'Ââåäèòå: ïðè÷èíó', '»', 'x', 1)
		end
	},
	{
		title = 'Ìýðèÿ',
		onclick = function()
			mstype = 'ñîòðóäíèêà ìýðèè'
			sampShowDialog(1385, '{9966cc}'..script.this.name..' {ffffff}| Ìàñêèðîâêà', 'Ââåäèòå: ïðè÷èíó', '»', 'x', 1)
		end
	},
	{
		title = 'Àâòîøêîëà',
		onclick = function()
			mstype = 'ðàáîòíèêà àâòîøêîëû'
			sampShowDialog(1385, '{9966cc}'..script.this.name..' {ffffff}| Ìàñêèðîâêà', 'Ââåäèòå: ïðè÷èíó', '»', 'x', 1)
		end
	},
	{
		title = 'Íîâîñòè',
		onclick = function()
			mstype = 'ðàáîòíèêà íîâîñòåé'
			sampShowDialog(1385, '{9966cc}'..script.this.name..' {ffffff}| Ìàñêèðîâêà', 'Ââåäèòå: ïðè÷èíó', '»', 'x', 1)
		end
	},
	{
		title = 'LCN',
		ocnlick = function()
			mstype = '×ÎÏ LCN'
			sampShowDialog(1385, '{9966cc}'..script.this.name..' {ffffff}| Ìàñêèðîâêà', 'Ââåäèòå: ïðè÷èíó', '»', 'x', 1)
		end
	},
	{
		title = 'Yakuza',
		onclick = function()
			mstype = '×ÎÏ Yakuza'
			sampShowDialog(1385, '{9966cc}'..script.this.name..' {ffffff}| Ìàñêèðîâêà', 'Ââåäèòå: ïðè÷èíó', '»', 'x', 1)
		end
	},
	{
		title = 'Russian Mafia',
		onclick = function()
			mstype = '×ÎÏ Russian Mafia'
			sampShowDialog(1385, '{9966cc}'..script.this.name..' {ffffff}| Ìàñêèðîâêà', 'Ââåäèòå: ïðè÷èíó', '»', 'x', 1)
		end
	},
	{
		title = 'Rifa',
		onclick = function()
			mstype = 'ÁÊ Rifa'
			sampShowDialog(1385, '{9966cc}'..script.this.name..' {ffffff}| Ìàñêèðîâêà', 'Ââåäèòå: ïðè÷èíó', '»', 'x', 1)
		end
	},
	{
		title = 'Grove',
		onclick = function()
			mstype = 'ÁÊ Grove'
			sampShowDialog(1385, '{9966cc}'..script.this.name..' {ffffff}| Ìàñêèðîâêà', 'Ââåäèòå: ïðè÷èíó', '»', 'x', 1)
		end
	},
	{
		title = 'Ballas',
		onclick = function()
			mstype = 'ÁÊ Ballas'
			sampShowDialog(1385, '{9966cc}'..script.this.name..' {ffffff}| Ìàñêèðîâêà', 'Ââåäèòå: ïðè÷èíó', '»', 'x', 1)
		end
	},
	{
		title = 'Vagos',
		onclick = function()
			mstype = 'ÁÊ Vagos'
			sampShowDialog(1385, '{9966cc}'..script.this.name..' {ffffff}| Ìàñêèðîâêà', 'Ââåäèòå: ïðè÷èíó', '»', 'x', 1)
		end
	},
	{
		title = 'Aztec',
		onclick = function()
			mstype = 'ÁÊ Aztec'
			sampShowDialog(1385, '{9966cc}'..script.this.name..' {ffffff}| Ìàñêèðîâêà', 'Ââåäèòå: ïðè÷èíó', '»', 'x', 1)
		end
	},
	{
		title = 'Áàéêåðû',
		onclick = function()
			mstype = 'áàéêåðîâ'
			sampShowDialog(1385, '{9966cc}'..script.this.name..' {ffffff}| Ìàñêèðîâêà', 'Ââåäèòå: ïðè÷èíó', '»', 'x', 1)
		end
	}
}

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
local tCarsTypeName = {"Àâòîìîáèëü", "Ìîòîèöèêë", "Âåðòîë¸ò", "Ñàìîë¸ò", "Ïðèöåï", "Ëîäêà", "Äðóãîå", "Ïîåçä", "Âåëîñèïåä"}
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

function update()
    local fpath = os.getenv('TEMP') .. '\\ftulsupd.json'
    downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/ftulsupd.json', fpath, function(id, status, p1, p2)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            local f = io.open(fpath, 'r')
            if f then
                local info = decodeJson(f:read('*a'))
                updatelink = info.updateurl
                updlist1 = info.updlist
                ttt = updlist1
			    if info and info.latest then
                    if tonumber(thisScript().version) < tonumber(info.latest) then
                        ftext('Îáíàðóæåíî îáíîâëåíèå {9966cc}'..script.this.name..'{ffffff}. Äëÿ îáíîâëåíèÿ íàæìèòå êíîïêó â îêîøêå.')
                        ftext('Ïðèìå÷àíèå: Åñëè ó âàñ íå ïîÿâèëîñü îêîøêî ââåäèòå {9966cc}/ft')
                        updwindows.v = true
                        canupdate = true
                    else
                        print('Îáíîâëåíèé ñêðèïòà íå îáíàðóæåíî. Ïðèÿòíîé èãðû.')
                        update = false
				    end
                end
            else
                print("Ïðîâåðêà îáíîâëåíèÿ ïðîøêà íåóñïåøíî. Çàïóñêàþ ñòàðóþ âåðñèþ.")
            end
        elseif status == 64 then
            print("Ïðîâåðêà îáíîâëåíèÿ ïðîøêà íåóñïåøíî. Çàïóñêàþ ñòàðóþ âåðñèþ.")
            update = false
        end
    end)
end


function goupdate()
    ftext('Íà÷àëîñü ñêà÷èâàíèå îáíîâëåíèÿ. Ñêðèïò ïåðåçàãðóçèòñÿ ÷åðåç ïàðó ñåêóíä.', -1)
    wait(300)
    downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23)
        if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
            thisScript():reload()
        elseif status1 == 64 then
            ftext("Ñêà÷èâàíèå îáíîâëåíèÿ ïðîøëî íå óñïåøíî. Çàïóñêàþ ñòàðóþ âåðñèþ")
        end
    end)
end

function libs()
    if not limgui or not lsampev or not lsphere or not lrkeys or not limadd or not lsha1 or not lbasexx then
        ftext('Íà÷àòà çàãðóçêà íåäîñòàþùèõ áèáëèîòåê')
        ftext('Ïî îêîí÷àíèþ çàãðóçêè ñêðèïò áóäåò ïåðåçàãðóæåí')
        if limgui == false then
            imgui_download_status = 'proccess'
            downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/lib/imgui.lua', 'moonloader/lib/imgui.lua', function(id, status, p1, p2)
                if status == dlstatus.STATUS_DOWNLOADINGDATA then
                    imgui_download_status = 'proccess'
                    print(string.format('Çàãðóæåíî %d êèëîáàéò èç %d êèëîáàéò.', p1, p2))
                elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    imgui_download_status = 'succ'
                elseif status == 64 then
                    imgui_download_status = 'failed'
                end
            end)
            while imgui_download_status == 'proccess' do wait(0) end
            if imgui_download_status == 'failed' then
                print('Íå óäàëîñü çàãðóçèòü: imgui.lua')
                thisScript():unload()
            else
                print('Ôàéë: imgui.lua óñïåøíî çàãðóæåí')
                if doesFileExist('moonloader/lib/MoonImGui.dll') then
                    print('Imgui áûë çàãðóæåí')
                else
                    imgui_download_status = 'proccess'
                    downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/lib/MoonImGui.dll', 'moonloader/lib/MoonImGui.dll', function(id, status, p1, p2)
                        if status == dlstatus.STATUS_DOWNLOADINGDATA then
                            imgui_download_status = 'proccess'
                            print(string.format('Çàãðóæåíî %d êèëîáàéò èç %d êèëîáàéò.', p1, p2))
                        elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
                            imgui_download_status = 'succ'
                        elseif status == 64 then
                            imgui_download_status = 'failed'
                        end
                    end)
                    while imgui_download_status == 'proccess' do wait(0) end
                    if imgui_download_status == 'failed' then
                        print('Íå óäàëîñü çàãðóçèòü Imgui')
                        thisScript():unload()
                    else
                        print('Imgui áûë çàãðóæåí')
                    end
                end
            end
        end
        if not lsampev then
            local folders = {'samp', 'samp/events'}
            local files = {'events.lua', 'raknet.lua', 'synchronization.lua', 'events/bitstream_io.lua', 'events/core.lua', 'events/extra_types.lua', 'events/handlers.lua', 'events/utils.lua'}
            for k, v in pairs(folders) do if not doesDirectoryExist('moonloader/lib/'..v) then createDirectory('moonloader/lib/'..v) end end
            for k, v in pairs(files) do
                sampev_download_status = 'proccess'
                downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/lib/samp/'..v, 'moonloader/lib/samp/'..v, function(id, status, p1, p2)
                    if status == dlstatus.STATUS_DOWNLOADINGDATA then
                        sampev_download_status = 'proccess'
                        print(string.format('Çàãðóæåíî %d êèëîáàéò èç %d êèëîáàéò.', p1, p2))
                    elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
                        sampev_download_status = 'succ'
                    elseif status == 64 then
                        sampev_download_status = 'failed'
                    end
                end)
                while sampev_download_status == 'proccess' do wait(0) end
                if sampev_download_status == 'failed' then
                    print('Íå óäàëîñü çàãðóçèòü sampev')
                    thisScript():unload()
                else
                    print(v..' áûë çàãðóæåí')
                end
            end
        end
        if not lsphere then
            sphere_download_status = 'proccess'
            downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/lib/sphere.lua', 'moonloader/lib/sphere.lua', function(id, status, p1, p2)
                if status == dlstatus.STATUS_DOWNLOADINGDATA then
                    sphere_download_status = 'proccess'
                    print(string.format('Çàãðóæåíî %d êèëîáàéò èç %d êèëîáàéò.', p1, p2))
                elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sphere_download_status = 'succ'
                elseif status == 64 then
                    sphere_download_status = 'failed'
                end
            end)
            while sphere_download_status == 'proccess' do wait(0) end
            if sphere_download_status == 'failed' then
                print('Íå óäàëîñü çàãðóçèòü Sphere.lua')
                thisScript():unload()
            else
                print('Sphere.lua áûë çàãðóæåí')
            end
        end
        if not lrkeys then
            rkeys_download_status = 'proccess'
            downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/lib/rkeys.lua', 'moonloader/lib/rkeys.lua', function(id, status, p1, p2)
                if status == dlstatus.STATUS_DOWNLOADINGDATA then
                    rkeys_download_status = 'proccess'
                    print(string.format('Çàãðóæåíî %d êèëîáàéò èç %d êèëîáàéò.', p1, p2))
                elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    rkeys_download_status = 'succ'
                elseif status == 64 then
                    rkeys_download_status = 'failed'
                end
            end)
            while rkeys_download_status == 'proccess' do wait(0) end
            if rkeys_download_status == 'failed' then
                print('Íå óäàëîñü çàãðóçèòü rkeys.lua')
                thisScript():unload()
            else
                print('rkeys.lua áûë çàãðóæåí')
            end
        end
        if not limadd then
            imadd_download_status = 'proccess'
            downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/lib/imgui_addons.lua', 'moonloader/lib/imgui_addons.lua', function(id, status, p1, p2)
                if status == dlstatus.STATUS_DOWNLOADINGDATA then
                    imadd_download_status = 'proccess'
                    print(string.format('Çàãðóæåíî %d êèëîáàéò èç %d êèëîáàéò.', p1, p2))
                elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    imadd_download_status = 'succ'
                elseif status == 64 then
                    imadd_download_status = 'failed'
                end
            end)
            while imadd_download_status == 'proccess' do wait(0) end
            if imadd_download_status == 'failed' then
                print('Íå óäàëîñü çàãðóçèòü imgui_addons.lua')
                thisScript():unload()
            else
                print('imgui_addons.lua áûë çàãðóæåí')
            end
        end
        if not lsha1 then
            sha1_download_status = 'proccess'
            downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/lib/sha1.lua', 'moonloader/lib/sha1.lua', function(id, status, p1, p2)
                if status == dlstatus.STATUS_DOWNLOADINGDATA then
                    sha1_download_status = 'proccess'
                    print(string.format('Çàãðóæåíî %d êèëîáàéò èç %d êèëîáàéò.', p1, p2))
                elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sha1_download_status = 'succ'
                elseif status == 64 then
                    sha1_download_status = 'failed'
                end
            end)
            while sha1_download_status == 'proccess' do wait(0) end
            if sha1_download_status == 'failed' then
                print('Íå óäàëîñü çàãðóçèòü sha1.lua')
                thisScript():unload()
            else
                print('sha1.lua áûë çàãðóæåí')
            end
        end
        if not lbasexx then
            basexx_download_status = 'proccess'
            downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/lib/basexx.lua', 'moonloader/lib/basexx.lua', function(id, status, p1, p2)
                if status == dlstatus.STATUS_DOWNLOADINGDATA then
                    basexx_download_status = 'proccess'
                    print(string.format('Çàãðóæåíî %d êèëîáàéò èç %d êèëîáàéò.', p1, p2))
                elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    basexx_download_status = 'succ'
                elseif status == 64 then
                    basexx_download_status = 'failed'
                end
            end)
            while basexx_download_status == 'proccess' do wait(0) end
            if basexx_download_status == 'failed' then
                print('Íå óäàëîñü çàãðóçèòü basexx.lua')
                thisScript():unload()
            else
                print('basexx.lua áûë çàãðóæåí')
            end
        end
        ftext('Âñå íåîáõîäèìûå áèáëèîòåêè áûëè çàãðóæåíû')
        reloadScripts()
    else
        print('Âñå íåîáõîäèìå áèáëèîòåêè áûëè íàéäåíû è çàãðóæåíû')
    end
end

function checkStats()
    while not sampIsLocalPlayerSpawned() do wait(0) end
    checkstat = true
    sampSendChat('/stats')
	local chtime = os.clock() + 10
    while chtime > os.clock() do wait(0) end
    local chtime = nil
    checkstat = false
    if rang == -1 and frak == -1 then
        frak = 'Íåò'
        rang = 'Íåò'
        ftext('Íå óäàëîñü îïðåäåëèòü ñòàòèñòèêó ïåðñîíàæà. Ïîâòîðèòü ïîïûòêó?', -1)
        ftext('Ïîäòâåðäèòü: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | Îòìåíèòü: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
        opyatstat = true
    end
end

function ykf()
    if not doesFileExist('moonloader/fbitools/yk.txt') then
        local fpathyk = os.getenv('TEMP') .. '\\yk.txt'
        downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/yk.txt', fpath, function(id, status, p1, p2)
            if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                local f = io.open(fpathyk, 'r')
                if f then
                    local file = io.open("moonloader/fbitools/yk.txt", "w")
                    file:write(u8:decode(f:read('*a')))
                    file:close()
                else
                    local file = io.open("moonloader/fbitools/yk.txt", "w")
                    file:write("Ïðîèçîøëà îøèáêà çàêà÷êè ÓÊ.\nÈçìåíèòü òåêñò ýòîé øïîðû ìîæíî â ôàéëå: moonloader/fbitools/yk.txt")
                    file:close()
                end
            elseif status == 64 then
                local file = io.open("moonloader/fbitools/yk.txt", "w")
                file:write("Ïðîèçîøëà îøèáêà çàêà÷êè ÓÊ.\nÈçìåíèòü òåêñò ýòîé øïîðû ìîæíî â ôàéëå: moonloader/fbitools/yk.txt")
                file:close()
            end
        end)
    end
    if not doesFileExist('moonloader/fbitools/yk.txt') then
        local file = io.open("moonloader/fbitools/yk.txt", "w")
        file:write("Ïðîèçîøëà îøèáêà çàêà÷êè ÓÊ.\nÈçìåíèòü òåêñò ýòîé øïîðû ìîæíî â ôàéëå: moonloader/fbitools/yk.txt")
        file:close()
    end

end

function shpf()
    if not doesFileExist("moonloader/fbitools/shp.txt") then
        local file = io.open("moonloader/fbitools/shp.txt", 'w')
        file:write(shpt)
        file:close()
    end
end

function fpf()
    if not doesFileExist('moonloader/fbitools/fp.txt') then
        local fpathfp = os.getenv('TEMP') .. '\\fp.txt'
        downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/fp.txt', fpath, function(id, status, p1, p2)
            if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                local f = io.open(fpathfp, 'r')
                if f then
                    local file = io.open("moonloader/fbitools/fp.txt", "w")
                    file:write(u8:decode(f:read('*a')))
                    file:close()
                else
                    local file = io.open("moonloader/fbitools/fp.txt", "w")
                    file:write("Ïðîèçîøëà îøèáêà çàêà÷êè ÔÏ.\nÈçìåíèòü òåêñò ýòîé øïîðû ìîæíî â ôàéëå: moonloader/fbitools/yk.txt")
                    file:close()
                end
            elseif status == 64 then
                local file = io.open("moonloader/fbitools/fp.txt", "w")
                file:write("Ïðîèçîøëà îøèáêà çàêà÷êè ÔÏ.\nÈçìåíèòü òåêñò ýòîé øïîðû ìîæíî â ôàéëå: moonloader/fbitools/yk.txt")
                file:close()
            end
        end)
    end
    if not doesFileExist('moonloader/fbitools/fp.txt') then 
        local file = io.open("moonloader/fbitools/fp.txt", "w")
        file:write("Ïðîèçîøëà îøèáêà çàêà÷êè ÔÏ.\nÈçìåíèòü òåêñò ýòîé øïîðû ìîæíî â ôàéëå: moonloader/fbitools/yk.txt")
        file:close()
    end
end

function akf()
    if not doesFileExist('moonloader/fbitools/ak.txt') then
        local fpathak = os.getenv('TEMP') .. '\\ak.txt'
        downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/ak.txt', fpath, function(id, status, p1, p2)
            if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                local f = io.open(fpathak, 'r')
                if f then
                    local file = io.open("moonloader/fbitools/ak.txt", "w")
                    file:write(u8:decode(f:read('*a')))
                    file:close()
                else
                    local file = io.open("moonloader/fbitools/ak.txt", "w")
                    file:write("Ïðîèçîøëà îøèáêà çàêà÷êè ÀÊ.\nÈçìåíèòü òåêñò ýòîé øïîðû ìîæíî â ôàéëå: moonloader/fbitools/yk.txt")
                    file:close()
                end
            elseif status == 64 then
                local file = io.open("moonloader/fbitools/ak.txt", "w")
                file:write("Ïðîèçîøëà îøèáêà çàêà÷êè ÀÊ.\nÈçìåíèòü òåêñò ýòîé øïîðû ìîæíî â ôàéëå: moonloader/fbitools/yk.txt")
                file:close()
            end
        end)
    end
    if not doesFileExist('moonloader/fbitools/ak.txt') then
        local file = io.open("moonloader/fbitools/ak.txt", "w")
        file:write("Ïðîèçîøëà îøèáêà çàêà÷êè ÀÊ.\nÈçìåíèòü òåêñò ýòîé øïîðû ìîæíî â ôàéëå: moonloader/fbitools/yk.txt")
        file:close()
    end
end

function suf()
    if not doesFileExist('moonloader/fbitools/su.txt') then
        local file = io.open('moonloader/fbitools/su.txt', 'w')
        file:write(sut)
        file:close()
        file = nil
    end
end

function mcheckf() if not doesFileExist('moonloader/fbitools/mcheck.txt') then io.open("moonloader/fbitools/mcheck.txt", "w"):close() end end

function sampGetPlayerNicknameForBinder(nikkid)
    local nick = '-1'
    local nickid = tonumber(nikkid)
    if nickid ~= nil then
        if sampIsPlayerConnected(nickid) then
            nick = sampGetPlayerNickname(nickid)
        end
    end
    return nick
end

function sumenu(args)
    return
    {
      {
        title = '{5b83c2}« Ðàçäåë ¹1 »',
        onclick = function()
        end
      },
      {
        title = '{ffffff}» Èçáèåíèå - {ff0000}2 óðîâåíü ðîçûñêà.',
        onclick = function()
          sampSendChat("/su "..args.." 2 Èçáèåíèå")
        end
      },
      {
        title = '{ffffff}» Âîîðóæåííîå íàïàäåíèå íà ãðàæäàíñêîãî - {ff0000}3 óðîâåíü ðîçûñêà.',
        onclick = function()
          sampSendChat("/su "..args.." 3 Âîîðóæåííîå íàïàäåíèå íà ãðàæäàíñêîãî")
        end
      },
      {
        title = '{ffffff}» Âîîðóæåííîå íàïàäåíèå íà ãîñ.ñëóæàùåãî - {ff0000}6 óðîâåíü ðîçûñêà.',
        onclick = function()
          sampSendChat("/su "..args.." 6 Âîîðóæåííîå íàïàäåíèå íà ÏÎ")
        end
      },
      {
        title = '{ffffff}» Óáèéñòâî ÷åëîâåêà - {ff0000}3 óðîâåíü ðîçûñêà.',
        onclick = function()
          sampSendChat("/su "..args.." 3 Óáèéñòâî ÷åëîâåêà")
        end
      },
      {
        title = '{ffffff}» Õóëèãàíñòâî - {ff0000}1 óðîâåíü ðîçûñêà.',
        onclick = function()
          sampSendChat("/su "..args.." 1 Õóëèãàíñòâî")
        end
      },
      {
        title = '{ffffff}» Íåàäåêâàòíîå ïîâåäåíèå - {ff0000}1 óðîâåíü ðîçûñêà.',
        onclick = function()
          sampSendChat("/su "..args.." 1 Íåàäåêâàòíîå ïîâåäåíèå")
        end
      },
      {
        title = '{ffffff}» Ïîïðîøàéíè÷åñòâî - {ff0000}1 óðîâåíü ðîçûñêà.',
        onclick = function()
          sampSendChat("/su "..args.." 1 Ïîïðîøàéíè÷åñòâî")
        end
      },
      {
        title = '{ffffff}» Îñêîðáëåíèå - {ff0000}2 óðîâåíü ðîçûñêà.',
        onclick = function()
          sampSendChat("/su "..args.." 2 Îñêîðáëåíèå")
        end
      },
      {
        title = '{ffffff}» Íàåçä íà ïåøåõîäà - {ff0000}2 óðîâåíü ðîçûñêà.',
        onclick = function()
          sampSendChat("/su "..args.." 2 Íàåçä íà ïåøåõîäà")
        end
      },
      {
        title = '{ffffff}» Èãíîðèðîâàíèå ñïåö.ñèãíàëà - {ff0000}1 óðîâåíü ðîçûñêà.',
        onclick = function()
          sampSendChat("/su "..args.." 1 Èãíîðèðîâàíèå ñïåö.ñèãíàëà")
        end
      },
      {
        title = '{ffffff}» Óãîí òðàíñïîðòíîãî ñðåäñòâà - {ff0000}2 óðîâåíü ðîçûñêà.',
        onclick = function()
          sampSendChat("/su "..args.." 2 Óãîí òðàíñïîðòíîãî ñðåäñòâà")
        end
      },
      {
        title = '{ffffff}» Ïîð÷à ÷óæîãî èìóùåñòâà - {ff0000}1 óðîâåíü ðîçûñêà.',
        onclick = function()
          sampSendChat("/su "..args.. " 1 Ïîð÷à ÷óæîãî èìóùåñòâà")
        end
      },
      {
        title = '{ffffff}» Óíè÷òîæåíèå ÷óæîãî èìóùåñòâà - {ff0000}4 óðîâåíü ðîçûñêà.',
        onclick = function()
          sampSendChat("/su "..args.." 4 Óíè÷òîæåíèå ÷óæîãî èìóùåñòâà")
        end
      },
      {
        title = '{ffffff}» Íåïîä÷èíåíèå ñîòðóäíèêó ÏÎ - {ff0000}1 óðîâåíü ðîçûñêà.',
        onclick = function()
          sampSendChat("/su "..args.." 1 Íåïîä÷èíåíèå ñîòðóäíèêó ÏÎ")
        end
      },
      {
        title = '{ffffff}» Óõîä îò ñîòðóäíèêà ÏÎ - {ff0000}2 óðîâåíü ðîçûñêà',
        onclick = function()
          sampSendChat("/su "..args.." 2 Óõîä îò ñîòðóäíèêà ÏÎ")
        end
      },
      {
          title = '{ffffff}» Óõîä ñ ìåñòà ÄÒÏ - {ff0000}3 óðîâåíü ðîçûñêà',
          onclick = function()
            sampSendChat('/su '..args.. ' 3 Óõîä ñ ìåñòà ÄÒÏ')
          end
      },
      {
        title = '{ffffff}» Ïîáåã èç ìåñòà çàêëþ÷åíèÿ - {ff0000}6 óðîâåíü ðîçûñêà.',
        onclick = function()
          sampSendChat("/su "..args.." 6 Ïîáåã èç ìåñòà çàêëþ÷åíèÿ")
        end
      },
      {
        title = '{ffffff}» Ïðîíèêíîâåíèå íà îõðàíÿåìóþ òåððèòîðèþ - {ff0000}2 óðîâåíü ðîçûñêà.',
        onclick = function()
          sampSendChat("/su "..args.." 2 Ïðîíèêíîâåíèå íà îõð. òåððèòîðèþ")
        end
      },
      {
        title = '{ffffff}» Ïðîâîêàöèÿ - {ff0000}2 óðîâåíü ðîçûñêà.',
        onclick = function()
          sampSendChat("/su "..args.." 2 Ïðîâîêàöèÿ")
        end
      },
      {
        title = '{ffffff}» Óãðîçû - {ff0000}1 óðîâåíü ðîçûñêà.',
        onclick = function()
          sampSendChat("/su "..args.." 1 Óãðîçû")
        end
      },
      {
        title = '{ffffff}» Ïðåäëîæåíèå èíòèì. óñëóã - {ff0000}1 óðîâåíü ðîçûñêà',
        onclick = function()
          sampSendChat('/su '..args..' 1 Ïðåäëîæåíèå èíòèìíûõ óñëóã')
        end
      },
      {
        title = '{ffffff}» Èçíàñèëîâàíèå - {ff0000}3 óðîâåíü ðîçûñêà',
        onclick = function()
          sampSendChat('/su '..args..' 3 Èçíàñèëîâàíèå')
        end
      },
      {
        title = '{ffffff}» ×èñòîñåðäå÷íîå ïðèçíàíèå - {ff0000}1 óðîâåíü ðîçûñêà.',
        onclick = function()
          local result = isCharInAnyCar(PLAYER_PED)
          if result then
            sampSendChat("/clear "..args)
            wait(1400)
            sampSendChat("/su "..args.." 1 ×èñòîñåðäå÷íîå ïðèçíàíèå")
          else
            sampAddChatMessage("{9966CC}"..script.this.name.." {FFFFFF}| You have to be in the car", -1)
          end
        end
      },
      {
        title = '{ffbc54}« Ðàçäåë ¹2 »',
        onclick = function()
        end
      },
      {
        title = '{ffffff}» Õðàíåíèå ìàòåðèàëîâ - {ff0000}3 óðîâåíü ðîçûñêà.',
        onclick = function()
          sampSendChat("/su "..args.." 3 Õðàíåíèå ìàòåðèàëîâ")
        end
      },
      {
        title = '{ffffff}» Õðàíåíèå íàðêîòèêîâ - {ff0000}3 óðîâåíü ðîçûñêà.',
        onclick = function()
          sampSendChat("/su "..args.." 3 Õðàíåíèå íàðêîòèêîâ")
        end
      },
      {
        title = '{ffffff}» Ïðîäàæà êëþ÷åé îò êàìåðû - {ff0000}6 óðîâåíü ðîçûñêà',
        onclick = function()
          sampSendChat("/su "..args.." 6 Ïðîäàæà êëþ÷åé îò êàìåðû")
        end
      },
      {
        title = '{ffffff}» Óïîòðåáëåíèå íàðêîòèêîâ - {ff0000}3 óðîâåíü ðîçûñêà',
        onclick = function()
          sampSendChat("/su "..args.." 3 Óïîòðåáëåíèå íàðêîòèêîâ")
        end
      },
      {
        title = '{ffffff}» Ïðîäàæà íàðêîòèêîâ - {ff0000}2 óðîâåíü ðîçûñêà',
        onclick = function()
          sampSendChat("/su "..args.." 2 Ïðîäàæà íàðêîòèêîâ")
        end
      },
      {
        title = '{ffffff}» Ïîêóïêà âîåííîé ôîðìû - {ff0000}2 óðîâåíü ðîçûñêà',
        onclick = function()
          sampSendChat("/su "..args.." 2 Ïîêóïêà âîåííîé ôîðìû")
        end
      },
      {
        title = '{ffffff}» Ïðåäëîæåíèå âçÿòêè ãîñ.ñëóæàùåìó - {ff0000}2 óðîâåíü ðîçûñêà.',
        onclick = function()
          sampSendChat("/su "..args.." 2 Ïðåäëîæåíèå âçÿòêè ãîñ.ñëóæàùåìó")
        end
      },
      {
        title = '{ae0620}« Ðàçäåë ¹3 »',
        onclick = function()
        end
      },
      {
        title = '{ffffff}» Óõîä â AFK îò àðåñòà - {ff0000}6 óðîâåíü ðîçûñêà.',
        onclick = function()
          sampSendChat("/su "..args.." 6 Óõîä")
        end
      },
      {
        title = '{ffffff}» Ñîâåðøåíèå òåððàêòà - {ff0000}6 óðîâåíü ðîçûñêà.',
        onclick = function()
          sampSendChat("/su "..args.." 6 Ñîâåðøåíèå òåðàêòà")
        end
      },
      {
        title = '{ffffff}» Íåóïëàòà øòðàôà - {ff0000}2 óðîâåíü ðîçûñêà.',
        onclick = function()
          sampSendChat("/su "..args.." 2 Íåóïëàòà øòðàôà")
        end
      },
      {
        title = '{ffffff}» Ïðåâûøåíèå ïîëíîìî÷èé àäâîêàòà - {ff0000}3 óðîâåíü ðîçûñêà.',
        onclick = function()
          sampSendChat("/su "..args.." 3 Ïðåâûøåíèå ïîëíîìî÷èé àäâîêàòà")
        end
      },
      {
        title = '{ffffff}» Ïîõèùåíèå ãðàæäàíñêîãî/ãîñ.ñëóæàùåãî - {ff0000}4 óðîâåíü ðîçûñêà',
        onclick = function()
          sampSendChat("/su "..args.." 4 Ïîõèùåíèå")
        end
      },
      {
        title = '{ffffff}» Ñòàòóñ ÎÎÏ - {ff0000}6 óðîâåíü ðîçûñêà',
        onclick = function()
          sampSendChat("/su "..args.." 6 ÎÎÏ")
        end
      }
    }
end

function getDriveLicenseCount(id)
    local lvl = sampGetPlayerScore(id)
    if lvl <= 2 then return 500
    elseif lvl >= 3 and lvl <= 5 then return 5000
    elseif lvl >= 6 and lvl <= 15 then return 10000
    elseif lvl >= 16 then return 30000 end
end

function giveLicense(id, list)
    ins.list = list
    ins.isLicense = true
    sampSendChat(("/me %s ïàïêó ñ ëèöåíçèÿìè"):format(cfg.main.male and "îòêðûë" or "îòêðûëà"))
    wait(cfg.commands.zaderjka)
    sampSendChat("/do Ëèöåíçèÿ â ðóêå.")
    wait(cfg.commands.zaderjka)
    sampSendChat(("/me %s ïå÷àòü \"Autoschool San Fierro\" è %s ëèöåíçèþ"):format(cfg.main.male and "ïîñòàâèë" or "ïîñòàâèëà", cfg.main.male and "ïåðåäàë" or "ïåðåäàëà"))
    wait(1400)
    sampSendChat(("/givelicense %s"):format(id))
end

function healPlayer(id, head)
    sampSendChat(("/me %s àïòå÷êó"):format(cfg.main.male and "äîñòàë" or "äîñòàëà"))
    wait(cfg.commands.zaderjka)
    sampSendChat(("/me %s íåîáõîäèìûé ïðåïàðàò"):format(cfg.main.male and "íàøåë" or "íàøëà"))
    wait(cfg.commands.zaderjka)
    sampSendChat(("/do %s â ðóêàõ"):format(head and "Àñïèðèí" or "Íîøïà"))
    wait(cfg.commands.zaderjka)
    sampSendChat(("/me %s ïàöèåíòó ëåêàðñòâî è %s çàïèòü âîäîé"):format(cfg.main.male and "ïåðåäàë" or "ïåðåäàëà", cfg.main.male and "äàë" or "äàëà"))
    wait(1400)
    sampSendChat(("/heal %s"):format(id))
end

function pkmmenuMOH(id)
    return
    {
        {
            title = "Âûëå÷èòü",
            submenu = {
                {
                    title = "Ãîëîâà",
                    onclick = function()
                        healPlayer(id, true)
                    end
                },
                {
                    title = "Æèâîòà",
                    onclick = function()
                        healPlayer(id, false)
                    end
                },
                {
                    title = "Ãîðëî",
                    onclick = function()
                        sampSendChat(("/me %s ãîðëî"):format(cfg.main.male and "îñìîòðåë" or "îñìîòðåëà"))
                        wait(cfg.commands.zaderjka)
                        sampSendChat(("/me %s àïòå÷êó"):format(cfg.main.male and "äîñòàë" or "äîñòàëà"))
                        wait(cfg.commands.zaderjka)
                        sampSendChat(("/me %s íåîáõîäèìûé ïðåïàðàò"):format(cfg.main.male and "íàøåë" or "íàøëà"))
                        wait(cfg.commands.zaderjka)
                        sampSendChat("/do Ñòîïàíãèí â ðóêàõ")
                        wait(cfg.commands.zaderjka)
                        sampSendChat(("/me %s ïàöèåíòó ëåêàðñòâî è %s çàïèòü âîäîé"):format(cfg.main.male and "ïåðåäàë" or "ïåðåäàëà", cfg.main.male and "äàë" or "äàëà"))
                        wait(1400)
                        sampSendChat(("/heal %s"):format(id))
                    end
                }
            }
        },
        {
            title = "» Ïðîâåñòè ñåàíñ",
            onclick = function()
                sampSendChat("/do Øïðèö â ðóêå.")
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s âàòêó ñìî÷åííóþ ìåä.ñïèðòîì è %s ìåñòî óêîëà"):format(cfg.main.male and "âçÿë" or "âçÿëà", cfg.main.male and "îáðàáîòàë" or "îáðàáîòàëà"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s æãóò íà ðóêå ïàöèåíòà, ïîñëå ÷åãî %s èíúåêöèþ"):format(cfg.main.male and "çàòÿíóë" or "çàòÿíóëà", cfg.main.male and "ââåë" or "ââåëà"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s æãóò è %s âàòêó ê ìåñòó óêîëà"):format(cfg.main.male and "ñíÿë" or "ñíÿëà", cfg.main.male and "ïðèëîæèë" or "ïðèëîæèëà"))
                wait(1400)
                sampSendChat(("/healaddict %s 10000"):format(id))
            end
        },
        {
            title = "» Ñäåëàòü ðåíòãåí",
            onclick = function()
                sampSendChat(("/me %s ðåíòãåíîâñêèé àïïàðàò"):format(cfg.main.male and "âêëþ÷èë" or "âêëþ÷èëà"))
                wait(cfg.commands.zaderjka)
                sampSendChat("/do Ðåíòãåíîâñêèé àïïàðàò çàøóìåë.")
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s ðåíòãåíîâñêèì àïïàðàòîì ïî ïîâðåæäåííîìó ó÷àñòêó"):format(cfg.main.male and "ïðîâåë" or "ïðîâåëà"))
                wait(cfg.commands.zaderjka)
                sampSendChat("/me ðàññìàòðèâàåò ñíèìîê")
                wait(cfg.commands.zaderjka)
                sampSendChat(("/try %s ïåðåëîì"):format(cfg.main.male and "îáíàðóæèë" or "îáíàðóæèëà"))
            end
        },
        {
            title = "» Âûëå÷èòü ïåðåëîì êîíå÷íîñòåé",
            onclick = function()
                sampSendChat(("/me %s ñî ñòîëà ïåð÷àòêè è %s èõ"):format(cfg.main.male and "âçÿë" or "âçÿëà", cfg.main.male and "íàäåë" or "íàäåëà"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s øïðèö ñ îáåçáàëèâàþùèì, ïîñëå ÷åãî %s ïîâðåæäåííûé ó÷àñòîê"):format(cfg.main.male and "âçÿë" or "âçÿëà", cfg.main.male and "îáåçáîëèë" or "îáåçáîëèëà"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s ðåïîçèöèþ ïîâðåæäåííîãî ó÷àñòêà"):format(cfg.main.male and "ïðîâåë" or "ïðîâåëà"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s áèíò âäîëü ñòîëà, ïîñëå ÷åãî %s ãèïñîâûé ðàñòâîð"):format(cfg.main.male and "ðàñêàòèë" or "ðàñêàòèëà", cfg.main.male and "âòåð" or "âòåðëà"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s áèíò, ïîñëå ÷åãî çàôèêñèðîâàë ïåðåëîì"):format(cfg.main.male and "ñâåðíóë" or "ñâåðíóëà"))
                wait(cfg.commands.zaderjka)
                sampSendChat("Ïðèõîäèòå ÷åðåç ìåñÿö. Âñåãî äîáðîãî!")
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s ïåð÷àòêè è %s èõ â óðíó âîçëå ñòîëà"):format(cfg.main.male and "ñíÿë" or "ñíÿëà", cfg.main.male and "áðîñèë" or "áðîñèëà"))
            end
        },
        {
            title = "» Âûëå÷èòü ïåðåëîì ïîçâîíî÷íèêà / ðåáåð",
            onclick = function()
                sampSendChat(("/me îñòîðîæíî %s ïîñòðàäàâøåãî íà îïåðàöèîííûé ñòîë"):format(cfg.main.male and "óêëàë" or "óêëàëà"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s ñî ñòîëà ïåð÷àòêè è %s èõ"):format(cfg.main.male and "âçÿë" or "âçÿëà", cfg.main.male and "íàäåë" or "íàäåëà"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s ïîñòðàäàâøåãî ê êàïåëüíèöå"):format(cfg.main.male and "ïîäêëþ÷èë" or "ïîäêëþ÷èëà"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s âàòêó ñïèðòîì è %s êîæó íà ðóêå ïàöèåíòà"):format(cfg.main.male and "íàìî÷èë" or "íàìî÷èëà", cfg.main.male and "îáðàáîòàë" or "îáðàáîòàëà"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me âíóòðèâåííî %s Ôòîðîòàí"):format(cfg.main.male and "ââåë" or "ââåëà"))
                wait(cfg.commands.zaderjka)
                sampSendChat("/do Íàðêîç íà÷èíàåò äåéñòâîâàòü, ïàöèåíò ïîòåðÿë ñîçíàíèå.")
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s ñêàëüïåëü è ïèíöåò"):format(cfg.main.male and "äîñòàë" or "äîñòàëà"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me ñ ïîìîùüþ ðàçëè÷íûõ èíñòðóìåíòîâ %s ðåïîçèöèþ ïîâðåæäåííîãî ó÷àñòêà"):format(cfg.main.male and "ïðîèçâåë" or "ïðîèçâåëà"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s èç òóìáî÷êè ñïåöèàëüíûé êîðñåò"):format(cfg.main.male and "äîñòàë" or "äîñòàëà"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s ïîâðåæäåííûé ó÷àñòîê ñ ïîìîùüþ êàðñåòà"):format(cfg.main.male and "çàôèêñèðîâàë" or "çàôèêñèðîâàëà"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s ïåð÷àòêè è %s èõ â óðíó âîçëå ñòîëà"):format(cfg.main.male and "ñíÿë" or "ñíÿëà", cfg.main.male and "áðîñèë" or "áðîñèëà"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s â îòäåëüíûé êîíòåéíåð ãðÿçíûé èíñòðóìåíòàðèé"):format(cfg.main.male and "óáðàë" or "óáðàëà"))
                wait(cfg.commands.zaderjka)
                sampSendChat("/do Ïðîøëî íåêîòîðîå âðåìÿ, ïàöèåíò ïðèøåë â ñîçíàíèå.")
            end
        },
        {
            title = "» Ãëóáîêèé ïîðåç",
            onclick = function()
                sampSendChat(("/me %s ñî ñòîëà ïåð÷àòêè è %s èõ"):format(cfg.main.male and "âçÿë" or "âçÿëà", cfg.main.male and "íàäåë" or "íàäåëà"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s îñìîòð ïàöèåíòà"):format(cfg.main.male and "ïðîâåë" or "ïðîâåëà"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s ñòåïåíü òÿæåñòè ïîðåçà ó ïàöèåíòà"):format(cfg.main.male and "îïðåäåëèë" or "îïðåäåëèëà"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s ïîâðåæäåííûé ó÷àñòîê"):format(cfg.main.male and "îáåçáîëèë" or "îáåçáîëèëà"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s èç ìåä. ñóìêè æãóò è %s åãî ïîâåðõ ïîâðåæäåíèÿ"):format(cfg.main.male and "äîñòàë" or "äîñòàëà", cfg.main.male and "íàëîæèë" or "íàëîæèëà"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s õèðóðãè÷åñêèå èíñòðóìåíòû íà ñòîëå"):format(cfg.main.male and "ðàçëîæèë" or "ðàçëîæèëà"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s ñïåöèàëüíûå èãëó è íèòè"):format(cfg.main.male and "âçÿë" or "âçÿëà"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s êðîâåíîñíûé ñîñóä è %s ïóëüñ"):format(cfg.main.male and "çàøèë" or "çàøèëà", cfg.main.male and "ïðîâåðèë" or "ïðîâåðèëà"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s êðîâü è %s ìåñòî ïîðåçà"):format(cfg.main.male and "ïðîòåð" or "ïðîòåðëà", cfg.main.male and "çàøèë" or "çàøèëà"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s èãëó è íèòè â ñòîðîíó"):format(cfg.main.male and "îòëîæèë" or "îòëîæèëà"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s æãóò, %s áèíòû è %s ïîâðåæäåííûé ó÷àñòîê êîæè"):format(cfg.main.male and "ñíÿë" or "ñíÿëà", cfg.main.male and "âçÿë" or "âçÿëà", cfg.main.male and "ïåðåáèíòîâàë" or "ïåðåáèíòîâàëà"))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/me %s â îòäåëüíûé êîíòåéíåð ãðÿçíûé èíñòðóìåíòàðèé"):format(cfg.main.male and "óáðàë" or "óáðàëà"))
            end
        },
        {
            title = "Ïóëåâîå ðàíåíèå",
            submenu = {
                {
                    title = "» Îñíîâíàÿ îòûãðîâêà",
                    onclick = function()
                        sampSendChat(("/me %s îñìîòð ïàöèåíòà"):format(cfg.main.male and "ïðîâåë" or "ïðîâåëà"))
                        wait(cfg.commands.zaderjka)
                        sampSendChat(("/me %s ïðèçíàêè ïóëåâîãî ðàíåíèÿ ó ïàöèåíòà"):format(cfg.main.male and "âûÿâèë" or "âûÿâèëà"))
                        wait(cfg.commands.zaderjka)
                        sampSendChat(("/me %s èç ìåä. ñóìêè è %s ñòåðèëüíûå ïåð÷àòêè"):format(cfg.main.male and "äîñòàë" or "äîñòàëà", cfg.main.male and "íàäåë" or "íàäåëà"))
                        wait(cfg.commands.zaderjka)
                        sampSendChat(("/me %s è %s àïïàðàò äëÿ íàðêîçà"):format(cfg.main.male and "ïîäêàòèë" or "ïîäêàòèëà", cfg.main.male and "âêëþ÷èë" or "âêëþ÷èëà"))
                        wait(cfg.commands.zaderjka)
                        sampSendChat(("/me %s ìàñêó äëÿ íàðêîçà ïàöèåíòó"):format(cfg.main.male and "íàäåë" or "íàäåëà"))
                        wait(cfg.commands.zaderjka)
                        sampSendChat("/do Ïàöèåíò çàñíóë.")
                        wait(cfg.commands.zaderjka)
                        sampSendChat(("/me %s õèðóðãè÷åñêèå èíñòðóìåíòû íà ñòîëå è %s âàòêó"):format(cfg.main.male and "ðàçëîæèë" or "ðàçëîæèëà", cfg.main.male and "âçÿë" or "âçÿëà"))
                        wait(cfg.commands.zaderjka)
                        sampSendChat(("/me %s ðàíó ïàöèåíòà è %s ùèïöû"):format(cfg.main.male and "îáðàáîòàë" or "îáðàáîòàëà", cfg.main.male and "âçÿë" or "âçÿëà"))
                        wait(cfg.commands.zaderjka)
                        sampSendChat(("/try %s ïóëþ"):format(cfg.main.male and "âûòàùèë" or "âûòàùèëà"))
                        return true
                    end
                },
                {
                    title = "» Ïðîäîëæåíèå åñëè {63c600}[Óäà÷íî]",
                    onclick = function()
                        sampSendChat(("/me %s ïóëþ, %s ìåä. èãëó è ìåä. íèòè è %s ðàíó ïàöèåíòó"):format(cfg.main.male and "îòëîæèë" or "îòëîæèëà", cfg.main.male and "âçÿë" or "âçÿëà", cfg.main.male and "çàøèë" or "çàøèëà"))
                        wait(cfg.commands.zaderjka)
                        sampSendChat(("/me %s áèíòû è %s íà ðàíåíèÿ"):format(cfg.main.male and "äîñòàë" or "äîñòàëà", cfg.main.male and "íàëîæèë" or "íàëîæèëà"))
                        wait(cfg.commands.zaderjka)
                        sampSendChat(("/me %s è %s ñòåðèëüíûå ïåð÷àòêè "):format(cfg.main.male and "ñíÿë" or "ñíÿëà", cfg.main.male and "ñâåðíóë" or "ñâåðíóëà"))
                        wait(cfg.commands.zaderjka)
                        sampSendChat(("/me %s àïïàðàò äëÿ íàðêîçà è %s ìàñêó ñ ïàöèåíòà"):format(cfg.main.male and "îòêëþ÷èë" or "îòêëþ÷èëà", cfg.main.male and "ñíÿë" or "ñíÿëà"))
                        wait(cfg.commands.zaderjka)
                        sampSendChat("/do Ïàöèåíò ïðîñíóëñÿ ")
                        wait(1400)
                        sampSendChat("Âàì ïîëîæåí ïîñòåëüíûé ðåæèì. Âûçäîðàâëèâàéòå")
                    end
                },
                {
                    title = "» Ïðîäîëæåíèå {bf0000}[Íåóäà÷íî]",
                    onclick = function()
                        sampSendChat(("/me %s êðîâü âàòêîé"):format(cfg.main.male and "âûòåð" or "âûòåðëà"))
                        wait(cfg.commands.zaderjka)
                        sampSendChat(("/try %s ïóëþ"):format(cfg.main.male and "âûòàùèë" or "âûòàùèëà"))
                        return true
                    end
                }
            }
        }
    }
end

function pkmmenuAS(id)
    return
    {
        {
            title = "{FFFFFF}Âûäàòü ëèöåíçèè",
            submenu = {
                {
                    title = "» Âîäèòåëüñêèå ïðàâà",
                    onclick = function()
                        if sampIsPlayerConnected(id) then
                            giveLicense(id, 0)
                        end
                    end
                },
                {
                    title = "» Âîçäóøíèé òðàíñïîðò",
                    onclick = function()
                        if sampIsPlayerConnected(id) then
                            giveLicense(id, 1)
                        end
                    end
                },
                {
                    title = "» Âîäíûé òðàíñïîðò",
                    onclick = function()
                        if sampIsPlayerConnected(id) then
                            giveLicense(id, 3)
                        end
                    end
                },
                {
                    title = "» Ëèöåíçèÿ íà îðóæèå",
                    onclick = function()
                        if sampIsPlayerConnected(id) then
                            giveLicense(id, 4)
                        end
                    end
                },
                {
                    title = "» Ëèöåíçèÿ íà ðûáîëîâñòâî",
                    onclick = function()
                        if sampIsPlayerConnected(id) then
                            giveLicense(id, 2)
                        end
                    end
                },
                {
                    title = "» Ëèöåíçèÿ íà áèçíåñ",
                    onclick = function()
                        if sampIsPlayerConnected(id) then
                            giveLicense(id, 5)
                        end
                    end
                }
            }
        },
        {
            title = "{FFFFFF}Çàäàòü âîïðîñû",
            submenu = {
                {
                    title = "{FFFFFF}» Ìàêñèìàëüíàÿ ñêîðîñòü â ãîðîäå {6495ED}[Îòâåò: {FFFFFF}50{6495ED}]",
                    onclick = function() sampSendChat("Êàêàÿ ìàêñèìàëüíàÿ ñêîðîñòü ðàçðåøåíà â ãîðîäå?") end
                },
                {
                    title = "{FFFFFF}» Ìàêñèìàëüíàÿ ñêîðîñòü â æèëûõ çîíàõ {6495ED}[Îòâåò: {FFFFFF}30{6495ED}]",
                    onclick = function() sampSendChat("Êàêàÿ ìàêñèìàëüíàÿ ñêîðîñòü ðàçðåøåíà â æèëûõ çîíàõ?") end
                },
                {
                    title = "{FFFFFF}» Ñ êàêîé ñòîðîíû ðàçðåøåí îáãîí {6495ED}[Îòâåò: {FFFFFF}Ñ ëåâîé{6495ED}]",
                    onclick = function() sampSendChat("Ñ êàêîé ñòîðîíû ðàçðåøåí îáãîí?") end
                },
                {
                    title = "{FFFFFF}» Ìîæíî ëè îñòàíàâëèâàòüñÿ íà ïðîåçæåé ÷àñòè {6495ED}[Îòâåò: {FFFFFF}Íåò{6495ED}]",
                    onclick = function() sampSendChat("Ìîæíî ëè îñòàíàâëèâàòüñÿ íà ïðîåçæåé ÷àñòè?") end
                },
                {
                    title = "{FFFFFF}» Öåëü íîøåíèÿ îðóæèÿ",
                    onclick = function() sampSendChat("Çà÷åì âàì ëèöåíçèÿ íà îðóæèå?") end
                },
                {
                    title = "{FFFFFF}» Õðàíåíèå îðóæèÿ",
                    onclick = function() sampSendChat("Ãäå âû áóäåòå õðàíèòü îðóæèå?") end
                }
            }
        },
        {
            title = "{FFFFFF}Îãëàñèòü öåíó íà ëèçöåíçèþ",
            submenu = {
                {
                    title = "» Âîäèòåëüñêèå ïðàâà",
                    onclick = function() sampSendChat(("Ëèöåíçèÿ áóäåò ñòîèòü %s$. Îôîðìëÿåì?"):format(getDriveLicenseCount(id))) end
                },
                {
                    title = "» Âîçäóøíèé òðàíñïîðò",
                    onclick = function() sampSendChat("Ëèöåíçèÿ áóäåò ñòîèòü 10000$. Îôîðìëÿåì?") end
                },
                {
                    title = "» Âîäíûé òðàíñïîðò",
                    onclick = function() sampSendChat("Ëèöåíçèÿ áóäåò ñòîèòü 5000$. Îôîðìëÿåì?") end
                },
                {
                    title = "» Ëèöåíçèÿ íà îðóæèå",
                    onclick = function() sampSendChat("Ëèöåíçèÿ áóäåò ñòîèòü 50000$. Îôîðìëÿåì?") end
                },
                {
                    title = "» Ëèöåíçèÿ íà ðûáîëîâñòâî",
                    onclick = function() sampSendChat("Ëèöåíçèÿ áóäåò ñòîèòü 2000$. Îôîðìëÿåì?") end
                },
                {
                    title = "» Ëèöåíçèÿ íà áèçíåñ",
                    onclick = function() sampSendChat("Ëèöåíçèÿ áóäåò ñòîèòü 100000$. Îôîðìëÿåì?") end
                }
            }
        }
    }
end

function pkmmenuPD(id)
	return
	{
		{
			title = '{ffffff}» Íàäåòü íàðó÷íèêè',
			onclick = function()
				if sampIsPlayerConnected(id) then
					sampSendChat(string.format('/me %s ðóêè %s è %s íàðó÷íèêè', cfg.main.male and 'çàëîìàë' or 'çàëîìàëà', sampGetPlayerNickname(id):gsub("_", " "), cfg.main.male and 'äîñòàë' or 'äîñòàëà'))
					wait(1400)
					sampSendChat(string.format('/cuff %s', id))
				end
			end
		},
		{
			title = "{ffffff}» Âåñòè çà ñîáîé",
			onclick = function()
				if sampIsPlayerConnected(id) then
					sampSendChat(string.format('/me %s îäèí èç êîíöîâ íàðó÷íèêîâ ê ñåáå, ïîñëå ÷åãî %s çà ñîáîé %s', cfg.main.male and 'ïðèñòåãíóë' or 'ïðèñòåãíóëà', cfg.main.male and 'ïîâåë' or 'ïîâåëà', sampGetPlayerNickname(id):gsub("_", " ")))
					wait(1400)
					sampSendChat(string.format('/follow %s', id))
				end
			end
		},
		{
			title = "{ffffff}» Ïðîèçâåñòè îáûñê",
			onclick = function()
				if sampIsPlayerConnected(id) then
					sampSendChat(string.format("/me íàäåâ ïåð÷àòêè, %s ðóêàìè ïî òîðñó", cfg.main.male and 'ïðîâåë' or 'ïðîâåëà'))
					wait(cfg.commands.zaderjka)
					sampSendChat(('/take %s'):format(id))
				end
			end
		},
		{
			title = "{ffffff}» Ïðîèçâåñòè àðåñò",
			onclick = function()
				if sampIsPlayerConnected(id) then
					--[[sampSendChat(('/me äîñòàâ êëþ÷è îò êàìåðû %s åå'):format(cfg.main.male and 'îòêðûë' or 'îòêðûëà'))
					wait(cfg.commands.zaderjka)
					sampSendChat(('/me %s %s â êàìåðó'):format(cfg.main.male and 'çàòîëêíóë' or 'çàòîëêíóëà', sampGetPlayerNickname(id):gsub("_", " ")))
					wait(cfg.commands.zaderjka)
					sampSendChat(('/arrest %s'):format(id))
					wait(cfg.commands.zaderjka)
                    sampSendChat(('/me çàêðûâ êàìåðó %s êëþ÷è â êàðìàí'):format(cfg.main.male and 'óáðàë' or 'óáðàëà'))]]
                    sampSendChat("/do Êëþ÷è îò êàìåðû âèñÿò íà ïîÿñå.")
                    wait(cfg.commands.zaderjka)
                    sampSendChat(string.format("/me %s êëþ÷è ñ ïîÿñà è %s êàìåðó, ïîñëå %s òóäà ïðåñòóïíèêà", cfg.main.male and 'ñíÿë' or 'ñíÿëà', cfg.main.male and 'îòêðûë' or 'îòêðûëà', cfg.main.male and 'çàòîëêíóë' or 'çàòîëêíóëà'))
                    wait(cfg.commands.zaderjka)
                    sampSendChat('/arrest '..id)
                    wait(cfg.commands.zaderjka)
                    sampSendChat(string.format("/me %s äâåðü êàìåðû è %s êëþ÷è íà ïîÿñ", cfg.main.male and 'çàêðûë' or 'çàêðûëà', cfg.main.male and 'ïîâåñèë' or 'ïîâåñèëà'))
				end
			end
		},
		{
			title = '{ffffff}» Ñíÿòü íàðó÷íèêè',
			onclick = function()
				if sampIsPlayerConnected(id) then
					sampSendChat(('/me %s íàðó÷íèêè ñ %s'):format(cfg.main.male and 'ñíÿë' or 'ñíÿëà', sampGetPlayerNickname(id):gsub("_", " ")))
					wait(1400)
					sampSendChat(('/uncuff %s'):format(id))
				end
			end
        },
        {
            title = "{ffffff}» Ñíÿòü ìàñêó",
            onclick = function()
                if sampIsPlayerConnected(id) then
                    sampSendChat(("/offmask %s"):format(id))
                end
            end
        },
		{
			title = "{ffffff}» Âûäàòü ðîçûñê çà ïðîíèêíîâåíèå",
			onclick = function()
				if sampIsPlayerConnected(id) then
					sampSendChat(("/su %s 2 Ïðîíèêíîâåíèå íà îõð. òåððèòîðèþ"):format(id))
				end
			end
		},
		{
			title = "{ffffff}» Âûäàòü ðîçûñê çà õðàíåíèå íàðêîòèêîâ",
			onclick = function()
				if sampIsPlayerConnected(id) then
					sampSendChat(("/su %s 3 Õðàíåíèå íàðêîòèêîâ"):format(id))
				end
			end
		},
		{
			title = "{ffffff}» Âûäàòü ðîçûñê çà õðàíåíèå ìàòåðèàëîâ",
			onclick = function()
				if sampIsPlayerConnected(id) then
					sampSendChat(("/su %s 3 Õðàíåíèå ìàòåðèàëîâ"):format(id))
				end
			end
		},
		{
			title = "{ffffff}» Âûäàòü ðîçûñê çà ïðîäàæó íàðêîòèêîâ",
			onclick = function()
				if sampIsPlayerConnected(id) then
					sampSendChat(('/su %s 2 Ïðîäàæà íàðêîòèêîâ'):format(id))
					wait(1400)
					sampSendChat(("/me %s ðóêè %s è %s íàðó÷íèêè"):format(cfg.main.male and 'çàëîìàë' or 'çàëîìàëà', sampGetPlayerNickname(id):gsub("_", " "), cfg.main.male and 'äîñòàë' or 'äîñòàëà'))
				end
			end
		},
		{
			title = "{ffffff}» Âûäàòü ðîçûñê çà ïðîäàæó êëþ÷åé îò êàìåðû",
			onclick = function()
				if sampIsPlayerConnected(id) then
					sampSendChat(("/su %s 6 Ïðîäàæà êëþ÷åé îò êàìåðû"):format(id))
				end
			end
		},
		{
			title = "{ffffff}» Âûäàòü ðîçûñê çà âîîðóæåííîå íàïàäåíèå íà ÏÎ",
			onclick = function()
				if sampIsPlayerConnected(id) then
					sampSendChat(("/su %s 6 Âîîðóæåííîå íàïàäåíèå íà ÏÎ"):format(id))
				end
			end
		},
		{
			title = "{ffffff}» Âûäàòü ðîçûñê",
			onclick = function()
				if sampIsPlayerConnected(id) then
					submenus_show(sumenu(id), ('{9966cc}'..script.this.name..' {ffffff}| %s [%s]'):format(sampGetPlayerNickname(id):gsub("_", " "), id))
				end
			end
		}
	}
end

function apply_custom_style()
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4

	style.WindowRounding = 2.0
	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
	style.ChildWindowRounding = 2.0
	style.FrameRounding = 2.0
	style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
	style.ScrollbarSize = 13.0
	style.ScrollbarRounding = 0
	style.GrabMinSize = 8.0
	style.GrabRounding = 1.0

	colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
	colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
	colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
	colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
	colors[clr.ComboBg]                = colors[clr.PopupBg]
	colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
	colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.FrameBg]                = ImVec4(0.16, 0.29, 0.48, 0.54)
	colors[clr.FrameBgHovered]         = ImVec4(0.26, 0.59, 0.98, 0.40)
	colors[clr.FrameBgActive]          = ImVec4(0.26, 0.59, 0.98, 0.67)
	colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
	colors[clr.TitleBgActive]          = ImVec4(0.16, 0.29, 0.48, 1.00)
	colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
	colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
	colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
	colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
	colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
	colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
	colors[clr.CheckMark]              = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.SliderGrab]             = ImVec4(0.24, 0.52, 0.88, 1.00)
	colors[clr.SliderGrabActive]       = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.Button]                 = ImVec4(0.26, 0.59, 0.98, 0.40)
	colors[clr.ButtonHovered]          = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.ButtonActive]           = ImVec4(0.06, 0.53, 0.98, 1.00)
	colors[clr.Header]                 = ImVec4(0.26, 0.59, 0.98, 0.31)
	colors[clr.HeaderHovered]          = ImVec4(0.26, 0.59, 0.98, 0.80)
	colors[clr.HeaderActive]           = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.Separator]              = colors[clr.Border]
	colors[clr.SeparatorHovered]       = ImVec4(0.26, 0.59, 0.98, 0.78)
	colors[clr.SeparatorActive]        = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.ResizeGrip]             = ImVec4(0.26, 0.59, 0.98, 0.25)
	colors[clr.ResizeGripHovered]      = ImVec4(0.26, 0.59, 0.98, 0.67)
	colors[clr.ResizeGripActive]       = ImVec4(0.26, 0.59, 0.98, 0.95)
	colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
	colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
	colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
	colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
	colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
	colors[clr.TextSelectedBg]         = ImVec4(0.26, 0.59, 0.98, 0.35)
	colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
end

function onScriptTerminate(scr)
    if scr == script.this then
		showCursor(false)
	end
end

if limgui then
    function imgui.TextQuestion(text)
        imgui.TextDisabled('(?)')
        if imgui.IsItemHovered() then
            imgui.BeginTooltip()
            imgui.PushTextWrapPos(450)
            imgui.TextUnformatted(text)
            imgui.PopTextWrapPos()
            imgui.EndTooltip()
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
    function imgui.OnDrawFrame()
        if infbar.v then
            imgui.ShowCursor = false
            _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
            local myname = sampGetPlayerNickname(myid)
            local myping = sampGetPlayerPing(myid)
            local myweapon = getCurrentCharWeapon(PLAYER_PED)
            local myweaponammo = getAmmoInCharWeapon(PLAYER_PED, myweapon)
            local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
            local myweaponname = getweaponname(myweapon)
            imgui.SetNextWindowPos(imgui.ImVec2(cfg.main.posX, cfg.main.posY), imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(cfg.main.widehud, 160), imgui.Cond.FirstUseEver)
            imgui.Begin(script.this.name, infbar, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar)
            imgui.CentrText(script.this.name)
            imgui.Separator()
            imgui.Text((u8"Èíôîðìàöèÿ:"):format(myname, myid, myping))
            imgui.SameLine()
            imgui.TextColored(imgui.ImVec4(getColor(myid)), u8('%s [%s]'):format(myname, myid))
            imgui.SameLine()
            imgui.Text((u8"| Ïèíã: %s"):format(myping))
            --imgui.Text((u8 'Îðóæèå: %s [%s]'):format(myweaponname, myweaponammo))
            if getAmmoInClip() ~= 0 then
                imgui.Text((u8 "Îðóæèå: %s [%s/%s]"):format(myweaponname, getAmmoInClip(), myweaponammo - getAmmoInClip()))
            else
                imgui.Text((u8 'Îðóæèå: %s'):format(myweaponname))
            end
            if isCharInAnyCar(playerPed) then
                local vHandle = storeCarCharIsInNoSave(playerPed)
                local result, vID = sampGetVehicleIdByCarHandle(vHandle)
                local vHP = getCarHealth(vHandle)
                local carspeed = getCarSpeed(vHandle)
                local speed = math.floor(carspeed)
                local vehName = tCarsName[getCarModel(storeCarCharIsInNoSave(playerPed))-399]
                local ncspeed = math.floor(carspeed*2)
                imgui.Text((u8 'Òðàíñïîðò: %s [%s] | HP: %s | Ñêîðîñòü: %s'):format(vehName, vID, vHP, ncspeed))
            else
                imgui.Text(u8 'Òðàíñïîðò: Íåò')
            end
            if valid and doesCharExist(ped) then 
                local result, id = sampGetPlayerIdByCharHandle(ped)
                if result then
                    local targetname = sampGetPlayerNickname(id)
                    local targetscore = sampGetPlayerScore(id)
                    imgui.Text((u8 'Öåëü: %s [%s] | Óðîâåíü: %s'):format(targetname, id, targetscore))
                else
                    imgui.Text(u8 'Öåëü: Íåò')
                end
            else
                imgui.Text(u8 'Öåëü: Íåò')
            end
            imgui.Text((u8 'Êâàäðàò: %s'):format(u8(kvadrat())))
            imgui.Text((u8 'Âðåìÿ: %s'):format(os.date('%H:%M:%S')))
            if cfg.main.group == "ÏÄ/ÔÁÐ" or cfg.main.group == "Ìýðèÿ" then imgui.Text((u8 'Tazer: %s'):format(stazer and 'ON' or 'OFF')) end
            if imgui.IsMouseClicked(0) and changetextpos then
                changetextpos = false
                sampToggleCursor(false)
                mainw.v = true
                saveData(cfg, 'moonloader/config/fbitools/config.json')
            end
            imgui.End()
        end
        if imegaf.v then
            imgui.ShowCursor = true
            local x, y = getScreenResolution()
            local btn_size = imgui.ImVec2(-0.1, 0)
            imgui.SetNextWindowSize(imgui.ImVec2(300, 300), imgui.Cond.FirstUseEver)
            imgui.SetNextWindowPos(imgui.ImVec2(x/2+300, y/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.Begin(u8(script.this.name..' | Ìåãàôîí'), imegaf, imgui.WindowFlags.NoResize)
            for k, v in ipairs(incar) do
                local mx, my, mz = getCharCoordinates(PLAYER_PED)
                if sampIsPlayerConnected(v) then
                    local result, ped = sampGetCharHandleBySampPlayerId(v)
                    if result then
                        local px, py, pz = getCharCoordinates(ped)
                        local dist = math.floor(getDistanceBetweenCoords3d(mx, my, mz, px, py, pz))
                        if isCharInAnyCar(ped) then
                            local carh = storeCarCharIsInNoSave(ped)
                            local carhm = getCarModel(carh)
                            if imgui.Button(("%s [EVL%sX] | Distance: %s m.##%s"):format(tCarsName[carhm-399], v, dist, k), btn_size) then
                                lua_thread.create(function()
                                    imegaf.v = false
                                    gmegafid = v
                                    gmegaflvl = sampGetPlayerScore(v)
                                    gmegaffrak = sampGetFraktionBySkin(v)
                                    gmegafcar = tCarsName[carhm-399]
                                    sampSendChat(("/m Âîäèòåëü à/ì %s [EVL%sX]"):format(tCarsName[carhm-399], v))
                                    wait(1400)
                                    sampSendChat("/m Ïðèæìèòåñü ê îáî÷èíå èëè ìû îòêðîåì îãîíü!")
                                    wait(300)
                                    sampAddChatMessage(' {ffffff}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~', 0x9966cc)
                                    sampAddChatMessage('', 0x9966cc)
                                    sampAddChatMessage(' {ffffff}Íèê: {9966cc}'..sampGetPlayerNickname(v)..' ['..v..']', 0x9966cc)
                                    sampAddChatMessage(' {ffffff}Óðîâåíü: {9966cc}'..sampGetPlayerScore(v), 0x9966cc)
                                    sampAddChatMessage(' {ffffff}Ôðàêöèÿ: {9966cc}'..sampGetFraktionBySkin(v), 0x9966cc)
                                    sampAddChatMessage('', 0x9966cc)
                                    sampAddChatMessage(' {ffffff}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~', 0x9966cc)
                                end)
                            end
                        end
                    end
                end
            end
            imgui.End()
        end
        if updwindows.v then
            local updlist = ttt
            imgui.ShowCursor = true
            local iScreenWidth, iScreenHeight = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(700, 290), imgui.Cond.FirstUseEver)
            imgui.Begin(u8(script.this.name..' | Îáíîâëåíèå'), updwindows, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
            imgui.Text(u8('Âûøëî îáíîâëåíèå ñêðèïòà '..script.this.name..'! ×òî áû îáíîâèòüñÿ íàæìèòå êíîïêó âíèçó. Ñïèñîê èçìåíåíèé:'))
            imgui.Separator()
            imgui.BeginChild("uuupdate", imgui.ImVec2(690, 200))
            for line in ttt:gmatch('[^\r\n]+') do
                imgui.TextWrapped(line)
            end
            imgui.EndChild()
            imgui.Separator()
            imgui.PushItemWidth(305)
            if imgui.Button(u8("Îáíîâèòü"), imgui.ImVec2(339, 25)) then
                lua_thread.create(goupdate)
                updwindows.v = false
            end
            imgui.SameLine()
            if imgui.Button(u8("Îòëîæèòü îáíîâëåíèå"), imgui.ImVec2(339, 25)) then
                updwindows.v = false
                ftext("Åñëè âû çàõîòèòå óñòàíîâèòü îáíîâëåíèå ââåäèòå êîìàíäó {9966CC}/ft")
            end
            imgui.End()
        end
        if mainw.v then
            imgui.ShowCursor = true
            local x, y = getScreenResolution()
            local btn_size = imgui.ImVec2(-0.1, 0)
            imgui.SetNextWindowSize(imgui.ImVec2(300, 300), imgui.Cond.FirstUseEver)
            imgui.SetNextWindowPos(imgui.ImVec2(x/2, y/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.Begin(u8(script.this.name..' | Ãëàâíîå ìåíþ | Âåðñèÿ: '..thisScript().version), mainw, imgui.WindowFlags.NoResize)
            if imgui.Button(u8'Áèíäåð', btn_size) then
                bMainWindow.v = not bMainWindow.v
            end
            if imgui.Button(u8'Êîìàíäíûé áèíäåð', btn_size) then
                vars.mainwindow.v = not vars.mainwindow.v
            end
            if imgui.Button(u8 'Êîìàíäû ñêðèïòà', btn_size) then cmdwind.v = not cmdwind.v end
            if imgui.Button(u8'Íàñòðîéêè ñêðèïòà', btn_size) then
                setwindows.v = not setwindows.v
            end
            if imgui.Button(u8 'Ñîîáùèòü î îøèáêå / áàãå', btn_size) then os.execute('explorer "https://vk.me/fbitools"') end
            if canupdate then if imgui.Button(u8 '[!] Äîñòóïíî îáíîâëåíèå ñêðèïòà [!]', btn_size) then updwindows.v = not updwindows.v end end
            if imgui.CollapsingHeader(u8 'Äåéñòâèÿ ñî ñêðèïòîì', btn_size) then
                if imgui.Button(u8'Ïåðåçàãðóçèòü ñêðèïò', btn_size) then
                    thisScript():reload()
                end
                if imgui.Button(u8 'Îòêëþ÷èòü ñêðèïò', btn_size) then
                    thisScript():unload()
                end
            end
            imgui.End()
            if cmdwind.v then
                local x, y = getScreenResolution()
                imgui.SetNextWindowSize(imgui.ImVec2(500, 500), imgui.Cond.FirstUseEver)
                imgui.SetNextWindowPos(imgui.ImVec2(x/2, y/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
                imgui.Begin(u8(script.this.name..' | Êîìàíäû'), cmdwind)
                for k, v in ipairs(fthelp) do
                    if imgui.CollapsingHeader(v['cmd']..'##'..k) then
                        imgui.TextWrapped(u8('Îïèñàíèå: %s'):format(u8(v['desc'])))
                        imgui.TextWrapped(u8("Èñïîëüçîâàíèå: %s"):format(u8(v['use'])))
                    end
                end
                imgui.End()
            end
            if vars.mainwindow.v then
                local sX, sY = getScreenResolution()
                imgui.SetNextWindowPos(imgui.ImVec2(sX/2, sY/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
                imgui.SetNextWindowSize(imgui.ImVec2(891, 380), imgui.Cond.FirstUseEver)
                imgui.Begin(u8(script.this.name.." | Ñïèñîê êîìàíä"), vars.mainwindow, imgui.WindowFlags.NoResize)
                imgui.BeginChild("##commandlist", imgui.ImVec2(170 ,320), true)
                for k, v in pairs(commands) do
                    if imgui.Selectable(u8(("%s. /%s##%s"):format(k, v.cmd, k)), vars.menuselect == k) then 
                        vars.menuselect     = k 
                        vars.cmdbuf.v       = u8(v.cmd) 
                        vars.cmdparams.v    = v.params
                        vars.cmdtext.v      = u8(v.text)
                    end
                end
                imgui.EndChild()
                imgui.SameLine()
                imgui.BeginChild("##commandsetting", imgui.ImVec2(700, 320), true)
                for k, v in pairs(commands) do
                    if vars.menuselect == k then
                        imgui.InputText(u8 "Ââåäèòå ñàìó êîìàíäó", vars.cmdbuf)
                        imgui.InputInt(u8 "Ââåäèòå êîë-âî ïàðàìåòðîâ êîìàíäû", vars.cmdparams, 0)
                        imgui.InputTextMultiline(u8 "##cmdtext", vars.cmdtext, imgui.ImVec2(678, 200))
                        imgui.TextWrapped(u8 "Êëþ÷è ïàðàìåòðîâ: {param:1}, {param:2} è ò.ä (Èñïîëüçîâàòü â òåêñòå íà ìåñòå ïàðàìåòðà)\nÊëþ÷ çàäåðæêè: {wait:êîë-âî ìèëëèñåêóíä} (Èñïîëüçîâàòü íà íîâîé ñòðîêå)")
                        if imgui.Button(u8 "Ñîõðàíèòü êîìàíäó") then
                            sampUnregisterChatCommand(v.cmd)
                            v.cmd = u8:decode(vars.cmdbuf.v)
                            v.params = vars.cmdparams.v
                            v.text = u8:decode(vars.cmdtext.v)
                            saveData(commands, "moonloader/config/fbitools/cmdbinder.json")
                            registerCommandsBinder()
                            ftext("Êîìàíäà ñîõðàíåíà")
                        end
                        imgui.SameLine()
                        if imgui.Button(u8 "Óäàëèòü êîìàíäó") then
                            imgui.OpenPopup(u8 "Óäàëåíèå êîìàíäû##"..k)
                        end
                        if imgui.BeginPopupModal(u8 "Óäàëåíèå êîìàíäû##"..k, _, imgui.WindowFlags.AlwaysAutoResize) then
                            imgui.SetCursorPosX(imgui.GetWindowWidth()/2 - imgui.CalcTextSize(u8 "Âû äåéñòâèòåëüíî õîòèòå óäàëèòü êîìàíäó?").x / 2)
                            imgui.Text(u8 "Âû äåéñòâèòåëüíî õîòèòå óäàëèòü êîìàíäó?")
                            if imgui.Button(u8 "Óäàëèòü##"..k, imgui.ImVec2(170, 20)) then
                                sampUnregisterChatCommand(v.cmd)
                                vars.menuselect     = 0
                                vars.cmdbuf.v       = ""
                                vars.cmdparams.v    = 0
                                vars.cmdtext.v      = ""
                                table.remove(commands, k)
                                saveData(commands, "moonloader/config/fbitools/cmdbinder.json")
                                registerCommandsBinder()
                                ftext("Êîìàíäà óäàëåíà")
                                imgui.CloseCurrentPopup()
                            end
                            imgui.SameLine()
                            if imgui.Button(u8 "Îòìåíà##"..k, imgui.ImVec2(170, 20)) then
                                imgui.CloseCurrentPopup()
                            end
                            imgui.EndPopup()
                        end
                        imgui.SameLine()
                        if imgui.Button(u8 'Êëþ÷è', imgui.ImVec2(170, 20)) then imgui.OpenPopup('##bindkey') end
                        if imgui.BeginPopup('##bindkey') then
                            imgui.Text(u8 'Èñïîëüçóéòå êëþ÷è áèíäåðà äëÿ áîëåå óäîáíîãî èñïîëüçîâàíèÿ áèíäåðà')
                            imgui.Text(u8 'Ïðèìåð: /su {targetid} 6 Âîîðóæåííîå íàïàäåíèå íà ÏÎ')
                            imgui.Separator()
                            imgui.Text(u8 '{myid} - ID âàøåãî ïåðñîíàæà | '..select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
                            imgui.Text(u8 '{myrpnick} - ÐÏ íèê âàøåãî ïåðñîíàæà | '..sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub('_', ' '))
                            imgui.Text(u8 ('{naparnik} - Âàøè íàïàðíèêè | '..naparnik()))
                            imgui.Text(u8 ('{kv} - Âàø òåêóùèé êâàäðàò | '..kvadrat()))
                            imgui.Text(u8 '{targetid} - ID èãðîêà íà êîòîðîãî âû öåëèòåñü | '..targetid)
                            imgui.Text(u8 '{targetrpnick} - ÐÏ íèê èãðîêà íà êîòîðîãî âû öåëèòåñü | '..sampGetPlayerNicknameForBinder(targetid):gsub('_', ' '))
                            imgui.Text(u8 '{smsid} - Ïîñëåäíèé ID òîãî, êòî âàì íàïèñàë â SMS | '..smsid)
                            imgui.Text(u8 '{smstoid} - Ïîñëåäíèé ID òîãî, êîìó âû íàïèñàëè â SMS | '..smstoid)
                            imgui.Text(u8 '{megafid} - ID èãðîêà, çà êîòîðûì áûëà íà÷àòà ïîãîíÿ | '..gmegafid)
                            imgui.Text(u8 '{rang} - Âàøå çâàíèå | '..u8(rang))
                            imgui.Text(u8 '{frak} - Âàøà ôðàêöèÿ | '..u8(frak))
                            imgui.Text(u8 '{dl} - ID àâòî, â êîòîðîì âû ñèäèòå | '..mcid)
                            imgui.Text(u8 '{noe} - Îñòàâèòü ñîîáùåíèå â ïîëëå ââîäà à íå îòïðàâëÿòü åãî â ÷àò (èñïîëüçîâàòü â ñàìîì íà÷àëå)')
                            imgui.Text(u8 '{wait:sek} - Çàäåðæêà ìåæäó ñòðîêàìè, ãäå sek - êîë-âî ìèëëèñåêóíä. Ïðèìåð: {wait:2000} - çàäåðæêà 2 ñåêóíäû. (èñïîëüçîâàòü îòäåëüíî íà íîâîé ñòðî÷êå)')
                            imgui.Text(u8 '{screen} - Ñäåëàòü ñêðèíøîò ýêðàíà (èñïîëüçîâàòü îòäåëüíî íà íîâîé ñòðî÷êå)')
                            imgui.EndPopup()
                        end
                    end
                end
                imgui.EndChild()
                if imgui.Button(u8 "Äîáàâèòü êîìàíäó", imgui.ImVec2(170, 20)) then
                    table.insert(commands, {cmd = "", params = 0, text = ""})
                    saveData(commands, "moonloader/config/fbitools/cmdbinder.json")
                end
                imgui.End()
            end
            if bMainWindow.v then
                imgui.ShowCursor = true
                local iScreenWidth, iScreenHeight = getScreenResolution()
                imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
                imgui.SetNextWindowSize(imgui.ImVec2(1000, 510), imgui.Cond.FirstUseEver)
                imgui.Begin(u8(script.this.name.." | Áèíäåð##main"), bMainWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
                imgui.BeginChild("##bindlist", imgui.ImVec2(995, 442))
                for k, v in ipairs(tBindList) do
                    if imadd.HotKey("##HK" .. k, v, tLastKeys, 100) then
                        if not rkeys.isHotKeyDefined(v.v) then
                            if rkeys.isHotKeyDefined(tLastKeys.v) then
                                rkeys.unRegisterHotKey(tLastKeys.v)
                            end
                            rkeys.registerHotKey(v.v, true, onHotKey)
                        end
                        saveData(tBindList, fileb)
                    end
                    imgui.SameLine()
                    imgui.CentrText(u8(v.name))
                    imgui.SameLine(850)
                    if imgui.Button(u8 'Ðåäàêòèðîâàòü áèíä##'..k) then imgui.OpenPopup(u8 "Ðåäàêòèðîâàíèå áèíäåðà##editbind"..k) 
                        bindname.v = u8(v.name) 
                        bindtext.v = u8(v.text)
                    end
                    if imgui.BeginPopupModal(u8 'Ðåäàêòèðîâàíèå áèíäåðà##editbind'..k, _, imgui.WindowFlags.NoResize) then
                        imgui.Text(u8 "Ââåäèòå íàçâàíèå áèíäåðà:")
                        imgui.InputText("##Ââåäèòå íàçâàíèå áèíäåðà", bindname)
                        imgui.Text(u8 "Ââåäèòå òåêñò áèíäåðà:")
                        imgui.InputTextMultiline("##Ââåäèòå òåêñò áèíäåðà", bindtext, imgui.ImVec2(500, 200))
                        imgui.Separator()
                        if imgui.Button(u8 'Êëþ÷è', imgui.ImVec2(90, 20)) then imgui.OpenPopup('##bindkey') end
                        if imgui.BeginPopup('##bindkey') then
                            imgui.Text(u8 'Èñïîëüçóéòå êëþ÷è áèíäåðà äëÿ áîëåå óäîáíîãî èñïîëüçîâàíèÿ áèíäåðà')
                            imgui.Text(u8 'Ïðèìåð: /su {targetid} 6 Âîîðóæåííîå íàïàäåíèå íà ÏÎ')
                            imgui.Separator()
                            imgui.Text(u8 '{myid} - ID âàøåãî ïåðñîíàæà | '..select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
                            imgui.Text(u8 '{myrpnick} - ÐÏ íèê âàøåãî ïåðñîíàæà | '..sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub('_', ' '))
                            imgui.Text(u8 ('{naparnik} - Âàøè íàïàðíèêè | '..naparnik()))
                            imgui.Text(u8 ('{kv} - Âàø òåêóùèé êâàäðàò | '..kvadrat()))
                            imgui.Text(u8 '{targetid} - ID èãðîêà íà êîòîðîãî âû öåëèòåñü | '..targetid)
                            imgui.Text(u8 '{targetrpnick} - ÐÏ íèê èãðîêà íà êîòîðîãî âû öåëèòåñü | '..sampGetPlayerNicknameForBinder(targetid):gsub('_', ' '))
                            imgui.Text(u8 '{smsid} - Ïîñëåäíèé ID òîãî, êòî âàì íàïèñàë â SMS | '..smsid)
                            imgui.Text(u8 '{smstoid} - Ïîñëåäíèé ID òîãî, êîìó âû íàïèñàëè â SMS | '..smstoid)
                            imgui.Text(u8 '{megafid} - ID èãðîêà, çà êîòîðûì áûëà íà÷àòà ïîãîíÿ | '..gmegafid)
                            imgui.Text(u8 '{rang} - Âàøå çâàíèå | '..u8(rang))
                            imgui.Text(u8 '{frak} - Âàøà ôðàêöèÿ | '..u8(frak))
                            imgui.Text(u8 '{dl} - ID àâòî, â êîòîðîì âû ñèäèòå | '..mcid)
                            imgui.Text(u8 '{f6} - Îòïðàâèòü ñîîáùåíèå â ÷àò ÷åðåç ýìóëÿöèþ ÷àòà (èñïîëüçîâàòü â ñàìîì íà÷àëå)')
                            imgui.Text(u8 '{noe} - Îñòàâèòü ñîîáùåíèå â ïîëëå ââîäà à íå îòïðàâëÿòü åãî â ÷àò (èñïîëüçîâàòü â ñàìîì íà÷àëå)')
                            imgui.Text(u8 '{wait:sek} - Çàäåðæêà ìåæäó ñòðîêàìè, ãäå sek - êîë-âî ìèëëèñåêóíä. Ïðèìåð: {wait:2000} - çàäåðæêà 2 ñåêóíäû. (èñïîëüçîâàòü îòäåëüíî íà íîâîé ñòðî÷êå)')
                            imgui.Text(u8 '{screen} - Ñäåëàòü ñêðèíøîò ýêðàíà (èñïîëüçîâàòü îòäåëüíî íà íîâîé ñòðî÷êå)')
                            imgui.EndPopup()
                        end
                        imgui.SameLine()
                        imgui.SetCursorPosX((imgui.GetWindowWidth() - 90 - imgui.GetStyle().ItemSpacing.x))
                        if imgui.Button(u8 "Óäàëèòü áèíä##"..k, imgui.ImVec2(90, 20)) then
                            table.remove(tBindList, k)
                            saveData(tBindList, fileb)
                            imgui.CloseCurrentPopup()
                        end
                        imgui.SameLine()
                        imgui.SetCursorPosX((imgui.GetWindowWidth() - 180 + imgui.GetStyle().ItemSpacing.x) / 2)
                        if imgui.Button(u8 "Ñîõðàíèòü##"..k, imgui.ImVec2(90, 20)) then
                            v.name = u8:decode(bindname.v)
                            v.text = u8:decode(bindtext.v)
                            bindname.v = ''
                            bindtext.v = ''
                            saveData(tBindList, fileb)
                            imgui.CloseCurrentPopup()
                        end
                        imgui.SameLine()
                        if imgui.Button(u8 "Çàêðûòü##"..k, imgui.ImVec2(90, 20)) then imgui.CloseCurrentPopup() end
                        imgui.EndPopup()
                    end
                end
                imgui.EndChild()
                imgui.Separator()
                if imgui.Button(u8"Äîáàâèòü êëàâèøó") then
                    tBindList[#tBindList + 1] = {text = "", v = {}, time = 0, name = "Áèíä"..#tBindList + 1}
                    saveData(tBindList, fileb)
                end
                imgui.End()
            end
            if setwindows.v then
                --
                cput            = imgui.ImBool(cfg.commands.cput)
                ceject          = imgui.ImBool(cfg.commands.ceject)
                ftazer          = imgui.ImBool(cfg.commands.ftazer)
                deject          = imgui.ImBool(cfg.commands.deject)
                kmdcb           = imgui.ImBool(cfg.commands.kmdctime)
                carb            = imgui.ImBool(cfg.main.autocar)
                stateb          = imgui.ImBool(cfg.main.male)
                tagf            = imgui.ImBuffer(u8(cfg.main.tar), 256)
                parolf          = imgui.ImBuffer(u8(tostring(cfg.main.parol)), 256)
                tagb            = imgui.ImBool(cfg.main.tarb)
                xcord           = imgui.ImInt(cfg.main.posX)
                ycord           = imgui.ImInt(cfg.main.posY)
                clistbuffer     = imgui.ImInt(cfg.main.clist)
                waitbuffer      = imgui.ImInt(cfg.commands.zaderjka)
                clistb          = imgui.ImBool(cfg.main.clistb)
                parolb          = imgui.ImBool(cfg.main.parolb)
                offptrlb        = imgui.ImBool(cfg.main.offptrl)
                offwntdb        = imgui.ImBool(cfg.main.offwntd)
                ticketb         = imgui.ImBool(cfg.commands.ticket)
                tchatb          = imgui.ImBool(cfg.main.tchat)
                strobbsb        = imgui.ImBool(cfg.main.strobs)
                megafb          = imgui.ImBool(cfg.main.megaf)
                infbarb         = imgui.ImBool(cfg.main.hud)
                autobpb         = imgui.ImBool(cfg.main.autobp)
                deagleb         = imgui.ImBool(cfg.autobp.deagle)
                shotb           = imgui.ImBool(cfg.autobp.shot)
                smgb            = imgui.ImBool(cfg.autobp.smg)
                m4b             = imgui.ImBool(cfg.autobp.m4)
                rifleb          = imgui.ImBool(cfg.autobp.rifle)
                armourb         = imgui.ImBool(cfg.autobp.armour)
                specb           = imgui.ImBool(cfg.autobp.spec)
                dvadeagleb      = imgui.ImBool(cfg.autobp.dvadeagle)
                dvashotb        = imgui.ImBool(cfg.autobp.dvashot)
                dvasmgb         = imgui.ImBool(cfg.autobp.dvasmg)
                dvam4b          = imgui.ImBool(cfg.autobp.dvam4)
                dvarifleb       = imgui.ImBool(cfg.autobp.dvarifle)
                googlecodeb     = imgui.ImBuffer(tostring(cfg.main.googlecode), 256)
                googlecodebb    = imgui.ImBool(cfg.main.googlecodeb)
                nwantedb        = imgui.ImBool(cfg.main.nwanted)
                nclearb         = imgui.ImBool(cfg.main.nclear)
                --
                local iScreenWidth, iScreenHeight = getScreenResolution()
                imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
                imgui.SetNextWindowSize(imgui.ImVec2(1161, 436), imgui.Cond.FirstUseEver)
                imgui.Begin(u8'Íàñòðîéêè##1', setwindows, imgui.WindowFlags.NoResize)
                --ftext(("w: %s / h: %s"):format(imgui.GetWindowWidth(), imgui.GetWindowHeight()))
                if cfg.main.group ~= 'unknown' then
                    imgui.BeginChild('##set', imgui.ImVec2(140, 400), true)
                    if imgui.Selectable(u8'Îñíîâíûå', show == 1) then show = 1 end
                    if cfg.main.group == 'ÏÄ/ÔÁÐ' then if imgui.Selectable(u8'Êîìàíäû', show == 2) then show = 2 end end
                    if imgui.Selectable(u8'Êëàâèøè', show == 3) then show = 3 end
                    if cfg.main.group == 'ÏÄ/ÔÁÐ' then if imgui.Selectable(u8'Àâòî-ÁÏ', show == 4) then show = 4 end end
                    imgui.EndChild()
                    imgui.SameLine()
                    imgui.BeginChild('##set1', imgui.ImVec2(1000, 400), true)
                    if show == 1 then
                        if imadd.ToggleButton(u8 'Èíôîáàð', infbarb) then cfg.main.hud = infbarb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end imgui.SameLine() imgui.Text(u8 "Èíôî-áàð")
                        if infbarb.v then
                            imgui.SameLine()
                            if imgui.Button(u8 'Èçìåíèòü ìåñòîïîëîæåíèå') then
                                mainw.v = false
                                changetextpos = true
                                ftext('Ïî çàâåøåíèþ íàæìèòå ëåâóþ êíîïêó ìûøè')
                            end
                        end
                        if cfg.main.group == 'ÏÄ/ÔÁÐ' then
                            if imadd.ToggleButton(u8'Ñêðûâàòü ñîîáùåíèÿ î íà÷àëå ïðåñëåäîâàíèÿ', offptrlb) then cfg.main.offptrl = offptrlb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end imgui.SameLine(); imgui.Text(u8 'Ñêðûâàòü ñîîáùåíèÿ î íà÷àëå ïðåñëåäîâàíèÿ')
                            if imadd.ToggleButton(u8'Ñêðûâàòü ñîîáùåíèÿ î âûäà÷å ðîçûñêà', offwntdb) then cfg.main.offwntd = offwntdb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end imgui.SameLine(); imgui.Text(u8 'Ñêðûâàòü ñîîáùåíèÿ î âûäà÷å ðîçûñêà')
                            if imadd.ToggleButton(u8'Íîâûé wanted', nwantedb) then cfg.main.nwanted = nwantedb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end imgui.SameLine(); imgui.Text(u8 'Îáíîâëåííûé Wanted')
                            if imadd.ToggleButton(u8'äîïclear', nclearb) then cfg.main.nclear = nclearb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end imgui.SameLine(); imgui.Text(u8 'Äîïîëíåíûé Clear')
                        end
                        if imadd.ToggleButton(u8'Ìóæñêèå îòûãðîâêè', stateb) then cfg.main.male = stateb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end imgui.SameLine(); imgui.Text(u8 'Ìóæñêèå îòûãðîâêè')
                        if imadd.ToggleButton(u8'Èñïîëüçîâàòü àâòîòåã', tagb) then cfg.main.tarb = tagb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end imgui.SameLine(); imgui.Text(u8 'Èñïîëüçîâàòü àâòîòåã')
                        if tagb.v then
                            if imgui.InputText(u8'Ââåäèòå âàø Òåã.', tagf) then cfg.main.tar = u8:decode(tagf.v) saveData(cfg, 'moonloader/config/fbitools/config.json') end
                        end
                        if imadd.ToggleButton(u8'Èñïîëüçîâàòü àâòî ëîãèí', parolb) then cfg.main.parolb = parolb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end; imgui.SameLine(); imgui.Text(u8 'Èñïîëüçîâàòü àâòî ëîãèí')
                        if parolb.v then
                            if imgui.InputText(u8'Ââåäèòå âàø ïàðîëü.', parolf, imgui.InputTextFlags.Password) then cfg.main.parol = u8:decode(parolf.v) saveData(cfg, 'moonloader/config/fbitools/config.json') end
                            if imgui.Button(u8'Óçíàòü ïàðîëü') then ftext('Âàø ïàðîëü: {9966cc}'..cfg.main.parol) end
                        end
                        if imadd.ToggleButton(u8'Èñïîëüçîâàòü àâòî g-auth', googlecodebb) then cfg.main.googlecodeb = googlecodebb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end; imgui.SameLine(); imgui.Text(u8 'Èñïîëüçîâàòü àâòî g-auth')
                        if googlecodebb.v then
                            if imgui.InputText(u8'Ââåäèòå âàø ãóãë êîä(êîòîðûé ïðèøåë âàì íà ïî÷òó).', googlecodeb, imgui.InputTextFlags.Password) then cfg.main.googlecode = googlecodeb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end
                            if imgui.Button(u8'Óçíàòü ãóãë êîä') then ftext('Âàø ãóãë êîä: {9966cc}'..cfg.main.googlecode) end
                            if #tostring(cfg.main.googlecode) == 16 then imgui.SameLine() imgui.Text(u8(("Ñãåíåðèðîâàíûé êîä: %s"):format(genCode(tostring(cfg.main.googlecode))))) end
                        end
                        if imadd.ToggleButton(u8'Èñïîëüçîâàòü àâòîêëèñò', clistb) then cfg.main.clistb = clistb.v end; imgui.SameLine() saveData(cfg, 'moonloader/config/fbitools/config.json'); imgui.Text(u8 'Èñïîëüçîâàòü àâòîêëèñò')
                        if clistb.v then
                            if imgui.SliderInt(u8"Âûáåðèòå çíà÷åíèå êëèñòà", clistbuffer, 0, 33) then cfg.main.clist = clistbuffer.v saveData(cfg, 'moonloader/config/fbitools/config.json') end
                        end
                        if imadd.ToggleButton(u8'Îòêðûâàòü ÷àò íà T', tchatb) then cfg.main.tchat = tchatb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end imgui.SameLine(); imgui.Text(u8 'Îòêðûâàòü ÷àò íà T')
                        if imadd.ToggleButton(u8 'Àâòîìàòè÷åñêè çàâîäèòü àâòî', carb) then cfg.main.autocar = carb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end imgui.SameLine(); imgui.Text(u8 'Àâòîìàòè÷åñêè çàâîäèòü àâòî')
                        if cfg.main.group == 'ÏÄ/ÔÁÐ' then
                            if imadd.ToggleButton(u8 'Ñòðîáîñêîïû', strobbsb) then cfg.main.strobs = strobbsb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end imgui.SameLine(); imgui.Text(u8 'Ñòðîáîñêîïû')
                            if imadd.ToggleButton(u8 'Ðàñøèðåííûé ìåãàôîí', megafb) then cfg.main.megaf = megafb.v end saveData(cfg, 'moonloader/config/fbitools/config.json'); imgui.SameLine(); imgui.Text(u8 'Ðàñøèðåííûé ìåãàôîí')
                        end
                        if imgui.InputInt(u8'Çàäåðæêà â îòûãðîâêàõ', waitbuffer) then cfg.commands.zaderjka = waitbuffer.v saveData(cfg, 'moonloader/config/fbitools/config.json') end
                        imgui.Separator()
                        if imgui.Button(u8 'Ñáðîñèòü ãðóïïó') then imgui.OpenPopup(u8 'Ñáðîññ ãðóïïû') end
                        imgui.SameLine()
                        imgui.Text(u8 'Òåêóùàÿ ãðóïïà ôðàêöèé: '..u8(cfg.main.group))
                        if imgui.BeginPopupModal(u8 'Ñáðîññ ãðóïïû', _, imgui.WindowFlags.NoResize) then
                            imgui.CentrText(u8 'Âû äåéñòâèòåëüíî õîòèòå ñáðîñèòü ãðóïïó ôðàêöèé?')
                            if imgui.Button(u8 'Äà##ãðóïïà', imgui.ImVec2(170, 20)) then cfg.main.group = 'unknown'
                                saveData(cfg, 'moonloader/config/fbitools/config.json')
                                registerCommands()
                                imgui.CloseCurrentPopup()
                            end
                            imgui.SameLine()
                            if imgui.Button(u8 'Íåò##ãðóïïà', imgui.ImVec2(170, 20)) then imgui.CloseCurrentPopup() end
                            imgui.EndPopup()
                        end
                    end
                    if show == 2 then
                        if cfg.main.group == 'ÏÄ/ÔÁÐ' then
                            if imadd.ToggleButton(u8('Îòûãðîâêà /cput'), cput) then cfg.commands.cput = cput.v end; imgui.SameLine(); imgui.Text(u8 'Îòûãðîâêà /cput')
                            if imadd.ToggleButton(u8('Îòûãðîâêà /ceject'), ceject) then cfg.commands.ceject = ceject.v saveData(cfg, 'moonloader/config/fbitools/config.json') end; imgui.SameLine(); imgui.Text(u8 'Îòûãðîâêà /ceject')
                            if imadd.ToggleButton(u8('Îòûãðîâêà /ftazer'), ftazer) then cfg.commands.ftazer = ftazer.v saveData(cfg, 'moonloader/config/fbitools/config.json') end; imgui.SameLine(); imgui.Text(u8 'Îòûãðîâêà /ftazer')
                            if imadd.ToggleButton(u8('Îòûãðîâêà /deject'), deject) then cfg.commands.deject = deject.v saveData(cfg, 'moonloader/config/fbitools/config.json') end; imgui.SameLine(); imgui.Text(u8 'Îòûãðîâêà /deject')
                            if imadd.ToggleButton(u8('Îòûãðîâêà /ticket'), ticketb) then cfg.commands.ticket = ticketb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end; imgui.SameLine(); imgui.Text(u8 'Îòûãðîâêà /ticket')
                            if imadd.ToggleButton(u8('Èñïîëüçîâàòü /time F8 ïðè /kmdc'), kmdcb) then cfg.commands.kmdctime = kmdcb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end; imgui.SameLine(); imgui.Text(u8 'Èñïîëüçîâàòü /time F8 ïðè /kmdc')
                        end
                    end
                    if show == 3 then
                        if cfg.main.group ~= "Ìýðèÿ" then
                            if imadd.HotKey(u8'##Êëàâèøà âçàèìîäåéñòâèÿ ñ èãðîêîì', config_keys.vzaimkey, tLastKeys, 100) then
                                rkeys.changeHotKey(vzaimbind, config_keys.vzaimkey.v)
                                ftext('Êëàâèøà óñïåøíî èçìåíåíà. Ñòàðîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Íîâîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(config_keys.vzaimkey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end
                            imgui.SameLine()
                            imgui.Text(u8 'Êëàâèøà âçàèìîäåéñòâèÿ ñ èãðîêîì (ñðàáàòûâàåò ïîñëå ïðèöåëèâàíèÿ íà èãðîêà)')
                            if imadd.HotKey('##fastmenu', config_keys.fastmenukey, tLastKeys, 100) then
                                rkeys.changeHotKey(fastmenubind, config_keys.fastmenukey.v)
                                ftext('Êëàâèøà óñïåøíî èçìåíåíà. Ñòàðîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Íîâîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(config_keys.fastmenukey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end
                            imgui.SameLine()
                            imgui.Text(u8('Êëàâèøà áûñòðîãî ìåíþ'))
                        end
                        if cfg.main.group == 'ÏÄ/ÔÁÐ' or cfg.main.group == 'Ìýðèÿ' then
                            if imadd.HotKey(u8'##Êëàâèøà áûñòðîãî òàçåðà', config_keys.tazerkey, tLastKeys, 100) then
                                rkeys.changeHotKey(tazerbind, config_keys.tazerkey.v)
                                ftext('Êëàâèøà óñïåøíî èçìåíåíà. Ñòàðîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Íîâîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(config_keys.tazerkey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end
                            imgui.SameLine()
                            imgui.Text(u8'Êëàâèøà áûñòðîãî òàçåðà')
                        end
                        if cfg.main.group == 'ÏÄ/ÔÁÐ' then
                            if imadd.HotKey('##oopda', config_keys.oopda, tLastKeys, 100) then
                                rkeys.changeHotKey(oopdabind, config_keys.oopda.v)
                                ftext('Êëàâèøà óñïåøíî èçìåíåíà. Ñòàðîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Íîâîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(config_keys.oopda.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end
                            imgui.SameLine()
                            imgui.Text(u8('Êëàâèøà ïîäòâåðæäåíèÿ'))
                            if imadd.HotKey('##oopnet', config_keys.oopnet, tLastKeys, 100) then
                                rkeys.changeHotKey(oopnetbind, config_keys.oopnet.v)
                                ftext('Êëàâèøà óñïåøíî èçìåíåíà. Ñòàðîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Íîâîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end
                            imgui.SameLine()
                            imgui.Text(u8('Êëàâèøà îòìåíû'))
                            if imadd.HotKey('##megaf', config_keys.megafkey, tLastKeys, 100) then
                                rkeys.changeHotKey(megafbind, config_keys.megafkey.v)
                                ftext('Êëàâèøà óñïåøíî èçìåíåíà. Ñòàðîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Íîâîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(config_keys.megafkey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end
                            imgui.SameLine()
                            imgui.Text(u8('Êëàâèøà ìåãàôîíà'))
                            if imadd.HotKey('##dkld', config_keys.dkldkey, tLastKeys, 100) then
                                rkeys.changeHotKey(dkldbind, config_keys.dkldkey.v)
                                ftext('Êëàâèøà óñïåøíî èçìåíåíà. Ñòàðîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Íîâîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(config_keys.dkldkey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end
                            imgui.SameLine()
                            imgui.Text(u8('Êëàâèøà äîêëàäà'))
                            if imadd.HotKey('##cuff', config_keys.cuffkey, tLastKeys, 100) then
                                rkeys.changeHotKey(cuffbind, config_keys.cuffkey.v)
                                ftext('Êëàâèøà óñïåøíî èçìåíåíà. Ñòàðîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Íîâîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(config_keys.cuffkey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end
                            imgui.SameLine()
                            imgui.Text(u8('Íàäåòü íàðó÷íèêè íà ïðåñòóïíèêà'))
                            if imadd.HotKey('##uncuff', config_keys.uncuffkey, tLastKeys, 100) then
                                rkeys.changeHotKey(uncuffbind, config_keys.uncuffkey.v)
                                ftext('Êëàâèøà óñïåøíî èçìåíåíà. Ñòàðîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Íîâîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(config_keys.uncuffkey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end
                            imgui.SameLine()
                            imgui.Text(u8('Ñíÿòü íàðó÷íèêè'))
                            if imadd.HotKey('##follow', config_keys.followkey, tLastKeys, 100) then
                                rkeys.changeHotKey(followbind, config_keys.followkey.v)
                                ftext('Êëàâèøà óñïåøíî èçìåíåíà. Ñòàðîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Íîâîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(config_keys.followkey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end
                            imgui.SameLine()
                            imgui.Text(u8('Âåñòè ïðåñòóïíèêà çà ñîáîé'))
                            if imadd.HotKey('##cput', config_keys.cputkey, tLastKeys, 100) then
                                rkeys.changeHotKey(cputbind, config_keys.cputkey.v)
                                ftext('Êëàâèøà óñïåøíî èçìåíåíà. Ñòàðîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Íîâîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(config_keys.cputkey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end
                            imgui.SameLine()
                            imgui.Text(u8('Ïîñàäèòü ïðåñòóïíèêà â àâòî'))
                            if imadd.HotKey('##ceject', config_keys.cejectkey, tLastKeys, 100) then
                                rkeys.changeHotKey(cejectbind, config_keys.cejectkey.v)
                                ftext('Êëàâèøà óñïåøíî èçìåíåíà. Ñòàðîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Íîâîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(config_keys.cejectkey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end
                            imgui.SameLine()
                            imgui.Text(u8('Âûñàäèòü ïðåñòóïíèêà â ó÷àñòîê'))
                            if imadd.HotKey('##take', config_keys.takekey, tLastKeys, 100) then
                                rkeys.changeHotKey(takebind, config_keys.takekey.v)
                                ftext('Êëàâèøà óñïåøíî èçìåíåíà. Ñòàðîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Íîâîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(config_keys.takekey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end
                            imgui.SameLine()
                            imgui.Text(u8('Îáûñêàòü ïðåñòóïíèêà'))
                            if imadd.HotKey('##arrest', config_keys.arrestkey, tLastKeys, 100) then
                                rkeys.changeHotKey(arrestbind, config_keys.arrestkey.v)
                                ftext('Êëàâèøà óñïåøíî èçìåíåíà. Ñòàðîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Íîâîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(config_keys.arrestkey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end
                            imgui.SameLine()
                            imgui.Text(u8('Àðåñòîâàòü ïðåñòóïíèêà'))
                            if imadd.HotKey('##deject', config_keys.dejectkey, tLastKeys, 100) then
                                rkeys.changeHotKey(dejectbind, config_keys.dejectkey.v)
                                ftext('Êëàâèøà óñïåøíî èçìåíåíà. Ñòàðîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Íîâîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(config_keys.dejectkey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end
                            imgui.SameLine()
                            imgui.Text(u8('Âûòàùèòü ïðåñòóïíèêà èç àâòî'))
                            if imadd.HotKey('##siren', config_keys.sirenkey, tLastKeys, 100) then
                                rkeys.changeHotKey(sirenbind, config_keys.sirenkey.v)
                                ftext('Êëàâèøà óñïåøíî èçìåíåíà. Ñòàðîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Íîâîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(config_keys.sirenkey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end
                            imgui.SameLine()
                            imgui.Text(u8('Âêëþ÷èòü / âûêëþ÷èòü ñèðåíó íà àâòî'))
                        end
                        if cfg.main.group == 'Ìýðèÿ' then
                            if imadd.HotKey('##hik', config_keys.hikey, tLastKeys, 100) then 
                                rkeys.changeHotKey(hibind, config_keys.hikey.v) 
                                ftext('Êëàâèøà óñïåøíî èçìåíåíà. Ñòàðîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Íîâîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(config_keys.hikey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end imgui.SameLine() imgui.Text(u8 'Ïðèâåòñòâèå')
                            if imadd.HotKey('##sumk', config_keys.summakey, tLastKeys, 100) then 
                                rkeys.changeHotKey(summabind, config_keys.summakey.v) 
                                ftext('Êëàâèøà óñïåøíî èçìåíåíà. Ñòàðîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Íîâîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(config_keys.summakey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end imgui.SameLine() imgui.Text(u8 'Îãëàñèòü ñóììó')
                            if imadd.HotKey('##freenk', config_keys.freenalkey, tLastKeys, 100) then 
                                rkeys.changeHotKey(freenalbind, config_keys.freenalkey.v) 
                                ftext('Êëàâèøà óñïåøíî èçìåíåíà. Ñòàðîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Íîâîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(config_keys.freenalkey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end imgui.SameLine() imgui.Text(u8 'Âûïóñòèòü íàëè÷íûìè')
                            if imadd.HotKey('##freebk', config_keys.freebankkey, tLastKeys, 100) then 
                                rkeys.changeHotKey(freebankbind, config_keys.freebankkey.v) 
                                ftext('Êëàâèøà óñïåøíî èçìåíåíà. Ñòàðîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | Íîâîå çíà÷åíèå: '.. table.concat(rkeys.getKeysName(config_keys.freebankkey.v), " + "))
                                saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                            end imgui.SameLine() imgui.Text(u8 'Âûïóñòèòü ÷åðåç áàíê')
                        end
                    elseif show == 4 then
                        if imadd.ToggleButton(u8 'Àâòîáï', autobpb) then cfg.main.autobp = autobpb.v end saveData(cfg, 'moonloader/config/fbitools/config.json'); imgui.SameLine(); imgui.Text(u8 'Àâòîìàòè÷åñêè áðàòü áîåïðèïàñû')
                        if imgui.Checkbox(u8 "Desert Eagle", deagleb) then cfg.autobp.deagle = deagleb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end
                        if deagleb.v then
                            imgui.SameLine(110)
                            if imgui.Checkbox(u8 'Äâà êîìïåêòà##1', dvadeagleb) then cfg.autobp.dvadeagle = dvadeagleb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end
                        end
                        if imgui.Checkbox(u8 "Shotgun", shotb) then cfg.autobp.shot = shotb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end
                        if shotb.v then
                            imgui.SameLine(110)
                            if imgui.Checkbox(u8 'Äâà êîìïåêòà##2', dvashotb) then cfg.autobp.dvashot = dvashotb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end
                        end
                        if imgui.Checkbox(u8 "SMG", smgb) then cfg.autobp.smg = smgb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end
                        if smgb.v then
                            imgui.SameLine(110)
                            if imgui.Checkbox(u8 'Äâà êîìïåêòà##3', dvasmgb) then cfg.autobp.dvasmg = dvasmgb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end
                        end
                        if imgui.Checkbox(u8 "M4A1", m4b) then cfg.autobp.m4 = m4b.v saveData(cfg, 'moonloader/config/fbitools/config.json') end
                        if m4b.v then
                            imgui.SameLine(110)
                            if imgui.Checkbox(u8 'Äâà êîìïåêòà##4', dvam4b) then cfg.autobp.dvam4 = dvam4b.v saveData(cfg, 'moonloader/config/fbitools/config.json') end
                        end
                        if imgui.Checkbox(u8 "Rifle", rifleb) then cfg.autobp.rifle = rifleb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end
                        if rifleb.v then
                            imgui.SameLine(110)
                            if imgui.Checkbox(u8 'Äâà êîìïåêòà##5', dvarifleb) then cfg.autobp.dvarifle = dvarifleb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end
                        end
                        if imgui.Checkbox(u8 "Áðîíÿ", armourb) then cfg.autobp.armour = armourb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end 
                        if imgui.Checkbox(u8 "Ñïåö. îðóæèå", specb)then cfg.autobp.spec = specb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end
                    end
                    imgui.EndChild()
                else
                    imgui.SetCursorPosX( imgui.GetWindowWidth()/2 - imgui.CalcTextSize(u8 "Âûáåðèòå âàøó ãðóïïó ôðàêöèé").x/2 - 50 )
                    imgui.SetCursorPosY( imgui.GetWindowHeight()/2 )
                    imgui.PushItemWidth(100)
                    imgui.Combo(u8 'Âûáåðèòå âàøó ãðóïïó ôðàêöèé', groupInt, groupNames)
                    imgui.SetCursorPosX( imgui.GetWindowWidth()/2 - 50 )
                    if imgui.Button(u8 'Ïîäòâåðäèòü') then
                        ftext(("Âû âûáðàëè ãðóïïó: {9966CC}%s"):format(u8:decode(groupNames[groupInt.v + 1])))
                        cfg.main.group = u8:decode(groupNames[groupInt.v + 1])
                        saveData(cfg, 'moonloader/config/fbitools/config.json')
                        registerCommands()
                    end
                end
                imgui.End()
            end
        end
        if shpwindow.v then
            imgui.ShowCursor = true
            local iScreenWidth, iScreenHeight = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(iScreenWidth/2, iScreenHeight / 2), imgui.Cond.FirstUseEver)
            imgui.Begin(u8(script.this.name..' | Øïîðà'), shpwindow)
            for line in io.lines('moonloader\\fbitools\\shp.txt') do
                imgui.TextWrapped(u8(line))
            end
            imgui.End()
        end
        if akwindow.v then
            imgui.ShowCursor = true
            local iScreenWidth, iScreenHeight = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(iScreenWidth/2, iScreenHeight / 2), imgui.Cond.FirstUseEver)
            imgui.Begin(u8(script.this.name..' | Àäìèíèñòðàòèâíûé êîäåêñ'), akwindow)
            for line in io.lines('moonloader\\fbitools\\ak.txt') do
                imgui.TextWrapped(u8(line))
            end
            imgui.End()
        end
        if fpwindow.v then
            imgui.ShowCursor = true
            local iScreenWidth, iScreenHeight = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(iScreenWidth/2, iScreenHeight / 2), imgui.Cond.FirstUseEver)
            imgui.Begin(u8(script.this.name..' | Ôåäåðàëüíîå ïîñòàíîâëåíèå'), fpwindow)
            for line in io.lines('moonloader\\fbitools\\fp.txt') do
                imgui.TextWrapped(u8(line))
            end
            imgui.End()
        end
        if ykwindow.v then
            imgui.ShowCursor = true
            local iScreenWidth, iScreenHeight = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(iScreenWidth/2, iScreenHeight / 2), imgui.Cond.FirstUseEver)
            imgui.Begin(u8(script.this.name..' | Óãîëîâíûé êîäåêñ'), ykwindow)
            for line in io.lines('moonloader\\fbitools\\yk.txt') do
                imgui.TextWrapped(u8(line))
            end
            imgui.End()
        end
        if memw.v then
            imgui.ShowCursor = true
            local sw, sh = getScreenResolution()
            --imgui.SetWindowPos('##' .. thisScript().name, imgui.ImVec2(sw/2 - imgui.GetWindowSize().x/2, sh/2 - imgui.GetWindowSize().y/2))
            --imgui.SetWindowSize('##' .. thisScript().name, imgui.ImVec2(670, 500))
            imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(670, 330), imgui.Cond.FirstUseEver)
            imgui.Begin(u8(script.this.name..' | Ñïèñîê ñîòðóäíèêîâ [Âñåãî: %s]'):format(#tMembers), memw, imgui.WindowFlags.NoResize)
            imgui.BeginChild('##1', imgui.ImVec2(670, 300))
            imgui.Columns(5, _)
            imgui.SetColumnWidth(-1, 180) imgui.Text(u8 'Íèê èãðîêà'); imgui.NextColumn()
            imgui.SetColumnWidth(-1, 190) imgui.Text(u8 'Äîëæíîñòü');  imgui.NextColumn()
            imgui.SetColumnWidth(-1, 80) imgui.Text(u8 'Ñòàòóñ') imgui.NextColumn()
            imgui.SetColumnWidth(-1, 120) imgui.Text(u8 'Äàòà ïðèåìà') imgui.NextColumn() 
            imgui.SetColumnWidth(-1, 70) imgui.Text(u8 'AFK') imgui.NextColumn() 
            imgui.Separator()
            for _, v in ipairs(tMembers) do
                imgui.TextColored(imgui.ImVec4(getColor(v.id)), u8('%s [%s]'):format(v.nickname, v.id))
                if imgui.IsItemHovered() then
                    imgui.BeginTooltip();
                    imgui.PushTextWrapPos(450.0);
                    imgui.TextColored(imgui.ImVec4(getColor(v.id)), u8("%s\nÓðîâåíü: %s"):format(v.nickname, sampGetPlayerScore(v.id)))
                    imgui.PopTextWrapPos();
                    imgui.EndTooltip();
                end
                imgui.NextColumn()
                imgui.Text(('%s [%s]'):format(v.sRang, v.iRang))
                imgui.NextColumn()
                if v.status ~= u8("Íà ðàáîòå") then
                    imgui.TextColored(imgui.ImVec4(0.80, 0.00, 0.00, 1.00), v.status);
                else
                    imgui.TextColored(imgui.ImVec4(0.00, 0.80, 0.00, 1.00), v.status);
                end
                imgui.NextColumn()
                imgui.Text(v.invite)
                imgui.NextColumn()
                if v.sec ~= 0 then
                    if v.sec < 360 then 
                        imgui.TextColored(getColorForSeconds(v.sec), tostring(v.sec .. u8(' ñåê.')));
                    else
                        imgui.TextColored(getColorForSeconds(v.sec), tostring("360+" .. u8(' ñåê.')));
                    end
                else
                    imgui.TextColored(imgui.ImVec4(0.00, 0.80, 0.00, 1.00), u8("Íåò"));
                end
                imgui.NextColumn()
            end
            imgui.Columns(1)
            imgui.EndChild()
            imgui.End()
        end
    end
end

if lsampev then
    function sp.onPlayerQuit(id, reason)
        if gmegafhandle ~= -1 and id == gmegafid then
            sampAddChatMessage(' {ffffff}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~', 0x9966cc)
            sampAddChatMessage('', 0x9966cc)
            sampAddChatMessage(' {ffffff}Èãðîê: {9966cc}'..sampGetPlayerNickname(gmegafid)..'['..gmegafid..'] {ffffff}âûøåë èç èãðû', 0x9966cc)
            sampAddChatMessage(' {ffffff}Óðîâåíü: {9966cc}'..gmegaflvl, 0x9966cc)
            sampAddChatMessage(' {ffffff}Ôðàêöèÿ: {9966cc}'..gmegaffrak, 0x9966cc)
            sampAddChatMessage(' {ffffff}Ïðè÷èíà âûõîäà: {9966cc}'..quitReason[reason], 0x9966CC)
            sampAddChatMessage('', 0x9966cc)
            sampAddChatMessage(' {ffffff}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~', 0x9966cc)
            gmegafid = -1
            gmegaflvl = nil
            gmegaffrak = nil
            gmegafhandle = nil
        end
    end

    function sp.onSendSpawn()
        if cfg.main.clistb and rabden then
            lua_thread.create(function()
                wait(1400)
                ftext('Öâåò íèêà ñìåíåí íà: {9966cc}' .. cfg.main.clist)
                sampSendChat('/clist '..cfg.main.clist)
            end)
        end
    end

    function sp.onServerMessage(color, text)
        if text:find("Ó äàííîãî èãðîêà óæå åñòü") and ins.isLicense then
            ins.isLicense = false
            ins.list = nil
        end
        if text:match(" ^Âû íà÷àëè ïðåñëåäîâàíèå çà ïðåñòóïíèêîì %S!$") then
            local nick = text:match(" ^Âû íà÷àëè ïðåñëåäîâàíèå çà ïðåñòóïíèêîì (%S)!$")
            local id = sampGetPlayerIdByNickname(nick)
            gmegafid = id
            gmegaflvl = sampGetPlayerScore(id)
            gmegaffrak = sampGetFraktionBySkin(id)
        end
        if nazhaloop then
            if text:match('Ïîñûëàòü ñîîáùåíèå â /d ìîæíî ðàç â 10 ñåêóíä!') then
                zaproop = true
                ftext('Íå óäàëîñü ïîäàòü â ÎÎÏ èãðîêà {9966cc}'..nikk..'{ffffff}. Ïîâòîðèòü ïîïûòêó?')
                ftext('Ïîäòâåðäèòü: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | Îòìåíèòü: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "))
            end
            if nikk == nil then
                dmoop = false
                nikk = nil
                zaproop = false
                aroop = false
                nazhaloop = false
            end
            if color == -8224086 and text:find(nikk) then
                dmoop = false
                nikk = nil
                zaproop = false
                aroop = false
                nazhaloop = false
            end
        end
        if (text:match('äåëî íà èìÿ .+ ðàññìîòðåíèþ íå ïîäëåæèò, ÎÎÏ') or text:match('äåëî .+ ðàññìîòðåíèþ íå ïîäëåæèò %- ÎÎÏ.')) and color == -8224086 then
            local ooptext = text:match('Mayor, (.+)')
            table.insert(ooplistt, ooptext)
        end
        if text:find('{00AB06}×òîáû çàâåñòè äâèãàòåëü, íàæìèòå êëàâèøó {FFFFFF}"2"{00AB06} èëè ââåäèòå êîìàíäó {FFFFFF}"/en"') then
            if cfg.main.autocar then
                lua_thread.create(function()
                    while not isCharInAnyCar(PLAYER_PED) do wait(0) end
                    if not isCarEngineOn(storeCarCharIsInNoSave(PLAYER_PED)) then
                        while sampIsChatInputActive() or sampIsDialogActive() or isSampfuncsConsoleActive() do wait(0) end
                        setVirtualKeyDown(key.VK_2, true)
                        wait(150)
                        setVirtualKeyDown(key.VK_2, false)
                    end
                end)
            end
        end
        if color == -8224086 then
            local colors = ("{%06X}"):format(bit.rshift(color, 8))
            table.insert(departament, os.date(colors.."[%H:%M:%S] ") .. text)
        end
        if color == -1920073984 and (text:match('.+ .+%: .+') or text:match('%(%( .+ .+%: .+ %)%)')) then
            local colors = ("{%06X}"):format(bit.rshift(color, 8))
            table.insert(radio, os.date(colors.."[%H:%M:%S] ") .. text)
        end
        if color == -3669760 and text:match('%[Wanted %d+: .+%] %[Ñîîáùàåò%: .+%] %[.+%]') then
            local colors = ("{%06X}"):format(bit.rshift(color, 8))
            table.insert(wanted, os.date(colors.."[%H:%M:%S] ") .. text)
        end
        if color == -65366 and (text:match('SMS%: .+. Îòïðàâèòåëü%: .+') or text:match('SMS%: .+. Ïîëó÷àòåëü%: .+')) then
            if text:match('SMS%: .+. Îòïðàâèòåëü%: .+%[%d+%]') then smsid = text:match('SMS%: .+. Îòïðàâèòåëü%: .+%[(%d+)%]') elseif text:match('SMS%: .+. Ïîëó÷àòåëü%: .+%[%d+%]') then smstoid = text:match('SMS%: .+. Ïîëó÷àòåëü%: .+%[(%d+)%]') end
            local colors = ("{%06X}"):format(bit.rshift(color, 8))
            table.insert(sms, os.date(colors.."[%H:%M:%S] ") .. text)
        end
        if mcheckb then
            if text:find('---======== ÌÎÁÈËÜÍÛÉ ÊÎÌÏÜÞÒÅÐ ÄÀÍÍÛÕ ========---') then
                local open = io.open("moonloader/fbitools/mcheck.txt", 'a')
                open:write(string.format('%s\n', text))
                open:close()
            end
            if text:find('Èìÿ:') then
                local open = io.open("moonloader/fbitools/mcheck.txt", 'a')
                open:write(string.format('%s\n', text))
                open:close()
            end
            if text:find('Îðãàíèçàöèÿ:') then
                local open = io.open("moonloader/fbitools/mcheck.txt", 'a')
                open:write(string.format('%s\n', text))
                open:close()
            end
            if text:find('Ïðåñòóïëåíèå:') then
                local open = io.open("moonloader/fbitools/mcheck.txt", 'a')
                open:write(string.format('%s\n', text))
                open:close()
            end
            if text:find('Ñîîáùèë:') then
                local open = io.open("moonloader/fbitools/mcheck.txt", 'a')
                open:write(string.format('%s\n', text))
                open:close()
            end
            if text:find('Óðîâåíü ðîçûñêà:') then
                local open = io.open("moonloader/fbitools/mcheck.txt", 'a')
                open:write(string.format('%s\n', text))
                open:close()
            end
            if text:find('---============================================---') then
                local open = io.open("moonloader/fbitools/mcheck.txt", 'a')
                open:write(string.format('%s\n', text))
                open:write(' \n')
                open:close()
            end
        end
        if text:find('Âû ïîñàäèëè â òþðüìó') then
            local nik, sek = text:match('Âû ïîñàäèëè â òþðüìó (%S+) íà (%d+) ñåêóíä')
            if sek == '3600' or sek == '3000'  then
                lua_thread.create(function()
                    nikk = nik:gsub('_', ' ')
                    aroop = true
                    wait(3000)
                    ftext(string.format("Çàïðåòèòü ðàññìîòð äåëà íà èìÿ {9966cc}%s", nikk), -1)
                    ftext('Ïîäòâåðäèòü: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | Îòìåíèòü: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
                end)
            end
        end
        if text:find('Âû ïîñàäèëè ïðåñòóïíèêà íà') then
            local sekk = text:match('Âû ïîñàäèëè ïðåñòóïíèêà íà (.+) ñåêóíä!')
            if sekk == '3000' or sekk == '3600' then
                lua_thread.create(function()
                    nikk = sampGetPlayerNickname(tdmg)
                    dmoop = true
                    wait(50)
                    ftext(string.format("Çàïðåòèòü ðàññìîòð äåëà íà èìÿ {9966cc}%s", nikk:gsub('_', ' ')), -1)
                    ftext('Ïîäòâåðäèòü: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | Îòìåíèòü: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
                end)
            end
        end
        if status then
            if text:find("ID: %d+ | .+ | %g+: .+%[%d+%] %- %{......%}.+%{......%}") then
                if not text:find("AFK") then
                    local id, invDate, nickname, sRang, iRang, status = text:match("ID: (%d+) | (.+) | (%g+): (.+)%[(%d+)%] %- %{.+%}(.+)%{.+%}")
                    table.insert(tMembers, Player:new(id, sRang, iRang, status, invDate, false, 0, nickname))
                else
                    local id, invDate, nickname, sRang, iRang, status, sec = text:match("ID: (%d+) | (.+) | (%g+): (.+)%[(%d+)%] %- %{.+%}(.+)%{.+%} | %{.+%}%[AFK%]: (%d+).+")
                    table.insert(tMembers, Player:new(id, sRang, iRang, status, invDate, true, sec, nickname))
                end
                return false
            end
            if text:find("ID: %d+ | .+ | %g+: .+%[%d+%]") then
                if not text:find("AFK") then
                    local id, invDate, nickname, sRang, iRang = text:match("ID: (%d+) | (.+) | (%g+): (.+)%[(%d+)%]")
                    table.insert(tMembers, Player:new(id, sRang, iRang, "Íåäîñòóïíî", invDate, false, 0, nickname))
                else
                    local id, invDate, nickname, sRang, iRang, sec = text:match("ID: (%d+) | (.+) | (%g+): (.+)%[(%d+)%] | %{.+%}%[AFK%]: (%d+).+")
                    table.insert(tMembers, Player:new(id, sRang, iRang, "Íåäîñòóïíî", invDate, true, sec, nickname))
                end
                return false
            end
            if text:match('Âñåãî: %d+ ÷åëîâåê') then
                gotovo = true
                return false
            end
            if color == -1 then
                return false
            end
            if color == 647175338 then
                return false
            end
        end
        if fnrstatus then
            if text:match("^ ID: %d+") then 
                if text:find("Âûõîäíîé") then
                    table.insert(vixodid, tonumber(text:match("ID: (%d+)")))
                end
                return false
            end
            if text:match('Âñåãî: %d+ ÷åëîâåê') then
                gotovo = true
                return false
            end
            if color == -1 then
                return false
            end
            if color == 647175338 then
                return false
            end
        end
        if warnst then
            if text:find('Îðãàíèçàöèÿ:') then
                local wcfrac = text:match('Îðãàíèçàöèÿ: (.+)')
                wfrac = wcfrac
                if wcfrac == 'Àðìèÿ ÑÔ' or wcfrac == 'Àðìèÿ ËÂ' or wcfrac == 'ÔÁÐ' then
                    wfrac = longtoshort(wcfrac)
                end
            end
        end
        if text:find('Ðàáî÷èé äåíü íà÷àò') and color ~= -1 then
            if cfg.main.clistb then
                lua_thread.create(function()
                    wait(100)
                    ftext('Öâåò íèêà ñìåíåí íà: {9966cc}'..cfg.main.clist)
                    sampSendChat('/clist '..tonumber(cfg.main.clist))
                    rabden = true
                end)
            end
        end
        if text:find('Ðàáî÷èé äåíü îêîí÷åí') and color ~= -1 then
            rabden = false
        end
        if text:find('Âû ïîìåíÿëè ïóëè íà ðåçèíîâûå') then
            stazer = true
        end
        if text:find('Âû ïîìåíÿëè ïóëè íà îáû÷íûå') then
            stazer = false
        end
        if cfg.main.nclear then
            if text:find('óäàëèë èç ðîçûñêèâàåìûõ') then
                local chist, jertva = text:match('%[Clear%] (.+) óäàëèë èç ðîçûñêèâàåìûõ (.+)')
                printStringNow(chist..' cleared '..jertva..' from BD', 3000)
            end
        end
        if text:find('Wanted') and text:find('Ñîîáùàåò') then
            local id, prestp, police, prichin = text:match('%[Wanted (%d+): (.+)%] %[Ñîîáùàåò: (.+)%] %[(.+)%]')
            if not cfg.main.offwntd then
                if cfg.main.nwanted then
                    return {0x9966CCFF, ' [{ffffff}Wanted '..id..': '..prestp..'{9966cc}] [{ffffff}Ñîîáùàåò: '..police..'{9966cc}] [{ffffff}'..prichin..'{9966cc}]'}
                end
            else
                local mynick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
                if police ~= mynick then
                    return false
                else
                    if cfg.main.nwanted then
                        return {0x9966CCFF, ' [{ffffff}Wanted '..id..': '..prestp..'{9966cc}] [{ffffff}Ñîîáùàåò: '..police..'{9966cc}] [{ffffff}'..prichin..'{9966cc}]'}
                    end
                end
            end
        end
        if text:find('íà÷àë ïðåñëåäîâàíèå çà ïðåñòóïíèêîì') then
            local polic, prest, yrvn = text:match('Ïîëèöåéñêèé (.+) íà÷àë ïðåñëåäîâàíèå çà ïðåñòóïíèêîì (.+) %(Óðîâåíü ðîçûñêà: (.+)%)')
            if not cfg.main.offptrl then
                if cfg.main.nwanted then
                    return {0xFFFFFFFF, ' Ïîëèöåéñêèé {9966cc}'..polic..' {ffffff}íà÷àë ïðåñëåäîâàíèå çà {9966cc}'..prest..' {ffffff}(Óðîâåíü ðîçûñêà: {9966cc}'..yrvn..'{ffffff})'}
                end
            else
                local mynick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
                if polic ~= mynick then
                    return false
                else
                    if cfg.main.nwanted then
                        return {0xFFFFFFFF, ' Ïîëèöåéñêèé {9966cc}'..polic..' {ffffff}íà÷àë ïðåñëåäîâàíèå çà {9966cc}'..prest..' {ffffff}(Óðîâåíü ðîçûñêà: {9966cc}'..yrvn..'{ffffff})'}
                    end
                end
            end
        end
        if cfg.main.nwanted then
            if text:find('óäàëèë èç ðîçûñêèâàåìûõ') then
                local chist, jertva = text:match('%[Clear%] (.+) óäàëèë èç ðîçûñêèâàåìûõ (.+)')
                return {0x9966CCFF, ' [{ffffff}Clear{9966cc}] '..chist..'{ffffff} óäàëèë èç ðîçûñêèâàåìûõ {9966cc}'..jertva}
            end
            if text:find('<<') and text:find('Îôèöåð') and text:find('àðåñòîâàë') and text:find('>>') then
                local arr, arre = text:match('<< Îôèöåð (.+) àðåñòîâàë (.+) >>')
                return {0xFFFFFFFF, ' « Îôèöåð {9966CC}'..arr..' {ffffff}àðåñòîâàë {9966cc}'..arre..' {ffffff}»'}
            end
            if text:find('<<') and text:find('Àãåíò FBI') and text:find('àðåñòîâàë') and text:find('>>') then
                local arrr, arrre = text:match('<< Àãåíò FBI (.+) àðåñòîâàë (.+) >>')
                return {0xFFFFFFFF, ' « Àãåíò FBI {9966CC}'..arrr..' {ffffff}àðåñòîâàë {9966cc}'..arrre..' {ffffff}»'}
            end
            if text:find('Âû ïîñàäèëè ïðåñòóïíèêà íà') then
                local sekund = text:match('Âû ïîñàäèëè ïðåñòóïíèêà íà (%d+) ñåêóíä!')
                return {0xFFFFFFFF, ' Âû ïîñàäèëè ïðåñòóïíèêà íà {9966cc}'..sekund..' {ffffff}ñåêóíä!'}
            end
        end
    end

    function sp.onShowDialog(id, style, title, button1, button2, text)
        if id == 7777 and ins.isLicense then
            sampSendDialogResponse(id, 1, ins.list, _)
            ins.isLicense = false
            ins.list = nil
            return false
        end
        if id == 50 and msda then
            sampSendDialogResponse(id, 1, getMaskList(msvidat), _)
            msid = nil
            msda = false
            msvidat = nil
            return false
        end
        if id == 1 and cfg.main.parolb and #tostring(cfg.main.parol) >= 6 then
            sampSendDialogResponse(id, 1, _, tostring(cfg.main.parol))
            return false
        end
        if id == 16 and cfg.main.googlecodeb and #tostring(cfg.main.googlecode) == 16 then
            if lsha1 and lbasexx then
                sampSendDialogResponse(id, 1, _, genCode(tostring(cfg.main.googlecode)))
                return false
            end
        end
        if id == 0 and checkstat then
            frak = text:match('.+Îðãàíèçàöèÿ%:%s+(.+)%s+Ðàíã')
            rang = text:match('.+Ðàíã%:%s+(.+)%s+Ðàáîòà')
            print(frak)
            print(rang)
            checkstat = false
            sampSendDialogResponse(id, 1, _, _)
            return false
        end
        if cfg.main.autobp == true and id == 5225 then
            --[[lua_thread.create(function()
                wait(250)
                if autoBP == 6 and repeatgun then
                    autoBP = 0
                    sampCloseCurrentDialogWithButton(0)
                    repeatgun = false
                    return
                elseif autoBP == 6 and not repeatgun then
                    autoBP = 0
                    repeatgun = true
                    return
                end
                sampSendDialogResponse(5225, 1, autoBP, "")
                autoBP = autoBP + 1
                if autoBP == 2 then autoBP = 3 end
                return
            end)]]
            local guns = getCompl()
            lua_thread.create(function()
                wait(250)
                if autoBP == #guns + 1 then
                    autoBP = 1
                    sampCloseCurrentDialogWithButton(0)
                    return
                end
                sampSendDialogResponse(5225, 1, guns[autoBP], "")
                autoBP = autoBP + 1
                return
            end)
        end
    end

    function sp.onSendGiveDamage(playerId, damage, weapon, bodypart)
        tdmg = playerId
    end
end
if lrkeys then
    function rkeys.onHotKey(id, keys)
        if sampIsChatInputActive() or sampIsDialogActive() or isSampfuncsConsoleActive() then
            return false
        end
    end
end

if lsphere then
function Sphere.onEnterSphere(id)
        post = id
    end

    function Sphere.onExitSphere(id)
        post = nil
    end
end

function registerCommands()
    if sampIsChatCommandDefined('yk') then sampUnregisterChatCommand('yk') end
    if sampIsChatCommandDefined('fp') then sampUnregisterChatCommand('fp') end
    if sampIsChatCommandDefined('ak') then sampUnregisterChatCommand('ak') end
    if sampIsChatCommandDefined('shp') then sampUnregisterChatCommand('shp') end
    if sampIsChatCommandDefined('ft') then sampUnregisterChatCommand('ft') end
    if sampIsChatCommandDefined('fnr') then sampUnregisterChatCommand('fnr') end
    if sampIsChatCommandDefined('fkv') then sampUnregisterChatCommand('fkv') end
    if sampIsChatCommandDefined('ooplist') then sampUnregisterChatCommand('ooplist') end
    if sampIsChatCommandDefined('ticket') then sampUnregisterChatCommand('ticket') end
    if sampIsChatCommandDefined('dlog') then sampUnregisterChatCommand('dlog') end
    if sampIsChatCommandDefined('rlog') then sampUnregisterChatCommand('rlog') end
    if sampIsChatCommandDefined('sulog') then sampUnregisterChatCommand('sulog') end
    if sampIsChatCommandDefined('smslog') then sampUnregisterChatCommand('smslog') end
    if sampIsChatCommandDefined('ftazer') then sampUnregisterChatCommand('ftazer') end
    if sampIsChatCommandDefined('kmdc') then sampUnregisterChatCommand('kmdc') end
    if sampIsChatCommandDefined('su') then sampUnregisterChatCommand('ssu') end
    if sampIsChatCommandDefined('megaf') then sampUnregisterChatCommand('megaf') end
    if sampIsChatCommandDefined('tazer') then sampUnregisterChatCommand('tazer') end
    if sampIsChatCommandDefined('keys') then sampUnregisterChatCommand('keys') end
    if sampIsChatCommandDefined('oop') then sampUnregisterChatCommand('oop') end
    if sampIsChatCommandDefined('cput') then sampUnregisterChatCommand('cput') end
    if sampIsChatCommandDefined('ceject') then sampUnregisterChatCommand('ceject') end
    if sampIsChatCommandDefined('st') then sampUnregisterChatCommand('st') end
    if sampIsChatCommandDefined('deject') then sampUnregisterChatCommand('deject') end
    if sampIsChatCommandDefined('rh') then sampUnregisterChatCommand('rh') end
    if sampIsChatCommandDefined('ak') then sampUnregisterChatCommand('ak') end
    if sampIsChatCommandDefined('gr') then sampUnregisterChatCommand('gr') end
    if sampIsChatCommandDefined('warn') then sampUnregisterChatCommand('warn') end
    if sampIsChatCommandDefined('ms') then sampUnregisterChatCommand('ms') end
    if sampIsChatCommandDefined('ar') then sampUnregisterChatCommand('ar') end
    if sampIsChatCommandDefined('r') then sampUnregisterChatCommand('r') end
    if sampIsChatCommandDefined('f') then sampUnregisterChatCommand('f') end
    if sampIsChatCommandDefined('rt') then sampUnregisterChatCommand('rt') end
    if sampIsChatCommandDefined('fst') then sampUnregisterChatCommand('fst') end
    if sampIsChatCommandDefined('fsw') then sampUnregisterChatCommand('fsw') end
    if sampIsChatCommandDefined('fshp') then sampUnregisterChatCommand('fshp') end
    if sampIsChatCommandDefined('fyk') then sampUnregisterChatCommand('fyk') end
    if sampIsChatCommandDefined('ffp') then sampUnregisterChatCommand('ffp') end
    if sampIsChatCommandDefined('fak') then sampUnregisterChatCommand('fak') end
    if sampIsChatCommandDefined('dmb') then sampUnregisterChatCommand('dmb') end
    if sampIsChatCommandDefined('dkld') then sampUnregisterChatCommand('dkld') end
    if sampIsChatCommandDefined('fvz') then sampUnregisterChatCommand('fvz') end
    if sampIsChatCommandDefined('fbd') then sampUnregisterChatCommand('fbd') end
    if sampIsChatCommandDefined('blg') then sampUnregisterChatCommand('blg') end
    if sampIsChatCommandDefined('cc') then sampUnregisterChatCommand('cc') end
    if sampIsChatCommandDefined('df') then sampUnregisterChatCommand('df') end
    if sampIsChatCommandDefined('mcheck') then sampUnregisterChatCommand('mcheck') end
    if sampIsChatCommandDefined('z') then sampUnregisterChatCommand('z') end
    if sampIsChatCommandDefined('pr') then sampUnregisterChatCommand('pr') end
    if isSampfuncsConsoleCommandDefined('gppc') then sampfuncsUnregisterConsoleCommand('gppc') end
    if cfg.main.group == 'ÏÄ/ÔÁÐ' then
        sampRegisterChatCommand('fkv', fkv)
        sampRegisterChatCommand('ticket', ticket)
        sampRegisterChatCommand('sulog', sulog)
        sampRegisterChatCommand('ftazer', ftazer)
        sampRegisterChatCommand('kmdc', kmdc)
        sampRegisterChatCommand('su', su)
        sampRegisterChatCommand('ssu', ssu)
        sampRegisterChatCommand('megaf', megaf)
        sampRegisterChatCommand('tazer', tazer)
        sampRegisterChatCommand('oop', oop)
        sampRegisterChatCommand('keys', keys)
        sampRegisterChatCommand('cput', cput)
        sampRegisterChatCommand('ceject', ceject)
        sampRegisterChatCommand('st', st)
        sampRegisterChatCommand('deject', deject)
        sampRegisterChatCommand('rh', rh)
        sampRegisterChatCommand('gr', gr)
        sampRegisterChatCommand('warn', warn)
        sampRegisterChatCommand('ms', ms)
        sampRegisterChatCommand('ar', ar)
        sampRegisterChatCommand('fshp', fshp)
        sampRegisterChatCommand('fyk', fyk)
        sampRegisterChatCommand('ffp', ffp)
        sampRegisterChatCommand('fak', fak)
        sampRegisterChatCommand('dkld', dkld)
        sampRegisterChatCommand('fvz', fvz)
        sampRegisterChatCommand('fbd', fbd)
        sampRegisterChatCommand('df', df)
        sampRegisterChatCommand('mcheck', mcheck)
        sampRegisterChatCommand('z', ssuz)
        sampRegisterChatCommand("pr", pr)
    end
    if cfg.main.group == 'ÏÄ/ÔÁÐ' or cfg.main.group == 'Ìýðèÿ' then sampRegisterChatCommand('ooplist', ooplist) end
    sampRegisterChatCommand('fnr', fnr)
    sampRegisterChatCommand('yk', function() ykwindow.v = not ykwindow.v end)
    sampRegisterChatCommand('fp', function() fpwindow.v = not fpwindow.v end)
    sampRegisterChatCommand('ak', function() akwindow.v = not akwindow.v end)
    sampRegisterChatCommand('shp',function() shpwindow.v = not shpwindow.v end)
    sampRegisterChatCommand('ft', function() mainw.v = not mainw.v end)
    sampRegisterChatCommand('dlog', dlog)
    sampRegisterChatCommand('rlog', rlog)
    sampRegisterChatCommand('smslog', smslog)
    sampRegisterChatCommand('r', r)
    sampRegisterChatCommand('f', f)
    sampRegisterChatCommand('rt', rt)
    sampRegisterChatCommand("fst", fst)
    sampRegisterChatCommand("fsw", fsw)
    sampRegisterChatCommand('dmb', dmb)
    sampRegisterChatCommand('blg', blg)
    sampRegisterChatCommand('cc', cc)
    sampfuncsRegisterConsoleCommand('gppc', function()
        local mxx, myy, mzz = getCharCoordinates(PLAYER_PED)
        print(string.format('%s, %s, %s', mxx, myy, mzz))
    end)
end

function registerSphere()
    Sphere.createSphere(-1984.6375732422, 106.85540008545, 27.42943572998, 50.0)-- -1984.6375732422 106.85540008545 27.42943572998 -- ÀÂÑÔ [1]
    Sphere.createSphere(-2055.283203125, -84.472702026367, 35.064281463623, 50.0)-- -2055.283203125 -84.472702026367 35.064281463623 -- ÀØ [2]
    Sphere.createSphere(-1521.4412841797, 503.20678710938, 6.7215604782104, 40.0)-- -1521.4412841797 503.20678710938 6.7215604782104 -- ÑÔà [3]
    Sphere.createSphere(-1702.3824462891, 684.79150390625, 25.01790618896, 30.0)-- -1702.3824462891 684.79150390625 25.017906188965 -- Ïîñò Â ÑÔÏÄ [4]
    Sphere.createSphere(-1574.4406738281, 662.24047851563, 7.3254537582397, 20.0)-- -1574.4406738281 662.24047851563 7.3254537582397 Ïîñò À ÑÔÏÄ [5]
    Sphere.createSphere(-2013.1629638672, 464.77380371094, 35.313331604004, 30.0)-- -2013.1629638672 464.77380371094 35.313331604004 -- ÑÔí [6]
    Sphere.createSphere(-1749.7822265625, -591.34033203125, 16.62273979187, 100.0)-- -1749.7822265625 -591.34033203125 16.62273979187 -- Òîííåëü [7]
    Sphere.createSphere(1481.77734375, -1739.9536132813, 13.546875, 70.0)-- 1481.77734375 -1739.9536132813 13.546875 -- Ìýðèÿ [8]
    Sphere.createSphere(-2448.3591308594, 725.09326171875, 34.756977081299, 70.0)-- -2448.3591308594 725.09326171875 34.756977081299 -- Õîò-Äîãè [9]
    Sphere.createSphere(1186.5642089844, -1322.2257080078,13.098788261414, 50.0)-- 1186.5642089844 -1322.2257080078 13.098788261414 -- Áîëüíèöà ËÑ [10]
    Sphere.createSphere(1195.8181152344, -1741.1024169922, 13.131011962891, 70.0)-- 1195.8181152344 -1741.1024169922 13.131011962891 -- ÀÂ ËÑ [11]
    Sphere.createSphere(1667.1462402344, -768.31890869141, 54.092594146729, 70.0)-- 1667.1462402344 -768.31890869141 54.092594146729 -- Ìîñò ËÑ-ËÂ [12]
    Sphere.createSphere(1766.12109375,   874.89379882813,   10.887091636658, 70.0)-- 1820.5036621094 816.41632080078 10.8203125 -- Ïåðåêðîñòîê LVPD [13]
    Sphere.createSphere(1155.6971435547, 831.9443359375, 10.409364700317, 80.0)-- 1155.6971435547 831.9443359375 10.409364700317 Ðàçâèëêà LVPD [14]
    Sphere.createSphere(2033.3028564453, 1007.163269043, 10.8203125, 50.0)-- 2033.3028564453 1007.163269043 10.8203125 Ïîñòîâîé Â LVPD [4 Äðàêîíà] [15]
    Sphere.createSphere(2824.7353515625, 1292.9085693359, 10.764576911926, 50.0)-- 2824.7353515625 1292.9085693359 10.764576911926 Ïîñòîâîé À LVPD [ÀÂËÂ] [16]
    Sphere.createSphere(2180.99609375, 1676.2248535156, 11.060985565186, 50.0)-- 2180.99609375 1676.2248535156 11.060985565186 Ïîñòîâîé Â LVPD [Êàëëèãóëà] [17]
    Sphere.createSphere(1727.3302001953, 1618.9171142578, 9.8169927597046, 50.0)-- 1727.3302001953 1618.9171142578 9.8169927597046 -- Ïîñò Ñ LVPD [18]
    Sphere.createSphere(1545.6296386719, -1631.2828369141, 13.3828125, 50.0)-- 1545.6296386719 -1631.2828369141 13.3828125 -- ÊÏÏ ËÑÏÄ [19]
    Sphere.createSphere(2753.5388183594, -2432.2268066406, 13.64318561554, 80.0)-- 2753.5388183594 -2432.2268066406 13.64318561554 -- Ïîðò ËÑ[20]
    Sphere.createSphere(2293.4145507813, -1584.8774414063, 3.5703411102295, 670.0)--  2293.4145507813 -1584.8774414063 3.5703411102295 -- Ïàòðóëü ãåòòî [21]
    Sphere.createSphere(186.95843505859, 1901.0294189453, 17.640625, 300.0)-- 186.95843505859 1901.0294189453 17.640625 -- Ïàòðóëü ËÂà [22]
    Sphere.createSphere(-422, -1195, 60, 500.0)-- -422 -1195 60 --Þðèñäèêöèÿ ËÑ - ÑÔ [23]
    Sphere.createSphere(1644, -25, 36, 300.0)-- 1644 -25 36 --Þðèñäèêöèÿ ËÑ - ËÂ [24]
    Sphere.createSphere(413, 625, 18, 300.0)-- 413 625 18 Þðèñäèêöèÿ ËÑ- ËÂ 2 [25]
    Sphere.createSphere(-129, 518, 8, 300.0)-- -129 518 8 Þðèñäèêöèÿ ËÑ - ËÂ 3 [26]
    Sphere.createSphere(-1003, 1285, 40, 300.0)-- -1003 1285 40 Þðèñäèêöèÿ ÑÔ - ËÂ [27]
    Sphere.createSphere(-2126, 2654, 53, 300.0)-- -2126 2654 53 Þðèñäèêöèÿ ÑÔ - ËÂ 2 [28]
    Sphere.createSphere(-1006, -442, 36, 300.0)-- -1006 -442 36 Þðèñäèêöèÿ ËÑ - ÑÔ 2 [29]
    Sphere.createSphere(-1126, -2574, 72, 300.0)-- -1126 -2574 72 Þðèñäèêöèÿ ËÑ - ÑÔ 3 [30]
    Sphere.createSphere(-1248, -2867, 64, 300.0)-- -1248 -2867 64 Þðèñäèêöèÿ ËÑ- ÑÔ 4 [31]
    Sphere.createSphere(2238.6533203125,   2449.4895019531,   11.037217140198, 10.0) -- 2238.6533203125   2449.4895019531   11.037217140198 -- ÊÏÏ ËÂÏÄ [32]
    Sphere.createSphere(2458.4575195313,   1340.5772705078,   10.9765625, 30) -- 2458.4575195313   1340.5772705078   10.9765625 -- LVPD D [33]
    Sphere.createSphere(373.66720581055,   173.75173950195,   1008.3893432617, 30) -- 373.66720581055,   173.75173950195,   1008.3893432617 -- Õîëë ìýðèè [34]
    Sphere.createSphere(361.3515, -1785.0653, 5.4350, 30) -- 361.3515,-1785.0653,5.4350 -- Àâòîÿðìàðêà [35]
end

function registerHotKey()
    --all
    vzaimbind = rkeys.registerHotKey(config_keys.vzaimkey.v, true, vzaimk)
    --pd/fbi
    tazerbind = rkeys.registerHotKey(config_keys.tazerkey.v, true, function() 
        if cfg.main.group == 'ÏÄ/ÔÁÐ' or cfg.main.group == 'Ìýðèÿ' then
            sampSendChat('/tazer')
        end
    end)
    fastmenubind = rkeys.registerHotKey(config_keys.fastmenukey.v, true, function() 
        if cfg.main.group == 'ÏÄ/ÔÁÐ' then
            lua_thread.create(function() 
                submenus_show(fthmenuPD, '{9966cc}'..script.this.name.." {FFFFFF}| Áûñòðîå ìåíþ") 
            end) 
        elseif cfg.main.group == 'Àâòîøêîëà' then
            lua_thread.create(function() 
                submenus_show(fthmenuAS, '{9966cc}'..script.this.name.." {FFFFFF}| Áûñòðîå ìåíþ") 
            end)
        elseif cfg.main.group == "Ìåäèêè" then
            lua_thread.create(function() 
                submenus_show(fthmenuMOH, '{9966cc}'..script.this.name.." {FFFFFF}| Áûñòðîå ìåíþ") 
            end)
        end
    end)
    oopdabind = rkeys.registerHotKey(config_keys.oopda.v, true, oopdakey)
    oopnetbind = rkeys.registerHotKey(config_keys.oopnet.v, true, oopnetkey)
    megafbind = rkeys.registerHotKey(config_keys.megafkey.v, true, megaf)
    dkldbind = rkeys.registerHotKey(config_keys.dkldkey.v, true, dkld)
    cuffbind = rkeys.registerHotKey(config_keys.cuffkey.v, true, cuffk)
    followbind = rkeys.registerHotKey(config_keys.followkey.v, true, followk)
    cputbind = rkeys.registerHotKey(config_keys.cputkey.v, true, cputk)
    cejectbind = rkeys.registerHotKey(config_keys.cejectkey.v, true, cejectk)
    takebind = rkeys.registerHotKey(config_keys.takekey.v, true, takek)
    arrestbind = rkeys.registerHotKey(config_keys.arrestkey.v, true, arrestk)
    uncuffbind = rkeys.registerHotKey(config_keys.uncuffkey.v, true, uncuffk)
    dejectbind = rkeys.registerHotKey(config_keys.dejectkey.v, true, dejectk)
    sirenbind = rkeys.registerHotKey(config_keys.sirenkey.v, true, sirenk)
    --mayor
    hibind = rkeys.registerHotKey(config_keys.hikey.v, true, hikeyk)
	summabind = rkeys.registerHotKey(config_keys.summakey.v, true, summakeyk)
	freenalbind = rkeys.registerHotKey(config_keys.freenalkey.v, true, freenalkeyk)
	freebankbind = rkeys.registerHotKey(config_keys.freebankkey.v, true, freebankkeyk)
end

function oopchat()
	while true do wait(0)
        stext, sprefix, scolor, spcolor = sampGetChatString(99)
        if cfg.main.group == 'ÏÄ/ÔÁÐ' then
            if zaproop then
                if nikk ~= nil then
                    if stext:find(nikk) and scolor == 4294935170 then
                        local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
                        local myname = sampGetPlayerNickname(myid)
                        if not stext:find(myname) then
                            zaproop = false
                            nikk = nil
                            wait(100)
                            ftext('Êîìàíäó âûïîëíèë äðóãîé ñîòðóäíèê.', -1)
                        end
                    end
                end
            end
            --if scolor == 4287467007 or scolor == 9276927 then
                if frak == 'FBI' then
                    if rang == 'Ãëàâà DEA' or rang == 'Ãëàâà CID' or rang == 'Èíñïåêòîð FBI' or rang == 'Çàì.Äèðåêòîðà FBI' or rang == 'Äèðåêòîð FBI' then
                        if stext:match('Ïåðåîäåëñÿ â êîñòþì àãåíòà') then
                            local msrang, msnick = stext:match('(.+) (.+): Ïåðåîäåëñÿ â êîñòþì àãåíòà')
                            if msnick ~= sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) then
                                mssnyat = true
                                msoffid = sampGetPlayerIdByNickname(msnick)
                                ftext(('Àãåíò {9966cc}%s {ffffff}õî÷åò cíÿòü ìàñêèðîâêó'):format(msnick:gsub('_', ' ')))
                                ftext('Ïîäòâåðäèòü: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | Îòìåíèòü: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
                            end
                        end
                        if stext:match('Ïåðåîäåëàñü â êîñòþì àãåíòà') then
                            local msrang, msnick = stext:match('(.+) (.+): Ïåðåîäåëàñü â êîñòþì àãåíòà')
                            if msnick ~= sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) then
                                mssnyat = true
                                msoffid = sampGetPlayerIdByNickname(msnick)
                                ftext(('Àãåíò {9966cc}%s {ffffff}õî÷åò cíÿòü ìàñêèðîâêó'):format(msnick:gsub('_', ' ')))
                                ftext('Ïîäòâåðäèòü: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | Îòìåíèòü: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
                            end
                        end
                        if stext:match('Ïåðåîäåëñÿ â ñîòðóäíèêà ëàáîðàòîðèè') then
                            local msrang, msnick = stext:match('(.+) (.+): Ïåðåîäåëñÿ â ñîòðóäíèêà ëàáîðàòîðèè')
                            if msnick ~= sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) then
                                msid = sampGetPlayerIdByNickname(msnick)
                                msvidat = "ëàáîðàòîðèÿ"
                                ftext(('Àãåíò {9966cc}%s {ffffff}õî÷åò âçÿòü ôîðìó {9966cc}ñîòðóäíèêà ëàáîðàòîðèè{ffffff}'):format(msnick:gsub('_', ' ')))
                                ftext('Ïîäòâåðäèòü: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | Îòìåíèòü: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
                            end
                        end
                        if stext:match('Ïåðåîäåëàñü â ñîòðóäíèêà ëàáîðàòîðèè') then
                            local msrang, msnick = stext:match('(.+) (.+): Ïåðåîäåëàñü â ñîòðóäíèêà ëàáîðàòîðèè')
                            if msnick ~= sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) then
                                msid = sampGetPlayerIdByNickname(msnick)
                                msvidat = "ëàáîðàòîðèÿ"
                                ftext(('Àãåíò {9966cc}%s {ffffff}õî÷åò âçÿòü ôîðìó {9966cc}ñîòðóäíèêà ëàáîðàòîðèè{ffffff}'):format(msnick:gsub('_', ' ')))
                                ftext('Ïîäòâåðäèòü: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | Îòìåíèòü: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
                            end
                        end
                        if stext:match('Ïåðåîäåëñÿ â ôîðìó .+. Ïðè÷èíà: .+') then
                            local msrang, msnick, msforma, msreason = stext:match('(.+) (.+): Ïåðåîäåëñÿ â ôîðìó (.+). Ïðè÷èíà: (.+)')
                            if msnick ~= sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) then
                                msid = sampGetPlayerIdByNickname(msnick)
                                msvidat = msforma
                                ftext(('Àãåíò {9966cc}%s {ffffff}õî÷åò âçÿòü ìàñêèðîâêó {9966cc}%s{ffffff}. Ïðè÷èíà: {9966cc}%s'):format(msnick:gsub('_', ' '), msforma, msreason))
                                ftext('Ïîäòâåðäèòü: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | Îòìåíèòü: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
                            end
                        end
                        if stext:match('Ïåðåîäåëàñü â ôîðìó .+. Ïðè÷èíà: .+') then
                            local msrang, msnick, msforma, msreason = stext:match('(.+) (.+): Ïåðåîäåëàñü â ôîðìó (.+). Ïðè÷èíà: (.+)')
                            if msnick ~= sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) then
                                msid = sampGetPlayerIdByNickname(msnick)
                                msvidat = forma
                                ftext(('Àãåíò {9966cc}%s {ffffff}õî÷åò âçÿòü ìàñêèðîâêó {9966cc}%s{ffffff}. Ïðè÷èíà: {9966cc}%s'):format(msnick:gsub('_', ' '), msforma, msreason))
                                ftext('Ïîäòâåðäèòü: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | Îòìåíèòü: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
                            end
                        end
                    end
                end
                if rang ~= 'Êàäåò' and rang ~= 'Îôèöåð' and rang ~= 'Ìë.Ñåðæàíò' and  rang ~= 'Ñåðæàíò' and  rang ~= 'Ïðàïîðùèê' then
                    if stext:find('Äåëî íà èìÿ .+ %(%d+%) ðàññìîòðåíèþ íå ïîäëåæèò, ÎÎÏ, îáúÿâèòå.') then
                        local name, id = stext:match('Äåëî íà èìÿ (.+) %((%d+)%) ðàññìîòðåíèþ íå ïîäëåæèò, ÎÎÏ, îáúÿâèòå.')
                        zaproop = true
                        nikk = name
                        if nikk ~= nil then
                            ftext(string.format("Ïîñòóïèë çàïðîñ íà îáúÿâëåíèå ÎÎÏ èãðîêà {9966cc}%s", nikk:gsub('_', ' ')), -1)
                            ftext('Ïîäòâåðäèòü: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | Îòìåíèòü: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
                        else
                            zaproop = false
                        end
                    end
                    if stext:match('Äåëî .+ ðàññìîòðåíèþ íå ïîäëåæèò %- ÎÎÏ.') then
                        local name = stext:match('Äåëî (.+) ðàññìîòðåíèþ íå ïîäëåæèò %- ÎÎÏ.')
                        zaproop = true
                        nikk = name
                        if nikk ~= nil then
                            ftext(string.format("Ïîñòóïèë çàïðîñ íà îáúÿâëåíèå ÎÎÏ èãðîêà {9966cc}%s", nikk:gsub('_', ' ')), -1)
                            ftext('Ïîäòâåðäèòü: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | Îòìåíèòü: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
                        else
                            zaproop = false
                        end
                    end
                    if stext:match('Äåëî íà èìÿ .+ ðàññìîòðåíèþ íå ïîäëåæèò, ÎÎÏ.') then
                        local name = stext:match('Äåëî íà èìÿ (.+) ðàññìîòðåíèþ íå ïîäëåæèò, ÎÎÏ.')
                        zaproop = true
                        nikk = name
                        if nikk ~= nil then
                            ftext(string.format("Ïîñòóïèë çàïðîñ íà îáúÿâëåíèå ÎÎÏ èãðîêà {9966cc}%s", nikk:gsub('_', ' ')), -1)
                            ftext('Ïîäòâåðäèòü: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | Îòìåíèòü: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
                        else
                            zaproop = false
                        end
                    end
                end
            --end
            if nikk == nil then
                if aroop then aroop = false end
                if zaproop then zaproop = false end
                if dmoop then dmoop = false end
            end
        end
	end
end

function oopdakey()
    if cfg.main.group == 'ÏÄ/ÔÁÐ' then
        if msvidat then
            msda = true
            sampSendChat('/spy '..msid)
        end
        if mssnyat then
            sampSendChat('/spyoff '..msoffid)
            msoffid = nil
            mssnyat = false
        end
        if opyatstat then
            lua_thread.create(checkStats)
            opyatstat = false
        end
        if zaproop then
            sampSendChat(string.format('/d Mayor, äåëî íà èìÿ %s ðàññìîòðåíèþ íå ïîäëåæèò, ÎÎÏ', nikk:gsub('_', ' ')))
            zaproop = false
            nazhaloop = true
        end
        if dmoop then
            if frak == 'FBI' or frak == 'LSPD' or frak == 'SFPD' or frak == 'LVPD' then
                if rang == 'Êàäåò' or rang == 'Îôèöåð' or rang == 'Ìë.Ñåðæàíò' or  rang == 'Ñåðæàíò' or  rang == 'Ïðàïîðùèê' then
                    if not cfg.main.tarb then
                        sampSendChat(string.format('/r Äåëî íà èìÿ %s ðàññìîòðåíèþ íå ïîäëåæèò, ÎÎÏ.', nikk:gsub('_', ' ')))
                        dmoop = false
                    else
                        sampSendChat(string.format('/r [%s]: Äåëî íà èìÿ %s ðàññìîòðåíèþ íå ïîäëåæèò, ÎÎÏ.', cfg.main.tar, nikk:gsub('_', ' ')))
                        dmoop = false
                    end
                else
                    sampSendChat(string.format('/d Mayor, äåëî íà èìÿ %s ðàññìîòðåíèþ íå ïîäëåæèò, ÎÎÏ ÊÏÇ LSPD.', nikk:gsub('_', ' ')))
                    dmoop = false
                    nazhaloop = true
                end
            end
        end
        if aroop then
            if frak == 'FBI' or frak == 'LSPD' or frak == 'SFPD' or frak == 'LVPD' then
                if rang == 'Êàäåò' or rang == 'Îôèöåð' or rang == 'Ìë.Ñåðæàíò' or  rang == 'Ñåðæàíò' or  rang == 'Ïðàïîðùèê' then
                    if not cfg.main.tarb then
                        sampSendChat(string.format('/r Äåëî íà èìÿ %s ðàññìîòðåíèþ íå ïîäëåæèò, ÎÎÏ.', nikk:gsub('_', ' ')))
                        aroop = false
                        nikk = nil
                    else
                        sampSendChat(string.format('/r [%s]: Äåëî íà èìÿ %s ðàññìîòðåíèþ íå ïîäëåæèò, ÎÎÏ.', cfg.main.tar, nikk:gsub('_', ' ')))
                        aroop = false
                        nikk = nil
                    end
                else
                    sampSendChat(string.format("/d Mayor, äåëî íà èìÿ %s ðàññìîòðåíèþ íå ïîäëåæèò, ÎÎÏ.", nikk:gsub('_', ' ')))
                    aroop = false
                    --nikk = nil
                    nazhaloop = true
                end
            end
        end
    end
end

function oopnetkey()
    if cfg.main.group == 'ÏÄ/ÔÁÐ' then
        msid = nil
        msda = false
        msvidat = nil
        mssnyat = false
        msoffid = nil
        if opyatstat then
            opyatstat = false
        end
        if dmoop == true then
            dmoop = false
            nikk = nil
            ftext("Ðàññìîòð äåëà îòìåíåí.", -1)
        end
        if zaproop == true then
            zaproop = false
            nikk = nil
            ftext("Ðàññìîòð äåëà îòìåíåí.", -1)
        end
        if aroop == true then
            aroop = false
            nikk = nil
            ftext("Ðàññìîòð äåëà îòìåíåí.", -1)
        end
    end
end

function main()
    local directoryes = {'config', 'config/fbitools', 'fbitools'}
    for k, v in pairs(directoryes) do
        if not doesDirectoryExist('moonloader/'..v) then createDirectory("moonloader/"..v) end
    end
    if not doesFileExist('moonloader/config/fbitools/config.json') then
        io.open('moonloader/config/fbitools/config.json', 'w'):close()
    else
        local file = io.open('moonloader/config/fbitools/config.json', 'r')
        if file then
            cfg = decodeJson(file:read('*a'))
            if cfg.main.megaf == nil then cfg.main.megaf = true end
            if cfg.main.autobp == nil then cfg.main.autobp = false end
            if cfg.autobp == nil then cfg.autobp = {
                deagle = true,
                dvadeagle = true,
                shot = true,
                dvashot = true,
                smg = true,
                dvasmg = true,
                m4 = true,
                dvam4 = true,
                rifle = true,
                dvarifle = true,
                armour = true,
                spec = true
            }
            end
            if cfg.main.googlecode == nil then cfg.main.googlecode = '' end
            if cfg.main.googlecodeb == nil then cfg.main.googlecodeb = false end
            if cfg.main.group == nil then cfg.main.group = 'unknown' end
            if cfg.main.nwanted == nil then cfg.main.nwanted = false end
            if cfg.main.nclear == nil then cfg.main.nclear = false end
        end
    end
    saveData(cfg, 'moonloader/config/fbitools/config.json')
    if doesFileExist("moonloader/config/fbitools/cmdbinder.json") then
        local file = io.open('moonloader/config/fbitools/cmdbinder.json', 'r')
        if file then
            commands = decodeJson(file:read('*a'))
        end
    end
    saveData(commands, "moonloader/config/fbitools/cmdbinder.json")
    if not doesFileExist("moonloader/config/fbitools/keys.json") then
        local fa = io.open("moonloader/config/fbitools/keys.json", "w")
		fa:write(encodeJson(config_keys))
        fa:close()
    else
        local fa = io.open("moonloader/config/fbitools/keys.json", 'r')
        if fa then
            config_keys = decodeJson(fa:read('*a'))
            if config_keys.hikey == nil then config_keys.hikey = {v = {key.VK_I}} end
            if config_keys.summakey == nil then config_keys.summakey = {v = {key.VK_L}} end
            if config_keys.freenalkey == nil then config_keys.freenalkey = {v = {key.VK_Y}} end
            if config_keys.freebankkey == nil then config_keys.freebankkey = {v = {key.VK_U}} end
            if config_keys.vzaimkey == nil then config_keys.vzaimkey = {v = {key.VK_Z}} end
        end
    end
    saveData(config_keys, 'moonloader/config/fbitools/keys.json')
    if doesFileExist(fileb) then
        local f = io.open(fileb, "r")
        if f then
            tBindList = decodeJson(f:read())
            f:close()
        end
    else
        tBindList = {
            [1] = {
                text = "",
                v = {},
                name = 'Áèíä1'
            },
            [2] = {
                text = "",
                v = {},
                name = 'Áèíä2'
            },
            [3] = {
                text = "",
                v = {},
                name = 'Áèíä3'
            }
        }
    end
    saveData(tBindList, fileb)
    repeat wait(0) until isSampAvailable()
    ftext(script.this.name..' óñïåøíî çàãðóæåí. Ââåäèòå: /ft ÷òî áû ïîëó÷èòü äîïîëíèòåëüíóþ èíôîðìàöèþ.')
    ftext('Àâòîðû: '..table.concat(script.this.authors))
    print(("%s v%s: Óñïåøíî çàãðóæåí"):format(script.this.name, script.this.version))
    libs()
    registerCommands()
    registerSphere()
    registerHotKey()
    registerCommandsBinder()
    if cfg.main.group == 'unknown' then ftext("Ñåé÷àñ ó âàñ íå âûáðàíà ãðóïïà ôðàêöèé. Áîëüøèíñòâî ôóíêöèé ñêðèïòà íåäîñòóïíû.")
        ftext("Íàñòðîèòü ãðóïïó ìîæíî â íàñòðîéêàõ ñêðèïòà.") 
    else 
        ftext("Çàãðóæåíû íàñòðîéêè äëÿ ãðóïïû: {9966CC}"..cfg.main.group) 
    end
    update()
    mcheckf()
    shpf()
    ykf()
    akf()
    fpf()
    suf()
    apply_custom_style()
    lua_thread.create(oopchat)
	lua_thread.create(strobes)
    for k, v in pairs(tBindList) do
        rkeys.registerHotKey(v.v, true, onHotKey)
        if v.time ~= nil then v.time = nil end
        if v.name == nil then v.name = "Áèíä"..k end
        v.text = v.text:gsub("%[enter%]", ""):gsub("{noenter}", "{noe}")
    end
    saveData(tBindList, fileb)
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
            if wparam == key.VK_ESCAPE then
                if not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() then
                    if mainw.v then mainw.v = false consumeWindowMessage(true, true) end
                    if imegaf.v then imegaf.v = false consumeWindowMessage(true, true) end
                    if shpwindow.v then shpwindow.v = false consumeWindowMessage(true, true) end
                    if ykwindow.v then ykwindow.v = false consumeWindowMessage(true, true) end
                    if fpwindow.v then fpwindow.v = false consumeWindowMessage(true, true) end
                    if akwindow.v then akwindow.v = false consumeWindowMessage(true, true) end
                    if updwindows.v then updwindows.v = false consumeWindowMessage(true, true) end
                    if memw.v then memw.v = false consumeWindowMessage(true, true) end
                end
            end
        end
    end)
    if not sampIsDialogActive() then
        lua_thread.create(checkStats)
    else
        while sampIsDialogActive() do wait(0) end
        lua_thread.create(checkStats)
    end
    while true do wait(0)
        if isCharInAnyCar(PLAYER_PED) then mcid = select(2, sampGetVehicleIdByCarHandle(storeCarCharIsInNoSave(PLAYER_PED))) end
        if gmegafid == nil then gmegafid = -1 end
        if #departament > 25 then table.remove(departament, 1) end
        if #radio > 25 then table.remove(radio, 1) end
        if #wanted > 25 then table.remove(wanted, 1) end
        if #sms > 25 then table.remove(sms, 1) end
        infbar = imgui.ImBool(cfg.main.hud)
        local myid = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
        imgui.Process = infbar.v or mainw.v or shpwindow.v or ykwindow.v or fpwindow.v or akwindow.v or updwindows.v or imegaf.v or memw.v
        local myskin = getCharModel(PLAYER_PED)
        if myskin == 280 or myskin == 265 or myskin == 266 or myskin == 267 or myskin == 281 or myskin == 282 or myskin == 288 or myskin == 284 or myskin == 285 or myskin == 304 or myskin == 305 or myskin == 306 or myskin == 307 or myskin == 309 or myskin == 283 or myskin == 286 or myskin == 287 or myskin == 252 or myskin == 279 or myskin == 163 or myskin == 164 or myskin == 165 or myskin == 166 then
            rabden = true
        end
        if cfg.main.group == 'ÏÄ/ÔÁÐ' then if sampGetFraktionBySkin(myid) == 'Ïîëèöèÿ' or sampGetFraktionBySkin(myid) == 'FBI' or sampGetFraktionBySkin(myid) == 'Army' then rabden = true end
        elseif cfg.main.group == 'Àâòîøêîëà' then if sampGetFraktionBySkin(myid) == 'Àâòîøêîëà' then rabden = true end
        elseif cfg.main.group == 'ÌÎÍ' then if sampGetFraktionBySkin(myid) == 'Ìåäèêè' then rabden = true end
        elseif cfg.main.group == 'Ìýðèÿ' then if sampGetFraktionBySkin(myid) == 'Ìýðèÿ' then rabden = true end
        end
        if sampIsDialogActive() == false and not isPauseMenuActive() and isPlayerPlaying(playerHandle) and sampIsChatInputActive() == false then
            if coordX ~= nil and coordY ~= nil then
                cX, cY, cZ = getCharCoordinates(playerPed)
                cX = math.ceil(cX)
                cY = math.ceil(cY)
                cZ = math.ceil(cZ)
                ftext('Ìåòêà óñòàíîâëåíà íà '..kvadY..'-'..kvadX)
                placeWaypoint(coordX, coordY, 0)
                coordX = nil
                coordY = nil
            end
        end
        if not doesCharExist(gmegafhandle) and gmegafhandle ~= nil then
            ftext(string.format('Èãðîê {9966cc}%s [%s] {ffffff}ïîòåðÿí èç ïîëÿ çðåíèÿ', sampGetPlayerNickname(gmegafid), gmegafid))
            gmegafid = -1
			gmegaflvl = nil
			gmegaffrak = nil
            gmegafhandle = nil
        end
        if changetextpos then
            sampToggleCursor(true)
            local CPX, CPY = getCursorPos()
            cfg.main.posX = CPX
            cfg.main.posY = CPY
        end
        if wasKeyPressed(key.VK_T) and cfg.main.tchat and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
            sampSetChatInputEnabled(true)
        end
        local myhp = getCharHealth(PLAYER_PED)
        local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
        if valid and doesCharExist(ped) then
            local result, id = sampGetPlayerIdByCharHandle(ped)
            targetid = id
        end
        local result, button, list, input = sampHasDialogRespond(1385)
        local result16, button, list, input = sampHasDialogRespond(1401)
        local result17, button, list, input = sampHasDialogRespond(1765)
        local ooplresult, button, list, input = sampHasDialogRespond(2458)
        local oopdelresult, button, list, input = sampHasDialogRespond(2459)
        local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
        if #ooplistt > 30 then
            table.remove(ooplistt, 1)
        end
        if oopdelresult then
            if button == 1 then
                local oopi = 1
                while oopi <= #ooplistt do
                    if ooplistt[oopi]:find(oopdelnick) then
                        table.remove(ooplistt, oopi)
                    else
                        oopi = oopi + 1
                    end
                end
                ftext('Èãðîê {9966cc}'..oopdelnick..'{ffffff} áûë óäàëåí èç ñïèñêà ÎÎÏ')
            elseif button == 0 then
                sampShowDialog(2458, '{9966cc}'..script.this.name.. '| {ffffff}Ñïèñîê ÎÎÏ', table.concat(ooplistt, '\n'), '»', "x", 2)
            end
        end
        if ooplresult then
            if button == 1 then
                local ltext = sampGetListboxItemText(list)
                if ltext:match("äåëî íà èìÿ .+ ðàññìîòðåíèþ íå ïîäëåæèò, ÎÎÏ") then
                    oopdelnick = ltext:match("äåëî íà èìÿ (.+) ðàññìîòðåíèþ íå ïîäëåæèò, ÎÎÏ")
                    sampShowDialog(2459, '{9966cc}'..script.this.name..' | {ffffff}Óäàëåíèå èç ÎÎÏ', "{ffffff}Âû äåéñòâèòåëüíî æåëàåòå óäàëèòü {9966cc}"..oopdelnick.."\n{ffffff}Èç ñïèñêà ÎÎÏ?", "»", "«", 0)
                elseif ltext:match("äåëî .+ ðàññìîòðåíèþ íå ïîäëåæèò %- ÎÎÏ.") then
                    oopdelnick = ltext:match("äåëî (.+) ðàññìîòðåíèþ íå ïîäëåæèò %- ÎÎÏ.")
                    sampShowDialog(2459, '{9966cc}'..script.this.name..' | {ffffff}Óäàëåíèå èç ÎÎÏ', "{ffffff}Âû äåéñòâèòåëüíî æåëàåòå óäàëèòü {9966cc}"..oopdelnick.."\n{ffffff}Èç ñïèñêà ÎÎÏ?", "»", "«", 0)
                end
            end
        end
        if result17 then
            if button == 1 then
                if #input ~= 0 and tonumber(input) ~= nil then
                    for k, v in pairs(suz) do
                        if tonumber(input) == k then
                            local reas, zzv = v:match('(.+) %- (%d+) .+')
                            sampSendChat(string.format('/su %s %s %s', zid, zzv, reas))
                            zid = nil
                        end
                    end
                else
                    ftext('Âû íå âûáðàëè íîìåð ñòàòüè.')
                end
            end
        end
        if result16 then
            if input ~= '' and button == 1 then
                if cfg.main.tarb then
                    sampSendChat(string.format('/r [%s]: Çàïðàøèâàþ ýâàêóàöèþ â êâàäðàò %s íà %s', cfg.main.tar, kvadrat(), input))
                else
                    sampSendChat(string.format('/r Çàïðàøèâàþ ýâàêóàöèþ â êâàäðàò %s íà %s', kvadrat(), input))
                end
            end
        end
        if result then
            if button == 1 then
				sampSendChat(("/r %s â ôîðìó %s. Ïðè÷èíà: %s"):format(cfg.main.male and 'Ïåðåîäåëñÿ' or 'Ïåðåîäåëàñü', mstype, input))
				wait(1400)
				sampSendChat("/rb "..myid)
				mstype = ''
            end
        end
    end
end

function oop(pam)
    pID = tonumber(pam)
    if frak == 'FBI' or frak == 'LSPD' or frak == 'SFPD' or frak == 'LVPD' then
        if pID ~= nil then
            if sampIsPlayerConnected(pID) then
                if rang == 'Êàäåò' or rang == 'Îôèöåð' or rang == 'Ìë.Ñåðæàíò' or  rang == 'Ñåðæàíò' or  rang == 'Ïðàïîðùèê' then
                    if not cfg.main.tarb then
                        sampSendChat("/r Äåëî íà èìÿ "..sampGetPlayerNickname(pID):gsub('_', ' ').." ðàññìîòðåíèþ íå ïîäëåæèò, ÎÎÏ.")
                    else
                        sampSendChat("/r ["..cfg.main.tar.."]: Äåëî íà èìÿ "..sampGetPlayerNickname(pID):gsub('_', ' ').." ðàññìîòðåíèþ íå ïîäëåæèò, ÎÎÏ.")
                    end
                else
                    sampSendChat("/d Mayor, äåëî íà èìÿ "..sampGetPlayerNickname(pID):gsub('_', ' ').." ðàññìîòðåíèþ íå ïîäëåæèò, ÎÎÏ.")
                end
            else
                ftext("Èãðîê ñ ID: "..pID.." íå ïîäêëþ÷åí ê ñåðâåðó")
            end
        else
            ftext("Ââåäèòå: /oop [id]")
        end
    else
        ftext("Âû íå ñîòðóäíèê ÏÄ/FBI")
    end
end

function tazer()
    lua_thread.create(function()
        sampSendChat("/tazer")
        wait(1400)
        sampSendChat(('/me %s òèï ïàòðîíîâ'):format(cfg.main.male and 'ñìåíèë' or 'ñìåíèëà'))
    end)
end

function su(pam)
    pID = tonumber(pam)
    if pID ~= nil then
        if sampIsPlayerConnected(pID) then
            lua_thread.create(function()
                submenus_show(sumenu(pID), "{9966cc}"..script.this.name.." {ffffff}| "..sampGetPlayerNickname(pID).."["..pID.."] ")
            end)
        else
            ftext("Èãðîê ñ ID: "..pID.." íå ïîäêëþ÷åí ê ñåðâåðó")
        end
    else
        ftext("Ââåäèòå: /su [id]")
    end
end

function ssu(pam)
    local id, zv, orichina = pam:match('(%d+) (%d+) (.+)')
    if id and zv and orichina then
        sampSendChat(string.format('/su %s %s %s', id, zv, orichina))
    else
        ftext('Ââåäèòå: /ssu [id] [êîë-âî çâåçä] [ïðè÷èíà]')
    end
end

function keys()
    lua_thread.create(function()
        sampSendChat(("/me %s êëþ÷"):format(cfg.main.male and 'âçÿë' or 'âçÿëà'))
        wait(cfg.commands.zaderjka)
        sampSendChat("/me ñðàâíèâàåò êëþ÷ ñ êëþ÷îì îò ÊÏÇ")
        wait(cfg.commands.zaderjka)
        sampSendChat(("/try %s, ÷òî êëþ÷è èäåíòè÷íû"):format(cfg.main.male and 'îáíàðóæèë', 'îáíàðóæèëà'))
    end)
end

function cput(pam)
    lua_thread.create(function()
        if cfg.commands.cput then
            if pam:match("^(%d+)$") then
                local id = tonumber(pam:match("^(%d+)$"))
                if sampIsPlayerConnected(id) then
                    if isCharInAnyCar(PLAYER_PED) then
                        if isCharOnAnyBike(PLAYER_PED) then
                            sampSendChat(("/me %s %s íà ñèäåíüå ìîòîöèêëà"):format(cfg.main.male and 'ïîñàäèë' or 'ïîñàäèëà', sampGetPlayerNickname(id):gsub("_", ' ')))
                            wait(1400)
                            sampSendChat(("/cput %s %s"):format(id, getFreeSeat()))
                        else
                            sampSendChat(("/me %s äâåðü àâòîìîáèëÿ è %s òóäà %s"):format(cfg.main.male and 'îòêðûë' or 'îòêðûëà', cfg.main.male and 'çàòîëêíóë' or 'çàòîëêíóëà', sampGetPlayerNickname(id):gsub("_", ' ')))
                            wait(1400)
                            sampSendChat(("/cput %s %s"):format(id, getFreeSeat()))
                        end
                    else
                        sampSendChat(("/me %s äâåðü àâòîìîáèëÿ è %s òóäà %s"):format(cfg.main.male and 'îòêðûë' or 'îòêðûëà', cfg.main.male and 'çàòîëêíóë' or 'çàòîëêíóëà', sampGetPlayerNickname(id):gsub("_", ' ')))
                        while not isCharInAnyCar(PLAYER_PED) do wait(0) end
                        sampSendChat(("/cput %s %s"):format(id, getFreeSeat()))
                    end
                else
                    ftext("Èãðîê îôôëàéí")
                end
            elseif pam:match("^(%d+) (%d+)$") then
                local id, seat = pam:match("^(%d+) (%d+)$")
                local id, seat = tonumber(id), tonumber(seat)
                if sampIsPlayerConnected(id) then
                    if seat >=1 and seat <=3 then
                        if isCharInAnyCar(PLAYER_PED) then
                            if isCharOnAnyBike(PLAYER_PED) then
                                sampSendChat(("/me %s %s íà ñèäåíüå ìîòîöèêëà"):format(cfg.main.male and 'ïîñàäèë' or 'ïîñàäèëà', sampGetPlayerNickname(id):gsub("_", ' ')))
                                wait(1400)
                                sampSendChat(("/cput %s %s"):format(id, seat))
                            else
                                sampSendChat(("/me %s äâåðü àâòîìîáèëÿ è %s òóäà %s"):format(cfg.main.male and 'îòêðûë' or 'îòêðûëà', cfg.main.male and 'çàòîëêíóë' or 'çàòîëêíóëà', sampGetPlayerNickname(id):gsub("_", ' ')))
                                wait(1400)
                                sampSendChat(("/cput %s %s"):format(id, seat))
                            end
                        else
                            sampSendChat(("/me %s äâåðü àâòîìîáèëÿ è %s òóäà %s"):format(cfg.main.male and 'îòêðûë' or 'îòêðûëà', cfg.main.male and 'çàòîëêíóë' or 'çàòîëêíóëà', sampGetPlayerNickname(id):gsub("_", ' ')))
                            while not isCharInAnyCar(PLAYER_PED) do wait(0) end
                            sampSendChat(("/cput %s %s"):format(id, seat))
                        end
                    else
                        ftext('Çíà÷åíèå íå äîëæíî áûòü ìåíüøå 1 è áîëüøå 3!')
                    end
                else
                    ftext('Èãðîê îôôëàéí')
                end
            elseif #pam == 0 or not pam:match("^(%d+)$") or not pam:match("^(%d+) (%d+)$") then
                ftext('Ââåäèòå: /cput [id] [ìåñòî(íå îáÿçàòåëüíî)]')
            end
        else
            sampSendChat(('/cput %s'):format(pam))
        end
    end)
end

function ceject(pam)
    lua_thread.create(function()
        local id = tonumber(pam)
        if cfg.commands.ceject then
            if id ~= nil then
                if sampIsPlayerConnected(id) then
                    if isCharOnAnyBike(PLAYER_PED) then
                        sampSendChat(("/me %s %s ñ ìîòîöèêëà"):format(cfg.main.male and 'âûñàäèë' or 'âûñàäèëà', sampGetPlayerNickname(id):gsub('_', ' ')))
                        wait(1400)
                        sampSendChat(("/ceject %s"):format(id))
                    else
                        sampSendChat(("/me %s äâåðü àòâîìîáèëÿ è %s %s"):format(cfg.main.male and 'îòêðûë' or 'îòêðûëà', cfg.main.male and 'âûñàäèë' or 'âûñàäèëà', sampGetPlayerNickname(id):gsub('_', ' ')))
                        wait(1400)
                        sampSendChat(("/ceject %s"):format(id))
                    end
                else
                    ftext('Èãðîê îôôëàéí')
                end
            else
                ftext('Ââåäèòå: /ceject [id]')
            end
        else
            sampSendChat(("/ceject %s"):format(pam))
        end
    end)
end

function st(pam)
    local id = tonumber(pam)
    local result, ped = sampGetCharHandleBySampPlayerId(id)
    if id == nil then
        sampSendChat('/m ['..frak..'] Âîäèòåëü, ñíèçüòå ñêîðîñòü è ïðèæìèòåñü ê îáî÷èíå èëè ìû îòêðîåì îãîíü!')
    end
    if id ~= nil and not sampIsPlayerConnected(id) then
        ftext(string.format('Èãðîê ñ ID: %s íå ïîäêëþ÷åí ê ñåðâåðó', id), -1)
    end
    if result and not doesCharExist(ped) then
        local stname = sampGetPlayerNickname(id)
        ftext(string.format('Èãðîê %s [%s] íå äîñòóïåí', stname, id), -1)
    end
    if result and doesCharExist(ped) and not isCharInAnyCar(ped) then
        local stnaame = sampGetPlayerNickname(id)
        ftext(string.format('Èãðîê %s [%s] íå â òðàíñïîðòå', stnaame, id), -1)
    end
    if result and doesCharExist(ped) and isCharInAnyCar(ped) then
        local vehName = tCarsName[getCarModel(storeCarCharIsInNoSave(ped))-399]
        sampSendChat("/m Âîäèòåëü Ò/C "..vehName.." ñ ãîñ.íîìåðîì [EVL"..id.."X], ïðèæìèòåñü ê îáî÷èíå è îñòàíîâèòå ñâî¸ Ò/Ñ")
    end
end

function deject(pam)
    lua_thread.create(function()
        local id = tonumber(pam)
        if cfg.commands.deject then
            if id ~= nil then
                if sampIsPlayerConnected(id) then
                    local result, ped = sampGetCharHandleBySampPlayerId(id)
                    if result then
                        if isCharInFlyingVehicle(ped) then
                            sampSendChat(("/me %s äâåðü âåðòîë¸òà è %s %s"):format(cfg.main.male and 'îòêðûë' or 'îòêðûëà', cfg.main.male and 'âûòàùèë' or 'âûòàùèëà', sampGetPlayerNickname(id):gsub('_', ' ')))
                        elseif isCharInModel(ped, 481) or isCharInModel(ped, 510) then
                            sampSendChat(("/me %s %s ñ âåëîñèïåäà"):format(cfg.main.male and 'ñêèíóë' or 'ñêèíóëà', sampGetPlayerNickname(id):gsub('_', ' ')))
                        elseif isCharInModel(ped, 462) then
                            sampSendChat(("/me %s %s ñî ñêóòåðà"):format(cfg.main.male and 'ñêèíóë' or 'ñêèíóëà', sampGetPlayerNickname(id):gsub('_', ' ')))
                        elseif isCharOnAnyBike(ped) then
                            sampSendChat(("/me %s %s ñ ìîòîöèêëà"):format(cfg.main.male and 'ñêèíóë' or 'ñêèíóëà', sampGetPlayerNickname(id):gsub('_', ' ')))
                        elseif isCharInAnyCar(ped) then
                            sampSendChat(("/me %s îêíî è %s %s èç ìàøèíû"):format(cfg.main.male and 'ðàçáèë' or 'ðàçáèëà', cfg.main.male and 'âûòàùèë' or 'âûòàùèëà', sampGetPlayerNickname(id):gsub('_', ' ')))
                        end
                        wait(1400)
                        sampSendChat(("/deject %s"):format(id))
                    end
                else
                    ftext('Èãðîê îôôëàéí')
                end
            else
                ftext("Ââåäèòå: /deject [id]")
            end
        else
            sampSendChat(("/deject %s"):format(pam))
        end
    end)
end

function rh(id)
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if id == "" or id < "1" or id > "3" or id == nil then
        ftext("Ââåäèòå: /rh Äåïàðòàìåíò", -1)
        ftext("1 - LSPD | 2 - SFPD | 3 - LVPD", -1)
    elseif id == "1" then
        sampSendChat("/d LSPD, çàïðàøèâàþ ïàòðóëüíûé ýêèïàæ â "..kvadrat()..", êàê ïðèíÿëè? Îòâåò íà ïäæ."..myid)
    elseif id == "2" then
        sampSendChat("/d SFPD, çàïðàøèâàþ ïàòðóëüíûé ýêèïàæ â "..kvadrat()..", êàê ïðèíÿëè? Îòâåò íà ïäæ."..myid)
    elseif id == "3" then
        sampSendChat("/d LVPD, çàïðàøèâàþ ïàòðóëüíûé ýêèïàæ â "..kvadrat()..", êàê ïðèíÿëè? Îòâåò íà ïäæ."..myid)
    end
end
function gr(pam)
    local dep, reason = pam:match('(%d+)%s+(.+)')
    if dep == nil or reason == nil then
        ftext("Ââåäèòå: /gr [1-3] [Ïðè÷èíà]")
        ftext("1 - LSPD | 2 - SFPD | 3 - LVPD")
    end
    if dep ~= nil then
        if dep == "" or dep < "1" or dep > "3" then
            ftext("{9966CC}"..script.this.name.." {FFFFFF}| Ââåäèòå: /gr [1-3] [Ïðè÷èíà]")
            ftext("{9966CC}"..script.this.name.." {FFFFFF}| 1 - LSPD | 2 - SFPD | 3 - LVPD")
        elseif dep == "1" then
            sampSendChat("/d LSPD, ïåðåñåêàþ âàøó þðèñäèêöèþ, "..reason)
        elseif dep == "2" then
            sampSendChat("/d SFPD, ïåðåñåêàþ âàøó þðèñäèêöèþ, "..reason)
        elseif dep == "3" then
            sampSendChat("/d LVPD, ïåðåñåêàþ âàøó þðèñäèêöèþ, "..reason)
        end
    end
end
function warn(pam)
    local id = tonumber(pam)
    if frak == 'FBI' then
        if id == nil then
            ftext('Ââåäèòå /warn ID')
        end
        if id ~= nil and sampIsPlayerConnected(id) then
            lua_thread.create(function()
                warnst = true
                sampSendChat('/mdc '..id)
                wait(1400)
                if wfrac == 'LSPD' or wfrac == 'SFPD' or wfrac == 'LVPD' then
                    sampSendChat(string.format('/d %s, %s ïîëó÷àåò ïðåäóïðåæäåíèå çà íåïðàâèëüíóþ ïîäà÷ó â ðîçûñê.', wfrac, sampGetPlayerNickname(id):gsub('_', ' ')))
                else
                    ftext('×åëîâåê íå ÿâëÿåòñÿ ñîòðóäíèêîì PD')
                end
                wfrac = nil
                warnst = false
            end)
        end
    else
        ftext("Âû íå ñîòðóäíèê ÔÁÐ")
    end
end
function ms(pam)
	lua_thread.create(function()
		if frak == 'FBI' then
			if pam == "" or pam < "0" or pam > "3" or pam == nil then
				ftext("Ââåäèòå: /ms [Òèï]", -1)
				ftext("0 - Ñíÿòü ìàñêèðîâêó | 1 - Îôèñ | 2 - Áàãàæíèê | 3 - Ñóìêà", -1)
			elseif pam == '1' then
				sampSendChat(("/me %s ñ ñåáÿ êîñòþì àãåíòà è %s íà âåøàëêó"):format(cfg.main.male and 'ñíÿë' or 'ñíÿëà', cfg.main.male and 'ïîâåñèë' or 'ïîâåñèëà'))
				wait(cfg.commands.zaderjka)
				sampSendChat(("/me %s ÿùèê, ïîñëå ÷åãî äîñòàë %s ìàñêèðîâêè"):format(cfg.main.male and 'îòêðûë' or 'îòêðûëà', cfg.main.male and 'äîñòàë' or 'äîñòàëà'))
				wait(cfg.commands.zaderjka)
				sampSendChat(("/me %s íà ñåáÿ ìàñêèðîâêó è %s ÿùèê"):format(cfg.main.male and 'íàäåë' or 'íàäåëà', cfg.main.male and 'çàêðûë' or 'çàêðûëà'))
				wait(cfg.commands.zaderjka)
				sampSendChat("/do Àãåíò â ìàñêèðîâêå.")
				wait(100)
				submenus_show(osnova, "{9966cc}"..script.this.name.." {ffffff}| Mask")
			elseif pam == '2' then
				sampSendChat(("/me %s áàãàæíèê àâòîìîáèëÿ"):format(cfg.main.male and 'îòêðûë' or 'îòêðûëà'))
				wait(cfg.commands.zaderjka)
				sampSendChat(("/me %s ñ ñåáÿ êîñòþì àãåíòà è %s â áàãàæíèê"):format(cfg.main.male and 'ñíÿë' or 'ñíÿëà', cfg.main.male and 'óáðàë' or 'óáðàëà'))
				wait(cfg.commands.zaderjka)
				sampSendChat(("/me %s èç áàãàæíèêà êîìïëåêò ìàñêèðîâêè è %s íà ñåáÿ"):format(cfg.main.male and 'äîñòàë' or 'äîñòàëà', cfg.main.male and 'íàäåë' or 'íàäåëà'))
				wait(cfg.commands.zaderjka)
				sampSendChat(("/me %s áàãàæíèê"):format(cfg.main.male and 'çàêðûë' or 'çàêðûëà'))
				wait(cfg.commands.zaderjka)
				sampSendChat("/do Àãåíò â ìàñêèðîâêå.")
				wait(100)
				submenus_show(osnova, "{9966cc}"..script.this.name.." {ffffff}| Mask")
			elseif pam == '3' then
				sampSendChat("/do Íà ïëå÷å àãåíòà âèñèò ñóìêà.")
				wait(cfg.commands.zaderjka)
				sampSendChat(("/me îòêðûâ ñóìêó, %s êîñòþì àãåíòà è %s òóäà"):format(cfg.main.male and 'ñíÿë' or 'ñíÿëà', cfg.main.male and 'óáðàë' or 'óáðàëà'))
				wait(cfg.commands.zaderjka)
				sampSendChat(("/me %s èç ñóìêè êîìïëåêò ìàñêèðîâêè è %s íà ñåáÿ"):format(cfg.main.male and 'äîñòàë' or 'äîñòàëà', cfg.main.male and 'íàäåë' or 'íàäåëà'))
				wait(cfg.commands.zaderjka)
				sampSendChat(("/me %s ñóìêó"):format(cfg.main.male and 'çàêðûë' or 'çàêðûëà'))
				wait(cfg.commands.zaderjka)
				sampSendChat("/do Àãåíò â ìàñêèðîâêå.")
				wait(100)
				submenus_show(osnova, "{9966cc}"..script.this.name.." {ffffff}| Mask")
			elseif pam == '0' then
				sampSendChat(("/me %s ñ ñåáÿ ìàñêèðîâêó"):format(cfg.main.male and 'ñíÿë' or 'ñíÿëà'))
				wait(cfg.commands.zaderjka)
				sampSendChat(("/me %s íà ñåáÿ êîñòþì àãåíòà"):format(cfg.main.male and 'íàäåë' or 'íàäåëà'))
				wait(cfg.commands.zaderjka)
				sampSendChat(("/r %s â êîñòþì àãåíòà"):format(cfg.main.male and 'Ïåðåîäåëñÿ' or 'Ïåðåîäåëàñü'))
				wait(cfg.commands.zaderjka)
				sampSendChat("/rb "..select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
			end
		else
			ftext('Âû íå ñîòðóäíèê FBI')
		end
	end)
end

function ar(id)
    if id == "" or id < "1" or id > "2" or id == nil then
        ftext("Ââåäèòå: /ar [1-2]", -1)
        ftext("1 - LVa | 2 - SFa", -1)
    elseif id == "1" then
        sampSendChat("/d LVa, ðàçðåøèòå âúåçä íà âàøó òåððèòîðèþ, ïîèìêà ïðåñòóïíèêà.")
    elseif id == "2" then
        sampSendChat("/d SFa, ðàçðåøèòå âúåçä íà âàøó òåððèòîðèþ, ïîèìêà ïðåñòóïíèêà.")
    end
end

function r(pam)
    if #pam ~= 0 then
        if cfg.main.tarb then
            sampSendChat(string.format('/r [%s]: %s', cfg.main.tar, pam))
        else
            sampSendChat(string.format('/r %s', pam))
        end
    else
        ftext('Ââåäèòå /r [òåêñò]')
    end
end

function f(pam)
    if #pam ~= 0 then
        if cfg.main.tarb then
            sampSendChat(string.format('/f [%s]: %s', cfg.main.tar, pam))
        else
            sampSendChat(string.format('/f %s', pam))
        end
    else
        ftext('Ââåäèòå /f [òåêñò]')
    end
end

function fst(param)
    local hour = tonumber(param)
    if hour ~= nil and hour >= 0 and hour <= 23 then
        time = hour
        patch_samp_time_set(true)
        if time then
            setTimeOfDay(time, 0)
            ftext('Âðåìÿ èçìåíåíî íà: {9966cc}'..time, -1)
        end
    else
        ftext('Çíà÷åíèå âðåìåíè äîëæíî áûòü â äèàïàçîíå îò 0 äî 23.', -1)
        patch_samp_time_set(false)
        time = nil
    end
end

function fsw(param)
    local weather = tonumber(param)
    if weather ~= nil and weather >= 0 and weather <= 45 then
        forceWeatherNow(weather)
        ftext('Ïîãîäà èçìåíåíà íà: {9966cc}'..weather, -1)
    else
        ftext('Çíà÷åíèå ïîãîäû äîëæíî áûòü â äèàïàçîíå îò 0 äî 45.', -1)
    end
end

function patch_samp_time_set(enable)
    if enable and default == nil then
        default = readMemory(sampGetBase() + 0x9C0A0, 4, true)
        writeMemory(sampGetBase() + 0x9C0A0, 4, 0x000008C2, true)
    elseif enable == false and default ~= nil then
        writeMemory(sampGetBase() + 0x9C0A0, 4, default, true)
        default = nil
    end
end

function fshp(pam)
    if #pam ~= 0 then
        local f = io.open('moonloader\\fbitools\\shp.txt')
        for line in f:lines() do
            if string.find(line, pam) or string.rlower(line):find(pam) or string.rupper(line):find(pam) then
                sampAddChatMessage(' '..line, -1)
            end
        end
        f:close()
    else
        ftext('Ââåäèòå /fshp [òåêñò]')
    end
end
function fyk(pam)
    if #pam ~= 0 then
        local f = io.open('moonloader\\fbitools\\yk.txt')
        for line in f:lines() do
            if string.find(line, pam) or string.rlower(line):find(pam) or string.rupper(line):find(pam) then
                sampAddChatMessage(' '..line, -1)
            end
        end
        f:close()
    else
        ftext('Ââåäèòå /fyk [òåêñò]')
    end
end

function ffp(pam)
    if #pam ~= 0 then
        local f = io.open('moonloader\\fbitools\\fp.txt')
        for line in f:lines() do
            if string.find(line, pam) or string.rlower(line):find(pam) or string.rupper(line):find(pam) then
                sampAddChatMessage(' '..line, -1)
            end
        end
        f:close()
    else
        ftext('Ââåäèòå /ffp [òåêñò]')
    end
end

function fak(pam)
    if #pam ~= 0 then
        local f = io.open('moonloader\\fbitools\\ak.txt')
        for line in f:lines() do
            if string.find(line, pam) or string.rlower(line):find(pam) or string.rupper(line):find(pam) then
                sampAddChatMessage(' '..line, -1)
            end
        end
        f:close()
    else
        ftext('Ââåäèòå /fak [òåêñò]')
    end
end

function dmb()
    lua_thread.create(function()
        if sampIsDialogActive() then
            if sampIsDialogClientside() then
                tMembers = {}
                status = true
                sampSendChat('/members')
                while not gotovo do wait(0) end
                memw.v = true
                gosmb = false
                krimemb = false
                gotovo = false
                status = false
                gcount = nil
            end
        else
            tMembers = {}
            status = true
            sampSendChat('/members')
            while not gotovo do wait(0) end
            memw.v = true
            gosmb = false
            krimemb = false
            gotovo = false
            status = false
            gcount = nil
        end
	end)
end

function megaf()
    if cfg.main.group == 'ÏÄ/ÔÁÐ' then
        lua_thread.create(function()
            if isCharInAnyCar(PLAYER_PED) then
                incar = {}
                local stream = sampGetStreamedPlayers()
                local _, myvodil = sampGetPlayerIdByCharHandle(getDriverOfCar(storeCarCharIsInNoSave(PLAYER_PED)))
                for k, v in pairs(stream) do
                    local result, ped = sampGetCharHandleBySampPlayerId(v)
                    if result then
                        if isCharInAnyCar(ped) then
                            local car = storeCarCharIsInNoSave(ped)
                            local myposx, myposy, myposz = getCharCoordinates(PLAYER_PED)
                            local pposx, pposy, pposz = getCharCoordinates(ped)
                            local dist = getDistanceBetweenCoords3d(myposx, myposy, myposz, pposx, pposy, pposz)
                            if dist <=65 then
                                if getDriverOfCar(car) == ped then
                                    if sampGetFraktionBySkin(v) ~= 'Ïîëèöèÿ' then
                                        if storeCarCharIsInNoSave(ped) ~= storeCarCharIsInNoSave(PLAYER_PED) then
                                            if v ~= myvodil then
                                                table.insert(incar, v)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                if #incar ~= 0 then
                    if #incar == 1 then
                        local result, ped = sampGetCharHandleBySampPlayerId(incar[1])
                        if doesCharExist(ped) then
                            if isCharInAnyCar(ped) then
                                local carh = storeCarCharIsInNoSave(ped)
                                local carhm = getCarModel(carh)
                                sampSendChat(("/m Âîäèòåëü à/ì %s [EVL%sX]"):format(tCarsName[carhm-399], incar[1]))
                                wait(1400)
                                sampSendChat("/m Ïðèæìèòåñü ê îáî÷èíå èëè ìû îòêðîåì îãîíü!")
                                wait(300)
                                sampAddChatMessage(' {ffffff}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~', 0x9966cc)
                                sampAddChatMessage('', 0x9966cc)
                                sampAddChatMessage(' {ffffff}Íèê: {9966cc}'..sampGetPlayerNickname(incar[1])..' ['..incar[1]..']', 0x9966cc)
                                sampAddChatMessage(' {ffffff}Óðîâåíü: {9966cc}'..sampGetPlayerScore(incar[1]), 0x9966cc)
                                sampAddChatMessage(' {ffffff}Ôðàêöèÿ: {9966cc}'..sampGetFraktionBySkin(incar[1]), 0x9966cc)
                                sampAddChatMessage('', 0x9966cc)
                                sampAddChatMessage(' {ffffff}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~', 0x9966cc)
                                gmegafid = incar[1]
                                gmegaflvl = sampGetPlayerScore(incar[1])
                                gmegaffrak = sampGetFraktionBySkin(incar[1])
                                gmegafcar = tCarsName[carhm-399]
                            end
                        end
                    else
                        if cfg.main.megaf then
                            if not imegaf.v then imegaf.v = true end
                        else
                            for k, v in pairs(incar) do
                                local result, ped = sampGetCharHandleBySampPlayerId(v)
                                if doesCharExist(ped) then
                                    local carh = storeCarCharIsInNoSave(ped)
                                    local carhm = getCarModel(carh)
                                    sampSendChat(("/m Âîäèòåëü à/ì %s [EVL%sX]"):format(tCarsName[carhm-399], v))
                                    wait(1400)
                                    sampSendChat("/m Ïðèæìèòåñü ê îáî÷èíå èëè ìû îòêðîåì îãîíü!")
                                    wait(300)
                                    sampAddChatMessage(' {ffffff}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~', 0x9966cc)
                                    sampAddChatMessage('', 0x9966cc)
                                    sampAddChatMessage(' {ffffff}Íèê: {9966cc}'..sampGetPlayerNickname(v)..' ['..v..']', 0x9966cc)
                                    sampAddChatMessage(' {ffffff}Óðîâåíü: {9966cc}'..sampGetPlayerScore(v), 0x9966cc)
                                    sampAddChatMessage(' {ffffff}Ôðàêöèÿ: {9966cc}'..sampGetFraktionBySkin(v), 0x9966cc)
                                    sampAddChatMessage('', 0x9966cc)
                                    sampAddChatMessage(' {ffffff}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~', 0x9966cc)
                                    gmegafid = v
                                    gmegaflvl = sampGetPlayerScore(v)
                                    gmegaffrak = sampGetFraktionBySkin(v)
                                    gmegafcar = tCarsName[carhm-399]
                                    break
                                end
                            end
                        end
                    end
                end
            else
                ftext("Âàì íåîáõîäèìî ñèäåòü â òðàíñïîðòå")
            end
        end)
    end
end

function dkld()
    if cfg.main.group == 'ÏÄ/ÔÁÐ' then
        if isCharInAnyCar(PLAYER_PED) then
            if post ~= 7 and post ~= 12 and post ~= 13 and post ~= 14 and post ~= 18 and post ~= 21 and post ~= 22 and post ~= 23 and post ~= 24 and post ~= 25 and post ~= 26 and post ~= 27 and post ~= 28 and post ~= 29 and post ~= 30 and post ~= 31 then
                if getCarSpeed(storeCarCharIsInNoSave(PLAYER_PED)) > 0 then
                    if frak == 'LSPD' then
                        if not cfg.main.tarb  then
                            sampSendChat('/r Ïàòðóëü ã. Ëîñ-Ñàíòîñ. '..naparnik())
                        else
                            sampSendChat('/r ['..cfg.main.tar..']: Ïàòðóëü ã. Ëîñ-Ñàíòîñ. '..naparnik())
                        end
                    elseif frak == 'SFPD' then
                        if not cfg.main.tarb then
                            sampSendChat('/r Ïàòðóëü ã. Ñàí-Ôèåððî. '..naparnik())
                        else
                            sampSendChat('/r ['..cfg.main.tar..']: Ïàòðóëü ã. Ñàí-Ôèåððî. '..naparnik())
                        end
                    elseif frak == 'LVPD' then
                        if not cfg.main.tarb then
                            sampSendChat('/r Ïàòðóëü ã. Ëàñ-Âåíòóðàñ. '..naparnik())
                        else
                            sampSendChat('/r ['..cfg.main.tar..']: Ïàòðóëü ã. Ëàñ-Âåíòóðàñ. '..naparnik())
                        end
                    end
                else
                    if post ~= nil then
                        if getNameSphere(post) ~= nil then
                            if not cfg.main.tarb then
                                sampSendChat('/r Ïîñò: '..getNameSphere(post)..'. '..naparnik())
                            else
                                sampSendChat('/r ['..cfg.main.tar..']: Ïîñò: '..getNameSphere(post)..'. '..naparnik())
                            end
                        end
                    else
                        if frak == 'LSPD' then
                            if not cfg.main.tarb  then
                                sampSendChat('/r Ïàòðóëü ã. Ëîñ-Ñàíòîñ. '..naparnik())
                            else
                                sampSendChat('/r ['..cfg.main.tar..']: Ïàòðóëü ã. Ëîñ-Ñàíòîñ. '..naparnik())
                            end
                        elseif frak == 'SFPD' then
                            if not cfg.main.tarb then
                                sampSendChat('/r Ïàòðóëü ã. Ñàí-Ôèåððî. '..naparnik())
                            else
                                sampSendChat('/r ['..cfg.main.tar..']: Ïàòðóëü ã. Ñàí-Ôèåððî. '..naparnik())
                            end
                        elseif frak == 'LVPD' then
                            if not cfg.main.tarb then
                                sampSendChat('/r Ïàòðóëü ã. Ëàñ-Âåíòóðàñ. '..naparnik())
                            else
                                sampSendChat('/r ['..cfg.main.tar..']: Ïàòðóëü ã. Ëàñ-Âåíòóðàñ. '..naparnik())
                            end
                        end
                    end
                end
            end
            if post == 7 or post == 12 or post == 13 or post == 14 or post == 18 then
                if not cfg.main.tarb then
                    sampSendChat('/r Ïîñò: '..getNameSphere(post)..'. '..naparnik())
                else
                    sampSendChat('/r ['..cfg.main.tar..']: Ïîñò: '..getNameSphere(post)..'. '..naparnik())
                end
            end
            if post == 21 then
                if not cfg.main.tarb then
                    sampSendChat('/r Ïàòðóëü îïàñíîãî ðàéîíà. '..naparnik())
                else
                    sampSendChat('/r ['..cfg.main.tar..']: Ïàòðóëü îïàñíîãî ðàéîíà. '..naparnik())
                end
            end
            if post == 22 then
                if cfg.main.tar == nil then
                    sampSendChat('/r Ïàòðóëü ËÂà. '..naparnik())
                else
                    sampSendChat('/r ['..cfg.main.tar..']: Ïàòðóëü ËÂà. '..naparnik())
                end
            end
            lua_thread.create(function()
                if post == 23 then
                    if frak == 'LSPD' then
                        sampSendChat('/d SFPD, ïåðåñåêàþ âàøó þðèñäèêöèþ, ïîãîíÿ.')
                    elseif frak == 'SFPD' then
                        sampSendChat('/d LSPD, ïåðåñåêàþ âàøó þðèñäèêöèþ, ïîãîíÿ.')
                    elseif frak == 'LVPD' then
                        submenus_show(yrisdkld1404, '{9966CC}'..script.this.name..'{ffffff} | Ïåðåñå÷åíèå þðèñäèêöèè')
                    end
                end
                if post == 24 then
                    if frak == 'LSPD' then
                        sampSendChat('/d LVPD, ïåðåñåêàþ âàøó þðèñäèêöèþ, ïîãîíÿ.')
                    elseif frak == 'LVPD' then
                        sampSendChat('/d LSPD, ïåðåñåêàþ âàøó þðèñäèêöèþ, ïîãîíÿ.')
                    elseif frak == 'SFPD' then
                        submenus_show(yrisdkld1405, '{9966CC}'..script.this.name..'{ffffff} | Ïåðåñå÷åíèå þðèñäèêöèè')
                    end
                end
                if post == 25 then
                    if frak == 'LSPD' then
                        sampSendChat('/d LVPD, ïåðåñåêàþ âàøó þðèñäèêöèþ, ïîãîíÿ.')
                    elseif frak == 'LVPD' then
                        sampSendChat('/d LSPD, ïåðåñåêàþ âàøó þðèñäèêöèþ, ïîãîíÿ.')
                    elseif frak == 'SFPD' then
                        submenus_show(yrisdkld1405, '{9966CC}'..script.this.name..'{ffffff} | Ïåðåñå÷åíèå þðèñäèêöèè')
                    end
                end
                if post == 26 then
                    if frak == 'LSPD' then
                        sampSendChat('/d LVPD, ïåðåñåêàþ âàøó þðèñäèêöèþ, ïîãîíÿ.')
                    elseif frak == 'LVPD' then
                        sampSendChat('/d LSPD, ïåðåñåêàþ âàøó þðèñäèêöèþ, ïîãîíÿ.')
                    elseif frak == 'SFPD' then
                        submenus_show(yrisdkld1405, '{9966CC}'..script.this.name..'{ffffff} | Ïåðåñå÷åíèå þðèñäèêöèè')
                    end
                end
                if post == 27 then
                    if frak == 'LVPD' then
                        sampSendChat('/d SFPD, ïåðåñåêàþ âàøó þðèñäèêöèþ, ïîãîíÿ.')
                    elseif frak == 'SFPD' then
                        sampSendChat('/d LVPD, ïåðåñåêàþ âàøó þðèñäèêöèþ, ïîãîíÿ.')
                    elseif frak == 'LSPD' then
                        submenus_show(yrisdkld1406, '{9966CC}'..script.this.name..'{ffffff} | Ïåðåñå÷åíèå þðèñäèêöèè')
                    end
                end
                if post == 28 then
                    if frak == 'LVPD' then
                        sampSendChat('/d SFPD, ïåðåñåêàþ âàøó þðèñäèêöèþ, ïîãîíÿ.')
                    elseif frak == 'SFPD' then
                        sampSendChat('/d LVPD, ïåðåñåêàþ âàøó þðèñäèêöèþ, ïîãîíÿ.')
                    elseif frak == 'LSPD' then
                        submenus_show(yrisdkld1406, '{9966CC}'..script.this.name..'{ffffff} | Ïåðåñå÷åíèå þðèñäèêöèè')
                    end
                end
                if post == 29 then
                    if frak == 'LSPD' then
                        sampSendChat('/d SFPD, ïåðåñåêàþ âàøó þðèñäèêöèþ, ïîãîíÿ.')
                    elseif frak == 'SFPD' then
                        sampSendChat('/d LSPD, ïåðåñåêàþ âàøó þðèñäèêöèþ, ïîãîíÿ.')
                    elseif frak == 'LVPD' then
                        submenus_show(yrisdkld1404, '{9966CC}'..script.this.name..'{ffffff} | Ïåðåñå÷åíèå þðèñäèêöèè')
                    end
                end
                if post == 30 then
                    if frak == 'LSPD' then
                        sampSendChat('/d SFPD, ïåðåñåêàþ âàøó þðèñäèêöèþ, ïîãîíÿ.')
                    elseif frak == 'SFPD' then
                        sampSendChat('/d LSPD, ïåðåñåêàþ âàøó þðèñäèêöèþ, ïîãîíÿ.')
                    elseif frak == 'LVPD' then
                        submenus_show(yrisdkld1404, '{9966CC}'..script.this.name..'{ffffff} | Ïåðåñå÷åíèå þðèñäèêöèè')
                    end
                end
                if post == 31 then
                    if frak == 'LSPD' then
                        sampSendChat('/d SFPD, ïåðåñåêàþ âàøó þðèñäèêöèþ, ïîãîíÿ.')
                    elseif frak == 'SFPD' then
                        sampSendChat('/d LSPD, ïåðåñåêàþ âàøó þðèñäèêöèþ, ïîãîíÿ.')
                    elseif frak == 'LVPD' then
                        submenus_show(yrisdkld1404, '{9966CC}'..script.this.name..'{ffffff} | Ïåðåñå÷åíèå þðèñäèêöèè')
                    end
                end
            end)
        end
        if not isCharInAnyCar(PLAYER_PED) then
            if post ~= nil then
                if getNameSphere(post) ~= nil then
                    if not cfg.main.tarb then
                        sampSendChat('/r Ïîñò: '..getNameSphere(post)..'. '..naparnik())
                    else
                        sampSendChat('/r ['..cfg.main.tar..']: Ïîñò: '..getNameSphere(post)..'. '..naparnik())
                    end
                end
            end
        end
    end
end

function kmdc(pam)
    lua_thread.create(function()
        local id = tonumber(pam)
        if id ~= nil then
            if sampIsPlayerConnected(id) then
                sampSendChat(("/me %s ÊÏÊ è %s ôîòîãðàôèþ ÷åëîâåêà"):format(cfg.main.male and 'äîñòàë' or 'äîñòàëà', cfg.main.male and 'ñäåëàë' or 'ñäåëàëà'))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/do ÊÏÊ äàë èíôîðìàöèþ: Èìÿ: %s."):format(sampGetPlayerNickname(id):gsub('_', ' ')))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/mdc %s"):format(id))
                if cfg.commands.kmdctime then
                    wait(1400)
                    sampSendChat("/time")
                    wait(500)
                    setVirtualKeyDown(key.VK_F8, true)
                    wait(150)
                    setVirtualKeyDown(key.VK_F8, false)
                end
            else
                ftext("Èãðîê îôôëàéí")
            end
        else
            ftext("Ââåäèòå: /kmdc [id]")
        end
    end)
end

function fvz(pam)
    local id = tonumber(pam)
    local _, myid = sampGetPlayerIdByCharHandle(playerPed)
    if frak == 'FBI' then
        if id == nil then
            ftext("Ââåäèòå: /fvz [id]")
        end
        if id ~= nil and sampIsPlayerConnected(id) then
            lua_thread.create(function()
                warnst = true
                sampSendChat('/mdc '..id)
                wait(1400)
                if wfrac == 'LSPD' or wfrac == 'SFPD' or wfrac == 'LVPD' or wfrac == 'LVa' or wfrac == 'SFa' then
                    sampSendChat(string.format('/d %s, %s, ÿâèòåñü â îôèñ ÔÁÐ ñî ñòàðøèìè. Êàê ïðèíÿëè? Îòâåò íà ïäæ.%s', wfrac, sampGetPlayerNickname(id):gsub('_', ' '), myid))
                else
                    ftext('×åëîâåê íå ÿâëÿåòñÿ ñîòðóäíèêîì PD/Army')
                end
                warnst = false
                wfrac = nil
            end)
        end
    else
        ftext("Âû íå ñîòðóäíèê ÔÁÐ")
    end
end

function ftazer(pam)
    lua_thread.create(function()
        local id = tonumber(pam)
        if cfg.commands.ftazer then
            if id ~= nil then
                if id >=1 and id <=3 then
                    sampSendChat(("/me %s èç âíóòðåííåãî êàðìàíà áåðóøè"):format(cfg.main.male and 'äîñòàë' or 'äîñòàëà'))
                    wait(1400)
                    sampSendChat(("/me %s áåðóøè è %s"):format(cfg.main.male and 'íàäåë' or 'íàäåëà', cfg.main.male and 'çàæìóðèëñÿ' or 'çàæìóðèëàñü'))
                    wait(1400)
                    sampSendChat(("/me %s ñâåòîøóìîâóþ ãðàíàòó"):format(cfg.main.male and 'áðîñèë' or 'áðîñèëà'))
                    wait(1400)
                    sampSendChat(("/ftazer %s"):format(id))
                else
                    ftext("Çíà÷åíèå íå ìîæåò áûòü ìåíòøå 1 è áîëüøå 3!")
                end
            else
                ftext("Ââåäèòå: /ftazer [òèï]")
            end
        else
            sampSendChat(("/ftazer %s"):format(pam))
        end
    end)
end

function df()
    lua_thread.create(function()
        submenus_show(dfmenu, "{9966cc}"..script.this.name.." {ffffff}| Bomb Menu")
    end)
end

function fbd(pam)
    local id = tonumber(pam)
    if frak == 'FBI' then
        if id == nil then
            ftext("Ââåäèòå: /fbd [id]")
        end
        if id ~= nil and sampIsPlayerConnected(id) then
            lua_thread.create(function()
                local _, myid = sampGetPlayerIdByCharHandle(playerPed)
                warnst = true
                sampSendChat('/mdc '..id)
                wait(1400)
                if wfrac == 'LSPD' or wfrac == 'SFPD' or wfrac == 'LVPD' then
                    sampSendChat(string.format('/d %s, %s, Ïðè÷èíà èçìåíåíèÿ ÁÄ íà ï.%s', wfrac, sampGetPlayerNickname(id):gsub('_', ' '), myid))
                else
                    ftext('×åëîâåê íå ÿâëÿåòñÿ ñîòðóäíèêîì PD')
                end
                warnst = false
                wfrac = nil
            end)
        end
    else
        ftext("Âû íå ñîòðóäíèê ÔÁÐ")
    end
end

function cc()
    memory.fill(sampGetChatInfoPtr() + 306, 0x0, 25200)
    memory.write(sampGetChatInfoPtr() + 306, 25562, 4, 0x0)
    memory.write(sampGetChatInfoPtr() + 0x63DA, 1, 1)
end

function blg(pam)
    local id, frack, pric = pam:match('(%d+) (%a+) (.+)')
    if id and frack and pric and sampIsPlayerConnected(id) then
        name = sampGetPlayerNickname(id)
        rpname = name:gsub('_', ' ')
        sampSendChat(string.format("/d %s, áëàãîäàðþ %s çà %s. Öåíèòå", frack, rpname, pric))
    else
        ftext("Ââåäèòå: /blg [id] [Ôðàêöèÿ] [Ïðè÷èíà]", -1)
    end
end

function mcheck()
    peds = getAllChars()
    if peds ~= nil then
        local openw = io.open("moonloader/fbitools/mcheck.txt", 'a')
        openw:write('\n')
        openw:write(os.date()..'\n')
        openw:close()
        lua_thread.create(function()
            for _, hm in pairs(peds) do
                _ , id = sampGetPlayerIdByCharHandle(hm)
                _ , m = sampGetPlayerIdByCharHandle(PLAYER_PED)
                if id ~= -1 and id ~= m and doesCharExist(hm) and sampIsPlayerConnected(id) then
                    local x, y, z = getCharCoordinates(hm)
                    local mx, my, mz = getCharCoordinates(PLAYER_PED)
                    local dist = getDistanceBetweenCoords3d(mx, my, mz, x, y, z)
                    if dist <= 200 then
                        mcheckb = true
                        _ , idofplayercar = sampGetPlayerIdByCharHandle(hm)
                        sampSendChat('/mdc '..idofplayercar)
                        wait(1400)
                        mcheckb = false
                    end
                end
            end
        end)
    end
end

function dlog()
    sampShowDialog(97987, '{9966cc}'..script.this.name..' {ffffff} | Ëîã ñîîáùåíèé äåïàðòàìåíòà', table.concat(departament, '\n'), '»', 'x', 0)
end

function rlog()
    sampShowDialog(97987, '{9966cc}'..script.this.name..' {ffffff} | Ëîã ñîîáùåíèé ðàöèè', table.concat(radio, '\n'), '»', 'x', 0)
end

function sulog()
    sampShowDialog(97987, '{9966cc}'..script.this.name..' {ffffff} | Ëîã âûäà÷è ðîçûñêà', table.concat(wanted, '\n'), '»', 'x', 0)
end

function smslog()
    sampShowDialog(97987, '{9966cc}'..script.this.name..' {ffffff} | Ëîã SMS', table.concat(sms, '\n'), '»', 'x', 0)
end

function ticket(pam)
    lua_thread.create(function()
        local id, summa, reason = pam:match('(%d+) (%d+) (.+)')
        if id and summa and reason then
            if cfg.commands.ticket then
                sampSendChat(string.format("/me %s áëàíê è ðó÷êó", cfg.main.male and 'äîñòàë' or 'äîñòàëà'))
                wait(cfg.commands.zaderjka)
                sampSendChat("/do Áëàíê è ðó÷êà â ðóêàõ.")
                wait(cfg.commands.zaderjka)
                sampSendChat("/me íà÷èíàåò çàïîëíÿòü áëàíê")
                wait(cfg.commands.zaderjka)
                sampSendChat("/do Áëàíê çàïîëíåí.")
                wait(cfg.commands.zaderjka)
                sampSendChat(string.format("/me %s áëàíê íàðóøèòåëþ", cfg.main.male and 'ïåðåäàë' or 'ïåðåäàëà'))
                wait(1400)
            end
            sampSendChat(string.format('/ticket %s %s %s', id, summa, reason))
        else
            ftext('Ââåäèòå: /ticket [id] [ñóììà] [ïðè÷èíà]')
        end
    end)
end

function ssuz(pam)
    suz = {}
    local dsuz = {}
    for line in io.lines('moonloader\\fbitools\\su.txt') do
        table.insert(suz, line)
    end
    for k, v in pairs(suz) do
        table.insert(dsuz, string.format('{9966cc}%s. {ffffff}%s', k, v))
    end
    if pam:match('(%d+) (%d+)') then
        zid, zsu = pam:match('(%d+) (%d+)')
        if sampIsPlayerConnected(tonumber(zid)) then
            for k, v in pairs(suz) do
                if tonumber(zsu) == k then
                    local reas, zzv = v:match('(.+) %- (%d+) .+')
                    sampSendChat(string.format('/su %s %s %s', zid, zzv, reas))
                    zid = nil
                end
            end
        end
    elseif pam:match('(%d+)') then
        zid = pam:match('(%d+)')
        if sampIsPlayerConnected(tonumber(zid)) then
            sampShowDialog(1765, '{9966cc}'..script.this.name..' {ffffff}| Âûäà÷à ðîçûñêà èãðîêó {9966cc}'..sampGetPlayerNickname(tonumber(zid)).. '[' ..zid.. ']', table.concat(dsuz, '\n').. '\n\n{ffffff}Âûáåðèòå íîìåð äëÿ îáúÿâëåíèÿ â ðîçûñê. Ïðèìåð: 15', '»', 'x', 1)
        end
    elseif #pam == 0 then
        ftext('Ââåäèòå: /z [id] [ïàðàìåòð(íå îïöèîíàëüíî)]')
    end
end

function rt(pam)
    if #pam == 0 then
        ftext("Ââåäèòå /rt [òåêñò]")
    else
        sampSendChat('/r '..pam)
    end
end

function ooplist(pam)
    lua_thread.create(function()
        local oopid = tonumber(pam)
        if oopid ~= nil and sampIsPlayerConnected(oopid) then
            for k, v in pairs(ooplistt) do
                sampSendChat('/sms '..oopid..' '..v)
                wait(1400)
            end
        else
            sampShowDialog(2458, '{9966cc}'..script.this.name..' | {ffffff}Ñïèñîê ÎÎÏ', table.concat(ooplistt, '\n'), '»', "x", 2)
            ftext('Äëÿ îòïðàâêè ñïèñêà ÎÎÏ àäâîêàòó ââåäèòå /ooplist [id]')
        end
    end)
end

function fkv(pam)
    if #pam ~= 0 then
        kvadY, kvadX = string.match(pam, "(%A)-(%d+)")
        if kvadrat(kvadY) ~= nil and kvadX ~= nil and kvadY ~= nil and tonumber(kvadX) < 25 and tonumber(kvadX) > 0 then
            last = lcs
            coordX = kvadX * 250 - 3125
            coordY = (kvadrat1(kvadY) * 250 - 3125) * - 1
        end
    else
        ftext('Ââåäèòå: /fkv [êâàäðàò]')
        ftext('Ïðèìåð: /fkv Ë-6')
    end
end

function fnr()
    lua_thread.create(function()
        vixodid = {}
		fnrstatus = true
		sampSendChat('/members')
        while not gotovo do wait(0) end
        wait(1400)
        for k, v in pairs(vixodid) do
            sampSendChat('/sms '..v..' Íà ðàáîòó')
            wait(1400)
        end
		gotovo = false
        status = false
	end)
end

function strobes()
	while true do
		if isCharInAnyCar(PLAYER_PED) and not isCharInAnyBoat(PLAYER_PED) and not isCharInFlyingVehicle(PLAYER_PED) and not isCharOnAnyBike(PLAYER_PED) and not isCharInAnyTrain(PLAYER_PED) then
			if cfg.main.strobs then
				local car = storeCarCharIsInNoSave(PLAYER_PED)
				if doesVehicleExist(car) then
					local veh_struct = getCarPointer(car) + 1440
					if isCarSirenOn(car) then
						callMethod(0x6C2100, veh_struct, 2, 1, 0, 1)
						callMethod(0x6C2100, veh_struct, 2, 1, 1, 0)
						wait(300)
						callMethod(0x6C2100, veh_struct, 2, 1, 0, 0)
						callMethod(0x6C2100, veh_struct, 2, 1, 1, 1)
					else
						callMethod(0x6C2100, veh_struct, 2, 1, 0, 0)
						callMethod(0x6C2100, veh_struct, 2, 1, 1, 0)
					end
				end
			end
		end
		wait(300)
	end
end
function screen() local memory = require 'memory' memory.setuint8(sampGetBase() + 0x119CBC, 1) end

function Player:new(id, sRang, iRang, status, invite, afk, sec, nick)
	local obj = {
		id = id,
		nickname = nick,
		iRang = tonumber(iRang),
		sRang = u8(sRang),
		status = u8(status),
		invite = invite,
		afk = afk,
		sec = tonumber(sec)
	}

	setmetatable(obj, self)
	self.__index = self

	return obj
end
function getColorForSeconds(sec)
	if sec > 0 and sec <= 50 then
		return imgui.ImVec4(1, 1, 0, 1)
	elseif sec > 50 and sec <= 100 then
		return imgui.ImVec4(1, 159/255, 32/255, 1)
	elseif sec > 100 and sec <= 200 then
		return imgui.ImVec4(1, 93/255, 24/255, 1)
	elseif sec > 200 and sec <= 300 then
		return imgui.ImVec4(1, 43/255, 43/255, 1)
	elseif sec > 300 then
		return imgui.ImVec4(1, 0, 0, 1)
	end
end
function getColor(ID)
	PlayerColor = sampGetPlayerColor(ID)
	a, r, g, b = explode_argb(PlayerColor)
	return r/255, g/255, b/255, 1
end
function explode_argb(argb)
    local a = bit.band(bit.rshift(argb, 24), 0xFF)
    local r = bit.band(bit.rshift(argb, 16), 0xFF)
    local g = bit.band(bit.rshift(argb, 8), 0xFF)
    local b = bit.band(argb, 0xFF)
    return a, r, g, b
end

function pr()
    lua_thread.create(function()
        sampSendChat("Âû àðåñòîâàíû, ó âàñ åñòü ïðàâî õðàíèòü ìîë÷àíèå. Âñ¸, ÷òî âû ñêàæåòå, ìîæåò è áóäåò èñïîëüçîâàíî ïðîòèâ âàñ â ñóäå.")
        wait(cfg.commands.zaderjka)
        sampSendChat("Ó âàñ åñòü ïðàâî íà àäâîêàòà è íà îäèí òåëåôîííûé çâîíîê. Âàì ïîíÿòíû âàøè ïðàâà?")
    end)
end

function getCompl()
    local t = {}
    if cfg.autobp.armour then table.insert(t, 5) end
    if cfg.autobp.spec then table.insert(t, 6) end
    if cfg.autobp.deagle then 
        table.insert(t, 0)
        if cfg.autobp.dvadeagle then table.insert(t, 0) end
    end
    if cfg.autobp.shot then 
        table.insert(t, 1)
        if cfg.autobp.dvashot then table.insert(t, 1) end
    end
    if cfg.autobp.smg then 
        table.insert(t, 2)
        if cfg.autobp.dvasmg then table.insert(t, 2) end
    end
    if cfg.autobp.m4 then 
        table.insert(t, 3)
        if cfg.autobp.dvam4 then table.insert(t, 3) end
    end
    if cfg.autobp.rifle then 
        table.insert(t, 4)
        if cfg.autobp.dvarifle then table.insert(t, 4) end
    end
    return t
end

function getAmmoInClip()
	local struct = getCharPointer(PLAYER_PED)
	local prisv = struct + 0x0718
	local prisv = memory.getint8(prisv, false)
	local prisv = prisv * 0x1C
	local prisv2 = struct + 0x5A0
	local prisv2 = prisv2 + prisv
	local prisv2 = prisv2 + 0x8
	local ammo = memory.getint32(prisv2, false)
	return ammo
end

function getFreeCost(lvl)
	if lvl >= 1 and lvl <= 2 then cost = 1000 end
	if lvl >= 3 and lvl <= 6 then cost = 3000 end
	if lvl >= 7 and lvl <= 13 then cost = 6000 end
	if lvl >= 14 and lvl <= 23 then cost = 9000 end
	if lvl >= 24 and lvl <= 35 then cost = 14000 end
	if lvl >= 36 then cost = 15000 end
	return cost
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

function registerCommandsBinder()
    for k, v in pairs(commands) do
        if sampIsChatCommandDefined(v.cmd) then sampUnregisterChatCommand(v.cmd) end
        sampRegisterChatCommand(v.cmd, function(pam)
            lua_thread.create(function()
                local params = string.split(pam, " ", v.params)
                local cmdtext = v.text
                if #params < v.params then
                    local paramtext = ""
                    for i = 1, v.params do
                        paramtext = paramtext .. "[ïàðàìåòð"..i.."] "
                    end
                    ftext("Ââåäèòå: /"..v.cmd.." "..paramtext, -1)
                else
                    for line in cmdtext:gmatch('[^\r\n]+') do

                        if line:match("^{wait%:%d+}$") then
                            wait(line:match("^%{wait%:(%d+)}$"))
                        elseif line:match("^{screen}$") then
                            screen()
                        else
                            local bIsEnter = string.match(line, "^{noe}(.+)") ~= nil
                            local bIsF6 = string.match(line, "^{f6}(.+)") ~= nil
                            local keys = {
                                ["{f6}"] = "",
                                ["{noe}"] = "",
                                ["{myid}"] = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)),
                                ["{kv}"] = kvadrat(),
                                ["{targetid}"] = targetid,
                                ["{targetrpnick}"] = sampGetPlayerNicknameForBinder(targetid):gsub('_', ' '),
                                ["{naparnik}"] = naparnik(),
                                ["{myrpnick}"] = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub("_", " "),
                                ["{smsid}"] = smsid,
                                ["{smstoid}"] = smstoid,
                                ["{rang}"] = rang,
                                ["{frak}"] = frak,
                                ["{megafid}"] = gmegafid,
                                ["{dl}"] = mcid
                            }
                            for k1, v1 in pairs(keys) do
                                line = line:gsub(k1, v1)
                            end

                            if not bIsEnter then
                                if bIsF6 then
                                    sampProcessChatInput(line)
                                else
                                    sampSendChat(line)
                                end
                            else
                                sampSetChatInputText(line)
                                sampSetChatInputEnabled(true)
                            end
                        end
                    end
                end
            end)
        end)
    end
end
