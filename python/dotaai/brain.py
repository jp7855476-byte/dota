from .schema import GameState, Action

class RuleBrain:
    # Deterministic baseline used as the reference policy for later ML work.
    def decide(self, state: GameState) -> Action:
        hp_ratio = state.hp / max(1.0, state.max_hp)

        if hp_ratio < 0.23:
            return Action("retreat")

        visible = [
            e for e in state.enemies
            if e.hp > 0 and e.distance < 1100
        ]

        if visible:
            target = min(visible, key=lambda e: (e.hp, e.distance))
            return Action("attack", target=target.name)

        return Action("farm")
