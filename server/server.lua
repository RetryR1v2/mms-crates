local VORPcore = exports.vorp_core:GetCore()

exports.vorp_inventory:registerUsableItem(Config.SmallCrate, function(data)
    local src = data.source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local Identifier = Character.identifier
    local MyCharID = Character.charIdentifier
    local Name = Character.firstname .. ' ' .. Character.lastname
    local CanCarry = exports.vorp_inventory:canCarryItem(src, Config.SmallCrateS, 1)
    if CanCarry then
        local NewCrateID = GetUniqueID()
        Wait(1000)
        MySQL.insert('INSERT INTO `mms_crates` (crateid,identifier,charidentifier,name,model,inventory,size) VALUES (?,?,?,?,?,?,?)',
        {NewCrateID,Identifier,MyCharID,Name,Config.SmallModel,Config.SmallCratesLimit,1}, function()end)
        exports.vorp_inventory:subItem(src, Config.SmallCrate, 1, {})
        exports.vorp_inventory:addItem(src, Config.SmallCrateS, 1, { description = _U('CrateID') .. NewCrateID, cratesid =  NewCrateID })
    end
end)

exports.vorp_inventory:registerUsableItem(Config.MediumCrate, function(data)
    local src = data.source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local Identifier = Character.identifier
    local MyCharID = Character.charIdentifier
    local Name = Character.firstname .. ' ' .. Character.lastname
    local CanCarry = exports.vorp_inventory:canCarryItem(src, Config.MediumCrateM, 1)
    if CanCarry then
        local NewCrateID = GetUniqueID()
        Wait(1000)
        MySQL.insert('INSERT INTO `mms_crates` (crateid,identifier,charidentifier,name,model,inventory,size) VALUES (?,?,?,?,?,?,?)',
        {NewCrateID,Identifier,MyCharID,Name,Config.MediumModel,Config.MediumCratesLimit,2}, function()end)
        exports.vorp_inventory:subItem(src, Config.MediumCrate, 1, {})
        exports.vorp_inventory:addItem(src, Config.MediumCrateM, 1, { description = _U('CrateID') .. NewCrateID, cratesid = NewCrateID })
    end
end)

exports.vorp_inventory:registerUsableItem(Config.BigCrate, function(data)
    local src = data.source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local Identifier = Character.identifier
    local MyCharID = Character.charIdentifier
    local Name = Character.firstname .. ' ' .. Character.lastname
    local CanCarry = exports.vorp_inventory:canCarryItem(src, Config.BigCrateB, 1)
    if CanCarry then
        local NewCrateID = GetUniqueID()
        Wait(1000)
        MySQL.insert('INSERT INTO `mms_crates` (crateid,identifier,charidentifier,name,model,inventory,size) VALUES (?,?,?,?,?,?,?)',
        {NewCrateID,Identifier,MyCharID,Name,Config.BigModel,Config.BigCratesLimit,3}, function()end)
        exports.vorp_inventory:subItem(src, Config.BigCrate, 1, {})
        exports.vorp_inventory:addItem(src, Config.BigCrateB, 1, { description = _U('CrateID') .. NewCrateID, cratesid =  NewCrateID })
    end
end)

exports.vorp_inventory:registerUsableItem(Config.SmallCrateS, function(data)
    local src = data.source
    if next(data.item) ~= nil and data.item.metadata then --Item has Metadata
        local GotCrateId = data.item.metadata.cratesid
        local ItemId = data.item.mainid
        local CrateData = MySQL.query.await("SELECT * FROM mms_crates WHERE crateid=@crateid", { ["crateid"] = GotCrateId})
        if #CrateData > 0 then
            local ThisCrateData = CrateData[1]
            TriggerClientEvent('mms-crates:client:CratePlacement',src,ThisCrateData,ItemId)
        end
    end
end)

exports.vorp_inventory:registerUsableItem(Config.MediumCrateM, function(data)
    local src = data.source
    if next(data.item) ~= nil and data.item.metadata then --Item has Metadata
        local GotCrateId = data.item.metadata.cratesid
        local ItemId = data.item.mainid
        local CrateData = MySQL.query.await("SELECT * FROM mms_crates WHERE crateid=@crateid", { ["crateid"] = GotCrateId})
        if #CrateData > 0 then
            local ThisCrateData = CrateData[1]
            TriggerClientEvent('mms-crates:client:CratePlacement',src,ThisCrateData,ItemId)
        end
    end
end)

exports.vorp_inventory:registerUsableItem(Config.BigCrateB, function(data)
    local src = data.source
    if next(data.item) ~= nil and data.item.metadata then --Item has Metadata
        local GotCrateId = data.item.metadata.cratesid
        local ItemId = data.item.mainid
        local CrateData = MySQL.query.await("SELECT * FROM mms_crates WHERE crateid=@crateid", { ["crateid"] = GotCrateId})
        if #CrateData > 0 then
            local ThisCrateData = CrateData[1]
            TriggerClientEvent('mms-crates:client:CratePlacement',src,ThisCrateData,ItemId)
        end
    end
end)

RegisterServerEvent('mms-crates:server:RemoveItemById',function(ThisCrateData,ItemId)
    local src = source
    print('Triggered')
    if not Config.LatestVORPInvetory then
        exports.vorp_inventory:subItemID(src, ItemId,nil,nil)
    else
        exports.vorp_inventory:subItemById(src, ItemId,nil,nil,1)
    end
end)

RegisterServerEvent('mms-crates:server:OpenCrate',function(ThisCrateData,ItemId)
    local src = source
    local isregistred = exports.vorp_inventory:isCustomInventoryRegistered(ThisCrateData.crateid)
    if isregistred then
        exports.vorp_inventory:closeInventory(src, ThisCrateData.crateid)
        exports.vorp_inventory:openInventory(src, ThisCrateData.crateid)
    else
        exports.vorp_inventory:registerInventory(
        {
            id = ThisCrateData.crateid,
            name = Config.InvetoryName,
            limit = ThisCrateData.inventory,
            acceptWeapons = true,
            shared = true,
            ignoreItemStackLimit = true,
        })
        exports.vorp_inventory:openInventory(src, ThisCrateData.crateid)
        isregistred = exports.vorp_inventory:isCustomInventoryRegistered(ThisCrateData.crateid)
    end
end)

RegisterServerEvent('mms-crates:server:PickupCrate',function(ThisCrateData,ItemId)
    local src = source
    CrateId = ThisCrateData.crateid
    if ThisCrateData.size == 1 then
        local CanCarry = exports.vorp_inventory:canCarryItem(src, Config.SmallCrateS, 1)
        if CanCarry then
            exports.vorp_inventory:addItem(src, Config.SmallCrateS, 1, { description = _U('CrateID') .. CrateId, cratesid =  CrateId })
        else
            VORPcore.NotifyTip(src,_U('InventoryFull'),5000)
        end
    elseif ThisCrateData.size == 2 then
        local CanCarry = exports.vorp_inventory:canCarryItem(src, Config.MediumCrateM, 1)
        if CanCarry then
            exports.vorp_inventory:addItem(src, Config.MediumCrateM, 1, { description = _U('CrateID') .. CrateId, cratesid = CrateId })
        else
            VORPcore.NotifyTip(src,_U('InventoryFull'),5000)
        end
    elseif ThisCrateData.size == 3 then
        local CanCarry = exports.vorp_inventory:canCarryItem(src, Config.BigCrateB, 1)
        if CanCarry then
            exports.vorp_inventory:addItem(src, Config.BigCrateB, 1, { description = _U('CrateID') .. CrateId, cratesid =  CrateId })
        else
            VORPcore.NotifyTip(src,_U('InventoryFull'),5000)
        end
    end
end)

RegisterServerEvent('mms-crates:server:DeleteCrate',function(ThisCrateData,ItemId)
    local src = source
    CrateId = ThisCrateData.crateid
    MySQL.execute('DELETE FROM mms_crates WHERE crateid = ?', {CrateId}, function() end)
end)

function GetUniqueID()
    local FoundUnique = false
    while not FoundUnique do
        Wait(50)
        local CrateID = math.random(11111,999999)
        local result = MySQL.query.await("SELECT * FROM mms_crates WHERE crateid=@crateid", { ["crateid"] = CrateID})
        if #result > 0 then
            FoundUnique = false
        else
            FoundUnique = true
        end
        if FoundUnique then
            return CrateID
        end
    end
end
