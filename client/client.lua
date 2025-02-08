local VORPcore = exports.vorp_core:GetCore()
local BccUtils = exports['bcc-utils'].initiate()
local progressbar = exports.vorp_progressbar:initiate()
local CreatedCrates = {}
local Placed = false

local PlaceCrateGroup = BccUtils.Prompts:SetupPromptGroup()
local PlaceCratePrompt = PlaceCrateGroup:RegisterPrompt(_U('PlaceCrate'), 0x760A9C6F, 1, 1, true, 'hold', {timedeventhash = 'MEDIUM_TIMED_EVENT'}) --G
local AbortPlaceprompt = PlaceCrateGroup:RegisterPrompt(_U('AbortPlacement'), 0x27D1C284, 1, 1, true, 'hold', {timedeventhash = 'MEDIUM_TIMED_EVENT'}) --R

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
            TriggerServerEvent('mms-crates:server:RemoveItemById',ThisCrateData,ItemId)
            Progressbar(5000,_U('PlaceItProgressbar'))
            ClearPedTasks(PlayerPedId())
            DeleteEntity(Package)
            Placed = true
            TriggerEvent('mms-crates:client:PlaceCrateFinal',ThisCrateData,ItemId)
        end

        if AbortPlaceprompt:HasCompleted() then
            Placed = true
            ClearPedTasks(PlayerPedId())
            DeleteEntity(Package) break
        end
    end
end)

local OpenCrateGroup = BccUtils.Prompts:SetupPromptGroup()
local OpenCratePrompt = OpenCrateGroup:RegisterPrompt(_U('OpenCrate'), 0x760A9C6F, 1, 1, true, 'hold', {timedeventhash = 'MEDIUM_TIMED_EVENT'}) -- G
local PickupCratePrompt = OpenCrateGroup:RegisterPrompt(_U('PickUpCrate'), 0x27D1C284, 1, 1, true, 'hold', {timedeventhash = 'MEDIUM_TIMED_EVENT'}) -- R
local DeleteCratePrompt = OpenCrateGroup:RegisterPrompt(_U('DeleteCrate'), 0x05CA7C52, 1, 1, true, 'hold', {timedeventhash = 'MEDIUM_TIMED_EVENT'}) -- Down

RegisterNetEvent('mms-crates:client:PlaceCrateFinal')
AddEventHandler('mms-crates:client:PlaceCrateFinal',function(ThisCrateData,ItemId)
    local MyPos = GetEntityCoords(PlayerPedId())
    print(ThisCrateData.model)
    CrateObj = CreateObject(ThisCrateData.model, MyPos.x, MyPos.y, MyPos.z - 1.0,true,true,false)
    SetEntityInvincible(CrateObj,true)
    FreezeEntityPosition(CrateObj,true)
    while Placed do
        Citizen.Wait(3)

        OpenCrateGroup:ShowGroup(_U('OpenCrateGroup'))

        if OpenCratePrompt:HasCompleted() then
            TriggerServerEvent('mms-crates:server:OpenCrate',ThisCrateData,ItemId)
        end

        if PickupCratePrompt:HasCompleted() then
            CrouchAnim()
            Progressbar(5000,_U('PickupThisChest'))
            ClearPedTasks(PlayerPedId())
            DeleteObject(CrateObj)
            Placed = false
            TriggerServerEvent('mms-crates:server:PickupCrate',ThisCrateData,ItemId)
        end

        if DeleteCratePrompt:HasCompleted() then
            CrouchAnim()
            Progressbar(5000,_U('DeleteThisChest'))
            ClearPedTasks(PlayerPedId())
            DeleteObject(CrateObj)
            Placed = false
            TriggerServerEvent('mms-crates:server:DeleteCrate',ThisCrateData,ItemId)
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
        
    end
end)