-- ============================================================================
-- Sacred Chalice Fix: Add missing toy spell + gameobject + collection_toy entry
-- Item 31827 (Sacred Chalice) uses spell 46096 (Add Toy to Collection) but was
-- missing its mapping in collection_toy, causing the item to do nothing.
-- Follows the same pattern as Blazing Forge Kit (item 31825 → spell 36600).
-- Turtle-WoW 1.18
-- Date: 2026-06-13
-- ============================================================================

-- 1. Portable Moonwell spell focus game object
INSERT IGNORE INTO `gameobject_template` (`entry`, `type`, `displayId`, `name`, `size`, `data0`, `data1`) VALUES
(3000686, 8, 224, 'Sacred Chalice Moonwell', 1.0, 883, 10);

-- 2. Sacred Chalice toy spell (SPELL_EFFECT_DUMMY, summons gameobject 3000686)
INSERT IGNORE INTO `spell_template` (`entry`, `castingTimeIndex`, `recoveryTime`, `interruptFlags`, `procChance`,
       `rangeIndex`, `equippedItemClass`,
       `effect1`, `effect2`, `effectImplicitTargetA1`,
       `spellVisual1`, `spellIconId`,
       `name`, `nameFlags`, `nameSubtext`, `nameSubtextFlags`, `description`, `descriptionFlags`,
       `startRecoveryCategory`, `startRecoveryTime`,
       `effectBonusCoefficient1`, `effectBonusCoefficient2`, `effectBonusCoefficient3`,
       `dmgMultiplier1`, `dmgMultiplier2`, `dmgMultiplier3`) VALUES
(36607,
 14, 600000, 15, 101,
 1, -1,
 3, 3, 1,
 1168, 69,
 'Sacred Chalice',
 16712190,
 'Toy',
 16712190,
 'Summons the essence of a Moonwell, allowing a tailor to craft Mooncloth anywhere under Elune''s blessing for five minutes.',
 16712190,
 133, 1500,
 -1, -1, -1,
 1, 0, 0);

-- 3. Register item → toy spell mapping
INSERT IGNORE INTO `collection_toy` (`itemId`, `spellId`) VALUES (31827, 36607);

-- Reload: requires mangosd restart (spell_template and gameobject_template changes)
