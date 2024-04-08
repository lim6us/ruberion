-- rubick_grand_illusion.lua
LinkLuaModifier("modifier_rubick_grand_illusion", "abilities/rubick/rubick_grand_illusion.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_rubick_grand_illusion_illusion", "abilities/rubick/rubick_grand_illusion.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

rubick_grand_illusion = class({})

function rubick_grand_illusion:OnSpellStart()
    local caster = PlayerResource:GetSelectedHeroEntity(0)

    -- Проверяем, что caster является героем Рубиком
    if caster:IsRealHero() and caster:GetUnitName() == "npc_dota_hero_rubick" then
        local duration = self:GetSpecialValueFor("illusion_duration")
        local player_owner = caster:GetPlayerOwner()
        local illusion_name = "npc_dota_rubick_grand_illusion"
        local illusion_hscript = LoadKeyValues("scripts/npc/npc_units_custom.txt")[illusion_name]

        -- Дополнительная проверка
        if caster:IsRealHero() and caster:GetUnitName() == "npc_dota_hero_rubick" and caster:IsHero() then
            print("Caster passed all checks and is Rubick")
            -- Создаем иллюзию
            local illusion = CreateIllusions(caster, player_owner, illusion_hscript, 1, 1, true, false)

            -- Добавляем проверку на успешное создание иллюзии
            if illusion ~= nil then
                local illusion_modifier = illusion[1]:AddNewModifier(caster, self, "modifier_rubick_grand_illusion_illusion", {})
                local caster_modifier = caster:AddNewModifier(caster, self, "modifier_rubick_grand_illusion", {})
            else
                print("Failed to create illusion")
            end
        else
            print("Caster is not a hero unit")
        end
    else
        print("Caster is not a real hero or not Rubick")
    end
end

    local illusion_hscript = LoadKeyValues("scripts/npc/npc_units_custom.txt")[illusion_name]
if illusion_hscript ~= nil then
    print("Illusion unit definition loaded successfully")
else
    print("Failed to load illusion unit definition")
end

-- Модификатор для Рубика
modifier_rubick_grand_illusion = class({})

function modifier_rubick_grand_illusion:IsHidden()
    return false
end

function modifier_rubick_grand_illusion:IsPurgable()
    return false
end

function modifier_rubick_grand_illusion:OnCreated(event)
    if IsServer() then
        self.damage_share_pct = self:GetAbility():GetSpecialValueFor("damage_share_pct")
    end
end

function modifier_rubick_grand_illusion:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }

    return funcs
end

function modifier_rubick_grand_illusion:OnAttackLanded(event)
    if IsServer() then
        local attacker = event.attacker
        local target = event.target
        local damage = event.damage

        if attacker == self:GetParent() then
            -- Поделить урон с иллюзией
            local illusion = self:GetCaster():FindIllusion()
            if illusion ~= nil then
                local share_damage = damage * self.damage_share_pct / 100
                ApplyDamage({attacker = illusion, victim = target, ability = nil, damage = share_damage, damage_type = DAMAGE_TYPE_MAGICAL})
            end
        end
    end
end

-- Модификатор для иллюзии
modifier_rubick_grand_illusion_illusion = class({})

function modifier_rubick_grand_illusion_illusion:IsHidden()
    return true
end

function modifier_rubick_grand_illusion_illusion:IsPurgable()
    return false
end

function modifier_rubick_grand_illusion_illusion:OnCreated(event)
    if IsServer() then
        self.outgoing_damage_pct = self:GetAbility():GetSpecialValueFor("outgoing_damage_pct")
    end
end

function modifier_rubick_grand_illusion_illusion:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    }

    return funcs
end

function modifier_rubick_grand_illusion_illusion:GetModifierDamageOutgoing_Percentage()
    return self.outgoing_damage_pct
end