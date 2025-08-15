from typing import Dict, Any, List
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from data_types.ventilator import VentilatorData, VentilatorVariable, VentilatorAlarm

def handle_ventilator_data(data: str) -> Dict[str, Any]:
    """Handle ventilator data and return structured information"""
    
    ventilator_data = VentilatorData(type='', variables=[], alarms=[])
    
    try:
        timestamp = data.split('|')[6]
        message_type = data.split('OBR')[1].split('^')[1]
        
        ventilator_data.type = message_type
        
        variables_lines = data.split('OBX')
        alarm_id = None
        alarm_state = None
        alarm_priority = None
        
        for i in range(1, len(variables_lines)):
            variable_line = variables_lines[i]
            variable_name = variable_line.split('^')[1]
            
            if message_type in ['Ventilator Measurements', 'Ventilator Settings']:
                variable_value = variable_line.split('^')[2].split('|')[2]
                variable_unit = variable_line.split('^')[2].split('|')[3]
                
                if variable_unit == '{breath}/min':
                    variable_unit = '1/min'
                
                ventilator_data.variables.append(VentilatorVariable(
                    name=variable_name,
                    value=str(variable_value),
                    unit=str(variable_unit) if variable_unit else '{unitless}'
                ))
                
            elif message_type == 'Ventilator Alarms':
                variable_value = variable_line.split('^')[3]
                
                if variable_name == 'ALARM ID':
                    alarm_id = variable_value
                elif variable_name == 'ALARM STATE':
                    alarm_state = variable_value
                elif variable_name == 'ALARM PRIORITY':
                    alarm_priority = variable_value
                
                if i % 3 == 0:
                    ventilator_data.alarms.append(VentilatorAlarm(
                        id=str(alarm_id),
                        state=str(alarm_state),
                        priority=str(alarm_priority)
                    ))
    
    except Exception as err:
        pass
    
    return {
        'type': ventilator_data.type,
        'variables': [{'name': v.name, 'value': v.value, 'unit': v.unit} for v in ventilator_data.variables],
        'alarms': [{'id': a.id, 'state': a.state, 'priority': a.priority} for a in ventilator_data.alarms]
    }
