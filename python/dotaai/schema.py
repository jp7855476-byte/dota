from dataclasses import dataclass, asdict
from typing import Optional, Any

@dataclass
class EnemyState:
    name: str
    hp: float
    max_hp: float
    distance: float

@dataclass
class GameState:
    time: float
    hp: float
    max_hp: float
    mana: float
    max_mana: float
    level: int
    gold: int
    enemies: list[EnemyState]

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)

@dataclass
class Action:
    name: str
    target: Optional[str] = None
    x: Optional[float] = None
    y: Optional[float] = None

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)
