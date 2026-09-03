# DotaAI — Local Bot AI

Version 0.1.0

This project is a local/custom-game Dota 2 bot. Lua runs inside Dota 2 through
the bot scripting API. Python is an offline layer for deterministic policy
tests, replay datasets and future ML training.

## Install

Run PowerShell:

    .\install.ps1 -DotaPath "C:\Program Files (x86)\Steam\steamapps\common\dota 2 beta"

Then start Dota 2 and test in a local/custom bot game using the local development
bot script option exposed by your current client.

The bot logs messages prefixed with [DotaAI].

## Layout

dota2ai/dota/scripts/vscripts/bots/
  bot_generic.lua
  hero_selection.lua
  ability_item_usage_generic.lua
  item_purchase_generic.lua
  mode_laning_generic.lua
  dotaai/
    config.lua
    state.lua
    actions.lua
    strategy.lua
    hero_juggernaut.lua

python/dotaai/
  schema.py
  brain.py
  replay.py
  reward.py

tests/test_brain.py

## V0.1

- Hero selection
- Lane assignment
- Juggernaut control
- Basic farming
- Basic combat
- Retreat logic
- Blade Fury / Healing Ward / Omnislash hooks
- Skill leveling
- Basic item purchasing
- Python deterministic baseline and tests

The Dota bot API changes over time. Runtime API calls are isolated in the
dotaai modules so they can be patched without redesigning the project.
