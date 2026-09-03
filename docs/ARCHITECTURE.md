# DotaAI Architecture

Runtime:
Dota 2 -> Lua bot API -> State -> Strategy -> Actions -> Dota 2

Lua is the runtime layer because Dota exposes bot control through its VScript
bot API. Python is intentionally offline in V0.1 for deterministic testing,
datasets and future machine learning.

State will grow toward:
- self hero
- allies
- visible enemies
- creeps
- towers
- objectives
- items
- abilities/cooldowns
- game time

Action will grow toward:
- move
- attack
- cast ability
- use item
- purchase
- retreat
- objective

Future ML:
state -> policy/value model -> action
with replay data and reward records feeding training.
