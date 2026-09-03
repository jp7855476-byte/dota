from python.dotaai.brain import RuleBrain
from python.dotaai.schema import GameState, EnemyState

def test_retreat_on_low_health():
    state = GameState(100, 100, 1000, 100, 500, 5, 500, [])
    assert RuleBrain().decide(state).name == "retreat"

def test_attack_visible_enemy():
    state = GameState(
        100, 900, 1000, 300, 500, 5, 500,
        [EnemyState("npc_dota_hero_axe", 500, 1000, 400)]
    )
    action = RuleBrain().decide(state)
    assert action.name == "attack"
    assert action.target == "npc_dota_hero_axe"

def test_farm_when_no_enemy():
    state = GameState(100, 900, 1000, 300, 500, 5, 500, [])
    assert RuleBrain().decide(state).name == "farm"
