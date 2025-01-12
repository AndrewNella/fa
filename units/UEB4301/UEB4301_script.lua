----****************************************************************************
----**
----**  File     :  /cdimage/units/UEB4301/UEB4301_script.lua
----**  Author(s):  John Comes, Greg Kohne
----**
----**  Summary  :  UEF Heavy Shield Generator Script
----**
----**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
----****************************************************************************
local TShieldStructureUnit = import("/lua/terranunits.lua").TShieldStructureUnit

---@class UEB4301 : TShieldStructureUnit
---@field Rotator1? moho.RotateManipulator
---@field Rotator2? moho.RotateManipulator
---@field ShieldEffectsBag TrashBag
UEB4301 = ClassUnit(TShieldStructureUnit) {
    ShieldEffects = {
        '/effects/emitters/terran_shield_generator_t2_01_emit.bp',
        '/effects/emitters/terran_shield_generator_T3_02_emit.bp',
        --'/effects/emitters/terran_shield_generator_t2_03_emit.bp',
    },

    ---@param self UEB4301
    OnCreate = function(self)
        TShieldStructureUnit.OnCreate(self)
        self.ShieldEffectsBag = TrashBag()
        self.Trash:Add(self.ShieldEffectsBag)
    end,

    ---@param self UEB4301
    ---@param builder Unit
    ---@param layer Layer
    OnStopBeingBuilt = function(self, builder, layer)
        TShieldStructureUnit.OnStopBeingBuilt(self, builder, layer)
        self.Rotator1 = CreateRotator(self, 'Spinner', 'y', nil, 10, 5, 10)
        self.Rotator2 = CreateRotator(self, 'B01', 'z', nil, -10, 5, -10)
        self.Trash:Add(self.Rotator1)
        self.Trash:Add(self.Rotator2)
    end,

    ---@param self UEB4301
    OnShieldEnabled = function(self)
        TShieldStructureUnit.OnShieldEnabled(self)
        if self.Rotator1 then
            self.Rotator1:SetTargetSpeed(10)
        end
        if self.Rotator2 then
            self.Rotator2:SetTargetSpeed(-10)
        end
        
        self.ShieldEffectsBag:Destroy()
        for k, v in self.ShieldEffects do
            self.ShieldEffectsBag:Add(CreateAttachedEmitter(self, 0, self.Army, v))
        end
    end,

    ---@param self UEB4301
    OnShieldDisabled = function(self)
        TShieldStructureUnit.OnShieldDisabled(self)
        self.Rotator1:SetTargetSpeed(0)
        self.Rotator2:SetTargetSpeed(0)
        self.ShieldEffectsBag:Destroy()
    end,
}

TypeClass = UEB4301
