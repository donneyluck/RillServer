-------------------------------------------------------------------------------
-- Copyright(C)   machine studio                                              --
-- Author:        donney                                                     --
-- Email:         donney_luck@sina.cn                                        --
-- Date:          2021-05-25                                                 --
-- Description:   ddz room                                                   --
-- Modification:  null                                                       --
-------------------------------------------------------------------------------

local RoomDDZ = class("RoomDDZ")
local tablex = require "pl.tablex"
local libcenter = require "libcenter"
local roomLogic = require("gp.logic")
local roomOnCall = require("gp.roomOnCall")

function RoomDDZ:roomInit(room_type)

    self._players = {}

    roomLogic:start()
end

function RoomDDZ:is_player_num_overload()
    return tablex.size(self._players) >= 10000
end

function RoomDDZ:initialize()
    RoomDDZ.onCall = roomOnCall
end

function RoomDDZ:broadcast(msg, filterUid)
    --DEBUG("broadcast")
    for k,v in pairs(self._players) do
        if not filterUid or filterUid ~= k then
            libcenter.send2client(k,msg)
        end
    end
end

local t
local idx

function RoomDDZ:enter(data)
    local uid = data.uid
    local player={
        uid=uid,
        agent=data.agent,
        node=data.node,
    }
    self._players[uid]=player
    self:broadcast({_cmd = "room_move.add", uid=uid,}, uid)

    --if self:is_player_num_overload() then
    --	t=timer:new()
    --	t:init()
    --	idx=t:register(3,self.gamestart,0,self)
    --	DEBUG("room player is overload")
    --end

    return SYSTEM_ERROR.success
end

function RoomDDZ:leave(uid)
    if not uid then
        ERROR("RoomDDZ leave uid is nil")
        return SYSTEM_ERROR.error
    end
    self._players[uid]=nil
    self:broadcast({_cmd = "movegame.leave", uid = uid}, uid)
    --DEBUG(t)
    --DEBUG(idx)
    --if t and idx then
    --    t:unregister(idx)
    --    DEBUG("unregister:"..idx)
    --end
    return SYSTEM_ERROR.success
end

return RoomDDZ