-- ================================================================
-- 物品 31825 炽焰锻造套件 (Blazing Forge Kit) 修复
--
-- 问题: 法术 36600 DummyEffect 硬编码 SummonGameObject(3000684) 和
--       SummonGameObject(3000685) 但 gameobject_template 中缺失这两个 ID
--       → 报错 "Gameobject template 3000684/3000685 not found"
--
-- 修复: 新增 GO 模板 3000684 (Blazing Forge) 和 3000685 (Blazing Anvil)
--       参照已有同类 GO entry 1743/1744 的参数
--
-- 日期: 2026-06-05 (分析 + 脚本), 2026-06-10 (应用)
-- ================================================================

-- 备份
CREATE TABLE IF NOT EXISTS gameobject_template_backup_20260605
AS SELECT * FROM gameobject_template;

-- 插入缺失的 GO 模板
-- type=8: GAMEOBJECT_TYPE_SPELL_FOCUS
-- data0: spell focus ID (forge=3, anvil=1)
-- data1: spell focus distance (10)

INSERT IGNORE INTO gameobject_template
  (entry, type, displayId, name, faction, flags, size,
   data0, data1, data2, data3, data4, data5, data6, data7,
   data8, data9, data10, data11, data12, data13, data14, data15,
   data16, data17, data18, data19, data20, data21, data22, data23,
   mingold, maxgold, phase_quest_id, script_name)
VALUES
  (3000684, 8, 197, 'Blazing Forge', 0, 0, 1,
   3, 10, 0, 0, 0, 0, 0, 0,
   0, 0, 0, 0, 0, 0, 0, 0,
   0, 0, 0, 0, 0, 0, 0, 0,
   0, 0, 0, ''),
  (3000685, 8, 166, 'Blazing Anvil', 0, 0, 1,
   1, 10, 0, 0, 0, 0, 0, 0,
   0, 0, 0, 0, 0, 0, 0, 0,
   0, 0, 0, 0, 0, 0, 0, 0,
   0, 0, 0, '');

-- 验证
SELECT '=== Fix applied ===' AS status;
SELECT entry, name, type, displayId, data0, data1
FROM gameobject_template
WHERE entry IN (3000684, 3000685);
