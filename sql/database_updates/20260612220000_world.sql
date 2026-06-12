-- ============================================================================
-- Carnage (Talent) Bug Fix: Ferocious Bite DOT refresh + Savage Bite mask
-- Turtle-WoW 1.18
-- Date: 2026-06-12
-- Author: AI-assisted fix based on unit test analysis
-- ============================================================================

-- Fix 1: Savage Bite spell family mask
-- CF_DRUID_SAVAGE_BITE = CM1 bit5 → global bit 37 → 1ULL << 37 = 137438953472
-- Previously was SpellFamilyMask1 = 32 (= CM0 bit5), completely wrong mask domain,
-- causing Savage Bite's heal-on-damage effect to never trigger.
UPDATE spell_proc_event 
SET SpellFamilyMask1 = 137438953472 
WHERE entry IN (16998, 16999);

-- Fix 2: (Code change) Enhanced Ferocious Bite DOT refresh logic in UnitAuraProcHandler.cpp
-- See source code commit for:
--   - Enhanced CP retrieval with target-side fallback 
--   - Full diagnostic logging via sLog.outDebug("[Carnage] ...")
--   - Spell-ID based aura matching safeguard (bypasses mask definition inconsistencies)
--   - Rake PERIODIC_DAMAGE scan across all effect indices
