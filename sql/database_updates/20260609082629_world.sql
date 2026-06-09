-- ==============================================
-- FILE: fix_feral_instinct_values.sql
-- Fix: 野性本能 (Feral Instinct, 16947-16951)
--       Rank 4(16950)/Rank 5(16951) 非单调递增
-- 根因:
--   effectBasePoints 应为 4/9/14/19/24
--   实际为 4/9/14/11/14 → Rank 4 < Rank 3
-- 修复:
--   Rank 4: 11 → 19
--   Rank 5: 14 → 24
-- GENERATED: 20260609082629
-- ==============================================

UPDATE `spell_template` SET `effectBasePoints1`=19, `effectBasePoints2`=19 WHERE `entry`=16950;
UPDATE `spell_template` SET `effectBasePoints1`=24, `effectBasePoints2`=24 WHERE `entry`=16951;
