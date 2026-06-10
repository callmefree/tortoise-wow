-- ================================================================
-- 野兽戒律 (Bestial Discipline) 修复
-- Bug: ID 19590/19592 的 Effect 1 (集中值回复) 因 aura 类型错误完全无效
--      且缺少 spell_affect 掩码导致 Effect 2 (CD减免) 无法匹配技能
-- 修复: Effect 1 改用 PERIODIC_ENERGIZE，补充 spell_affect 掩码
-- 日期: 2026-06-10
-- ================================================================

-- 备份
CREATE TABLE IF NOT EXISTS _backup_bestial_20260610
SELECT * FROM spell_template WHERE entry IN (19590, 19592);

-- Effect 1: 集中值回复
-- 原: effectApplyAuraName1=107(SPELL_AURA_ADD_FLAT_MODIFIER)
--     miscvalue1=8(SPELLMOD_CRITICAL_DAMAGE_BONUS) — 完全错误的机制
--     → HandleAddModifier 中即使通过 miscvalue 检查，也是修改暴击伤害
-- 新: effectApplyAuraName1=24(SPELL_AURA_PERIODIC_ENERGIZE)
--     miscvalue1=2(POWER_FOCUS)
--     amplitude1=4000(每4秒tick，匹配宠物集中值恢复间隔)
--     basePoints1=1(R1,+2)/4(R2,+5)

UPDATE spell_template SET
  effectApplyAuraName1 = 24,
  effectMiscValue1 = 2,
  effectBasePoints1 = 1,
  effectAmplitude1 = 4000
WHERE entry = 19590;

UPDATE spell_template SET
  effectApplyAuraName1 = 24,
  effectMiscValue1 = 2,
  effectBasePoints1 = 4,
  effectAmplitude1 = 4000
WHERE entry = 19592;

-- Effect 2: 宠物特殊技能冷却时间减少
-- miscvalue2 = 11(SPELLMOD_COOLDOWN) 已在数据库中正确，无需改
-- 缺少 spell_affect 掩码导致修饰器无法匹配任何技能
-- mask = 0x1800000000 = 103079215104
-- 覆盖 HUNTER 族宠物技能: Bite(bit36) + Scorpid Poison(bit35)
-- 注: Claw/Growl 的技能族为 ROGUE(7)，此修饰器(族=9)无法跨族匹配

INSERT INTO spell_affect (entry, effectId, SpellFamilyMask)
VALUES
  (19590, 1, 103079215104),   -- 0x1800000000
  (19592, 1, 103079215104)
ON DUPLICATE KEY UPDATE SpellFamilyMask = VALUES(SpellFamilyMask);

-- 验证
SELECT '=== Fix applied ===' AS status;
SELECT entry,
  effectApplyAuraName1 AS aura1,
  effectMiscValue1 AS misc1,
  effectBasePoints1 AS base1,
  effectAmplitude1 AS ampl1,
  effectApplyAuraName2 AS aura2,
  effectMiscValue2 AS misc2,
  effectBasePoints2 AS base2
FROM spell_template WHERE entry IN (19590, 19592);

SELECT * FROM spell_affect WHERE entry IN (19590, 19592);
