--██████╗ ██████╗ ██╗██╗     ██╗     ███████╗██████╗ ██╗███╗   ██╗██████╗ 
--██╔══██╗██╔══██╗██║██║     ██║     ██╔════╝██╔══██╗██║████╗  ██║██╔══██╗
--██║  ██║██████╔╝██║██║     ██║     █████╗  ██████╔╝██║██╔██╗ ██║██║  ██║
--██║  ██║██╔══██╗██║██║     ██║     ██╔══╝  ██╔═══╝ ██║██║╚██╗██║██║  ██║
--██████╔╝██║  ██║██║███████╗███████╗███████╗██║     ██║██║ ╚████║██████╔╝
--╚═════╝ ╚═╝  ╚═╝╚═╝╚══════╝╚══════╝╚══════╝╚═╝     ╚═╝╚═╝  ╚═══╝╚═════╝ 
------------------------CREDITS------------------------
--   Copyright 2020 ©Drillepind. All rights reserved --
-------------------------------------------------------


StillHere = false
delay = 250
tid = 0
sluttet = true

TriggerServerEvent("dp:status")

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(delay)
    local player = GetPlayerPed(-1)
    local StartJobCoords = Vdist(123.14703369141,-769.04260253906,242.15203857422, GetEntityCoords(player))
    if StartJobCoords < 3 then
      delay = 3
      if nyinfoStatus == false then
        DrawText3d(123.14703369141,-769.04260253906,242.15203857422, "Tryk ~b~E~s~ for at tage en sag")
        DrawMarker(27, 123.14703369141,-769.04260253906,242.15203857422-0.9, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5001, 238, 73, 73, 250, 0, 0, 0, 0)

        if IsControlJustPressed(1, 51) then
          TriggerServerEvent("dp:AdvokatCheckJob")
        end
      else
        DrawText3d(123.14703369141,-769.04260253906,242.15203857422, "~r~En kollega har påtaget sig opgaven!")
      end
    else
      delay = 250
    end         
  end
end)

RegisterNetEvent('dp_AdvokatHelp')
AddEventHandler('dp_AdvokatHelp', function()
  local pengeMand = GetHashKey( "s_m_m_highsec_01" )
  RequestModel( pengeMand )
  while not HasModelLoaded( pengeMand ) do
    Citizen.Wait(1)
  end  

  num = math.random(1,12)
  npc1 = CreatePed( 4, pengeMand, EmsNpc[num].x,EmsNpc[num].y,EmsNpc[num].z+1,EmsNpc[num].h, false, true )
  ClearAreaOfPeds(-11.340304374695,-1441.1440429688,31.573875427246, 1000000, 1)
  SetEntityAsMissionEntity(npc1, true, false)
  SetEntityCollision(npc1, true, true)
  SetNewWaypoint(EmsNpc[num].x,EmsNpc[num].y)
  StillHere = true
  TriggerEvent("dp_AdvokatAreHere", StillHere, num)
  tid = 300
  Timer()
end)

RegisterNetEvent('dp_AdvokatAreHere')
AddEventHandler('dp_AdvokatAreHere', function(StillHere, num)
  while StillHere do
  Citizen.Wait(3)
    if DoesEntityExist(npc1) then
      local player = GetPlayerPed(-1)
      local coords = GetEntityCoords(npc1)
      local npcCoords = Vdist(coords, GetEntityCoords(player))
      if npcCoords < 3 then
        
        vehSR_drawTxt("Tryk ~b~E~s~ for at hjælpe klienten",0,1,0.5,0.8,0.6,255,255,255,255)
        if IsControlJustPressed(1, 51) then
          exports['progressbars']:startUI(9900, "Udfylder papire")
          TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_CLIPBOARD")
          SetEntityHealth(npc1, 200)
          headingPlayer = GetEntityHeading(player)
          if headingPlayer <= 180 then
            heading = (headingPlayer + 179)
          else
            heading = (headingPlayer - 179)
          end
          Citizen.Wait(10000)
          FreezeEntityPosition(npc1, true)
          SetEntityHeading(npc1, heading)
          TriggerEvent("dp_tak_for_det_for_faen", true, num)
          ClearPedTasks(player)
          ClearPedTasksImmediately(npc1) 
          Citizen.Wait(5000)
          FreezeEntityPosition(npc1, false)
          TriggerServerEvent("dp:SavedByAdvokat")
          StillHere = false
          SetEntityAsNoLongerNeeded(npc1)
        end
      end
    end         
  end
end)

RegisterNetEvent('dp_status_c')
AddEventHandler('dp_status_c', function(status)
  nyinfoStatus = status
end)

RegisterNetEvent('dp_tak_for_det_for_faen')
AddEventHandler('dp_tak_for_det_for_faen', function(tak, num)
  while tak do
  Citizen.Wait(3)
  local takcoords = Vdist(EmsNpc[num].x,EmsNpc[num].y,EmsNpc[num].z, GetEntityCoords(GetPlayerPed(-1)))
    if takcoords < 5 then
      DrawText3d(EmsNpc[num].x,EmsNpc[num].y,EmsNpc[num].z, "Tak skal du have!")
    end
    Citizen.CreateThread(function()
      Citizen.Wait(5000)
      tak = false
    end)
  end
end)

function Timer()
  while tid > 0 do
    Citizen.Wait(1000)
    tid = tid - 1
    if tid == 0 and sluttet == true then 
      DeleteEntity(npc1)
      TriggerServerEvent("dp:stop")
      StillHere = false
    end
  end
end

function AddPropToPlayer(prop1, bone, off1, off2, off3, rot1, rot2, rot3)
  local Player = PlayerPedId()
  local x,y,z = table.unpack(GetEntityCoords(Player))

  if not HasModelLoaded(prop1) then
      LoadPropDict(prop1)
  end

  prop = CreateObject(GetHashKey(prop1), x, y, z+0.2,  true,  true, true)
  AttachEntityToEntity(prop, Player, GetPedBoneIndex(Player, bone), off1, off2, off3, rot1, rot2, rot3, true, true, false, true, 1, true)
  table.insert(props,prop)
  SetModelAsNoLongerNeeded(prop1)
end


function DrawText3d(x,y,z, text)
  local onScreen,_x,_y=World3dToScreen2d(x,y,z)
  local px,py,pz=table.unpack(GetGameplayCamCoords())
  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(1)
  AddTextComponentString(text)
  DrawText(_x,_y)
  local factor = (string.len(text)) / 370
  DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function vehSR_drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end