from typing import List
from dataclasses import dataclass

@dataclass
class VentilatorVariable:
    name: str
    value: str
    unit: str

@dataclass
class VentilatorAlarm:
    id: str
    state: str
    priority: str

@dataclass
class VentilatorData:
    type: str
    variables: List[VentilatorVariable]
    alarms: List[VentilatorAlarm]
