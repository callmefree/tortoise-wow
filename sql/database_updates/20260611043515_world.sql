-- ==============================================
-- FILE: fix_scarlet_monastery_graveyard.sql
-- Fix: 血色修道院玩家死亡后传送到东瘟疫之地的 BUG
-- 根因: 20260514011114_world.sql 错误将血色副本区域(796/5153/5163)
--       映射到 WorldSafeLocs ID=68 (东瘟疫之地圣光之愿礼拜堂)
--       新版 DBC 已移除旧版使用的 ID=429，正确入口 ID=62 已存在于 DBC
-- ==============================================

-- 删除错误映射：ID=68 是东瘟疫墓地
DELETE FROM `game_graveyard_zone` WHERE `id` = 68 AND `ghost_zone` IN (796, 5153, 5163);

-- 插入正确映射：ID=62 是血色修道院门口（提瑞斯法林地, 2605,-543,89）
-- ghost_zone 796 = Scarlet Monastery
-- ghost_zone 5135 = Scarlet Monastery Library (新增)
-- ghost_zone 5136 = Scarlet Monastery Graveyard (新增)
-- ghost_zone 5153 = Scarlet Monastery Armory
-- ghost_zone 5163 = Scarlet Monastery Cathedral
INSERT IGNORE INTO `game_graveyard_zone` (`id`, `ghost_zone`, `faction`) VALUES
  (62, 796, 0),
  (62, 5135, 0),
  (62, 5136, 0),
  (62, 5153, 0),
  (62, 5163, 0);
