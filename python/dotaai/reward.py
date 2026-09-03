def reward_for_event(
    *, won=False, hero_kill=0, creep_kill=0, tower_kill=0, deaths=0
) -> float:
    reward = 100.0 if won else 0.0
    reward += 20.0 * hero_kill
    reward += 2.0 * creep_kill
    reward += 10.0 * tower_kill
    reward -= 20.0 * deaths
    return reward
