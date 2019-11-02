script_name("FBI Tools")
script_authors("Thomas Lawson, Sesh Jefferson")
script_version(2.6)

require 'lib.moonloader'
require 'lib.sampfuncs'

local lsg, sf               = pcall(require, 'sampfuncs')
local lkey, key             = pcall(require, 'vkeys')
local lsampev, sp           = pcall(require, 'lib.samp.events')
local lsphere, Sphere       = pcall(require, 'Sphere')
local lrkeys, rkeys         = pcall(require, 'rkeys')
local limadd, imadd         = pcall(require, 'imgui_addons')
local dlstatus              = require('moonloader').download_status
local limgui, imgui         = pcall(require, 'imgui')
local lrequests, requests   = pcall(require, 'requests')
local wm                    = require 'lib.windows.message'
local gk                    = require 'game.keys'
local encoding              = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

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
    sInputEdit      = imgui.ImBuffer(256)
    bIsEnterEdit    = imgui.ImBool(false)
    local show      = 1
    piew            = imgui.ImBool(false)
    imegaf          = imgui.ImBool(false)
    bindname        = imgui.ImBuffer(256)
    bindtext        = imgui.ImBuffer(10240)
end

function ftext(text)
    sampAddChatMessage((' %s | {ffffff}%s'):format(script.this.name, text),0x9966CC)
end

local cfg =
{
    main = {
        posX = 1566,
        posY = 916,
        widehud = 350,
        male = true,
        wanted = false,
        clear = false,
        hud = false,
        tar = '���',
        parol = '������',
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
        megaf = true
    },
    commands = {
        cput = true,
        ceject = true,
        deject = true,
        ftazer = true,
        zaderjka = 1400,
        ticket = true,
        kmdctime = true
    }
}

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
    sirenkey = { v = {}}
}

local mcheckb = false
local stazer = false
local rabden = false
local frak = -1
local rang = -1
local wfrac = nil
local warnst = false
local changetextpos = false
local opyatstat = false
local gmegafhandle = nil
local gmegafid = -1
local gmegaflvl = nil
local gmegaffrak = nil
local gmegafcar = nil
local targetid = -1
local smsid = -1
local smstoid = -1
local nikk = nil
local ttt = nil
local vixodid = {}
local ooplistt = {}
local tLastKeys = {}
local departament = {}
local radio = {}
local sms = {}
local wanted = {}
local incar = {}
local suz = {}
local show = 1
local zid = nil
local checkstat = false
local fileb = getWorkingDirectory() .. "\\config\\fbitools.bind"
local players1 = {'{ffffff}���\t{ffffff}����'}
local players2 = {'{ffffff}���\t{ffffff}����\t{ffffff}������'}
local tBindList = {}
local fthelp = {
    {
        cmd = '/ft',
        desc = '������� ���� �������',
        use = '/ft'
    },
    {
        cmd = '/st',
        desc = '��������� ������ ��������� ���� �/� ����� ������� [/m]',
        use = '/st [id]'
    },
    {
        cmd = '/oop',
        desc = '�������� � ����� ������������ �� ���',
        use = '/oop [id]'
    },
    {
        cmd = '/warn',
        desc = '������������ ������ � ����� ������������ � ��������� ������ � ������',
        use = '/warn [id]'
    },
    {
        cmd = '/su',
        desc = '������ ������ ����� ������',
        use = '/su [id]'
    },
    {
        cmd = '/ssu',
        desc = '������ ������ ����� ��������� �������',
        use = '/ssu [id] [���-�� �����] [�������]'
    },
    {
        cmd = '/cput',
        desc = '�� ��������� ������� ����������� � ����������/����',
        use = '/cput [id] [�������(�� �����������)]'
    },
    {
        cmd = '/ceject',
        desc = '�� ��������� ������� ����������� �� ����������/����',
        use = '/ceject [id]'
    },
    {
        cmd = '/deject',
        desc = '�� ��������� ������������ ����������� �� ����������/����',
        use = '/deject [id]'
    },
    {
        cmd = '/ms',
        desc = '�� ��������� ������ ����������',
        use = '/ms [���]'
    },
    {
        cmd = '/keys',
        desc = "�� ��������� ��������� ������ �� ���",
        use = '/keys'
    },
    {
        cmd = '/rh',
        desc = "��������� ���������� ������ � ������� �������",
        use = "/rh [�����������(1 - LSPD, 2 - SFPD, 3 - LVPD)]"
    },
    {
        cmd = '/tazer',
        desc = "�� �����",
        use = '/tazer'
    },
    {
        cmd = "/gr",
        desc = "�������� � ����� ������������ � ����������� ����������",
        use = "/gr [�����������(1 - LSPD, 2 - SFPD, 3 - LVPD)] [�������]"
    },
    {
        cmd = '/df',
        desc = "������� ������ � ��������������� ����",
        use = '/df'
    },
    {
        cmd = '/dmb',
        desc = '������� /members � �������',
        use = '/dmb'
    },
    {
        cmd = '/ar',
        desc = '��������� ���������� �� ����� �� ������� ���������� � ����� ������������',
        use = '/ar [�����(1 - LVA, 2 - SFA)]'
    },
    {
        cmd = '/kmdc',
        desc = '�� �� ������� ������ � ���',
        use = '/kmdc [id]'
    },
    {
        cmd = '/ftazer',
        desc = '�� ��������� /ftazer',
        use = '/ftazer [���]'
    },
    {
        cmd = '/fvz',
        desc = '������� ������ � ���� ��� �� ��������',
        use = '/fvz [id]'
    },
    {
        cmd = '/fbd',
        desc = '��������� ������� ��������� �� �� ����� ������������',
        use = '/fbd [id]'
    },
    {
        cmd = '/blg',
        desc = '�������� ������������� �� ����� ������������',
        use = "/blg [id] [�������] [�������]"
    },
    {
        cmd = '/yk',
        desc = "������� ����� �� (����� ����� ����� �������� � ����� moonloader/fbitools/yk.txt)",
        use = "/yk"
    },
    {
        cmd = '/ak',
        desc = "������� ����� �� (����� ����� ����� �������� � ����� moonloader/fbitools/ak.txt)",
        use = "/ak"
    },
    {
        cmd = '/fp',
        desc = "������� ����� �� (����� ����� ����� �������� � ����� moonloader/fbitools/fp.txt)",
        use = "/fp"
    },
    {
        cmd = '/shp',
        desc = "������� ����� (����� ����� ����� �������� � ����� moonloader/fbitools/shp.txt)",
        use = "/shp"
    },
    {
        cmd = '/fyk',
        desc = '����� �� ����� ��',
        use = '/fyk [�����]'
    },
    {
        cmd = '/fak',
        desc = '����� �� ����� ��',
        use = '/fak [�����]'
    },
    {
        cmd = '/ffp',
        desc = '����� �� ����� ��',
        use = '/ffp [�����]'
    },
    {
        cmd = '/fshp',
        desc = '����� �� �����',
        use = '/fshp [�����]'
    },
    {
        cmd = '/fst',
        desc = '�������� �����',
        use = '/fst [�����]'
    },
    {
        cmd = '/fsw',
        desc = '�������� ������',
        use = '/fsw [������]'
    },
    {
        cmd = '/cc',
        desc = '�������� ���',
        use = '/cc'
    },
    {
        cmd = '/dkld',
        desc = '������� ������',
        use = '/dkld'
    },
    {
        cmd = '/mcheck',
        desc = '������� �� /mdc ���� �� ���������� 200 ������',
        use = '/mcheck'
    },
    {
        cmd = '/megaf',
        desc = '������� � ����������������� ����',
        use = '/megaf'
    },
    {
        cmd = '/rlog',
        desc = '������� ��� 25 ��������� ��������� � �����',
        use = '/rlog'
    },
    {
        cmd = '/dlog',
        desc = '������� ��� 25 ��������� ��������� � �����������',
        use = '/dlog'
    },
    {
        cmd = '/sulog',
        desc = '������� ��� 25 ��������� ������ �������',
        use = '/sulog'
    },
    {
        cmd = '/smslog',
        desc = '������� ��� 25 ��������� SMS',
        use = '/smslog'
    },
    {
        cmd = '/z',
        desc = '������ ������ �� ������������ �������',
        use = '/z [id] [��������(�� �����������)]'
    },
    {
        cmd = '/rt',
        desc = '��������� � ����� ��� ����',
        use = '/rt [�����]'
    },
    {
        cmd = '/ooplist',
        desc = '������ ���',
        use = '/ooplist [id(�� �����������)]'
    },
    {
        cmd = '/fkv',
        desc = '��������� ����� �� ������� �� �����',
        use = '/fkv [�������]'
    },
    {
        cmd = '/fnr',
        desc = '������� ����������� �� ������',
        use = '/fnr'
    }
}
local tEditData = {
	id = -1,
	inputActive = false
}
local quitReason = {
    [1] = '�����',
    [2] = '���/���',
    [0] = '����/�����'
}
local sut = [[
��������� �������� ����������� - 2 ����
����������� ��������� �� ����������� - 3 ����
����������� ��������� �� ��� - 6 ���, ������ �� ��������
����������� - 1 ���
������������ ��������� - 1 ���
���������������� - 1 ���
����������� - 2 ����
���� ������������� �������� - 2 ����
������������ ����������� �� - 1 ���
���� �� ����������� �� - 2 ����
����� � ����� ���������� - 6 ���
������� ������ ��� �������� - 1 ��� � ����� � ������� 2000$.
������������ ������������ ������ - 3 ���� � �������
������������ ������������ ������ - 3 ���� � �������
������� ������������ ������ - 3 ���� � �������
�������� ���������� - 3 ���� � �������
�������� ���������� - 3 ���� � �������
������������ ���������� - 3 ���� � �������
����� ������ ��������� - 1 ��� � ����� � ������� 5000$
����������� ������ ��������� - 4 ���� � ����� � ������� 15000$
������������� �� ���. ���������� - 2 ����
������������� �� ����. ���������� - 1 ���
�������������� - 2 ����
������ - 1 ���
���������� - 2 ����
������������� - 2 ����
����������� �������� ����� - 1 ���
������������� ���������� - 3 ���
�������������� ������������ - 2 ����
������������� ��������� ���������� - 1 ���
������� �� ���. ���� - 1 ���
������� �� ���. ����������� - 2 ����
������� ������� ����� - 2 ����, ����� �������� �������.
������� ������ �� ������ - 6 ���
����������� ������ - 2 ����
���������� ������� - 6 ���, ������� ���� ��������
�������� ������ - 2 ����
������������� ����. ����� - 1 ���
���������� ���������� �������� - 3 ����
��������� ���. ���������� - 4 ����
�������������� ��������� - 1 ���
����� �� �������� - 2 ����
���� � ����� ��� - 3 ����
���������� - 3 ����
��� - 6 ���
���� - 6 ���
]]

local shpt = [[
���� ��� �� �� ��������� �����.
��� �� �������� ���� ���� ����� ��� ����� ��������� ��� ��������:
1. ������� ����� fbitools ������� ��������� � ����� moonloader
2. ������� ���� shp.txt ����� ���������
3. �������� ����� � ��� �� ����� ��� �����
4. ��������� ����
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
    if isCharInAnyCar(PLAYER_PED) then
        local car = storeCarCharIsInNoSave(PLAYER_PED)
        switchCarSiren(car, not isCarSirenOn(car))
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
            if dist < minDist and sampGetFraktionBySkin(i) ~= '�������' and sampGetFraktionBySkin(i) ~= 'FBI' then
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
            if dist < minDist and sampGetFraktionBySkin(i) ~= '�������' and sampGetFraktionBySkin(i) ~= 'FBI' and isCharInAnyCar(pedID) then
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
            if dist < minDist and sampGetFraktionBySkin(i) ~= '�������' and sampGetFraktionBySkin(i) ~= 'FBI' and isCharInAnyCar(pedID) then
                minDist = dist
                closestId = i
            end
        end
    end
    return closestId
end

function cuffk()
    local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
    if valid then
        result, targetid = sampGetPlayerIdByCharHandle(ped)
        if result then
            lua_thread.create(function()
                sampSendChat(string.format('/me %s ���� ����������� � %s ���������', cfg.main.male and '�������' or '��������', cfg.main.male and '������' or '�������'))
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
                    sampSendChat(string.format('/me %s ���� ����������� � %s ���������', cfg.main.male and '�������' or '��������', cfg.main.male and '������' or '�������'))
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

function uncuffk()
    local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
    if valid then
        local result, targetid = sampGetPlayerIdByCharHandle(ped)
        if result then
            lua_thread.create(function()
                sampSendChat(string.format('/me %s ��������� � �����������', cfg.main.male and '����' or '�����'))
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
                        sampSendChat(string.format('/me %s ��������� � �����������', cfg.main.male and '����' or '�����'))
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

function followk()
    local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
    if valid then
        result, targetid = sampGetPlayerIdByCharHandle(ped)
        if result then
            lua_thread.create(function()
                sampSendChat(string.format('/me %s ���� �� ������ ���������� � ����, ����� ���� %s �� ����� �����������', cfg.main.male and '����������' or '�����������', cfg.main.male and '�����' or '������'))
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
                    sampSendChat(string.format('/me %s ���� �� ������ ���������� � ����, ����� ���� %s �� ����� �����������', cfg.main.male and '����������' or '�����������', cfg.main.male and '�����' or '������'))
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

function cputk()
    local closeid = getClosestPlayerId()
    if closeid ~= -1 then
        local result, closehandle = sampGetCharHandleBySampPlayerId(closeid)
        if doesCharExist(closehandle) then
            lua_thread.create(function()
                if isCharOnAnyBike(PLAYER_PED) then
                    sampSendChat(string.format("/me %s ����������� �� ������� ���������", cfg.main.male and '�������' or '��������'))
                    wait(1400)
                    sampSendChat("/cput "..closeid.." 1", -1)
                else
                    sampSendChat(string.format("/me %s ����� ���������� � %s ���� �����������", cfg.main.male and '������' or '�������', cfg.main.male and '���������' or '����������'))
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

function cejectk()
    if isCharInAnyCar(PLAYER_PED) then
        local closestId = getClosestPlayerIDinCar()
        if closestId ~= -1 then
            local result, closehandle = sampGetCharHandleBySampPlayerId(closestId)
            lua_thread.create(function()
                if isCharOnAnyBike(PLAYER_PED) then
                    sampSendChat(string.format("/me %s ����������� � ���������", cfg.main.male and '�������' or '��������'))
                    wait(1400)
                    sampSendChat("/ceject "..closestId, -1)
                else
                    sampSendChat(string.format("/me %s ����� ���������� � %s �����������", cfg.main.male and '������' or '������', cfg.main.male and '�������' or '��������'))
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

function takek()
    local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
    if valid then
        result, targetid = sampGetPlayerIdByCharHandle(ped)
        if result then
            lua_thread.create(function()
                sampSendChat(string.format('/me ����� ��������, %s ������ �� �����', cfg.main.male and '������' or '�������'))
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
                    sampSendChat(string.format('/me ����� ��������, %s ������ �� �����', cfg.main.male and '������' or '�������'))
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

function arrestk()
    local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
    if valid then
        result, targetid = sampGetPlayerIdByCharHandle(ped)
        if result then
            lua_thread.create(function()
                sampSendChat(string.format('/me %s ������', cfg.main.male and '������' or '�������'))
                wait(cfg.commands.zaderjka)
                sampSendChat(string.format('/me %s ����������� � ������', cfg.main.male and '������' or '�������'))
                wait(cfg.commands.zaderjka)
                sampSendChat('/arrest '..targetid)
                wait(cfg.commands.zaderjka)
                sampSendChat(string.format('/me %s ������', cfg.main.male and '������' or '�������'))
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
                    sampSendChat(string.format('/me %s ������', cfg.main.male and '������' or '�������'))
                    wait(cfg.commands.zaderjka)
                    sampSendChat(string.format('/me %s ����������� � ������', cfg.main.male and '������' or '�������'))
                    wait(cfg.commands.zaderjka)
                    sampSendChat('/arrest '..closeid)
                    wait(cfg.commands.zaderjka)
                    sampSendChat(string.format('/me %s ������', cfg.main.male and '������' or '�������'))
                    gmegafhandle = nil
                    gmegafid = -1
                    gmegaflvl = nil
                    gmegaffrak = nil
                end)
            end
        end
    end
end

function dejectk()
    local closestId = getClosestPlayerIDinCarD()
    if closestId ~= -1 then
        local result, closehandle = sampGetCharHandleBySampPlayerId(closestId)
        if result then
            lua_thread.create(function()
                if isCharInFlyingVehicle(closehandle) then
                    sampSendChat(string.format("/me %s ����� �������� � %s �����������", cfg.main.male and '������' or '�������', cfg.main.male and '�������' or '��������'))
                    wait(1400)
                    sampSendChat("/deject "..closestId)
                elseif isCharInModel(closehandle, 481) or isCharInModel(closehandle, 510) then
                    sampSendChat(string.format("/me ������ ����������� � ����������", cfg.main.male and '������' or '�������'))
                    wait(1400)
                    sampSendChat("/deject "..closestId)
                elseif isCharInModel(closehandle, 462) then
                    sampSendChat(string.format("/me %s ����������� �� �������", cfg.main.male and '������' or '�������'))
                    wait(1400)
                    sampSendChat("/deject "..closestId)
                elseif isCharOnAnyBike(closehandle) then
                    sampSendChat(string.format("/me %s ����������� � ���������", cfg.main.male and '������' or '�������'))
                    wait(1400)
                    sampSendChat("/deject "..closestId)
                elseif isCharInAnyCar(closehandle) then
                    sampSendChat(string.format("/me %s ���� � %s ����������� �� ������", cfg.main.male and '������' or '�������', cfg.main.male and '���������' or '����������'))
                    wait(1400)
                    sampSendChat("/deject "..closestId)
                end
            end)
        end
    end
end

function sampGetFraktionBySkin(id)
    local t = '�����������'
    if sampIsPlayerConnected(id) then
        local result, ped = sampGetCharHandleBySampPlayerId(id)
        if result then
            local skin = getCharModel(ped)
            if skin == 102 or skin == 103 or skin == 104 or skin == 195 or skin == 21 then t = 'Ballas Gang' end
            if skin == 105 or skin == 106 or skin == 107 or skin == 269 or skin == 270 or skin == 271 or skin == 86 or skin == 149 or skin == 297 then t = 'Grove Gang' end
            if skin == 108 or skin == 109 or skin == 110 or skin == 190 or skin == 47 then t = 'Vagos Gang' end
            if skin == 114 or skin == 115 or skin == 116 or skin == 48 or skin == 44 or skin == 41 or skin == 292 then t = 'Aztec Gang' end
            if skin == 173 or skin == 174 or skin == 175 or skin == 193 or skin == 226 or skin == 30 or skin == 119 then t = 'Rifa Gang' end
            if skin == 191 or skin == 252 or skin == 287 or skin == 61 or skin == 179 or skin == 255 then t = 'Army' end
            if skin == 57 or skin == 98 or skin == 147 or skin == 150 or skin == 187 or skin == 216 then t = '�����' end
            if skin == 59 or skin == 172 or skin == 189 or skin == 240 then t = '���������' end
            if skin == 201 or skin == 247 or skin == 248 or skin == 254 or skin == 248 or skin == 298 then t = '�������' end
            if skin == 272 or skin == 112 or skin == 125 or skin == 214 or skin == 111  or skin == 126 then t = '������� �����' end
            if skin == 113 or skin == 124 or skin == 214 or skin == 223 then t = 'La Cosa Nostra' end
            if skin == 120 or skin == 123 or skin == 169 or skin == 186 then t = 'Yakuza' end
            if skin == 211 or skin == 217 or skin == 250 or skin == 261 then t = 'News' end
            if skin == 70 or skin == 219 or skin == 274 or skin == 275 or skin == 276 or skin == 70 then t = '������' end
            if skin == 286 or skin == 141 or skin == 163 or skin == 164 or skin == 165 or skin == 166 then t = 'FBI' end
            if skin == 280 or skin == 265 or skin == 266 or skin == 267 or skin == 281 or skin == 282 or skin == 288 or skin == 284 or skin == 285 or skin == 304 or skin == 305 or skin == 306 or skin == 307 or skin == 309 or skin == 283 or skin == 303 then t = '�������' end
        end
    end
    return t
end

function sampGetPlayerIdByNickname(nick)
    local _, myid = sampGetPlayerIdByCharHandle(playerPed)
    if tostring(nick) == sampGetPlayerNickname(myid) then return myid end
    for i = 0, 1000 do if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == tostring(nick) then return i end end
end

function getMaskList(forma)
	local mask = {
		['������������'] = 0,
		['������������'] = 1,
		['��������'] = 2,
		['�����������'] = 3,
		['������'] = 3,
		['���������� �����'] = 4,
		['��������� ���������'] = 5,
		['��������� ��������'] = 6,
		['��� LCN'] = 7,
		['��� Yakuza'] = 8,
		['��� Russian Mafia'] = 9,
		['�� Rifa'] = 10,
		['�� Grove'] = 11,
		['�� Ballas'] = 12,
		['�� Vagos'] = 13,
		['�� Aztec'] = 14,
		['��������'] = 15
	}
	return mask[forma]
end

local russian_characters = {
    [168] = '�', [184] = '�', [192] = '�', [193] = '�', [194] = '�', [195] = '�', [196] = '�', [197] = '�', [198] = '�', [199] = '�', [200] = '�', [201] = '�', [202] = '�', [203] = '�', [204] = '�', [205] = '�', [206] = '�', [207] = '�', [208] = '�', [209] = '�', [210] = '�', [211] = '�', [212] = '�', [213] = '�', [214] = '�', [215] = '�', [216] = '�', [217] = '�', [218] = '�', [219] = '�', [220] = '�', [221] = '�', [222] = '�', [223] = '�', [224] = '�', [225] = '�', [226] = '�', [227] = '�', [228] = '�', [229] = '�', [230] = '�', [231] = '�', [232] = '�', [233] = '�', [234] = '�', [235] = '�', [236] = '�', [237] = '�', [238] = '�', [239] = '�', [240] = '�', [241] = '�', [242] = '�', [243] = '�', [244] = '�', [245] = '�', [246] = '�', [247] = '�', [248] = '�', [249] = '�', [250] = '�', [251] = '�', [252] = '�', [253] = '�', [254] = '�', [255] = '�',
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
        title = '����� � ������� ����������',
        onclick = function()
            sampSendChat(("/me %s �������� �����"):format(cfg.main.male and '������' or '�������'))
            wait(3500)
            sampSendChat(("/me %s �������� �����"):format(cfg.main.male and '������' or '�������'))
            wait(3500)
            sampSendChat(("/me %s �������� ����������"):format(cfg.main.male and '��������' or '���������'))
            wait(3500)
            sampSendChat(("/do %s ��� ��������� ����������. ����� � ������� ����������."):format(cfg.main.male and '���������' or '����������'))
            wait(3500)
            sampSendChat(("/do %s ��� ������� ��������� � ���������."):format(cfg.main.male and '������' or '�������'))
            wait(3500)
            sampSendChat(("/me %s ��� �� ��������� ������"):format(cfg.main.male and '������' or '�������'))
            wait(3500)
            sampSendChat(("/me ��������� %s ������ ������"):format(cfg.main.male and '��������' or '���������'))
            wait(3500)
            sampSendChat(("/try %s �������� � ����������� � %s ���� �������� � �������� �������"):format(cfg.main.male and '������' or '�������', cfg.main.male and '���������' or '����������'))
        end
    },
    {
        title = '����� � ������� ���������� ���� {63c600}[������]',
        onclick = function()
            sampSendChat(("/me %s ��������"):format(cfg.main.male and '���������' or '����������'))
            wait(3500)
            sampSendChat(("/me %s � ����������"):format(cfg.main.male and '�����������' or '������������'))
            wait(3500)
            sampSendChat("/do �������� �������� �������� �������� �����.")
            wait(3500)
            sampSendChat("/do ����� �����������.")
            wait(3500)
            sampSendChat(("/me %s ����������� ������� � �������� �����"):format(cfg.main.male and '������' or '�������'))
            wait(3500)
            sampSendChat(("/me %s ������������� ���� � ��������� %s ���� �����"):format(cfg.main.male and '������' or '�������', cfg.main.male and '������' or '�������'))
        end
    },
    {
        title = '����� � ������� ���������� ���� {bf0000}[��������]',
        onclick = function()
            sampSendChat(("/me ��������� %s ������ ������"):format(cfg.main.male and '��������' or '���������'))
            wait(3500)
            sampSendChat(("/me %s ��������"):format(cfg.main.male and '���������' or '����������'))
            wait(3500)
            sampSendChat(("/me %s � ����������"):format(cfg.main.male and '�����������' or '������������'))
            wait(3500)
            sampSendChat("/do �������� �������� �������� �������� �����.")
            wait(3500)
            sampSendChat("/do ����� �����������.")
            wait(3500)
            sampSendChat(("/me %s ����������� ������� � �������� �����"):format(cfg.main.male and '������' or '�������'))
            wait(3500)
            sampSendChat(("/me %s ������������� ���� � ��������� %s ���� �����"):format(cfg.main.male and '������' or '�������', cfg.main.male and '������' or '�������'))
        end
    },
    {
        title = '����� � ������������� �����������',
        onclick = function()
            sampSendChat(("/me %s �������� �����"):format(cfg.main.male and '������' or '�������'))
            wait(3500)
            sampSendChat(("/me %s �������� �����"):format(cfg.main.male and '������' or '�������'))
            wait(3500)
            sampSendChat(("/me %s �������� ����������"):format(cfg.main.male and '��������' or '���������'))
            wait(3500)
            sampSendChat(("/do %s ��� ��������� ����������. ����� � ������������� �����������."):format(cfg.main.male and '���������' or '����������'))
            wait(3500)
            sampSendChat(("/do %s ��� ������ �� ����� � ����������."):format(cfg.main.male and '������' or '�������'))
            wait(3500)
            sampSendChat(("/me %s �������� �� ��������� ������"):format(cfg.main.male and '������' or '�������'))
            wait(3500)
            sampSendChat("/me ��������� ����������� �����")
            wait(3500)
            sampSendChat(("/me %s ������ ����� � %s �������"):format(cfg.main.male and '���������' or '����������', cfg.main.male and '������' or '�������'))
            wait(3500)
            sampSendChat(("/do %s ������� �������� ���������."):format(cfg.main.male and '������' or '�������'))
            wait(3500)
            sampSendChat(("/me %s ���� ���������� �� ������� � ����������"):format(cfg.main.male and '����������' or '�����������'))
            wait(3500)
            sampSendChat(("/me %s ��� �������"):format(cfg.main.male and '������' or '�������'))
            wait(3500)
            sampSendChat(("/try %s ������ ������. ��������� �������� ������."):format(cfg.main.male and '���������' or '����������'))
        end
    },
    {
        title = '����� � ������������� ����������� ���� {63c600}[������]',
        onclick = function()
            sampSendChat("/do ����� �����������.")
            wait(3500)
            sampSendChat(("/me %s ����������� ������� � �������� �����"):format(cfg.main.male and '������' or '�������'))
            wait(3500)
            sampSendChat(("/me %s ������������� ���� � ��������� %s ���� �����"):format(cfg.main.male and '������' or '�������', cfg.main.male and '������' or '�������'))
        end
    },
    {
        title = '����� � ������������� ����������� ���� {bf0000}[��������]',
        onclick = function()
            sampSendChat(("/me %s ������ ������"):format(cfg.main.male and '���������' or '����������'))
            wait(3500)
            sampSendChat("/do ��������� �������� ������.")
            wait(3500)
            sampSendChat("/do ����� �����������.")
            wait(3500)
            sampSendChat(("/me %s ����������� ������� � �������� �����"):format(cfg.main.male and '������' or '�������'))
            wait(3500)
            sampSendChat(("/me %s ������������� ���� � ��������� %s ���� �����"):format(cfg.main.male and '������' or '�������', cfg.main.male and '������' or '�������'))
        end
    },
    {
        title = '����� � ������������� �����',
        onclick = function()
            sampSendChat(("/me %s �������� �����"):format(cfg.main.male and '������' or '�������'))
            wait(3500)
            sampSendChat(("/me %s �������� �����"):format(cfg.main.male and '������' or '�������'))
            wait(3500)
            sampSendChat(("/me %s �������� ����������"):format(cfg.main.male and '��������' or '���������'))
            wait(3500)
            sampSendChat(("/do %s ��� ��������� ����������. ����� � ������������� �����."):format(cfg.main.male and '���������' or '����������'))
            wait(3500)
            sampSendChat(("/me %s �� ��������� ������ ������ ��� ������� ����"):format(cfg.main.male and '������' or '�������'))
            wait(3500)
            sampSendChat(("/me %s ������ � �����"):format(cfg.main.male and '���������' or '����������'))
            wait(3500)
            sampSendChat("/do �� ������� �����������: �������� ��������� ������.")
            wait(3500)
            sampSendChat("/do �� ������� �����������: ������ 5326.")
            wait(3500)
            sampSendChat(("/try %s ���������� ������. ����� ����� ����������"):format(cfg.main.male and '���' or '����'))
        end
    },
    {
        title = '����� � ������������� ����� ���� {63c600}[������]',
        onclick = function()
            sampSendChat("/do ����� �����������.")
            wait(3500)
            sampSendChat(("/me %s ����������� ������� � �������� �����"):format(cfg.main.male and '������' or '�������'))
            wait(3500)
            sampSendChat(("/me %s ������������� ���� � ��������� %s ���� �����"):format(cfg.main.male and '������' or '�������', cfg.main.male and '������' or '�������'))
        end
    },
    {
        title = '����� � ������������� ����� ���� {bf0000}[��������]',
        onclick = function()
            sampSendChat(("/me ������������� ������"):format(cfg.main.male and '������������' or '�������������'))
            wait(3500)
            sampSendChat("/do �� ������� �����������: �������� ��������� ������.")
            wait(3500)
            sampSendChat("/do �� ������� �����������: ������ 3789.")
            wait(3500)
            sampSendChat(("/me %s ���������� ������"):format(cfg.main.male and '���' or '����'))
            wait(3500)
            sampSendChat("/����� ����� ����������")
            wait(3500)
            sampSendChat("/do ����� �����������.")
            wait(3500)
            sampSendChat(("/me %s ����������� ������� � �������� �����"):format(cfg.main.male and '������' or '�������'))
            wait(3500)
            sampSendChat(("/me %s ������������� ���� � ��������� %s ���� �����"):format(cfg.main.male and '������' or '�������', cfg.main.male and '������' or '�������'))
        end
    }
}

local fcmenu =
{
  {
    title = '�������',
    submenu =
    {
      {
        title = '{00BFFF}� ����� �'
      },
      {
        title = '{00BFFF}������ ����� ��� ���������� � {ff0000}100.000$'
      },
      {
        title = '{00BFFF}������ ����� c ����������� � {ff0000}150.000$'
      },
      {
        title = '{9A9593}� ���� ��� �'
      },
      {
        title = '{9A9593}������ ����� ������������ ���� ��� ���������� � {ff0000}100.000$'
      },
      {
        title = '{9A9593}������ ����� ������������ ���� c ����������� � {ff0000}150.000$'
      },
      {
        title = '{0080FF}� ������� SFPD �'
      },
      {
        title = '{0080FF}������ ������� SAPD ��� ���������� � {ff0000}100.000$'
      },
      {
        title = '{0080FF}������ ������� SAPD c ����������� � {ff0000}150.000$'
      },
      {
        title = '{BF4040}� �������� �'
      },
      {
        title = '{BF4040}������ �������� ��� ���������� � {ff0000}75.000$'
      },
      {
        title = '{BF4040}������ �������� � ����������� � {ff0000}100.000$'
      },
      {
        title = '{00BFFF}� ��������� �'
      },
      {
        title = '{00BFFF}������ ��������� ��� ���������� � {ff0000}50.000$'
      },
      {
        title = '{00BFFF}������ ��������� � ����������� � {ff0000}75.000$'
      },
      {
        title = '{40BFBF}� C�� �'
      },
      {
        title = '{40BFBF}������ ��� ��� ���������� � {ff0000}50.000$'
      },
      {
        title = '{40BFBF}������ ��� � ����������� � {ff0000}75.000$'
      },
      {
        title = '� ��������� �'
      },
      {
        title = '������ ���������������/������� ��������� ��� ���������� � {ff0000}50.000$'
      },
      {
        title = '������ ���������������/������� ��������� � ����������� � {ff0000}75.000$'
      }
    }
  },
  {
    title = '���������',
    submenu =
    {
      {
        title = '�����',
        submenu =
        {
          {
            title = '{0040BF}���{ffffff} [6] - {ff0000}100.000$'
          },
          {
            title = '{0040BF}���.����{ffffff} [5] - {ff0000}80.000$'
          },
          {
            title = '{0040BF}��������� ������{ffffff} [4] - {ff0000}60.000$'
          },
          {
            title = '{0040BF}��������{ffffff} [3] - {ff0000}40.000$'
          },
          {
            title = '{0040BF}�������{ffffff} [2] - {ff0000}30.000$'
          },
          {
            title = '{0040BF}���������{ffffff} [1] - {ff0000}20.000$'
          }
        }
      },
      {
        title = '���',
        submenu =
        {
          {
            title = '{9A9593}��������{ffffff} [10] - {ff0000}100.000$'
          },
          {
            title = '{9A9593}���.���������{FFFFFF} [9] - {ff0000}80.000$'
          },
          {
            title = '{9A9593}���������{ffffff} [8] - {ff0000}70.000$'
          },
          {
            title = '{9A9593}����� CID{ffffff} [7] - {ff0000}60.000$'
          },
          {
            title = '{9A9593}����� DEA{ffffff} [6] - {ff0000}50.000$'
          },
          {
            title = '{9A9593}����� CID{ffffff} [5] - {ff0000}40.000$'
          },
          {
            title = '{9A9593}����� DEA{ffffff} [4] - {ff0000}30.000$'
          },
          {
            title = '{9A9593}��.�����{ffffff} [3] - {ff0000}25.000$'
          },
          {
            title = '{9A9593}��������{ffffff} [2] - {ff0000}20.000$'
          },
          {
            title = '{9A9593}������{ffffff} [1] - {ff0000}15.000$'
          }
        }
      },
      {
        title = '�������',
        submenu =
        {
          {
            title = '{0000FF}�����{ffffff} [14] - {ff0000}80.000$'
          },
          {
            title = '{0000FF}���������{ffffff} [13] - {ff0000}70.000$'
          },
          {
            title = '{0000FF}������������{ffffff} [12] - {ff0000}65.000$'
          },
          {
            title = '{0000FF}�����{ffffff} [11] - {ff0000}60.000$'
          },
          {
            title = '{0000FF}�������{ffffff} [10] - {ff0000}55.000$'
          },
          {
            title = '{0000FF}��.���������{ffffff} [9] - {ff0000}50.000$'
          },
          {
            title = '{0000FF}���������{ffffff} [8] - {ff0000}45.000$'
          },
          {
            title = '{0000FF}��.���������{ffffff} [7] - {ff0000}40.000$'
          },
          {
            title = '{0000FF}��.���������{ffffff} [6] - {ff0000}35.000$'
          },
          {
            title = '{0000FF}���������{ffffff} [5] - {ff0000}30.000$'
          },
          {
            title = '{0000FF}�������{ffffff} [4] - {ff0000}25.000$'
          },
          {
            title = '{0000FF}��.�������{ffffff} [3] - {ff0000}20.000$'
          },
          {
            title = '{0000FF}������{ffffff} [2] - {ff0000}15.000$'
          },
          {
            title = '{0000FF}�����{ffffff} [1] - {ff0000}10.000$'
          }
        }
      },
      {
        title = '�����',
        submenu =
        {
          {
            title = '{008040}�������{ffffff} [15] - {ff0000}80.000$'
          },
          {
            title = '{008040}���������{ffffff} [14] - {ff0000}75.000$'
          },
          {
            title = '{008040}������������{ffffff} [13] - {ff0000}70.000$'
          },
          {
            title = '{008040}�����{ffffff} [12] - {ff0000}65.000$'
          },
          {
            title = '{008040}�������{ffffff} [11] - {ff0000}60.000$'
          },
          {
            title = '{008040}��.���������{ffffff} [10] - {ff0000}55.000$'
          },
          {
            title = '{008040}���������{ffffff} [9] - {ff0000}50.000$'
          },
          {
            title = '{008040}��.���������{ffffff} [8] - {ff0000}45.000$'
          },
          {
            title = '{008040}���������{ffffff} [7] - {ff0000}40.000$'
          },
          {
            title = '{008040}��������{ffffff} [6] - {ff0000}35.000$'
          },
          {
            title = '{008040}��.�������{ffffff} [5] - {ff0000}30.000$'
          },
          {
            title = '{008040}�������{ffffff} [4] - {ff0000}25.000$'
          },
          {
            title = '{008040}��.�������{ffffff} [3] - {ff0000}20.000$'
          },
          {
            title = '{008040}��������{ffffff} [2] - {ff0000}15.000$'
          },
          {
            title = '{008040}�������{ffffff} [1] - {ff0000}10.000$'
          }
        }
      },
      {
        title = '������',
        submenu =
        {
          {
            title = '{BF4040}����.����{ffffff} [10] - {ff0000}80.000$'
          },
          {
            title = '{BF4040}���.����.�����{ffffff} [9] - {ff0000}75.000$'
          },
          {
            title = '{BF4040}������{ffffff} [8] - {ff0000}70.000$'
          },
          {
            title = '{BF4040}��������{ffffff} [7] - {ff0000}60.000$'
          },
          {
            title = '{BF4040}������{ffffff} [6] - {ff0000}40.000$'
          },
          {
            title = '{BF4040}��������{ffffff} [5] - {ff0000}35.000$'
          },
          {
            title = '{BF4040}���������{ffffff} [4] - {ff0000}30.000$'
          },
          {
            title = '{BF4040}���.����{ffffff} [3] - {ff0000}25.000$'
          },
          {
            title = '{BF4040}�������{ffffff} [2] - {ff0000}20.000$'
          },
          {
            title = '{BF4040}������{ffffff} [1] - {ff0000}15.000$'
          }
        }
      },
      {
        title = '���������',
        submenu =
        {
          {
            title = '{40BFFF}�����������{ffffff} [10] - {ff0000}80.000$'
          },
          {
            title = '{40BFFF}��������{ffffff} [9] - {ff0000}75.000$'
          },
          {
            title = '{40BFFF}��.��������{ffffff} [8] - {ff0000}70.000$'
          },
          {
            title = '{40BFFF}��.��������{ffffff} [7] - {ff0000}60.000$'
          },
          {
            title = '{40BFFF}�����������{ffffff} [6] - {ff0000}55.000$'
          },
          {
            title = '{40BFFF}����������{FFFFFF} [5] - {ff0000}50.000$'
          },
          {
            title = '{40BFFF}��.����������{ffffff} [4] - {ff0000}45.000$'
          },
          {
            title = '{40BFFF}�����������{ffffff} [3] - {ff0000}30.000$'
          },
          {
            title = '{40BFFF}�����������{ffffff} [2] - {ff0000}25.000$'
          },
          {
            title = '{40BFFF}������{ffffff} [1] - {ff0000}20.000$'
          }
        }
      },
      {
        title = '�������',
        submenu =
        {
          {
            title = '{FFFF80}����������� ��������{ffffff} [10] - {ff0000}70.000$'
          },
          {
            title = '{FFFF80}���������� ��������{ffffff} [9] - {ff0000}60.000$'
          },
          {
            title = '{FFFF80}����������� ��������{ffffff} [8] - {ff0000}55.000$'
          },
          {
            title = '{FFFF80}������� ��������{ffffff} [7] - {ff0000}50.000$'
          },
          {
            title = '{FFFF80}��������{ffffff} [6] - {ff0000}45.000$'
          },
          {
            title = '{FFFF80}�������{ffffff} [5] - {ff0000}40.000$'
          },
          {
            title = '{FFFF80}��������{ffffff} [4] - {ff0000}30.000$'
          },
          {
            title = '{FFFF80}�������������{ffffff} [3] - {ff0000}25.000$'
          },
          {
            title = '{FFFF80}�������������{ffffff} [2] - {ff0000}20.000$'
          },
          {
            title = '{FFFF80}������{ffffff} [1] - {ff0000}15.000$'
          }
        }
      }
    }
  }
}

local fthmenu = {
    {
        title = '{ffffff}� ��������� ��������� � ������� �������',
        onclick = function()
            if cfg.main.tarb then
                sampSendChat(string.format('/r [%s]: ����� ��������� � ������� %s', cfg.main.tar, kvadrat()))
            else
                sampSendChat(string.format('/r ����� ��������� � ������� %s', kvadrat()))
            end
        end
    },
    {
        title = '{ffffff}� ��������� ��������� � ������� �������',
        onclick = function()
            sampShowDialog(1401, '{9966cc}FBI Tools {ffffff}| ���������', '{ffffff}�������: ���-�� ����\n������: 3 �����', '���������', '������', 1)
        end
    },
    {
        title = '{ffffff}� ���� ������',
        onclick = function()
            submenus_show(fcmenu, '{9966cc}FBI Tools {ffffff}| ���� ������')
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
                            if sampGetFraktionBySkin(i) == '�������' or sampGetFraktionBySkin(i) == 'FBI' then
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
                        if sampGetFraktionBySkin(i) == '�������' or sampGetFraktionBySkin(i) == 'FBI' then
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
        return '���������� ���.'
    elseif #v == 1 then
        return '��������: '..table.concat(v, ', ').. '.'
    elseif #v >=2 then
        return '���������: '..table.concat(v, ', ').. '.'
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
                            if not bIsEnter then
                                if bIsF6 then
                                    sampProcessChatInput(line:gsub("{f6}", ""):gsub('{myid}', select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub('{kv}', kvadrat()):gsub('{targetid}', targetid):gsub('{targetrpnick}', sampGetPlayerNicknameForBinder(targetid):gsub('_', ' ')):gsub('{naparnik}', naparnik()):gsub('{myrpnick}', sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub('_', ' ')):gsub('{smsid}', smsid):gsub('{smstoid}', smstoid):gsub('{rang}', rang):gsub('{frak}', frak):gsub('{megafid}', gmegafid))
                                else
                                    sampSendChat(line:gsub('{myid}', select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub('{kv}', kvadrat()):gsub('{targetid}', targetid):gsub('{targetrpnick}', sampGetPlayerNicknameForBinder(targetid):gsub('_', ' ')):gsub('{naparnik}', naparnik()):gsub('{myrpnick}', sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub('_', ' ')):gsub('{smsid}', smsid):gsub('{smstoid}', smstoid):gsub('{rang}', rang):gsub('{frak}', frak):gsub('{megafid}', gmegafid))
                                end
                            else
                                sampSetChatInputText(line:gsub("{noe}", ""):gsub('{myid}', select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub('{kv}', kvadrat()):gsub('{targetid}', targetid):gsub('{targetrpnick}', sampGetPlayerNicknameForBinder(targetid):gsub('_', ' ')):gsub('{naparnik}', naparnik()):gsub('{myrpnick}', sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub('_', ' ')):gsub('{smsid}', smsid):gsub('{smstoid}', smstoid):gsub('{rang}', rang):gsub('{frak}', frak):gsub('{megafid}', gmegafid))
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

function kvadrat1(param)
    local KV = {
        ["�"] = 1,
        ["�"] = 2,
        ["�"] = 3,
        ["�"] = 4,
        ["�"] = 5,
        ["�"] = 6,
        ["�"] = 7,
        ["�"] = 8,
        ["�"] = 9,
        ["�"] = 10,
        ["�"] = 11,
        ["�"] = 12,
        ["�"] = 13,
        ["�"] = 14,
        ["�"] = 15,
        ["�"] = 16,
        ["�"] = 17,
        ["�"] = 18,
        ["�"] = 19,
        ["�"] = 20,
        ["�"] = 21,
        ["�"] = 22,
        ["�"] = 23,
        ["�"] = 24,
        ["�"] = 1,
        ["�"] = 2,
        ["�"] = 3,
        ["�"] = 4,
        ["�"] = 5,
        ["�"] = 6,
        ["�"] = 7,
        ["�"] = 8,
        ["�"] = 9,
        ["�"] = 10,
        ["�"] = 11,
        ["�"] = 12,
        ["�"] = 13,
        ["�"] = 14,
        ["�"] = 15,
        ["�"] = 16,
        ["�"] = 17,
        ["�"] = 18,
        ["�"] = 19,
        ["�"] = 20,
        ["�"] = 21,
        ["�"] = 22,
        ["�"] = 23,
        ["�"] = 24,
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
      [1] = '��',
      [2] = '��',
      [3] = '���',
      [4] = '�',
      [5] = '�',
      [6] = '���',
      [7] = '�������',
      [8] = '�����',
      [9] = '���-����',
      [10] = '�������� ��',
      [11] = '��',
      [12] = '����',
      [13] = '�����������',
      [14] = '��������',
      [15] = '�',
      [16] = '�',
      [17] = '�',
      [18] = '�',
      [19] = '���',
      [20] = '���� ��',
      [21] = '������� �����',
      [32] = '���',
      [33] = 'D',
      [34] = '���� �����',
      [35] = '���������'
    }
    return names[id]
end

function longtoshort(long)
    local short =
    {
      ['����� ��'] = 'LVa',
      ['����� ��'] = 'SFa',
      ['���'] = 'FBI'
    }
    return short[long]
end
local osnova = {
	{
		title = '�����������',
		onclick = function()
			local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
			sampSendChat(("/r %s � ���������� �����������."):format(cfg.main.male and '����������' or '�����������'))
	        wait(1400)
	        sampSendChat("/rb "..myid)
		end
	},
	{
		title = '�����������',
		onclick = function()
			mstype = '������������'
			sampShowDialog(1385, '{9966cc}FBI Tools {ffffff}| ����������', '�������: �������', '�', 'x', 1)
		end
	},
	{
		title = '�������',
		onclick = function()
			mstype = '������������'
			sampShowDialog(1385, '{9966cc}FBI Tools {ffffff}| ����������', '�������: �������', '�', 'x', 1)
		end
	},
	{
		title = '�����',
		onclick = function()
			mstype = '��������'
			sampShowDialog(1385, '{9966cc}FBI Tools {ffffff}| ����������', '�������: �������', '�', 'x', 1)
		end
	},
	{
		title = '���',
		onclick = function()
			mstype = '������'
			sampShowDialog(1385, '{9966cc}FBI Tools {ffffff}| ����������', '�������: �������', '�', 'x', 1)
		end
	},
	{
		title = '�����',
		onclick = function()
			mstype = '���������� �����'
			sampShowDialog(1385, '{9966cc}FBI Tools {ffffff}| ����������', '�������: �������', '�', 'x', 1)
		end
	},
	{
		title = '���������',
		onclick = function()
			mstype = '��������� ���������'
			sampShowDialog(1385, '{9966cc}FBI Tools {ffffff}| ����������', '�������: �������', '�', 'x', 1)
		end
	},
	{
		title = '�������',
		onclick = function()
			mstype = '��������� ��������'
			sampShowDialog(1385, '{9966cc}FBI Tools {ffffff}| ����������', '�������: �������', '�', 'x', 1)
		end
	},
	{
		title = 'LCN',
		ocnlick = function()
			mstype = '��� LCN'
			sampShowDialog(1385, '{9966cc}FBI Tools {ffffff}| ����������', '�������: �������', '�', 'x', 1)
		end
	},
	{
		title = 'Yakuza',
		onclick = function()
			mstype = '��� Yakuza'
			sampShowDialog(1385, '{9966cc}FBI Tools {ffffff}| ����������', '�������: �������', '�', 'x', 1)
		end
	},
	{
		title = 'Russian Mafia',
		onclick = function()
			mstype = '��� Russian Mafia'
			sampShowDialog(1385, '{9966cc}FBI Tools {ffffff}| ����������', '�������: �������', '�', 'x', 1)
		end
	},
	{
		title = 'Rifa',
		onclick = function()
			mstype = '�� Rifa'
			sampShowDialog(1385, '{9966cc}FBI Tools {ffffff}| ����������', '�������: �������', '�', 'x', 1)
		end
	},
	{
		title = 'Grove',
		onclick = function()
			mstype = '�� Grove'
			sampShowDialog(1385, '{9966cc}FBI Tools {ffffff}| ����������', '�������: �������', '�', 'x', 1)
		end
	},
	{
		title = 'Ballas',
		onclick = function()
			mstype = '�� Ballas'
			sampShowDialog(1385, '{9966cc}FBI Tools {ffffff}| ����������', '�������: �������', '�', 'x', 1)
		end
	},
	{
		title = 'Vagos',
		onclick = function()
			mstype = '�� Vagos'
			sampShowDialog(1385, '{9966cc}FBI Tools {ffffff}| ����������', '�������: �������', '�', 'x', 1)
		end
	},
	{
		title = 'Aztec',
		onclick = function()
			mstype = '�� Aztec'
			sampShowDialog(1385, '{9966cc}FBI Tools {ffffff}| ����������', '�������: �������', '�', 'x', 1)
		end
	},
	{
		title = '�������',
		onclick = function()
			mstype = '��������'
			sampShowDialog(1385, '{9966cc}FBI Tools {ffffff}| ����������', '�������: �������', '�', 'x', 1)
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
                        ftext('���������� ���������� {9966cc}FBI Tools{ffffff}. ��� ���������� ������� ������ � ������.')
                        ftext('����������: ���� � ��� �� ��������� ������ ������� {9966cc}/ft')
					    updwindows.v = true
                    else
                        print('���������� ������� �� ����������. �������� ����.')
                        update = false
				    end
                end
            else
                print("�������� ���������� ������ ���������. �������� ������ ������.")
            end
        elseif status == 64 then
            print("�������� ���������� ������ ���������. �������� ������ ������.")
            update = false
        end
    end)
end


function goupdate()
    ftext('�������� ���������� ����������. ������ �������������� ����� ���� ������.', -1)
    wait(300)
    downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23)
        if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
            thisScript():reload()
        elseif status1 == 64 then
            ftext("���������� ���������� ������ �� �������. �������� ������ ������")
        end
    end)
end

function libs()
    if not limgui or not lsampev or not lsphere or not lrkeys or not limadd then
        ftext('������ �������� ����������� ���������')
        ftext('�� ��������� �������� ������ ����� ������������')
        if limgui == false then
            imgui_download_status = 'proccess'
            downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/lib/imgui.lua', 'moonloader/lib/imgui.lua', function(id, status, p1, p2)
                if status == dlstatus.STATUS_DOWNLOADINGDATA then
                    imgui_download_status = 'proccess'
                    print(string.format('��������� %d �������� �� %d ��������.', p1, p2))
                elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    imgui_download_status = 'succ'
                elseif status == 64 then
                    imgui_download_status = 'failed'
                end
            end)
            while imgui_download_status == 'proccess' do wait(0) end
            if imgui_download_status == 'failed' then
                print('�� ������� ���������: imgui.lua')
                thisScript():unload()
            else
                print('����: imgui.lua ������� ��������')
                if doesFileExist('moonloader/lib/MoonImGui.dll') then
                    print('Imgui ��� ��������')
                else
                    imgui_download_status = 'proccess'
                    downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/lib/MoonImGui.dll', 'moonloader/lib/MoonImGui.dll', function(id, status, p1, p2)
                        if status == dlstatus.STATUS_DOWNLOADINGDATA then
                            imgui_download_status = 'proccess'
                            print(string.format('��������� %d �������� �� %d ��������.', p1, p2))
                        elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
                            imgui_download_status = 'succ'
                        elseif status == 64 then
                            imgui_download_status = 'failed'
                        end
                    end)
                    while imgui_download_status == 'proccess' do wait(0) end
                    if imgui_download_status == 'failed' then
                        print('�� ������� ��������� Imgui')
                        thisScript():unload()
                    else
                        print('Imgui ��� ��������')
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
                        print(string.format('��������� %d �������� �� %d ��������.', p1, p2))
                    elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
                        sampev_download_status = 'succ'
                    elseif status == 64 then
                        sampev_download_status = 'failed'
                    end
                end)
                while sampev_download_status == 'proccess' do wait(0) end
                if sampev_download_status == 'failed' then
                    print('�� ������� ��������� sampev')
                    thisScript():unload()
                else
                    print(v..' ��� ��������')
                end
            end
        end
        if not lsphere then
            sphere_download_status = 'proccess'
            downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/lib/sphere.lua', 'moonloader/lib/sphere.lua', function(id, status, p1, p2)
                if status == dlstatus.STATUS_DOWNLOADINGDATA then
                    sphere_download_status = 'proccess'
                    print(string.format('��������� %d �������� �� %d ��������.', p1, p2))
                elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sphere_download_status = 'succ'
                elseif status == 64 then
                    sphere_download_status = 'failed'
                end
            end)
            while sphere_download_status == 'proccess' do wait(0) end
            if sphere_download_status == 'failed' then
                print('�� ������� ��������� Sphere.lua')
                thisScript():unload()
            else
                print('Sphere.lua ��� ��������')
            end
        end
        if not lrkeys then
            rkeys_download_status = 'proccess'
            downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/lib/rkeys.lua', 'moonloader/lib/rkeys.lua', function(id, status, p1, p2)
                if status == dlstatus.STATUS_DOWNLOADINGDATA then
                    rkeys_download_status = 'proccess'
                    print(string.format('��������� %d �������� �� %d ��������.', p1, p2))
                elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    rkeys_download_status = 'succ'
                elseif status == 64 then
                    rkeys_download_status = 'failed'
                end
            end)
            while rkeys_download_status == 'proccess' do wait(0) end
            if rkeys_download_status == 'failed' then
                print('�� ������� ��������� rkeys.lua')
                thisScript():unload()
            else
                print('rkeys.lua ��� ��������')
            end
        end
        if not limadd then
            imadd_download_status = 'proccess'
            downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/lib/imgui_addons.lua', 'moonloader/lib/imgui_addons.lua', function(id, status, p1, p2)
                if status == dlstatus.STATUS_DOWNLOADINGDATA then
                    imadd_download_status = 'proccess'
                    print(string.format('��������� %d �������� �� %d ��������.', p1, p2))
                elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    imadd_download_status = 'succ'
                elseif status == 64 then
                    imadd_download_status = 'failed'
                end
            end)
            while imadd_download_status == 'proccess' do wait(0) end
            if imadd_download_status == 'failed' then
                print('�� ������� ��������� imgui_addons.lua')
                thisScript():unload()
            else
                print('imgui_addons.lua ��� ��������')
            end
        end
        ftext('��� ����������� ���������� ���� ���������')
        reloadScripts()
    else
        print('��� ���������� ���������� ���� ������� � ���������')
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
        frak = '���'
        rang = '���'
        ftext('�� ������� ���������� ���������� ���������. ��������� �������?', -1)
        ftext('�����������: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | ��������: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
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
                    file:write("��������� ������ ������� ��.\n�������� ����� ���� ����� ����� � �����: moonloader/fbitools/yk.txt")
                    file:close()
                end
            elseif status == 64 then
                local file = io.open("moonloader/fbitools/yk.txt", "w")
                file:write("��������� ������ ������� ��.\n�������� ����� ���� ����� ����� � �����: moonloader/fbitools/yk.txt")
                file:close()
            end
        end)
    end
    if not doesFileExist('moonloader/fbitools/yk.txt') then
        local file = io.open("moonloader/fbitools/yk.txt", "w")
        file:write("��������� ������ ������� ��.\n�������� ����� ���� ����� ����� � �����: moonloader/fbitools/yk.txt")
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
                    file:write("��������� ������ ������� ��.\n�������� ����� ���� ����� ����� � �����: moonloader/fbitools/yk.txt")
                    file:close()
                end
            elseif status == 64 then
                local file = io.open("moonloader/fbitools/fp.txt", "w")
                file:write("��������� ������ ������� ��.\n�������� ����� ���� ����� ����� � �����: moonloader/fbitools/yk.txt")
                file:close()
            end
        end)
    end
    if not doesFileExist('moonloader/fbitools/fp.txt') then 
        local file = io.open("moonloader/fbitools/fp.txt", "w")
        file:write("��������� ������ ������� ��.\n�������� ����� ���� ����� ����� � �����: moonloader/fbitools/yk.txt")
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
                    file:write("��������� ������ ������� ��.\n�������� ����� ���� ����� ����� � �����: moonloader/fbitools/yk.txt")
                    file:close()
                end
            elseif status == 64 then
                local file = io.open("moonloader/fbitools/ak.txt", "w")
                file:write("��������� ������ ������� ��.\n�������� ����� ���� ����� ����� � �����: moonloader/fbitools/yk.txt")
                file:close()
            end
        end)
    end
    if not doesFileExist('moonloader/fbitools/ak.txt') then
        local file = io.open("moonloader/fbitools/ak.txt", "w")
        file:write("��������� ������ ������� ��.\n�������� ����� ���� ����� ����� � �����: moonloader/fbitools/yk.txt")
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
        title = '{5b83c2}� ������ �1 �',
        onclick = function()
        end
      },
      {
        title = '{ffffff}� �������� - {ff0000}2 ������� �������.',
        onclick = function()
          sampSendChat("/su "..args.." 2 ��������")
        end
      },
      {
        title = '{ffffff}� ����������� ��������� �� ������������ - {ff0000}3 ������� �������.',
        onclick = function()
          sampSendChat("/su "..args.." 3 ����������� ��������� �� ������������")
        end
      },
      {
        title = '{ffffff}� ����������� ��������� �� ���.��������� - {ff0000}6 ������� �������.',
        onclick = function()
          sampSendChat("/su "..args.." 6 ����������� ��������� �� ��")
        end
      },
      {
        title = '{ffffff}� �������� �������� - {ff0000}3 ������� �������.',
        onclick = function()
          sampSendChat("/su "..args.." 3 �������� ��������")
        end
      },
      {
        title = '{ffffff}� ����������� - {ff0000}1 ������� �������.',
        onclick = function()
          sampSendChat("/su "..args.." 1 �����������")
        end
      },
      {
        title = '{ffffff}� ������������ ��������� - {ff0000}1 ������� �������.',
        onclick = function()
          sampSendChat("/su "..args.." 1 ������������ ���������")
        end
      },
      {
        title = '{ffffff}� ���������������� - {ff0000}1 ������� �������.',
        onclick = function()
          sampSendChat("/su "..args.." 1 ����������������")
        end
      },
      {
        title = '{ffffff}� ����������� - {ff0000}2 ������� �������.',
        onclick = function()
          sampSendChat("/su "..args.." 2 �����������")
        end
      },
      {
        title = '{ffffff}� ����� �� �������� - {ff0000}2 ������� �������.',
        onclick = function()
          sampSendChat("/su "..args.." 2 ����� �� ��������")
        end
      },
      {
        title = '{ffffff}� ������������� ����.������� - {ff0000}1 ������� �������.',
        onclick = function()
          sampSendChat("/su "..args.." 1 ������������� ����.�������")
        end
      },
      {
        title = '{ffffff}� ���� ������������� �������� - {ff0000}2 ������� �������.',
        onclick = function()
          sampSendChat("/su "..args.." 2 ���� ������������� ��������")
        end
      },
      {
        title = '{ffffff}� ����� ������ ��������� - {ff0000}1 ������� �������.',
        onclick = function()
          sampSendChat("/su "..args.. " 1 ����� ������ ���������")
        end
      },
      {
        title = '{ffffff}� ����������� ������ ��������� - {ff0000}4 ������� �������.',
        onclick = function()
          sampSendChat("/su "..args.." 4 ����������� ������ ���������")
        end
      },
      {
        title = '{ffffff}� ������������ ���������� �� - {ff0000}1 ������� �������.',
        onclick = function()
          sampSendChat("/su "..args.." 1 ������������ ���������� ��")
        end
      },
      {
        title = '{ffffff}� ���� �� ���������� �� - {ff0000}2 ������� �������',
        onclick = function()
          sampSendChat("/su "..args.." 2 ���� �� ���������� ��")
        end
      },
      {
          title = '{ffffff}� ���� � ����� ��� - {ff0000}3 ������� �������',
          onclick = function()
            sampSendChat('/su '..args.. ' 3 ���� � ����� ���')
          end
      },
      {
        title = '{ffffff}� ����� �� ����� ���������� - {ff0000}6 ������� �������.',
        onclick = function()
          sampSendChat("/su "..args.." 6 ����� �� ����� ����������")
        end
      },
      {
        title = '{ffffff}� ������������� �� ���������� ���������� - {ff0000}2 ������� �������.',
        onclick = function()
          sampSendChat("/su "..args.." 2 ������������� �� ���. ����������")
        end
      },
      {
        title = '{ffffff}� ���������� - {ff0000}2 ������� �������.',
        onclick = function()
          sampSendChat("/su "..args.." 2 ����������")
        end
      },
      {
        title = '{ffffff}� ������ - {ff0000}1 ������� �������.',
        onclick = function()
          sampSendChat("/su "..args.." 1 ������")
        end
      },
      {
        title = '{ffffff}� ����������� �����. ����� - {ff0000}1 ������� �������',
        onclick = function()
          sampSendChat('/su '..args..' 1 ����������� �������� �����')
        end
      },
      {
        title = '{ffffff}� ������������� - {ff0000}3 ������� �������',
        onclick = function()
          sampSendChat('/su '..args..' 3 �������������')
        end
      },
      {
        title = '{ffffff}� �������������� ��������� - {ff0000}1 ������� �������.',
        onclick = function()
          local result = isCharInAnyCar(PLAYER_PED)
          if result then
            sampSendChat("/clear "..args)
            wait(1400)
            sampSendChat("/su "..args.." 1 �������������� ���������")
          else
            sampAddChatMessage("{9966CC}FBI Tools {FFFFFF}| You have to be in the car", -1)
          end
        end
      },
      {
        title = '{ffbc54}� ������ �2 �',
        onclick = function()
        end
      },
      {
        title = '{ffffff}� �������� ���������� - {ff0000}3 ������� �������.',
        onclick = function()
          sampSendChat("/su "..args.." 3 �������� ����������")
        end
      },
      {
        title = '{ffffff}� �������� ���������� - {ff0000}3 ������� �������.',
        onclick = function()
          sampSendChat("/su "..args.." 3 �������� ����������")
        end
      },
      {
        title = '{ffffff}� ������� ������ �� ������ - {ff0000}6 ������� �������',
        onclick = function()
          sampSendChat("/su "..args.." 6 ������� ������ �� ������")
        end
      },
      {
        title = '{ffffff}� ������������ ���������� - {ff0000}3 ������� �������',
        onclick = function()
          sampSendChat("/su "..args.." 3 ������������ ����������")
        end
      },
      {
        title = '{ffffff}� ������� ���������� - {ff0000}2 ������� �������',
        onclick = function()
          sampSendChat("/su "..args.." 2 ������� ����������")
        end
      },
      {
        title = '{ffffff}� ������� ������� ����� - {ff0000}2 ������� �������',
        onclick = function()
          sampSendChat("/su "..args.." 2 ������� ������� �����")
        end
      },
      {
        title = '{ffffff}� ����������� ������ ���.��������� - {ff0000}2 ������� �������.',
        onclick = function()
          sampSendChat("/su "..args.." 2 ����������� ������ ���.���������")
        end
      },
      {
        title = '{ae0620}� ������ �3 �',
        onclick = function()
        end
      },
      {
        title = '{ffffff}� ���� � AFK �� ������ - {ff0000}6 ������� �������.',
        onclick = function()
          sampSendChat("/su "..args.." 6 ����")
        end
      },
      {
        title = '{ffffff}� ���������� �������� - {ff0000}6 ������� �������.',
        onclick = function()
          sampSendChat("/su "..args.." 6 ���������� �������")
        end
      },
      {
        title = '{ffffff}� �������� ������ - {ff0000}2 ������� �������.',
        onclick = function()
          sampSendChat("/su "..args.." 2 �������� ������")
        end
      },
      {
        title = '{ffffff}� ���������� ���������� �������� - {ff0000}3 ������� �������.',
        onclick = function()
          sampSendChat("/su "..args.." 3 ���������� ���������� ��������")
        end
      },
      {
        title = '{ffffff}� ��������� ������������/���.��������� - {ff0000}4 ������� �������',
        onclick = function()
          sampSendChat("/su "..args.." 4 ���������")
        end
      },
      {
        title = '{ffffff}� ������ ��� - {ff0000}6 ������� �������',
        onclick = function()
          sampSendChat("/su "..args.." 6 ���")
        end
      }
    }
end
function pkmmenu(id)
	return
	{
		{
			title = '{ffffff}� ������ ���������',
			onclick = function()
				if sampIsPlayerConnected(id) then
					sampSendChat(string.format('/me %s ���� %s � %s ���������', cfg.main.male and '�������' or '��������', sampGetPlayerNickname(id):gsub("_", " "), cfg.main.male and '������' or '�������'))
					wait(1400)
					sampSendChat(string.format('/cuff %s', id))
				end
			end
		},
		{
			title = "{ffffff}� ����� �� �����",
			onclick = function()
				if sampIsPlayerConnected(id) then
					sampSendChat(string.format('/me %s ���� �� ������ ���������� � ����, ����� ���� %s �� ����� %s', cfg.main.male and '����������' or '�����������', cfg.main.male and '�����' or '������', sampGetPlayerNickname(id):gsub("_", " ")))
					wait(1400)
					sampSendChat(string.format('/follow %s', id))
				end
			end
		},
		{
			title = "{ffffff}� ���������� �����",
			onclick = function()
				if sampIsPlayerConnected(id) then
					sampSendChat(string.format("/me ����� ��������, %s ������ �� �����", cfg.main.male and '������' or '�������'))
					wait(cfg.commands.zaderjka)
					sampSendChat(('/take %s'):format(id))
				end
			end
		},
		{
			title = "{ffffff}� ���������� �����",
			onclick = function()
				if sampIsPlayerConnected(id) then
					sampSendChat(('/me ������ ����� �� ������ %s ��'):format(cfg.main.male and '������' or '�������'))
					wait(cfg.commands.zaderjka)
					sampSendChat(('/me %s %s � ������'):format(cfg.main.male and '���������' or '����������', sampGetPlayerNickname(id):gsub("_", " ")))
					wait(cfg.commands.zaderjka)
					sampSendChat(('/arrest %s'):format(id))
					wait(cfg.commands.zaderjka)
					sampSendChat(('/me ������ ������ %s ����� � ������'):format(cfg.main.male and '�����' or '������'))
				end
			end
		},
		{
			title = '{ffffff}� ����� ���������',
			onclick = function()
				if sampIsPlayerConnected(id) then
					sampSendChat(('/me %s ��������� � %s'):format(cfg.main.male and '����' or '�����', sampGetPlayerNickname(id):gsub("_", " ")))
					wait(1400)
					sampSendChat(('/uncuff %s'):format(id))
				end
			end
		},
		{
			title = "{ffffff}� ������ ������ �� �������������",
			onclick = function()
				if sampIsPlayerConnected(id) then
					sampSendChat(("/su %s 2 ������������� �� ���. ����������"):format(id))
				end
			end
		},
		{
			title = "{ffffff}� ������ ������ �� �������� ����������",
			onclick = function()
				if sampIsPlayerConnected(id) then
					sampSendChat(("/su %s 3 �������� ����������"):format(id))
				end
			end
		},
		{
			title = "{ffffff}� ������ ������ �� �������� ����������",
			onclick = function()
				if sampIsPlayerConnected(id) then
					sampSendChat(("/su %s 3 �������� ����������"):format(id))
				end
			end
		},
		{
			title = "{ffffff}� ������ ������ �� ������� ����������",
			onclick = function()
				if sampIsPlayerConnected(id) then
					sampSendChat(('/su %s 2 ������� ����������'):format(id))
					wait(1400)
					sampSendChat(("/me %s ���� %s � %s ���������"):format(cfg.main.male and '�������' or '��������', sampGetPlayerNickname(id):gsub("_", " "), cfg.main.male and '������' or '�������'))
				end
			end
		},
		{
			title = "{ffffff}� ������ ������ �� ������� ������ �� ������",
			onclick = function()
				if sampIsPlayerConnected(id) then
					sampSendChat(("/su %s 6 ������� ������ �� ������"):format(id))
				end
			end
		},
		{
			title = "{ffffff}� ������ ������ �� ����������� ��������� �� ��",
			onclick = function()
				if sampIsPlayerConnected(id) then
					sampSendChat(("/su %s 6 ����������� ��������� �� ��"):format(id))
				end
			end
		},
		{
			title = "{ffffff}� ������ ������",
			onclick = function()
				if sampIsPlayerConnected(id) then
					submenus_show(sumenu(id), ('{9966cc}FBI Tools {ffffff}| %s [%s]'):format(sampGetPlayerNickname(id):gsub("_", " "), id))
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
            imgui.Begin('FBI Tools', infbar, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar)
            imgui.CentrText('FBI Tools')
            imgui.Separator()
            imgui.Text((u8"����������: %s [%s] | ����: %s"):format(myname, myid, myping))
            imgui.Text((u8 '������: %s [%s]'):format(myweaponname, myweaponammo))
            if isCharInAnyCar(playerPed) then
                local vHandle = storeCarCharIsInNoSave(playerPed)
                local result, vID = sampGetVehicleIdByCarHandle(vHandle)
                local vHP = getCarHealth(vHandle)
                local carspeed = getCarSpeed(vHandle)
                local speed = math.floor(carspeed)
                local vehName = tCarsName[getCarModel(storeCarCharIsInNoSave(playerPed))-399]
                local ncspeed = math.floor(carspeed*2)
                imgui.Text((u8 '���������: %s [%s] | HP: %s | ��������: %s'):format(vehName, vID, vHP, ncspeed))
            else
                imgui.Text(u8 '���������: ���')
            end
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
            imgui.Text((u8 '�����: %s'):format(os.date('%H:%M:%S')))
            imgui.Text((u8 'Tazer: %s'):format(stazer and 'ON' or 'OFF'))
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
            imgui.Begin(u8'FBI Tools | �������', imegaf, imgui.WindowFlags.NoResize)
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
                                    sampSendChat(("/m �������� �/� %s [EVL%sX]"):format(tCarsName[carhm-399], v))
                                    wait(1400)
                                    sampSendChat("/m ���������� � ������� ��� �� ������� �����!")
                                    wait(300)
                                    sampAddChatMessage(' {ffffff}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~', 0x9966cc)
                                    sampAddChatMessage('', 0x9966cc)
                                    sampAddChatMessage(' {ffffff}���: {9966cc}'..sampGetPlayerNickname(v)..' ['..v..']', 0x9966cc)
                                    sampAddChatMessage(' {ffffff}�������: {9966cc}'..sampGetPlayerScore(v), 0x9966cc)
                                    sampAddChatMessage(' {ffffff}�������: {9966cc}'..sampGetFraktionBySkin(v), 0x9966cc)
                                    sampAddChatMessage('', 0x9966cc)
                                    sampAddChatMessage(' {ffffff}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~', 0x9966cc)
                                    gmegafid = v
                                    gmegaflvl = sampGetPlayerScore(v)
                                    gmegaffrak = sampGetFraktionBySkin(v)
                                    gmegafcar = tCarsName[carhm-399]
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
            imgui.LockPlayer = true
            imgui.ShowCursor = true
            local iScreenWidth, iScreenHeight = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(700, 290), imgui.Cond.FirstUseEver)
            imgui.Begin(u8('FBI Tools | ����������'), updwindows, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
            imgui.Text(u8('����� ���������� ������� FBI Tools! ��� �� ���������� ������� ������ �����. ������ ���������:'))
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
                ftext("���� �� �������� ���������� ���������� ������� ������� {9966CC}/ft")
            end
            imgui.End()
        end
        if mainw.v then
            imgui.ShowCursor = true
            local x, y = getScreenResolution()
            local btn_size = imgui.ImVec2(-0.1, 0)
            imgui.SetNextWindowSize(imgui.ImVec2(300, 300), imgui.Cond.FirstUseEver)
            imgui.SetNextWindowPos(imgui.ImVec2(x/2, y/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.Begin('FBI Tools | Main Menu | Version: '..thisScript().version, mainw, imgui.WindowFlags.NoResize)
            if imgui.Button(u8'������', btn_size) then
                bMainWindow.v = not bMainWindow.v
            end
            if imgui.Button(u8(cfg.main.nwanted and '��������� ����������� Wanted' or '�������� ����������� Wanted'), btn_size) then
                cfg.main.nwanted = not cfg.main.nwanted
                ftext(cfg.main.nwanted and '���������� Wanted �������' or '���������� Wanted ��������')
                saveData(cfg, 'moonloader/config/fbitools/config.json')
            end
            if imgui.Button(u8(cfg.main.nclear and '��������� ���������� Clear' or '�������� ���������� Clear'), btn_size) then
                cfg.main.nclear = not cfg.main.nclear
                ftext(cfg.main.nclear and '���������� Clear �������' or '���������� Clear ��������')
                saveData(cfg, 'moonloader/config/fbitools/config.json')
            end
            if imgui.Button(u8 '������� �������', btn_size) then cmdwind.v = not cmdwind.v end
            if imgui.Button(u8'��������� �������', btn_size) then
                setwindows.v = not setwindows.v
            end
            if imgui.Button(u8 '�������� � ������ / ����', btn_size) then lua_thread.create(function() sendReport('hello') end) end
            if canupdate then if imgui.Button(u8 '[!] �������� ���������� ������� [!]', btn_size) then updwindows.v = not updwindows.v end end
            if imgui.CollapsingHeader(u8 '�������� �� ��������', btn_size) then
                if imgui.Button(u8'������������� ������', btn_size) then
                    thisScript():reload()
                end
                if imgui.Button(u8 '��������� ������', btn_size) then
                    thisScript():unload()
                end
            end
            imgui.End()
            if cmdwind.v then
                local x, y = getScreenResolution()
                imgui.SetNextWindowSize(imgui.ImVec2(500, 500), imgui.Cond.FirstUseEver)
                imgui.SetNextWindowPos(imgui.ImVec2(x/2, y/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
                imgui.Begin(u8'FBI Tools | �������', cmdwind)
                for k, v in ipairs(fthelp) do
                    if imgui.CollapsingHeader(v['cmd']..'##'..k) then
                        imgui.TextWrapped(u8('��������: %s'):format(u8(v['desc'])))
                        imgui.TextWrapped(u8("�������������: %s"):format(u8(v['use'])))
                    end
                end
                imgui.End()
            end
            if bMainWindow.v then
                imgui.LockPlayer = true
                imgui.ShowCursor = true
                local iScreenWidth, iScreenHeight = getScreenResolution()
                imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
                imgui.SetNextWindowSize(imgui.ImVec2(1000, 510), imgui.Cond.FirstUseEver)
                imgui.Begin(u8("FBI Tools | ������##main"), bMainWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
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
                    if imgui.Button(u8 '������������� ����##'..k) then imgui.OpenPopup(u8 "�������������� �������##editbind"..k) 
                        bindname.v = u8(v.name) 
                        bindtext.v = u8(v.text)
                    end
                    if imgui.BeginPopupModal(u8 '�������������� �������##editbind'..k, _, imgui.WindowFlags.NoResize) then
                        imgui.Text(u8 "������� �������� �������:")
                        imgui.InputText("##������� �������� �������", bindname)
                        imgui.Text(u8 "������� ����� �������:")
                        imgui.InputTextMultiline("##������� ����� �������", bindtext, imgui.ImVec2(500, 200))
                        imgui.Separator()
                        if imgui.Button(u8 '�����', imgui.ImVec2(90, 20)) then imgui.OpenPopup('##bindkey') end
                        if imgui.BeginPopup('##bindkey') then
                            imgui.Text(u8 '����������� ����� ������� ��� ����� �������� ������������� �������')
                            imgui.Text(u8 '������: /su {targetid} 6 ����������� ��������� �� ��')
                            imgui.Separator()
                            imgui.Text(u8 '{myid} - ID ������ ��������� | '..select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
                            imgui.Text(u8 '{myrpnick} - �� ��� ������ ��������� | '..sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub('_', ' '))
                            imgui.Text(u8 ('{naparnik} - ���� ��������� | '..naparnik()))
                            imgui.Text(u8 ('{kv} - ��� ������� ������� | '..kvadrat()))
                            imgui.Text(u8 '{targetid} - ID ������ �� �������� �� �������� | '..targetid)
                            imgui.Text(u8 '{targetrpnick} - �� ��� ������ �� �������� �� �������� | '..sampGetPlayerNicknameForBinder(targetid):gsub('_', ' '))
                            imgui.Text(u8 '{smsid} - ��������� ID ����, ��� ��� ������� � SMS | '..smsid)
                            imgui.Text(u8 '{smstoid} - ��������� ID ����, ���� �� �������� � SMS | '..smstoid)
                            imgui.Text(u8 '{megafid} - ID ������, �� ������� ���� ������ ������ | '..gmegafid)
                            imgui.Text(u8 '{rang} - ���� ������ | '..u8(rang))
                            imgui.Text(u8 '{frak} - ���� ������� | '..u8(frak))
                            imgui.Text(u8 '{f6} - ��������� ��������� � ��� ����� �������� ���� (������������ � ����� ������)')
                            imgui.Text(u8 '{noe} - �������� ��������� � ����� ����� � �� ���������� ��� � ��� (������������ � ����� ������)')
                            imgui.Text(u8 '{wait:sek} - �������� ����� ��������, ��� sek - ���-�� �����������. ������: {wait:2000} - �������� 2 �������. (������������ �������� �� ����� �������)')
                            imgui.Text(u8 '{screen} - ������� �������� ������ (������������ �������� �� ����� �������)')
                            imgui.EndPopup()
                        end
                        imgui.SameLine()
                        imgui.SetCursorPosX((imgui.GetWindowWidth() - 90 - imgui.GetStyle().ItemSpacing.x))
                        if imgui.Button(u8 "������� ����##"..k, imgui.ImVec2(90, 20)) then
                            table.remove(tBindList, k)
                            saveData(tBindList, fileb)
                            imgui.CloseCurrentPopup()
                        end
                        imgui.SameLine()
                        imgui.SetCursorPosX((imgui.GetWindowWidth() - 180 + imgui.GetStyle().ItemSpacing.x) / 2)
                        if imgui.Button(u8 "���������##"..k, imgui.ImVec2(90, 20)) then
                            v.name = u8:decode(bindname.v)
                            v.text = u8:decode(bindtext.v)
                            bindname.v = ''
                            bindtext.v = ''
                            saveData(tBindList, fileb)
                            imgui.CloseCurrentPopup()
                        end
                        imgui.SameLine()
                        if imgui.Button(u8 "�������##"..k, imgui.ImVec2(90, 20)) then imgui.CloseCurrentPopup() end
                        imgui.EndPopup()
                    end
                end
                imgui.EndChild()
                imgui.Separator()
                if imgui.Button(u8"�������� �������") then
                    tBindList[#tBindList + 1] = {text = "", v = {}, time = 0, name = "����"..#tBindList + 1}
                    saveData(tBindList, fileb)
                end
                imgui.End()
            end
            if setwindows.v then
                imgui.LockPlayer = true
                local cput =  imgui.ImBool(cfg.commands.cput)
                local ceject = imgui.ImBool(cfg.commands.ceject)
                local ftazer = imgui.ImBool(cfg.commands.ftazer)
                local deject = imgui.ImBool(cfg.commands.deject)
                local kmdcb = imgui.ImBool(cfg.commands.kmdctime)
                local carb = imgui.ImBool(cfg.main.autocar)
                local stateb = imgui.ImBool(cfg.main.male)
                local tagf = imgui.ImBuffer(u8(cfg.main.tar), 256)
                local parolf = imgui.ImBuffer(u8(tostring(cfg.main.parol)), 256)
                local tagb = imgui.ImBool(cfg.main.tarb)
                local xcord = imgui.ImInt(cfg.main.posX)
                local ycord = imgui.ImInt(cfg.main.posY)
                local clistbuffer = imgui.ImInt(cfg.main.clist)
                local waitbuffer = imgui.ImInt(cfg.commands.zaderjka)
                local clistb = imgui.ImBool(cfg.main.clistb)
                local parolb = imgui.ImBool(cfg.main.parolb)
                local offptrlb = imgui.ImBool(cfg.main.offptrl)
                local offwntdb = imgui.ImBool(cfg.main.offwntd)
                local ticketb = imgui.ImBool(cfg.commands.ticket)
                local tchatb = imgui.ImBool(cfg.main.tchat)
                local strobbsb = imgui.ImBool(cfg.main.strobs)
                local megafb = imgui.ImBool(cfg.main.megaf)
                local infbarb = imgui.ImBool(cfg.main.hud)
                local iScreenWidth, iScreenHeight = getScreenResolution()
                imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(15,6))
                imgui.Begin(u8'���������##1', setwindows, imgui.WindowFlags.NoResize)
                imgui.BeginChild('##set', imgui.ImVec2(140, 400), true)
                if imgui.Selectable(u8'��������', show == 1) then show = 1 end
                if imgui.Selectable(u8'�������', show == 2) then show = 2 end
                if imgui.Selectable(u8'�������', show == 3) then show = 3 end
                imgui.EndChild()
                imgui.SameLine()
                imgui.BeginChild('##set1', imgui.ImVec2(800, 400), true)
                if show == 1 then
                    if imadd.ToggleButton(u8 '�������', infbarb) then cfg.main.hud = infbarb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end imgui.SameLine() imgui.Text(u8 "����-���")
                    if infbarb.v then
                        imgui.SameLine()
                        if imgui.Button(u8 '�������� ��������������') then
                            mainw.v = false
                            changetextpos = true
                            ftext('�� ��������� ������� ����� ������ ����')
                        end
                    end
                    if imadd.ToggleButton(u8'�������� ��������� � ������ �������������', offptrlb) then cfg.main.offptrl = offptrlb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end imgui.SameLine(); imgui.Text(u8 '�������� ��������� � ������ �������������')
                    if imadd.ToggleButton(u8'�������� ��������� � ������ �������', offwntdb) then cfg.main.offwntd = offwntdb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end imgui.SameLine(); imgui.Text(u8 '�������� ��������� � ������ �������')
                    if imadd.ToggleButton(u8'������� ���������', stateb) then cfg.main.male = stateb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end imgui.SameLine(); imgui.Text(u8 '������� ���������')
                    if imadd.ToggleButton(u8'������������ �������', tagb) then cfg.main.tarb = tagb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end imgui.SameLine(); imgui.Text(u8 '������������ �������')
                    if tagb.v then
                        if imgui.InputText(u8'������� ��� ���.', tagf) then cfg.main.tar = u8:decode(tagf.v) saveData(cfg, 'moonloader/config/fbitools/config.json') end
                    end
                    if imadd.ToggleButton(u8'������������ ���� �����', parolb) then cfg.main.parolb = parolb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end; imgui.SameLine(); imgui.Text(u8 '������������ ���� �����')
                    if parolb.v then
                        if imgui.InputText(u8'������� ��� ������.', parolf, imgui.InputTextFlags.Password) then cfg.main.parol = u8:decode(parolf.v) saveData(cfg, 'moonloader/config/fbitools/config.json') end
                        if imgui.Button(u8'������ ������') then ftext('��� ������: {9966cc}'..cfg.main.parol) end
                    end
                    if imadd.ToggleButton(u8'������������ ���������', clistb) then cfg.main.clistb = clistb.v end; imgui.SameLine() saveData(cfg, 'moonloader/config/fbitools/config.json'); imgui.Text(u8 '������������ ���������')
                    if clistb.v then
                        if imgui.SliderInt(u8"�������� �������� ������", clistbuffer, 0, 33) then cfg.main.clist = clistbuffer.v saveData(cfg, 'moonloader/config/fbitools/config.json') end
                    end
                    if imadd.ToggleButton(u8'��������� ��� �� T', tchatb) then cfg.main.tchat = tchatb.v end saveData(cfg, 'moonloader/config/fbitools/config.json'); imgui.SameLine(); imgui.Text(u8 '��������� ��� �� T')
                    if imadd.ToggleButton(u8 '������������� �������� ����', carb) then cfg.main.autocar = carb.v end saveData(cfg, 'moonloader/config/fbitools/config.json'); imgui.SameLine(); imgui.Text(u8 '������������� �������� ����')
                    if imadd.ToggleButton(u8 '�����������', strobbsb) then cfg.main.strobs = strobbsb.v end saveData(cfg, 'moonloader/config/fbitools/config.json'); imgui.SameLine(); imgui.Text(u8 '�����������')
                    if imadd.ToggleButton(u8'����������� �������', megafb) then cfg.main.megaf = megafb.v end saveData(cfg, 'moonloader/config/fbitools/config.json'); imgui.SameLine(); imgui.Text(u8 '����������� �������')
                    if imgui.InputInt(u8'�������� � ����������', waitbuffer) then cfg.commands.zaderjka = waitbuffer.v saveData(cfg, 'moonloader/config/fbitools/config.json') end
                end
                if show == 2 then
                    if imadd.ToggleButton(u8('��������� /cput'), cput) then cfg.commands.cput = cput.v end; imgui.SameLine(); imgui.Text(u8 '��������� /cput')
                    if imadd.ToggleButton(u8('��������� /ceject'), ceject) then cfg.commands.ceject = ceject.v saveData(cfg, 'moonloader/config/fbitools/config.json') end; imgui.SameLine(); imgui.Text(u8 '��������� /ceject')
                    if imadd.ToggleButton(u8('��������� /ftazer'), ftazer) then cfg.commands.ftazer = ftazer.v saveData(cfg, 'moonloader/config/fbitools/config.json') end; imgui.SameLine(); imgui.Text(u8 '��������� /ftazer')
                    if imadd.ToggleButton(u8('��������� /deject'), deject) then cfg.commands.deject = deject.v saveData(cfg, 'moonloader/config/fbitools/config.json') end; imgui.SameLine(); imgui.Text(u8 '��������� /deject')
                    if imadd.ToggleButton(u8('��������� /ticket'), ticketb) then cfg.commands.ticket = ticketb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end; imgui.SameLine(); imgui.Text(u8 '��������� /ticket')
                    if imadd.ToggleButton(u8('������������ /time F8 ��� /kmdc'), kmdcb) then cfg.commands.kmdctime = kmdcb.v saveData(cfg, 'moonloader/config/fbitools/config.json') end; imgui.SameLine(); imgui.Text(u8 '������������ /time F8 ��� /kmdc')
                end
                if show == 3 then
                    if imadd.HotKey(u8'##������� �������� ������', config_keys.tazerkey, tLastKeys, 100) then
                        rkeys.changeHotKey(tazerbind, config_keys.tazerkey.v)
                        ftext('������� ������� ��������. ������ ��������: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | ����� ��������: '.. table.concat(rkeys.getKeysName(config_keys.tazerkey.v), " + "))
                        saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                    end
                    imgui.SameLine()
                    imgui.Text(u8'������� �������� ������')
                    if imadd.HotKey('##fastmenu', config_keys.fastmenukey, tLastKeys, 100) then
                        rkeys.changeHotKey(fastmenubind, config_keys.fastmenukey.v)
                        ftext('������� ������� ��������. ������ ��������: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | ����� ��������: '.. table.concat(rkeys.getKeysName(config_keys.fastmenukey.v), " + "))
                        saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                    end
                    imgui.SameLine()
                    imgui.Text(u8('������� �������� ����'))
                    if imadd.HotKey('##oopda', config_keys.oopda, tLastKeys, 100) then
                        rkeys.changeHotKey(oopdabind, config_keys.oopda.v)
                        ftext('������� ������� ��������. ������ ��������: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | ����� ��������: '.. table.concat(rkeys.getKeysName(config_keys.oopda.v), " + "))
                        saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                    end
                    imgui.SameLine()
                    imgui.Text(u8('������� �������������'))
                    if imadd.HotKey('##oopnet', config_keys.oopnet, tLastKeys, 100) then
                        rkeys.changeHotKey(oopnetbind, config_keys.oopnet.v)
                        ftext('������� ������� ��������. ������ ��������: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | ����� ��������: '.. table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "))
                        saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                    end
                    imgui.SameLine()
                    imgui.Text(u8('������� ������'))
                    if imadd.HotKey('##megaf', config_keys.megafkey, tLastKeys, 100) then
                        rkeys.changeHotKey(megafbind, config_keys.megafkey.v)
                        ftext('������� ������� ��������. ������ ��������: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | ����� ��������: '.. table.concat(rkeys.getKeysName(config_keys.megafkey.v), " + "))
                        saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                    end
                    imgui.SameLine()
                    imgui.Text(u8('������� ��������'))
                    if imadd.HotKey('##dkld', config_keys.dkldkey, tLastKeys, 100) then
                        rkeys.changeHotKey(dkldbind, config_keys.dkldkey.v)
                        ftext('������� ������� ��������. ������ ��������: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | ����� ��������: '.. table.concat(rkeys.getKeysName(config_keys.dkldkey.v), " + "))
                        saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                    end
                    imgui.SameLine()
                    imgui.Text(u8('������� �������'))
                    if imadd.HotKey('##cuff', config_keys.cuffkey, tLastKeys, 100) then
                        rkeys.changeHotKey(cuffbind, config_keys.cuffkey.v)
                        ftext('������� ������� ��������. ������ ��������: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | ����� ��������: '.. table.concat(rkeys.getKeysName(config_keys.cuffkey.v), " + "))
                        saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                    end
                    imgui.SameLine()
                    imgui.Text(u8('������ ��������� �� �����������'))
                    if imadd.HotKey('##uncuff', config_keys.uncuffkey, tLastKeys, 100) then
                        rkeys.changeHotKey(uncuffbind, config_keys.uncuffkey.v)
                        ftext('������� ������� ��������. ������ ��������: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | ����� ��������: '.. table.concat(rkeys.getKeysName(config_keys.uncuffkey.v), " + "))
                        saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                    end
                    imgui.SameLine()
                    imgui.Text(u8('����� ���������'))
                    if imadd.HotKey('##follow', config_keys.followkey, tLastKeys, 100) then
                        rkeys.changeHotKey(followbind, config_keys.followkey.v)
                        ftext('������� ������� ��������. ������ ��������: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | ����� ��������: '.. table.concat(rkeys.getKeysName(config_keys.followkey.v), " + "))
                        saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                    end
                    imgui.SameLine()
                    imgui.Text(u8('����� ����������� �� �����'))
                    if imadd.HotKey('##cput', config_keys.cputkey, tLastKeys, 100) then
                        rkeys.changeHotKey(cputbind, config_keys.cputkey.v)
                        ftext('������� ������� ��������. ������ ��������: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | ����� ��������: '.. table.concat(rkeys.getKeysName(config_keys.cputkey.v), " + "))
                        saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                    end
                    imgui.SameLine()
                    imgui.Text(u8('�������� ����������� � ����'))
                    if imadd.HotKey('##ceject', config_keys.cejectkey, tLastKeys, 100) then
                        rkeys.changeHotKey(cejectbind, config_keys.cejectkey.v)
                        ftext('������� ������� ��������. ������ ��������: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | ����� ��������: '.. table.concat(rkeys.getKeysName(config_keys.cejectkey.v), " + "))
                        saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                    end
                    imgui.SameLine()
                    imgui.Text(u8('�������� ����������� � �������'))
                    if imadd.HotKey('##take', config_keys.takekey, tLastKeys, 100) then
                        rkeys.changeHotKey(takebind, config_keys.takekey.v)
                        ftext('������� ������� ��������. ������ ��������: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | ����� ��������: '.. table.concat(rkeys.getKeysName(config_keys.takekey.v), " + "))
                        saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                    end
                    imgui.SameLine()
                    imgui.Text(u8('�������� �����������'))
                    if imadd.HotKey('##arrest', config_keys.arrestkey, tLastKeys, 100) then
                        rkeys.changeHotKey(arrestbind, config_keys.arrestkey.v)
                        ftext('������� ������� ��������. ������ ��������: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | ����� ��������: '.. table.concat(rkeys.getKeysName(config_keys.arrestkey.v), " + "))
                        saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                    end
                    imgui.SameLine()
                    imgui.Text(u8('���������� �����������'))
                    if imadd.HotKey('##deject', config_keys.dejectkey, tLastKeys, 100) then
                        rkeys.changeHotKey(dejectbind, config_keys.dejectkey.v)
                        ftext('������� ������� ��������. ������ ��������: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | ����� ��������: '.. table.concat(rkeys.getKeysName(config_keys.dejectkey.v), " + "))
                        saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                    end
                    imgui.SameLine()
                    imgui.Text(u8('�������� ����������� �� ����'))
                    if imadd.HotKey('##siren', config_keys.sirenkey, tLastKeys, 100) then
                        rkeys.changeHotKey(sirenbind, config_keys.sirenkey.v)
                        ftext('������� ������� ��������. ������ ��������: '.. table.concat(rkeys.getKeysName(tLastKeys.v), " + ") .. ' | ����� ��������: '.. table.concat(rkeys.getKeysName(config_keys.sirenkey.v), " + "))
                        saveData(config_keys, 'moonloader/config/fbitools/keys.json')
                    end
                    imgui.SameLine()
                    imgui.Text(u8('�������� / ��������� ������ �� ����'))
                end
                imgui.EndChild()
                imgui.End()
            end
        end
        if shpwindow.v then
            imgui.LockPlayer = true
            imgui.ShowCursor = true
            local iScreenWidth, iScreenHeight = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(iScreenWidth/2, iScreenHeight / 2), imgui.Cond.FirstUseEver)
            imgui.Begin(u8('FBI Tools | �����'), shpwindow)
            for line in io.lines('moonloader\\fbitools\\shp.txt') do
                imgui.TextWrapped(u8(line))
            end
            imgui.End()
        end
        if akwindow.v then
            imgui.LockPlayer = true
            imgui.ShowCursor = true
            local iScreenWidth, iScreenHeight = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(iScreenWidth/2, iScreenHeight / 2), imgui.Cond.FirstUseEver)
            imgui.Begin(u8('FBI Tools | ���������������� ������'), akwindow)
            for line in io.lines('moonloader\\fbitools\\ak.txt') do
                imgui.TextWrapped(u8(line))
            end
            imgui.End()
        end
        if fpwindow.v then
            imgui.LockPlayer = true
            imgui.ShowCursor = true
            local iScreenWidth, iScreenHeight = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(iScreenWidth/2, iScreenHeight / 2), imgui.Cond.FirstUseEver)
            imgui.Begin(u8('FBI Tools | ����������� �������������'), fpwindow)
            for line in io.lines('moonloader\\fbitools\\fp.txt') do
                imgui.TextWrapped(u8(line))
            end
            imgui.End()
        end
        if ykwindow.v then
            imgui.LockPlayer = true
            imgui.ShowCursor = true
            local iScreenWidth, iScreenHeight = getScreenResolution()
            imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(iScreenWidth/2, iScreenHeight / 2), imgui.Cond.FirstUseEver)
            imgui.Begin(u8('FBI Tools | ��������� ������'), ykwindow)
            for line in io.lines('moonloader\\fbitools\\yk.txt') do
                imgui.TextWrapped(u8(line))
            end
            imgui.End()
        end
    end
end

if lsampev then
    function sp.onPlayerQuit(id, reason)
        if gmegafhandle ~= -1 and id == gmegafid then
            sampAddChatMessage(' {ffffff}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~', 0x9966cc)
            sampAddChatMessage('', 0x9966cc)
            sampAddChatMessage(' {ffffff}�����: {9966cc}'..sampGetPlayerNickname(gmegafid)..'['..gmegafid..'] {ffffff}����� �� ����', 0x9966cc)
            sampAddChatMessage(' {ffffff}�������: {9966cc}'..gmegaflvl, 0x9966cc)
            sampAddChatMessage(' {ffffff}�������: {9966cc}'..gmegaffrak, 0x9966cc)
            sampAddChatMessage(' {ffffff}������� ������: {9966cc}'..quitReason[reason], 0x9966CC)
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
                ftext('���� ���� ������ ��: {9966cc}' .. cfg.main.clist)
                sampSendChat('/clist '..cfg.main.clist)
            end)
        end
    end

    function sp.onServerMessage(color, text)
        if text:match(" ^�� ������ ������������� �� ������������ %S!$") then
            local nick = text:match(" ^�� ������ ������������� �� ������������ (%S)!$")
            local id = sampGetPlayerIdByNickname(nick)
            gmegafid = id
            gmegaflvl = sampGetPlayerScore(id)
            gmegaffrak = sampGetFraktionBySkin(id)
        end
        if nazhaloop then
            if text:match('�������� ��������� � /d ����� ��� � 10 ������!') then
                zaproop = true
                ftext('�� ������� ������ � ��� ������ {9966cc}'..nikk..'{ffffff}. ��������� �������?')
                ftext('�����������: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | ��������: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "))
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
                ftext("�������� ���� �������.", -1)
            end
        end
        if (text:match('���� �� ��� .+ ������������ �� ��������, ���') or text:match('���� .+ ������������ �� �������� %- ���.')) and color == -8224086 then
            local ooptext = text:match('Mayor, (.+)')
            table.insert(ooplistt, ooptext)
        end
        if text:find('{00AB06}����� ������� ���������, ������� ������� {FFFFFF}"2"{00AB06} ��� ������� ������� {FFFFFF}"/en"') then
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
        if color == -3669760 and text:match('%[Wanted %d+: .+%] %[��������%: .+%] %[.+%]') then
            local colors = ("{%06X}"):format(bit.rshift(color, 8))
            table.insert(wanted, os.date(colors.."[%H:%M:%S] ") .. text)
        end
        if color == -65366 and (text:match('SMS%: .+. �����������%: .+') or text:match('SMS%: .+. ����������%: .+')) then
            if text:match('SMS%: .+. �����������%: .+%[%d+%]') then smsid = text:match('SMS%: .+. �����������%: .+%[(%d+)%]') elseif text:match('SMS%: .+. ����������%: .+%[%d+%]') then smstoid = text:match('SMS%: .+. ����������%: .+%[(%d+)%]') end
            local colors = ("{%06X}"):format(bit.rshift(color, 8))
            table.insert(sms, os.date(colors.."[%H:%M:%S] ") .. text)
        end
        if mcheckb then
            if text:find('---======== ��������� ��������� ������ ========---') then
                local open = io.open("moonloader/fbitools/mcheck.txt", 'a')
                open:write(string.format('%s\n', text))
                open:close()
            end
            if text:find('���:') then
                local open = io.open("moonloader/fbitools/mcheck.txt", 'a')
                open:write(string.format('%s\n', text))
                open:close()
            end
            if text:find('�����������:') then
                local open = io.open("moonloader/fbitools/mcheck.txt", 'a')
                open:write(string.format('%s\n', text))
                open:close()
            end
            if text:find('������������:') then
                local open = io.open("moonloader/fbitools/mcheck.txt", 'a')
                open:write(string.format('%s\n', text))
                open:close()
            end
            if text:find('�������:') then
                local open = io.open("moonloader/fbitools/mcheck.txt", 'a')
                open:write(string.format('%s\n', text))
                open:close()
            end
            if text:find('������� �������:') then
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
        if text:find('�� �������� � ������') then
            local nik, sek = text:match('�� �������� � ������ (%S+) �� (%d+) ������')
            if sek == '3600' or sek == '3000'  then
                lua_thread.create(function()
                    nikk = nik:gsub('_', ' ')
                    aroop = true
                    wait(3000)
                    ftext(string.format("��������� �������� ���� �� ��� {9966cc}%s", nikk), -1)
                    ftext('�����������: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | ��������: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
                end)
            end
        end
        if text:find('�� �������� ����������� ��') then
            local sekk = text:match('�� �������� ����������� �� (.+) ������!')
            if sekk == '3000' or sekk == '3600' then
                lua_thread.create(function()
                    nikk = sampGetPlayerNickname(tdmg)
                    dmoop = true
                    wait(50)
                    ftext(string.format("��������� �������� ���� �� ��� {9966cc}%s", nikk:gsub('_', ' ')), -1)
                    ftext('�����������: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | ��������: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
                end)
            end
        end
        if status then
            if text:match('ID: .+ | .+: .+ %- .+') and not fstatus then
                gosmb = true
                local id, nick, mrang, stat = text:match('ID: (%d+) | (.+): (.+) %- (.+)')
                local color = ("%06X"):format(bit.band(sampGetPlayerColor(id), 0xFFFFFF))
                local nmrang = mrang:match('.+%[(%d+)%]')
                if stat:find('��������') and tonumber(nmrang) < 11 then
                    table.insert(vixodid, id)
                end
                table.insert(players2, string.format('{'..color..'}%s [%s]{ffffff}\t%s\t%s', nick, id, mrang, stat))
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
                table.insert(players1, string.format('{'..color..'}%s [%s]{ffffff}\t%s', nick, id, rang))
                return false
            end
        end
        if warnst then
            if text:find('�����������:') then
                local wcfrac = text:match('�����������: (.+)')
                wfrac = wcfrac
                if wcfrac == '����� ��' or wcfrac == '����� ��' or wcfrac == '���' then
                    wfrac = longtoshort(wcfrac)
                end
            end
        end
        if text:find('������� ���� �����') and color ~= -1 then
            if cfg.main.clistb then
                lua_thread.create(function()
                    wait(100)
                    ftext('���� ���� ������ ��: {9966cc}'..cfg.main.clist)
                    sampSendChat('/clist '..tonumber(cfg.main.clist))
                    rabden = true
                end)
            end
        end
        if text:find('������� ���� �������') and color ~= -1 then
            rabden = false
        end
        if text:find('�� �������� ���� �� ���������') then
            stazer = true
        end
        if text:find('�� �������� ���� �� �������') then
            stazer = false
        end
        if cfg.main.nclear then
            if text:find('������ �� �������������') then
                local chist, jertva = text:match('%[Clear%] (.+) ������ �� ������������� (.+)')
                printStringNow(chist..' cleared '..jertva..' from BD', 3000)
            end
        end
        if text:find('Wanted') and text:find('��������') then
            local id, prestp, police, prichin = text:match('%[Wanted (%d+): (.+)%] %[��������: (.+)%] %[(.+)%]')
            if not cfg.main.offwntd then
                if cfg.main.nwanted then
                    return {0x9966CCFF, ' [{ffffff}Wanted '..id..': '..prestp..'{9966cc}] [{ffffff}��������: '..police..'{9966cc}] [{ffffff}'..prichin..'{9966cc}]'}
                end
            else
                local mynick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
                if police ~= mynick then
                    return false
                else
                    if cfg.main.nwanted then
                        return {0x9966CCFF, ' [{ffffff}Wanted '..id..': '..prestp..'{9966cc}] [{ffffff}��������: '..police..'{9966cc}] [{ffffff}'..prichin..'{9966cc}]'}
                    end
                end
            end
        end
        if text:find('����� ������������� �� ������������') then
            local polic, prest, yrvn = text:match('����������� (.+) ����� ������������� �� ������������ (.+) %(������� �������: (.+)%)')
            if not cfg.main.offptrl then
                if cfg.main.nwanted then
                    return {0xFFFFFFFF, ' ����������� {9966cc}'..polic..' {ffffff}����� ������������� �� {9966cc}'..prest..' {ffffff}(������� �������: {9966cc}'..yrvn..'{ffffff})'}
                end
            else
                local mynick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
                if polic ~= mynick then
                    return false
                else
                    if cfg.main.nwanted then
                        return {0xFFFFFFFF, ' ����������� {9966cc}'..polic..' {ffffff}����� ������������� �� {9966cc}'..prest..' {ffffff}(������� �������: {9966cc}'..yrvn..'{ffffff})'}
                    end
                end
            end
        end
        if cfg.main.nwanted then
            if text:find('������ �� �������������') then
                local chist, jertva = text:match('%[Clear%] (.+) ������ �� ������������� (.+)')
                return {0x9966CCFF, ' [{ffffff}Clear{9966cc}] '..chist..'{ffffff} ������ �� ������������� {9966cc}'..jertva}
            end
            if text:find('<<') and text:find('������') and text:find('���������') and text:find('>>') then
                local arr, arre = text:match('<< ������ (.+) ��������� (.+) >>')
                return {0xFFFFFFFF, ' � ������ {9966CC}'..arr..' {ffffff}��������� {9966cc}'..arre..' {ffffff}�'}
            end
            if text:find('<<') and text:find('����� FBI') and text:find('���������') and text:find('>>') then
                local arrr, arrre = text:match('<< ����� FBI (.+) ��������� (.+) >>')
                return {0xFFFFFFFF, ' � ����� FBI {9966CC}'..arrr..' {ffffff}��������� {9966cc}'..arrre..' {ffffff}�'}
            end
            if text:find('�� �������� ����������� ��') then
                local sekund = text:match('�� �������� ����������� �� (%d+) ������!')
                return {0xFFFFFFFF, ' �� �������� ����������� �� {9966cc}'..sekund..' {ffffff}������!'}
            end
        end
    end

    function sp.onShowDialog(id, style, title, button1, button2, text)
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
        if id == 0 and checkstat then
            frak = text:match('.+�����������%:%s+(.+)%s+����')
            rang = text:match('.+����%:%s+(.+)%s+������')
            print(frak)
            print(rang)
            checkstat = false
            sampSendDialogResponse(id, 1, _, _)
            return false
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
    sampRegisterChatCommand('yk', function() ykwindow.v = not ykwindow.v end)
    sampRegisterChatCommand('fp', function() fpwindow.v = not fpwindow.v end)
    if sampIsChatCommandDefined('ak') then sampUnregisterChatCommand('ak') end
    sampRegisterChatCommand('ak', function() akwindow.v = not akwindow.v end)
    sampRegisterChatCommand('shp',function() shpwindow.v = not shpwindow.v end)
    sampRegisterChatCommand('ft', function() mainw.v = not mainw.v end)
    sampRegisterChatCommand('fnr', fnr)
    sampRegisterChatCommand('fkv', fkv)
    sampRegisterChatCommand('ooplist', ooplist)
    sampRegisterChatCommand('ticket', ticket)
    sampRegisterChatCommand('dlog', dlog)
    sampRegisterChatCommand('rlog', rlog)
    sampRegisterChatCommand('sulog', sulog)
    sampRegisterChatCommand('smslog', smslog)
    sampRegisterChatCommand('ftazer', ftazer)
    sampRegisterChatCommand('kmdc', kmdc)
    sampRegisterChatCommand('su', su)
    sampRegisterChatCommand('ssu', ssu)
    sampRegisterChatCommand('megaf', megaf)
    sampRegisterChatCommand('tazer', tazer)
    sampRegisterChatCommand('keys', keys)
    sampRegisterChatCommand('oop', oop)
    sampRegisterChatCommand('cput', cput)
    sampRegisterChatCommand('ceject', ceject)
    if sampIsChatCommandDefined('st') then sampUnregisterChatCommand('st') end
    sampRegisterChatCommand('st', st)
    sampRegisterChatCommand('deject', deject)
    sampRegisterChatCommand('rh', rh)
    sampRegisterChatCommand('gr', gr)
    sampRegisterChatCommand('warn', warn)
    sampRegisterChatCommand('ms', ms)
    sampRegisterChatCommand('ar', ar)
    sampRegisterChatCommand('r', r)
    sampRegisterChatCommand('f', f)
    sampRegisterChatCommand('rt', rt)
    sampRegisterChatCommand("fst", fst)
    sampRegisterChatCommand("fsw", fsw)
    sampRegisterChatCommand('fshp', fshp)
    sampRegisterChatCommand('fyk', fyk)
    sampRegisterChatCommand('ffp', ffp)
    sampRegisterChatCommand('fak', fak)
    sampRegisterChatCommand('dmb', dmb)
    sampRegisterChatCommand('dkld', dkld)
    sampRegisterChatCommand('fvz', fvz)
    sampRegisterChatCommand('fbd', fbd)
    sampRegisterChatCommand('blg', blg)
    sampRegisterChatCommand('cc', cc)
    sampRegisterChatCommand('df', df)
    sampRegisterChatCommand('mcheck', mcheck)
    sampRegisterChatCommand('z', ssuz)
    sampfuncsRegisterConsoleCommand('gppc', function() print(getCharCoordinates(PLAYER_PED)) end)
    sampfuncsRegisterConsoleCommand('gppc', function()
        local mxx, myy, mzz = getCharCoordinates(PLAYER_PED)
        print(string.format('%s, %s, %s', mxx, myy, mzz))
    end)
end

function registerSphere()
    Sphere.createSphere(-1984.6375732422, 106.85540008545, 27.42943572998, 50.0)-- -1984.6375732422 106.85540008545 27.42943572998 -- ���� [1]
    Sphere.createSphere(-2055.283203125, -84.472702026367, 35.064281463623, 50.0)-- -2055.283203125 -84.472702026367 35.064281463623 -- �� [2]
    Sphere.createSphere(-1521.4412841797, 503.20678710938, 6.7215604782104, 40.0)-- -1521.4412841797 503.20678710938 6.7215604782104 -- ��� [3]
    Sphere.createSphere(-1702.3824462891, 684.79150390625, 25.01790618896, 30.0)-- -1702.3824462891 684.79150390625 25.017906188965 -- ���� � ���� [4]
    Sphere.createSphere(-1574.4406738281, 662.24047851563, 7.3254537582397, 20.0)-- -1574.4406738281 662.24047851563 7.3254537582397 ���� � ���� [5]
    Sphere.createSphere(-2013.1629638672, 464.77380371094, 35.313331604004, 30.0)-- -2013.1629638672 464.77380371094 35.313331604004 -- ��� [6]
    Sphere.createSphere(-1749.7822265625, -591.34033203125, 16.62273979187, 100.0)-- -1749.7822265625 -591.34033203125 16.62273979187 -- ������� [7]
    Sphere.createSphere(1481.77734375, -1739.9536132813, 13.546875, 70.0)-- 1481.77734375 -1739.9536132813 13.546875 -- ����� [8]
    Sphere.createSphere(-2448.3591308594, 725.09326171875, 34.756977081299, 70.0)-- -2448.3591308594 725.09326171875 34.756977081299 -- ���-���� [9]
    Sphere.createSphere(1186.5642089844, -1322.2257080078,13.098788261414, 50.0)-- 1186.5642089844 -1322.2257080078 13.098788261414 -- �������� �� [10]
    Sphere.createSphere(1195.8181152344, -1741.1024169922, 13.131011962891, 70.0)-- 1195.8181152344 -1741.1024169922 13.131011962891 -- �� �� [11]
    Sphere.createSphere(1667.1462402344, -768.31890869141, 54.092594146729, 70.0)-- 1667.1462402344 -768.31890869141 54.092594146729 -- ���� ��-�� [12]
    Sphere.createSphere(1766.12109375,   874.89379882813,   10.887091636658, 70.0)-- 1820.5036621094 816.41632080078 10.8203125 -- ����������� LVPD [13]
    Sphere.createSphere(1155.6971435547, 831.9443359375, 10.409364700317, 80.0)-- 1155.6971435547 831.9443359375 10.409364700317 �������� LVPD [14]
    Sphere.createSphere(2033.3028564453, 1007.163269043, 10.8203125, 50.0)-- 2033.3028564453 1007.163269043 10.8203125 �������� � LVPD [4 �������] [15]
    Sphere.createSphere(2824.7353515625, 1292.9085693359, 10.764576911926, 50.0)-- 2824.7353515625 1292.9085693359 10.764576911926 �������� � LVPD [����] [16]
    Sphere.createSphere(2180.99609375, 1676.2248535156, 11.060985565186, 50.0)-- 2180.99609375 1676.2248535156 11.060985565186 �������� � LVPD [���������] [17]
    Sphere.createSphere(1727.3302001953, 1618.9171142578, 9.8169927597046, 50.0)-- 1727.3302001953 1618.9171142578 9.8169927597046 -- ���� � LVPD [18]
    Sphere.createSphere(1545.6296386719, -1631.2828369141, 13.3828125, 50.0)-- 1545.6296386719 -1631.2828369141 13.3828125 -- ��� ���� [19]
    Sphere.createSphere(2753.5388183594, -2432.2268066406, 13.64318561554, 80.0)-- 2753.5388183594 -2432.2268066406 13.64318561554 -- ���� ��[20]
    Sphere.createSphere(2293.4145507813, -1584.8774414063, 3.5703411102295, 670.0)--  2293.4145507813 -1584.8774414063 3.5703411102295 -- ������� ����� [21]
    Sphere.createSphere(186.95843505859, 1901.0294189453, 17.640625, 300.0)-- 186.95843505859 1901.0294189453 17.640625 -- ������� ��� [22]
    Sphere.createSphere(-422, -1195, 60, 500.0)-- -422 -1195 60 --���������� �� - �� [23]
    Sphere.createSphere(1644, -25, 36, 300.0)-- 1644 -25 36 --���������� �� - �� [24]
    Sphere.createSphere(413, 625, 18, 300.0)-- 413 625 18 ���������� ��- �� 2 [25]
    Sphere.createSphere(-129, 518, 8, 300.0)-- -129 518 8 ���������� �� - �� 3 [26]
    Sphere.createSphere(-1003, 1285, 40, 300.0)-- -1003 1285 40 ���������� �� - �� [27]
    Sphere.createSphere(-2126, 2654, 53, 300.0)-- -2126 2654 53 ���������� �� - �� 2 [28]
    Sphere.createSphere(-1006, -442, 36, 300.0)-- -1006 -442 36 ���������� �� - �� 2 [29]
    Sphere.createSphere(-1126, -2574, 72, 300.0)-- -1126 -2574 72 ���������� �� - �� 3 [30]
    Sphere.createSphere(-1248, -2867, 64, 300.0)-- -1248 -2867 64 ���������� ��- �� 4 [31]
    Sphere.createSphere(2238.6533203125,   2449.4895019531,   11.037217140198, 10.0) -- 2238.6533203125   2449.4895019531   11.037217140198 -- ��� ���� [32]
    Sphere.createSphere(2458.4575195313,   1340.5772705078,   10.9765625, 30) -- 2458.4575195313   1340.5772705078   10.9765625 -- LVPD D [33]
    Sphere.createSphere(373.66720581055,   173.75173950195,   1008.3893432617, 30) -- 373.66720581055,   173.75173950195,   1008.3893432617 -- ���� ����� [34]
    Sphere.createSphere(361.3515, -1785.0653, 5.4350, 30) -- 361.3515,-1785.0653,5.4350 -- ����������� [35]
end

function registerHotKey()
    tazerbind = rkeys.registerHotKey(config_keys.tazerkey.v, true, function() sampSendChat('/tazer') end)
    fastmenubind = rkeys.registerHotKey(config_keys.fastmenukey.v, true, function() lua_thread.create(function() submenus_show(fthmenu, '{9966cc}FBI Tools') end) end)
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
end

function oopchat()
	while true do wait(0)
	    stext, sprefix, scolor, spcolor = sampGetChatString(99)
	    if zaproop then
	        if nikk ~= nil then
	            if stext:find(nikk) and scolor == 4294935170 then
	                local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	                local myname = sampGetPlayerNickname(myid)
	                if not stext:find(myname) then
	                    zaproop = false
	                    nikk = nil
	                    wait(100)
	                    ftext('������� �������� ������ ���������.', -1)
	                end
	            end
	        end
	    end
	    --if scolor == 4287467007 or scolor == 9276927 then
			if frak == 'FBI' then
				if rang == '����� DEA' or rang == '����� CID' or rang == '��������� FBI' or rang == '���.��������� FBI' or rang == '�������� FBI' then
					if stext:match('���������� � ������ ������') then
						local msrang, msnick = stext:match('(.+) (.+): ���������� � ������ ������')
						if msnick ~= sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) then
							mssnyat = true
							msoffid = sampGetPlayerIdByNickname(msnick)
							ftext(('����� {9966cc}%s {ffffff}����� c���� ����������'):format(msnick:gsub('_', ' ')))
							ftext('�����������: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | ��������: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
						end
					end
					if stext:match('����������� � ������ ������') then
						local msrang, msnick = stext:match('(.+) (.+): ����������� � ������ ������')
						if msnick ~= sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) then
							mssnyat = true
							msoffid = sampGetPlayerIdByNickname(msnick)
							ftext(('����� {9966cc}%s {ffffff}����� c���� ����������'):format(msnick:gsub('_', ' ')))
							ftext('�����������: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | ��������: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
						end
					end
					if stext:match('���������� � ���������� �����������') then
						local msrang, msnick = stext:match('(.+) (.+): ���������� � ���������� �����������')
						if msnick ~= sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) then
							msid = sampGetPlayerIdByNickname(msnick)
							msvidat = "�����������"
							ftext(('����� {9966cc}%s {ffffff}����� ����� ����� {9966cc}���������� �����������{ffffff}'):format(msnick:gsub('_', ' ')))
							ftext('�����������: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | ��������: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
						end
					end
					if stext:match('����������� � ���������� �����������') then
						local msrang, msnick = stext:match('(.+) (.+): ����������� � ���������� �����������')
						if msnick ~= sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) then
							msid = sampGetPlayerIdByNickname(msnick)
							msvidat = "�����������"
							ftext(('����� {9966cc}%s {ffffff}����� ����� ����� {9966cc}���������� �����������{ffffff}'):format(msnick:gsub('_', ' ')))
							ftext('�����������: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | ��������: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
						end
					end
					if stext:match('���������� � ����� .+. �������: .+') then
						local msrang, msnick, msforma, msreason = stext:match('(.+) (.+): ���������� � ����� (.+). �������: (.+)')
						if msnick ~= sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) then
							msid = sampGetPlayerIdByNickname(msnick)
							msvidat = msforma
							ftext(('����� {9966cc}%s {ffffff}����� ����� ���������� {9966cc}%s{ffffff}. �������: {9966cc}%s'):format(msnick:gsub('_', ' '), msforma, msreason))
							ftext('�����������: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | ��������: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
						end
					end
					if stext:match('����������� � ����� .+. �������: .+') then
						local msrang, msnick, msforma, msreason = stext:match('(.+) (.+): ����������� � ����� (.+). �������: (.+)')
						if msnick ~= sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) then
							msid = sampGetPlayerIdByNickname(msnick)
							msvidat = forma
							ftext(('����� {9966cc}%s {ffffff}����� ����� ���������� {9966cc}%s{ffffff}. �������: {9966cc}%s'):format(msnick:gsub('_', ' '), msforma, msreason))
							ftext('�����������: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | ��������: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
						end
					end
				end
			end
	        if rang ~= '�����' and rang ~= '������' and rang ~= '��.�������' and  rang ~= '�������' and  rang ~= '���������' then
	            if stext:find('���� �� ��� .+ %(%d+%) ������������ �� ��������, ���, ��������.') then
	                local name, id = stext:match('���� �� ��� (.+) %((%d+)%) ������������ �� ��������, ���, ��������.')
	                zaproop = true
	                nikk = name
	                if nikk ~= nil then
	                    ftext(string.format("�������� ������ �� ���������� ��� ������ {9966cc}%s", nikk:gsub('_', ' ')), -1)
	                    ftext('�����������: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | ��������: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
	                else
	                    zaproop = false
	                end
	            end
	            if stext:match('���� .+ ������������ �� �������� %- ���.') then
	                local name = stext:match('���� (.+) ������������ �� �������� %- ���.')
	                zaproop = true
	                nikk = name
	                if nikk ~= nil then
	                    ftext(string.format("�������� ������ �� ���������� ��� ������ {9966cc}%s", nikk:gsub('_', ' ')), -1)
	                    ftext('�����������: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | ��������: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
	                else
	                    zaproop = false
	                end
	            end
	            if stext:match('���� �� ��� .+ ������������ �� ��������, ���.') then
	                local name = stext:match('���� �� ��� (.+) ������������ �� ��������, ���.')
	                zaproop = true
	                nikk = name
	                if nikk ~= nil then
	                    ftext(string.format("�������� ������ �� ���������� ��� ������ {9966cc}%s", nikk:gsub('_', ' ')), -1)
	                    ftext('�����������: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopda.v), " + ")..'{ffffff} | ��������: {9966cc}'..table.concat(rkeys.getKeysName(config_keys.oopnet.v), " + "), -1)
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

function oopdakey()
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
        sampSendChat(string.format('/d Mayor, ���� �� ��� %s ������������ �� ��������, ���', nikk:gsub('_', ' ')))
        zaproop = false
        nazhaloop = true
    end
    if dmoop then
        if frak == 'FBI' or frak == 'LSPD' or frak == 'SFPD' or frak == 'LVPD' then
            if rang == '�����' or rang == '������' or rang == '��.�������' or  rang == '�������' or  rang == '���������' then
                if not cfg.main.tarb then
                    sampSendChat(string.format('/r ���� �� ��� %s ������������ �� ��������, ���.', nikk:gsub('_', ' ')))
                    dmoop = false
                else
                    sampSendChat(string.format('/r [%s]: ���� �� ��� %s ������������ �� ��������, ���.', cfg.main.tar, nikk:gsub('_', ' ')))
                    dmoop = false
                end
            else
                sampSendChat(string.format('/d Mayor, ���� �� ��� %s ������������ �� ��������, ��� ��� LSPD.', nikk:gsub('_', ' ')))
                dmoop = false
                nazhaloop = true
            end
        end
    end
    if aroop then
        if frak == 'FBI' or frak == 'LSPD' or frak == 'SFPD' or frak == 'LVPD' then
            if rang == '�����' or rang == '������' or rang == '��.�������' or  rang == '�������' or  rang == '���������' then
                if not cfg.main.tarb then
                    sampSendChat(string.format('/r ���� �� ��� %s ������������ �� ��������, ���.', nikk:gsub('_', ' ')))
                    aroop = false
                    nikk = nil
                else
                    sampSendChat(string.format('/r [%s]: ���� �� ��� %s ������������ �� ��������, ���.', cfg.main.tar, nikk:gsub('_', ' ')))
                    aroop = false
                    nikk = nil
                end
            else
                sampSendChat(string.format("/d Mayor, ���� �� ��� %s ������������ �� ��������, ���.", nikk:gsub('_', ' ')))
                aroop = false
                --nikk = nil
                nazhaloop = true
            end
        end
    end
end

function oopnetkey()
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
        ftext("�������� ���� �������.", -1)
    end
    if zaproop == true then
        zaproop = false
        nikk = nil
        ftext("�������� ���� �������.", -1)
    end
    if aroop == true then
        aroop = false
        nikk = nil
        ftext("�������� ���� �������.", -1)
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
        end
    end
    saveData(cfg, 'moonloader/config/fbitools/config.json')
    if not doesFileExist("moonloader/config/fbitools/keys.json") then
        local fa = io.open("moonloader/config/fbitools/keys.json", "w")
		fa:write(encodeJson(config_keys))
        fa:close()
    else
        local fa = io.open("moonloader/config/fbitools/keys.json", 'r')
        if fa then
            config_keys = decodeJson(fa:read('*a'))
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
                name = '����1'
            },
            [2] = {
                text = "",
                v = {},
                name = '����2'
            },
            [3] = {
                text = "",
                v = {},
                name = '����3'
            }
        }
    end
    saveData(tBindList, fileb)
    repeat wait(0) until isSampAvailable()
    ftext(script.this.name..' ������� ��������. �������: /ft ��� �� �������� �������������� ����������.')
    ftext('������: '..table.concat(script.this.authors))
    libs()
    registerCommands()
    registerSphere()
    registerHotKey()
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
        if v.name == nil then v.name = "����"..k end
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
                if mainw.v then mainw.v = false consumeWindowMessage(true, true) end
                if imegaf.v then imegaf.v = false consumeWindowMessage(true, true) end
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
        if gmegafid == nil then gmegafid = -1 end
        if #departament > 25 then table.remove(departament, 1) end
        if #radio > 25 then table.remove(radio, 1) end
        if #wanted > 25 then table.remove(wanted, 1) end
        if #sms > 25 then table.remove(sms, 1) end
        infbar = imgui.ImBool(cfg.main.hud)
        imgui.Process = infbar.v or mainw.v or shpwindow.v or ykwindow.v or fpwindow.v or akwindow.v or updwindows.v or imegaf.v
        local myskin = getCharModel(PLAYER_PED)
        if myskin == 280 or myskin == 265 or myskin == 266 or myskin == 267 or myskin == 281 or myskin == 282 or myskin == 288 or myskin == 284 or myskin == 285 or myskin == 304 or myskin == 305 or myskin == 306 or myskin == 307 or myskin == 309 or myskin == 283 or myskin == 286 or myskin == 287 or myskin == 252 or myskin == 279 or myskin == 163 or myskin == 164 or myskin == 165 or myskin == 166 then
            rabden = true
        end
        if sampIsDialogActive() == false and not isPauseMenuActive() and isPlayerPlaying(playerHandle) and sampIsChatInputActive() == false then
            if coordX ~= nil and coordY ~= nil then
                cX, cY, cZ = getCharCoordinates(playerPed)
                cX = math.ceil(cX)
                cY = math.ceil(cY)
                cZ = math.ceil(cZ)
                ftext('����� ����������� �� '..kvadY..'-'..kvadX)
                placeWaypoint(coordX, coordY, 0)
                coordX = nil
                coordY = nil
            end
        end
        if not doesCharExist(gmegafhandle) and gmegafhandle ~= nil then
            ftext(string.format('����� {9966cc}%s [%s] {ffffff}������� �� ���� ������', sampGetPlayerNickname(gmegafid), gmegafid))
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
            if result and wasKeyPressed(key.VK_Z) then
                gmegafhandle = ped
                gmegafid = id
                gmegaflvl = sampGetPlayerScore(id)
                gmegaffrak = sampGetFraktionBySkin(id)
                submenus_show(pkmmenu(id), "{9966cc}FBI Tools {ffffff}| "..sampGetPlayerNickname(id).."["..id.."] ")
            end
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
                ftext('����� {9966cc}'..oopdelnick..'{ffffff} ��� ������ �� ������ ���')
            elseif button == 0 then
                sampShowDialog(2458, '{9966cc}FBI Tools | {ffffff}������ ���', table.concat(ooplistt, '\n'), '�', "x", 2)
            end
        end
        if ooplresult then
            if button == 1 then
                local ltext = sampGetListboxItemText(list)
                if ltext:match("���� �� ��� .+ ������������ �� ��������, ���") then
                    oopdelnick = ltext:match("���� �� ��� (.+) ������������ �� ��������, ���")
                    sampShowDialog(2459, '{9966cc}FBI Tools | {ffffff}�������� �� ���', "{ffffff}�� ������������� ������� ������� {9966cc}"..oopdelnick.."\n{ffffff}�� ������ ���?", "�", "�", 0)
                elseif ltext:match("���� .+ ������������ �� �������� %- ���.") then
                    oopdelnick = ltext:match("���� (.+) ������������ �� �������� %- ���.")
                    sampShowDialog(2459, '{9966cc}FBI Tools | {ffffff}�������� �� ���', "{ffffff}�� ������������� ������� ������� {9966cc}"..oopdelnick.."\n{ffffff}�� ������ ���?", "�", "�", 0)
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
                    ftext('�� �� ������� ����� ������.')
                end
            end
        end
        if result16 then
            if input ~= '' and button == 1 then
                if cfg.main.tarb then
                    sampSendChat(string.format('/r [%s]: ���������� ��������� � ������� %s �� %s', cfg.main.tar, kvadrat(), input))
                else
                    sampSendChat(string.format('/r ���������� ��������� � ������� %s �� %s', kvadrat(), input))
                end
            end
        end
        if result then
            if button == 1 then
				sampSendChat(("/r %s � ����� %s. �������: %s"):format(cfg.main.male and '����������' or '�����������', mstype, input))
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
                if rang == '�����' or rang == '������' or rang == '��.�������' or  rang == '�������' or  rang == '���������' then
                    if not cfg.main.tarb then
                        sampSendChat("/r ���� �� ��� "..sampGetPlayerNickname(pID):gsub('_', ' ').." ������������ �� ��������, ���.")
                    else
                        sampSendChat("/r ["..cfg.main.tar.."]: ���� �� ��� "..sampGetPlayerNickname(pID):gsub('_', ' ').." ������������ �� ��������, ���.")
                    end
                else
                    sampSendChat("/d Mayor, ���� �� ��� "..sampGetPlayerNickname(pID):gsub('_', ' ').." ������������ �� ��������, ���.")
                end
            else
                ftext("����� � ID: "..pID.." �� ��������� � �������")
            end
        else
            ftext("�������: /oop [id]")
        end
    else
        ftext("�� �� ��������� ��/FBI")
    end
end

function tazer()
    lua_thread.create(function()
        sampSendChat("/tazer")
        wait(1400)
        sampSendChat(('/me %s ��� ��������'):format(cfg.main.male and '������' or '�������'))
    end)
end

function su(pam)
    pID = tonumber(pam)
    if pID ~= nil then
        if sampIsPlayerConnected(pID) then
            lua_thread.create(function()
                submenus_show(sumenu(pID), "{9966cc}FBI Tools {ffffff}| "..sampGetPlayerNickname(pID).."["..pID.."] ")
            end)
        else
            ftext("����� � ID: "..pID.." �� ��������� � �������")
        end
    else
        ftext("�������: /su [id]")
    end
end

function ssu(pam)
    local id, zv, orichina = pam:match('(%d+) (%d+) (.+)')
    if id and zv and orichina then
        sampSendChat(string.format('/su %s %s %s', id, zv, orichina))
    else
        ftext('�������: /ssu [id] [���-�� �����] [�������]')
    end
end

function keys()
    lua_thread.create(function()
        sampSendChat(("/me %s ����"):format(cfg.main.male and '����' or '�����'))
        wait(cfg.commands.zaderjka)
        sampSendChat("/me ���������� ���� � ������ �� ���")
        wait(cfg.commands.zaderjka)
        sampSendChat(("/try %s, ��� ����� ���������"):format(cfg.main.male and '���������', '����������'))
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
                            sampSendChat(("/me %s %s �� ������� ���������"):format(cfg.main.male and '�������' or '��������', sampGetPlayerNickname(id):gsub("_", ' ')))
                            wait(1400)
                            sampSendChat(("/cput %s %s"):format(id, getFreeSeat()))
                        else
                            sampSendChat(("/me %s ����� ���������� � %s ���� %s"):format(cfg.main.male and '������' or '�������', cfg.main.male and '���������' or '����������', sampGetPlayerNickname(id):gsub("_", ' ')))
                            wait(1400)
                            sampSendChat(("/cput %s %s"):format(id, getFreeSeat()))
                        end
                    else
                        sampSendChat(("/me %s ����� ���������� � %s ���� %s"):format(cfg.main.male and '������' or '�������', cfg.main.male and '���������' or '����������', sampGetPlayerNickname(id):gsub("_", ' ')))
                        while not isCharInAnyCar(PLAYER_PED) do wait(0) end
                        sampSendChat(("/cput %s %s"):format(id, getFreeSeat()))
                    end
                else
                    ftext("����� �������")
                end
            elseif pam:match("^(%d+) (%d+)$") then
                local id, seat = pam:match("^(%d+) (%d+)$")
                local id, seat = tonumber(id), tonumber(seat)
                if sampIsPlayerConnected(id) then
                    if seat >=1 and seat <=3 then
                        if isCharInAnyCar(PLAYER_PED) then
                            if isCharOnAnyBike(PLAYER_PED) then
                                sampSendChat(("/me %s %s �� ������� ���������"):format(cfg.main.male and '�������' or '��������', sampGetPlayerNickname(id):gsub("_", ' ')))
                                wait(1400)
                                sampSendChat(("/cput %s %s"):format(id, seat))
                            else
                                sampSendChat(("/me %s ����� ���������� � %s ���� %s"):format(cfg.main.male and '������' or '�������', cfg.main.male and '���������' or '����������', sampGetPlayerNickname(id):gsub("_", ' ')))
                                wait(1400)
                                sampSendChat(("/cput %s %s"):format(id, seat))
                            end
                        else
                            sampSendChat(("/me %s ����� ���������� � %s ���� %s"):format(cfg.main.male and '������' or '�������', cfg.main.male and '���������' or '����������', sampGetPlayerNickname(id):gsub("_", ' ')))
                            while not isCharInAnyCar(PLAYER_PED) do wait(0) end
                            sampSendChat(("/cput %s %s"):format(id, seat))
                        end
                    else
                        ftext('�������� �� ������ ���� ������ 1 � ������ 3!')
                    end
                else
                    ftext('����� �������')
                end
            elseif #pam == 0 or not pam:match("^(%d+)$") or not pam:match("^(%d+) (%d+)$") then
                ftext('�������: /cput [id] [�����(�� �����������)]')
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
                        sampSendChat(("/me %s %s � ���������"):format(cfg.main.male and '�������' or '��������', sampGetPlayerNickname(id):gsub('_', ' ')))
                        wait(1400)
                        sampSendChat(("/ceject %s"):format(id))
                    else
                        sampSendChat(("/me %s ����� ���������� � %s %s"):format(cfg.main.male and '������' or '�������', cfg.main.male and '�������' or '��������', sampGetPlayerNickname(id):gsub('_', ' ')))
                        wait(1400)
                        sampSendChat(("/ceject %s"):format(id))
                    end
                else
                    ftext('����� �������')
                end
            else
                ftext('�������: /ceject [id]')
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
        sampSendChat('/m ['..frak..'] ��������, ������� �������� � ���������� � ������� ��� �� ������� �����!')
    end
    if id ~= nil and not sampIsPlayerConnected(id) then
        ftext(string.format('����� � ID: %s �� ��������� � �������', id), -1)
    end
    if result and not doesCharExist(ped) then
        local stname = sampGetPlayerNickname(id)
        ftext(string.format('����� %s [%s] �� ��������', stname, id), -1)
    end
    if result and doesCharExist(ped) and not isCharInAnyCar(ped) then
        local stnaame = sampGetPlayerNickname(id)
        ftext(string.format('����� %s [%s] �� � ����������', stnaame, id), -1)
    end
    if result and doesCharExist(ped) and isCharInAnyCar(ped) then
        local vehName = tCarsName[getCarModel(storeCarCharIsInNoSave(ped))-399]
        sampSendChat("/m �������� �/C "..vehName.." � ���.������� [EVL"..id.."X], ���������� � ������� � ���������� ��� �/�")
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
                            sampSendChat(("/me %s ����� �������� � %s %s"):format(cfg.main.male and '������' or '�������', cfg.main.male and '�������' or '��������', sampGetPlayerNickname(id):gsub('_', ' ')))
                        elseif isCharInModel(ped, 481) or isCharInModel(ped, 510) then
                            sampSendChat(("/me %s %s � ����������"):format(cfg.main.male and '������' or '�������', sampGetPlayerNickname(id):gsub('_', ' ')))
                        elseif isCharInModel(ped, 462) then
                            sampSendChat(("/me %s %s �� �������"):format(cfg.main.male and '������' or '�������', sampGetPlayerNickname(id):gsub('_', ' ')))
                        elseif isCharOnAnyBike(ped) then
                            sampSendChat(("/me %s %s � ���������"):format(cfg.main.male and '������' or '�������', sampGetPlayerNickname(id):gsub('_', ' ')))
                        elseif isCharInAnyCar(ped) then
                            sampSendChat(("/me %s ���� � %s %s �� ������"):format(cfg.main.male and '������' or '�������', cfg.main.male and '�������' or '��������', sampGetPlayerNickname(id):gsub('_', ' ')))
                        end
                        wait(1400)
                        sampSendChat(("/deject %s"):format(id))
                    end
                else
                    ftext('����� �������')
                end
            else
                ftext("�������: /deject [id]")
            end
        else
            sampSendChat(("/deject %s"):format(pam))
        end
    end)
end

function rh(id)
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if id == "" or id < "1" or id > "3" or id == nil then
        ftext("�������: /rh �����������", -1)
        ftext("1 - LSPD | 2 - SFPD | 3 - LVPD", -1)
    elseif id == "1" then
        sampSendChat("/d LSPD, ���������� ���������� ������ � "..kvadrat()..", ��� �������? ����� �� ���."..myid)
    elseif id == "2" then
        sampSendChat("/d SFPD, ���������� ���������� ������ � "..kvadrat()..", ��� �������? ����� �� ���."..myid)
    elseif id == "3" then
        sampSendChat("/d LVPD, ���������� ���������� ������ � "..kvadrat()..", ��� �������? ����� �� ���."..myid)
    end
end
function gr(pam)
    local dep, reason = pam:match('(%d+)%s+(.+)')
    if dep == nil or reason == nil then
        ftext("�������: /gr [1-3] [�������]")
        ftext("1 - LSPD | 2 - SFPD | 3 - LVPD")
    end
    if dep ~= nil then
        if dep == "" or dep < "1" or dep > "3" then
            ftext("{9966CC}FBI Tools {FFFFFF}| �������: /gr [1-3] [�������]")
            ftext("{9966CC}FBI Tools {FFFFFF}| 1 - LSPD | 2 - SFPD | 3 - LVPD")
        elseif dep == "1" then
            sampSendChat("/d LSPD, ��������� ���� ����������, "..reason)
        elseif dep == "2" then
            sampSendChat("/d SFPD, ��������� ���� ����������, "..reason)
        elseif dep == "3" then
            sampSendChat("/d LVPD, ��������� ���� ����������, "..reason)
        end
    end
end
function warn(pam)
    local id = tonumber(pam)
    if frak == 'FBI' then
        if id == nil then
            ftext('������� /warn ID')
        end
        if id ~= nil and sampIsPlayerConnected(id) then
            lua_thread.create(function()
                warnst = true
                sampSendChat('/mdc '..id)
                wait(1400)
                if wfrac == 'LSPD' or wfrac == 'SFPD' or wfrac == 'LVPD' then
                    sampSendChat(string.format('/d %s, %s �������� �������������� �� ������������ ������ � ������.', wfrac, sampGetPlayerNickname(id):gsub('_', ' ')))
                else
                    ftext('������� �� �������� ����������� PD')
                end
                wfrac = nil
                warnst = false
            end)
        end
    else
        ftext("�� �� ��������� ���")
    end
end
function ms(pam)
	lua_thread.create(function()
		if frak == 'FBI' then
			if pam == "" or pam < "0" or pam > "3" or pam == nil then
				ftext("�������: /ms [���]", -1)
				ftext("0 - ����� ���������� | 1 - ���� | 2 - �������� | 3 - �����", -1)
			elseif pam == '1' then
				sampSendChat(("/me %s � ���� ������ ������ � %s �� �������"):format(cfg.main.male and '����' or '�����', cfg.main.male and '�������' or '��������'))
				wait(cfg.commands.zaderjka)
				sampSendChat(("/me %s ����, ����� ���� ������ %s ����������"):format(cfg.main.male and '������' or '�������', cfg.main.male and '������' or '�������'))
				wait(cfg.commands.zaderjka)
				sampSendChat(("/me %s �� ���� ���������� � %s ����"):format(cfg.main.male and '�����' or '������', cfg.main.male and '������' or '�������'))
				wait(cfg.commands.zaderjka)
				sampSendChat("/do ����� � ����������.")
				wait(100)
				submenus_show(osnova, "{9966cc}FBI Tools {ffffff}| Mask")
			elseif pam == '2' then
				sampSendChat(("/me %s �������� ����������"):format(cfg.main.male and '������' or '�������'))
				wait(cfg.commands.zaderjka)
				sampSendChat(("/me %s � ���� ������ ������ � %s � ��������"):format(cfg.main.male and '����' or '�����', cfg.main.male and '�����' or '������'))
				wait(cfg.commands.zaderjka)
				sampSendChat(("/me %s �� ��������� �������� ���������� � %s �� ����"):format(cfg.main.male and '������' or '�������', cfg.main.male and '�����' or '������'))
				wait(cfg.commands.zaderjka)
				sampSendChat(("/me %s ��������"):format(cfg.main.male and '������' or '�������'))
				wait(cfg.commands.zaderjka)
				sampSendChat("/do ����� � ����������.")
				wait(100)
				submenus_show(osnova, "{9966cc}FBI Tools {ffffff}| Mask")
			elseif pam == '3' then
				sampSendChat("/do �� ����� ������ ����� �����.")
				wait(cfg.commands.zaderjka)
				sampSendChat(("/me ������ �����, %s ������ ������ � %s ����"):format(cfg.main.male and '����' or '�����', cfg.main.male and '�����' or '������'))
				wait(cfg.commands.zaderjka)
				sampSendChat(("/me %s �� ����� �������� ���������� � %s �� ����"):format(cfg.main.male and '������' or '�������', cfg.main.male and '�����' or '������'))
				wait(cfg.commands.zaderjka)
				sampSendChat(("/me %s �����"):format(cfg.main.male and '������' or '�������'))
				wait(cfg.commands.zaderjka)
				sampSendChat("/do ����� � ����������.")
				wait(100)
				submenus_show(osnova, "{9966cc}FBI Tools {ffffff}| Mask")
			elseif pam == '0' then
				sampSendChat(("/me %s � ���� ����������"):format(cfg.main.male and '����' or '�����'))
				wait(cfg.commands.zaderjka)
				sampSendChat(("/me %s �� ���� ������ ������"):format(cfg.main.male and '�����' or '������'))
				wait(cfg.commands.zaderjka)
				sampSendChat(("/r %s � ������ ������"):format(cfg.main.male and '����������' or '�����������'))
				wait(cfg.commands.zaderjka)
				sampSendChat("/rb "..select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
			end
		else
			ftext('�� �� ��������� FBI')
		end
	end)
end

function ar(id)
    if id == "" or id < "1" or id > "2" or id == nil then
        ftext("�������: /ar [1-2]", -1)
        ftext("1 - LVa | 2 - SFa", -1)
    elseif id == "1" then
        sampSendChat("/d LVa, ��������� ����� �� ���� ����������, ������ �����������.")
    elseif id == "2" then
        sampSendChat("/d SFa, ��������� ����� �� ���� ����������, ������ �����������.")
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
        ftext('������� /r [�����]')
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
        ftext('������� /f [�����]')
    end
end

function fst(param)
    local hour = tonumber(param)
    if hour ~= nil and hour >= 0 and hour <= 23 then
        time = hour
        patch_samp_time_set(true)
        if time then
            setTimeOfDay(time, 0)
            ftext('����� �������� ��: {9966cc}'..time, -1)
        end
    else
        ftext('�������� ������� ������ ���� � ��������� �� 0 �� 23.', -1)
        patch_samp_time_set(false)
        time = nil
    end
end

function fsw(param)
    local weather = tonumber(param)
    if weather ~= nil and weather >= 0 and weather <= 45 then
        forceWeatherNow(weather)
        ftext('������ �������� ��: {9966cc}'..weather, -1)
    else
        ftext('�������� ������ ������ ���� � ��������� �� 0 �� 45.', -1)
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
        ftext('������� /fshp [�����]')
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
        ftext('������� /fyk [�����]')
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
        ftext('������� /ffp [�����]')
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
        ftext('������� /fak [�����]')
    end
end

function dmb()
	lua_thread.create(function()
		status = true
		sampSendChat('/members')
		while not gotovo do wait(0) end
		if gosmb then
			sampShowDialog(716, "{ffffff}� ����: "..gcount.." | {ae433d}�����������", table.concat(players2, "\n"), "x", _, 5)
		elseif krimemb then
			sampShowDialog(716, "{ffffff}� ����: "..gcount.." | {ae433d}�����������", table.concat(players1, "\n"), "x", _, 5)
		end
		gosmb = false
		krimemb = false
		gotovo = false
		status = false
		players2 = {'{ffffff}���\t{ffffff}����\t{ffffff}������'}
		players1 = {'{ffffff}���\t{ffffff}����'}
		gcount = nil
	end)
end

function megaf()
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
                                if sampGetFraktionBySkin(v) ~= '�������' then
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
                            sampSendChat(("/m �������� �/� %s [EVL%sX]"):format(tCarsName[carhm-399], incar[1]))
                            wait(1400)
                            sampSendChat("/m ���������� � ������� ��� �� ������� �����!")
                            wait(300)
                            sampAddChatMessage(' {ffffff}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~', 0x9966cc)
                            sampAddChatMessage('', 0x9966cc)
                            sampAddChatMessage(' {ffffff}���: {9966cc}'..sampGetPlayerNickname(incar[1])..' ['..incar[1]..']', 0x9966cc)
                            sampAddChatMessage(' {ffffff}�������: {9966cc}'..sampGetPlayerScore(incar[1]), 0x9966cc)
                            sampAddChatMessage(' {ffffff}�������: {9966cc}'..sampGetFraktionBySkin(incar[1]), 0x9966cc)
                            sampAddChatMessage('', 0x9966cc)
                            sampAddChatMessage(' {ffffff}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~', 0x9966cc)
                            gmegafid = v
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
                                sampSendChat(("/m �������� �/� %s [EVL%sX]"):format(tCarsName[carhm-399], v))
                                wait(1400)
                                sampSendChat("/m ���������� � ������� ��� �� ������� �����!")
                                wait(300)
                                sampAddChatMessage(' {ffffff}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~', 0x9966cc)
                                sampAddChatMessage('', 0x9966cc)
                                sampAddChatMessage(' {ffffff}���: {9966cc}'..sampGetPlayerNickname(v)..' ['..v..']', 0x9966cc)
                                sampAddChatMessage(' {ffffff}�������: {9966cc}'..sampGetPlayerScore(v), 0x9966cc)
                                sampAddChatMessage(' {ffffff}�������: {9966cc}'..sampGetFraktionBySkin(v), 0x9966cc)
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
            ftext("��� ���������� ������ � ����������")
        end
    end)
end

function dkld()
    if isCharInAnyCar(PLAYER_PED) then
        if post ~= 7 and post ~= 12 and post ~= 13 and post ~= 14 and post ~= 18 and post ~= 21 and post ~= 22 and post ~= 23 and post ~= 24 and post ~= 25 and post ~= 26 and post ~= 27 and post ~= 28 and post ~= 29 and post ~= 30 and post ~= 31 then
            if frak == 'LSPD' then
                if not cfg.main.tarb  then
                    sampSendChat('/r ������� �. ���-������. '..naparnik())
                else
                    sampSendChat('/r ['..cfg.main.tar..']: ������� �. ���-������. '..naparnik())
                end
            elseif frak == 'SFPD' then
                if not cfg.main.tarb then
                    sampSendChat('/r ������� �. ���-������. '..naparnik())
                else
                    sampSendChat('/r ['..cfg.main.tar..']: ������� �. ���-������. '..naparnik())
                end
            elseif frak == 'LVPD' then
                if not cfg.main.tarb then
                    sampSendChat('/r ������� �. ���-��������. '..naparnik())
                else
                    sampSendChat('/r ['..cfg.main.tar..']: ������� �. ���-��������. '..naparnik())
                end
            end
        end
        if post == 7 or post == 12 or post == 13 or post == 14 or post == 18 then
            if not cfg.main.tarb then
                sampSendChat('/r ����: '..getNameSphere(post)..'. '..naparnik())
            else
                sampSendChat('/r ['..cfg.main.tar..']: ����: '..getNameSphere(post)..'. '..naparnik())
            end
        end
        if post == 21 then
            if not cfg.main.tarb then
                sampSendChat('/r ������� �������� ������. '..naparnik())
            else
                sampSendChat('/r ['..cfg.main.tar..']: ������� �������� ������. '..naparnik())
            end
        end
        if post == 22 then
            if cfg.main.tar == nil then
                sampSendChat('/r ������� ���. '..naparnik())
            else
                sampSendChat('/r ['..cfg.main.tar..']: ������� ���. '..naparnik())
            end
        end
        lua_thread.create(function()
            if post == 23 then
                if frak == 'LSPD' then
                    sampSendChat('/d SFPD, ��������� ���� ����������, ������.')
                elseif frak == 'SFPD' then
                    sampSendChat('/d LSPD, ��������� ���� ����������, ������.')
                elseif frak == 'LVPD' then
                    submenus_show(yrisdkld1404, '{9966CC}FBI Tools{ffffff} | ����������� ����������')
                end
            end
            if post == 24 then
                if frak == 'LSPD' then
                    sampSendChat('/d LVPD, ��������� ���� ����������, ������.')
                elseif frak == 'LVPD' then
                    sampSendChat('/d LSPD, ��������� ���� ����������, ������.')
                elseif frak == 'SFPD' then
                    submenus_show(yrisdkld1405, '{9966CC}FBI Tools{ffffff} | ����������� ����������')
                end
            end
            if post == 25 then
                if frak == 'LSPD' then
                    sampSendChat('/d LVPD, ��������� ���� ����������, ������.')
                elseif frak == 'LVPD' then
                    sampSendChat('/d LSPD, ��������� ���� ����������, ������.')
                elseif frak == 'SFPD' then
                    submenus_show(yrisdkld1405, '{9966CC}FBI Tools{ffffff} | ����������� ����������')
                end
            end
            if post == 26 then
                if frak == 'LSPD' then
                    sampSendChat('/d LVPD, ��������� ���� ����������, ������.')
                elseif frak == 'LVPD' then
                    sampSendChat('/d LSPD, ��������� ���� ����������, ������.')
                elseif frak == 'SFPD' then
                    submenus_show(yrisdkld1405, '{9966CC}FBI Tools{ffffff} | ����������� ����������')
                end
            end
            if post == 27 then
                if frak == 'LVPD' then
                    sampSendChat('/d SFPD, ��������� ���� ����������, ������.')
                elseif frak == 'SFPD' then
                    sampSendChat('/d LVPD, ��������� ���� ����������, ������.')
                elseif frak == 'LSPD' then
                    submenus_show(yrisdkld1406, '{9966CC}FBI Tools{ffffff} | ����������� ����������')
                end
            end
            if post == 28 then
                if frak == 'LVPD' then
                    sampSendChat('/d SFPD, ��������� ���� ����������, ������.')
                elseif frak == 'SFPD' then
                    sampSendChat('/d LVPD, ��������� ���� ����������, ������.')
                elseif frak == 'LSPD' then
                    submenus_show(yrisdkld1406, '{9966CC}FBI Tools{ffffff} | ����������� ����������')
                end
            end
            if post == 29 then
                if frak == 'LSPD' then
                    sampSendChat('/d SFPD, ��������� ���� ����������, ������.')
                elseif frak == 'SFPD' then
                    sampSendChat('/d LSPD, ��������� ���� ����������, ������.')
                elseif frak == 'LVPD' then
                    submenus_show(yrisdkld1404, '{9966CC}FBI Tools{ffffff} | ����������� ����������')
                end
            end
            if post == 30 then
                if frak == 'LSPD' then
                    sampSendChat('/d SFPD, ��������� ���� ����������, ������.')
                elseif frak == 'SFPD' then
                    sampSendChat('/d LSPD, ��������� ���� ����������, ������.')
                elseif frak == 'LVPD' then
                    submenus_show(yrisdkld1404, '{9966CC}FBI Tools{ffffff} | ����������� ����������')
                end
            end
            if post == 31 then
                if frak == 'LSPD' then
                    sampSendChat('/d SFPD, ��������� ���� ����������, ������.')
                elseif frak == 'SFPD' then
                    sampSendChat('/d LSPD, ��������� ���� ����������, ������.')
                elseif frak == 'LVPD' then
                    submenus_show(yrisdkld1404, '{9966CC}FBI Tools{ffffff} | ����������� ����������')
                end
            end
        end)
    end
    if not isCharInAnyCar(PLAYER_PED) then
        if post ~= nil and post ~= 8 then
            if getNameSphere(post) ~= nil then
                if not cfg.main.tarb then
                    sampSendChat('/r ����: '..getNameSphere(post)..'. '..naparnik())
                else
                    sampSendChat('/r ['..cfg.main.tar..']: ����: '..getNameSphere(post)..'. '..naparnik())
                end
                if post == 8 then
                    if not cfg.main.tarb then
                        sampSendChat('/r ����: '..getNameSphere(post)..'. '..naparnik())
                    else
                        sampSendChat('/r ['..cfg.main.tar..']: ����: '..getNameSphere(post)..'. '..naparnik())
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
                sampSendChat(("/me %s ��� � %s ���������� ��������"):format(cfg.main.male and '������' or '�������', cfg.main.male and '������' or '�������'))
                wait(cfg.commands.zaderjka)
                sampSendChat(("/do ��� ��� ����������: ���: %s."):format(sampGetPlayerNickname(id):gsub('_', ' ')))
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
                ftext("����� �������")
            end
        else
            ftext("�������: /kmdc [id]")
        end
    end)
end

function fvz(pam)
    local id = tonumber(pam)
    local _, myid = sampGetPlayerIdByCharHandle(playerPed)
    if frak == 'FBI' then
        if id == nil then
            ftext("�������: /fvz [id]")
        end
        if id ~= nil and sampIsPlayerConnected(id) then
            lua_thread.create(function()
                warnst = true
                sampSendChat('/mdc '..id)
                wait(1400)
                if wfrac == 'LSPD' or wfrac == 'SFPD' or wfrac == 'LVPD' or wfrac == 'LVa' or wfrac == 'SFa' then
                    sampSendChat(string.format('/d %s, %s, ������� � ���� ��� �� ��������. ��� �������? ����� �� ���.%s', wfrac, sampGetPlayerNickname(id):gsub('_', ' '), myid))
                else
                    ftext('������� �� �������� ����������� PD/Army')
                end
                warnst = false
                wfrac = nil
            end)
        end
    else
        ftext("�� �� ��������� ���")
    end
end

function ftazer(pam)
    lua_thread.create(function()
        local id = tonumber(pam)
        if cfg.commands.ftazer then
            if id ~= nil then
                if id >=1 and id <=3 then
                    sampSendChat(("/me %s �� ����������� ������� ������"):format(cfg.main.male and '������' or '�������'))
                    wait(1400)
                    sampSendChat(("/me %s ������ � %s"):format(cfg.main.male and '�����' or '������', cfg.main.male and '����������' or '�����������'))
                    wait(1400)
                    sampSendChat(("/me %s ������������ �������"):format(cfg.main.male and '������' or '�������'))
                    wait(1400)
                    sampSendChat(("/ftazer %s"):format(id))
                else
                    ftext("�������� �� ����� ���� ������ 1 � ������ 3!")
                end
            else
                ftext("�������: /ftazer [���]")
            end
        else
            sampSendChat(("/ftazer %s"):format(pam))
        end
    end)
end

function df()
    lua_thread.create(function()
        submenus_show(dfmenu, "{9966cc}FBI Tools {ffffff}| Bomb Menu")
    end)
end

function fbd(pam)
    local id = tonumber(pam)
    if frak == 'FBI' then
        if id == nil then
            ftext("�������: /fbd [id]")
        end
        if id ~= nil and sampIsPlayerConnected(id) then
            lua_thread.create(function()
                local _, myid = sampGetPlayerIdByCharHandle(playerPed)
                warnst = true
                sampSendChat('/mdc '..id)
                wait(1400)
                if wfrac == 'LSPD' or wfrac == 'SFPD' or wfrac == 'LVPD' then
                    sampSendChat(string.format('/d %s, %s, ������� ��������� �� �� �.%s', wfrac, sampGetPlayerNickname(id):gsub('_', ' '), myid))
                else
                    ftext('������� �� �������� ����������� PD')
                end
                warnst = false
                wfrac = nil
            end)
        end
    else
        ftext("�� �� ��������� ���")
    end
end

function cc()
    local memory = require "memory"
    memory.fill(sampGetChatInfoPtr() + 306, 0x0, 25200)
    memory.write(sampGetChatInfoPtr() + 306, 25562, 4, 0x0)
    memory.write(sampGetChatInfoPtr() + 0x63DA, 1, 1)
end

function blg(pam)
    local id, frack, pric = pam:match('(%d+) (%a+) (.+)')
    if id and frack and pric and sampIsPlayerConnected(id) then
        name = sampGetPlayerNickname(id)
        rpname = name:gsub('_', ' ')
        sampSendChat(string.format("/d %s, ��������� %s �� %s. ������", frack, rpname, pric))
    else
        ftext("�������: /blg [id] [�������] [�������]", -1)
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
    sampShowDialog(97987, '{9966cc}FBI Tools {ffffff} | ��� ��������� ������������', table.concat(departament, '\n'), '�', 'x', 0)
end

function rlog()
    sampShowDialog(97987, '{9966cc}FBI Tools {ffffff} | ��� ��������� �����', table.concat(radio, '\n'), '�', 'x', 0)
end

function sulog()
    sampShowDialog(97987, '{9966cc}FBI Tools {ffffff} | ��� ������ �������', table.concat(wanted, '\n'), '�', 'x', 0)
end

function smslog()
    sampShowDialog(97987, '{9966cc}FBI Tools {ffffff} | ��� SMS', table.concat(sms, '\n'), '�', 'x', 0)
end

function ticket(pam)
    lua_thread.create(function()
        local id, summa, reason = pam:match('(%d+) (%d+) (.+)')
        if id and summa and reason then
            if cfg.commands.ticket then
                sampSendChat(string.format("/me %s ����� � �����", cfg.main.male and '������' or '�������'))
                wait(cfg.commands.zaderjka)
                sampSendChat("/do ����� � ����� � �����.")
                wait(cfg.commands.zaderjka)
                sampSendChat("/me �������� ��������� �����")
                wait(cfg.commands.zaderjka)
                sampSendChat("/do ����� ��������.")
                wait(cfg.commands.zaderjka)
                sampSendChat(string.format("/me %s ����� ����������", cfg.main.male and '�������' or '��������'))
                wait(1400)
            end
            sampSendChat(string.format('/ticket %s %s %s', id, summa, reason))
        else
            ftext('�������: /ticket [id] [�����] [�������]')
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
            sampShowDialog(1765, '{9966cc}FBI Tools {ffffff}| ������ ������� ������ {9966cc}'..sampGetPlayerNickname(tonumber(zid)).. '[' ..zid.. ']', table.concat(dsuz, '\n').. '\n\n{ffffff}�������� ����� ��� ���������� � ������. ������: 15', '�', 'x', 1)
        end
    elseif #pam == 0 then
        ftext('�������: /z [id] [��������(�� �����������)]')
    end
end

function rt(pam)
    if #pam == 0 then
        ftext("������� /rt [�����]")
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
            sampShowDialog(2458, '{9966cc}FBI Tools | {ffffff}������ ���', table.concat(ooplistt, '\n'), '�', "x", 2)
            ftext('��� �������� ������ ��� �������� ������� /ooplist [id]')
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
        ftext('�������: /fkv [�������]')
        ftext('������: /fkv �-6')
    end
end

function fnr()
    lua_thread.create(function()
        vixodid = {}
		status = true
		sampSendChat('/members')
        while not gotovo do wait(0) end
        wait(1400)
        for k, v in pairs(vixodid) do
            sampSendChat('/sms '..v..' �� ������')
            wait(1400)
        end
        players2 = {'{ffffff}���\t{ffffff}����\t{ffffff}������'}
		players1 = {'{ffffff}���\t{ffffff}����'}
		gotovo = false
        status = false
        vixodid = {}
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