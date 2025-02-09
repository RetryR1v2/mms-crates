local VORPcore = exports.vorp_core:GetCore()
local BccUtils = exports['bcc-utils'].initiate()
local progressbar = exports.vorp_progressbar:initiate()
local CreatedCrates = {}
local Placed = false
local Active = false

local PlaceCrateGroup = BccUtils.Prompts:SetupPromptGroup()
local PlaceCratePrompt = PlaceCrateGroup:RegisterPrompt(_U('PlaceCrate'), 0x760A9C6F, 1, 1, true, 'hold', {timedeventhash = 'MEDIUM_TIMED_EVENT'}) --G
local AbortPlaceprompt = PlaceCrateGroup:RegisterPrompt(_U('AbortPlacement'), 0x27D1C284, 1, 1, true, 'hold', {timedeventhash = 'MEDIUM_TIMED_EVENT'}) --R

RegisterNetEvent('mms-crates:client:LoadCrates')
AddEventHandler('mms-crates:client:LoadCrates',function()
    TriggerServerEvent('mms-crates:server:LoadData')
end)

Citizen.CreateThread(function()
    Citizen.Wait(5000)
    TriggerServerEvent('mms-crates:server:LoadData')
end)

RegisterNetEvent('vorp:SelectedCharacter')
AddEventHandler('vorp:SelectedCharacter', function()
    Citizen.Wait(10000)
    TriggerServerEvent('mms-crates:server:LoadData')
end)

RegisterNetEvent('mms-crates:client:CratePlacement')
AddEventHandler('mms-crates:client:CratePlacement',function(ThisCrateData,ItemId)
    local dict = "mech_carry_box"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
    Package = CreateObject(GetHashKey("P_CRATE03X"), GetEntityCoords(PlayerPedId()), true, true, true)
    local FingerR12 = GetEntityBoneIndexByName(PlayerPedId(), 'SKEL_R_Finger12')
    AttachEntityToEntity(Package, PlayerPedId(), FingerR12,  0.20, -0.028, 0.001, 15.0, 175.0, 0.0, true, true, false, true, 1, true)
    TaskPlayAnim(PlayerPedId(),dict, "idle", 1.0, 8.0, -1, 31, 0, 0, 0,0)

    while not Placed do
        Citizen.Wait(3)
        PlaceCrateGroup:ShowGroup(_U('CratePlacementGroup'))

        if PlaceCratePrompt:HasCompleted() then
            CrouchAnim()
            Progressbar(5000,_U('PlaceItProgressbar'))
            ClearPedTasks(PlayerPedId())
            DeleteEntity(Package)
            Placed = true
            local MyPos = GetEntityCoords(PlayerPedId())
            local PosX = MyPos.x
            local PosY = MyPos.y
            local PosZ = MyPos.z - 1.0
            TriggerServerEvent('mms-crates:server:FinishCratePlacement',ThisCrateData,ItemId,PosX,PosY,PosZ)
            Citizen.Wait(200)
            TriggerEvent('mms-crates:client:Reload')
        end

        if AbortPlaceprompt:HasCompleted() then
            Placed = true
            ClearPedTasks(PlayerPedId())
            DeleteEntity(Package) break
        end
    end
    Citizen.Wait(200)
    Placed = false
end)

local OpenCrateGroup = BccUtils.Prompts:SetupPromptGroup()
local OpenCratePrompt = OpenCrateGroup:RegisterPrompt(_U('OpenCrate'), 0x760A9C6F, 1, 1, true, 'hold', {timedeventhash = 'MEDIUM_TIMED_EVENT'}) -- G
local PickupCratePrompt = OpenCrateGroup:RegisterPrompt(_U('PickUpCrate'), 0x27D1C284, 1, 1, true, 'hold', {timedeventhash = 'MEDIUM_TIMED_EVENT'}) -- R
local DeleteCratePrompt = OpenCrateGroup:RegisterPrompt(_U('DeleteCrate'), 0x05CA7C52, 1, 1, true, 'hold', {timedeventhash = 'MEDIUM_TIMED_EVENT'}) -- Down

RegisterNetEvent('mms-crates:client:PlaceCrateOnStart')
AddEventHandler('mms-crates:client:PlaceCrateOnStart',function(AllCrateData,MyCharID)
    for h,v in ipairs(AllCrateData) do
        if v.charidentifier == MyCharID then
            if v.placed == 1 then
                CrateObj = CreateObject(v.model, v.posx, v.posy, v.posz,true,true,false)
                SetEntityInvincible(CrateObj,true)
                FreezeEntityPosition(CrateObj,true)
                CreatedCrates[#CreatedCrates + 1] = CrateObj
            end
        end
    end
    TriggerEvent('mms-crates:client:StartPrompts',AllCrateData)
end)

RegisterNetEvent('mms-crates:client:Reload')
AddEventHandler('mms-crates:client:Reload',function()
    for h,v in ipairs(CreatedCrates) do
        DeleteObject(v)
    end
    Active = false
    Citizen.Wait(500)
    TriggerServerEvent('mms-crates:server:LoadData')
end)

RegisterNetEvent('mms-crates:client:StartPrompts')
AddEventHandler('mms-crates:client:StartPrompts',function(AllCrateData)
    Active = true
    while Active do
        Citizen.Wait(3)
    for h,v in ipairs(AllCrateData) do
        local CratePosX = v.posx
        local CratePosY = v.posy
        local CratePosZ = v.posz
        local MyPos = GetEntityCoords(PlayerPedId())
        local Distance = GetDistanceBetweenCoords(CratePosX,CratePosY,CratePosZ,MyPos.x,MyPos.y,MyPos.z,true)
        local CrateId = v.crateid
        local Inventory = v.inventory
        local Size = v.size
        if Distance < 3 and v.placed == 1 then
            OpenCrateGroup:ShowGroup(_U('OpenCrateGroup'))

            if OpenCratePrompt:HasCompleted() then
                TriggerServerEvent('mms-crates:server:OpenCrate',CrateId,Inventory)
            end

            if PickupCratePrompt:HasCompleted() then
                CrouchAnim()
                Progressbar(5000,_U('PickupThisChest'))
                ClearPedTasks(PlayerPedId())
                DeleteObject(CrateObj)
                Active = false
                TriggerServerEvent('mms-crates:server:PickupCrate',CrateId,Size)
                Citizen.Wait(200)
                CreatedCrates = {}
                TriggerEvent('mms-crates:client:Reload')
            end

            if DeleteCratePrompt:HasCompleted() then
                CrouchAnim()
                Progressbar(5000,_U('DeleteThisChest'))
                ClearPedTasks(PlayerPedId())
                DeleteObject(CrateObj)
                Placed = false
                TriggerServerEvent('mms-crates:server:DeleteCrate',CrateId)
                Citizen.Wait(200)
                CreatedCrates = {}
                TriggerEvent('mms-crates:client:Reload')
            end
        end
    end
end
end)


----------------- Utilities -----------------

------ Progressbar

function Progressbar(Time,Text)
    progressbar.start(Text, Time, function ()
    end, 'linear')
    Citizen.Wait(Time)
    ClearPedTasks(PlayerPedId())
end

------ Animation

function CrouchAnim()
    local dict = "script_rc@cldn@ig@rsc2_ig1_questionshopkeeper"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    TaskPlayAnim(ped, dict, "inspectfloor_player", 0.5, 8.0, -1, 1, 0, false, false, false)
end



---- CleanUp on Resource Restart 

RegisterNetEvent('onResourceStop',function(resource)
    if resource == GetCurrentResourceName() then
        for h,v in ipairs(CreatedCrates) do
            DeleteObject(v)
        end
    end
end)