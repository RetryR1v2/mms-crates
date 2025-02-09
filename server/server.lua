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

RegisterServerEvent('mms-crates:server:FinishCratePlacement',function(ThisCrateData,ItemId,PosX,PosY,PosZ)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local Identifier = Character.identifier
    local MyCharID = Character.charIdentifier
    local Name = Character.firstname .. ' ' .. Character.lastname
    MySQL.update('UPDATE `mms_crates` SET identifier = ? WHERE crateid = ?',{Identifier, ThisCrateData.crateid})
    MySQL.update('UPDATE `mms_crates` SET charidentifier = ? WHERE crateid = ?',{MyCharID, ThisCrateData.crateid})
    MySQL.update('UPDATE `mms_crates` SET name = ? WHERE crateid = ?',{Name, ThisCrateData.crateid})
    MySQL.update('UPDATE `mms_crates` SET posx = ? WHERE crateid = ?',{PosX, ThisCrateData.crateid})
    MySQL.update('UPDATE `mms_crates` SET posy = ? WHERE crateid = ?',{PosY, ThisCrateData.crateid})
    MySQL.update('UPDATE `mms_crates` SET posz = ? WHERE crateid = ?',{PosZ, ThisCrateData.crateid})
    MySQL.update('UPDATE `mms_crates` SET placed = ? WHERE crateid = ?',{1, ThisCrateData.crateid})
    if not Config.LatestVORPInvetory then
        exports.vorp_inventory:subItemID(src, ItemId,nil,nil)
    else
        exports.vorp_inventory:subItemById(src, ItemId,nil,nil,1)
    end
end)

RegisterServerEvent('mms-crates:server:OpenCrate',function(CrateId,Inventory)
    local src = source
    local isregistred = exports.vorp_inventory:isCustomInventoryRegistered(CrateId)
    if isregistred then
        exports.vorp_inventory:closeInventory(src, CrateId)
        exports.vorp_inventory:openInventory(src, CrateId)
    else
        exports.vorp_inventory:registerInventory(
        {
            id = CrateId,
            name = Config.InvetoryName,
            limit = Inventory,
            acceptWeapons = true,
            shared = true,
            ignoreItemStackLimit = true,
        })
        exports.vorp_inventory:openInventory(src, CrateId)
        isregistred = exports.vorp_inventory:isCustomInventoryRegistered(CrateId)
    end
end)

RegisterServerEvent('mms-crates:server:LoadData',function()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local MyCharID = Character.charIdentifier
    local AllCrateData = MySQL.query.await("SELECT * FROM mms_crates WHERE charidentifier=@charidentifier", { ["charidentifier"] = MyCharID})
    if #AllCrateData > 0 then
        TriggerClientEvent('mms-crates:client:PlaceCrateOnStart',src,AllCrateData,MyCharID)
    end
end)

RegisterServerEvent('mms-crates:server:PickupCrate',function(CrateId,Size)
    local src = source
    if Size == 1 then
        local CanCarry = exports.vorp_inventory:canCarryItem(src, Config.SmallCrateS, 1)
        if CanCarry then
            exports.vorp_inventory:addItem(src, Config.SmallCrateS, 1, { description = _U('CrateID') .. CrateId, cratesid =  CrateId })
        else
            VORPcore.NotifyTip(src,_U('InventoryFull'),5000)
        end
        MySQL.update('UPDATE `mms_crates` SET placed = ? WHERE crateid = ?',{0, CrateId})
    elseif Size == 2 then
        local CanCarry = exports.vorp_inventory:canCarryItem(src, Config.MediumCrateM, 1)
        if CanCarry then
            exports.vorp_inventory:addItem(src, Config.MediumCrateM, 1, { description = _U('CrateID') .. CrateId, cratesid = CrateId })
        else
            VORPcore.NotifyTip(src,_U('InventoryFull'),5000)
        end
        MySQL.update('UPDATE `mms_crates` SET placed = ? WHERE crateid = ?',{0, CrateId})
    elseif Size == 3 then
        local CanCarry = exports.vorp_inventory:canCarryItem(src, Config.BigCrateB, 1)
        if CanCarry then
            exports.vorp_inventory:addItem(src, Config.BigCrateB, 1, { description = _U('CrateID') .. CrateId, cratesid =  CrateId })
        else
            VORPcore.NotifyTip(src,_U('InventoryFull'),5000)
        end
        MySQL.update('UPDATE `mms_crates` SET placed = ? WHERE crateid = ?',{0, CrateId})
    end
end)

RegisterServerEvent('mms-crates:server:DeleteCrate',function(CrateId)
    local src = source
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
