from typing import List
from dataclasses import dataclass

@dataclass
class MonitorVariable:
    name: str
    value: str
    unit: str

@dataclass
class MonitorAlarm:
    id: str
    state: str
    priority: str

@dataclass
class MonitorData:
    type: str
    variables: List[MonitorVariable]
    alarms: List[MonitorAlarm]
