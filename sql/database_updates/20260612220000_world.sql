-- ============================================================================
-- Carnage (Talent) Bug Fix: Ferocious Bite DOT refresh + Savage Bite mask
-- Turtle-WoW 1.18
-- Date: 2026-06-12
-- Author: AI-assisted fix based on unit test analysis
-- ============================================================================

-- Fix 1: Savage Bite spell family mask
-- CF_DRUID_SAVAGE_BITE = CM1 bit5 → global bit 37 → 1ULL << 37 = 137438953472
-- The proc matching loop (Unit.cpp:~4831) checks spellFamilyMask[i] per effect index.
-- Carnage has Effect[0]=DUMMY (aura exists) and Effect[1]=disabled (no aura).
-- Therefore only Mask0 is checked; Mask1 is never reached.
-- Previously SpellFamilyMask0 = 8390656 (bits 11, 23 — Maul/Swipe + Rip/Bite only)
-- Savage Bite (bit 37) had no entry in any mask, so its proc was silently filtered
-- at the matching layer and never reached HandleDummyAuraProc.
-- Fix: add bit 37 to Mask0, clear the useless Mask1.
UPDATE spell_proc_event 
SET SpellFamilyMask0 = 137447342528,   -- bits 11 | 23 | 37 = 0x800 | 0x800000 | 0x2000000000
    SpellFamilyMask1 = 0               -- Carnage Effect[1] is disabled, Mask1 never checked
WHERE entry IN (16998, 16999);

-- Fix 2: (Code change) Code reverted to original mask-based matching from 2c7f0c34.
-- The only real fix was the DB mask. Code was already correct.
