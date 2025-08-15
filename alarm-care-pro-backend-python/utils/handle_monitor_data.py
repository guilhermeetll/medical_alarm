from typing import Dict, Any, List
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from data_types.monitor import MonitorData, MonitorVariable, MonitorAlarm

def handle_monitor_data(data: str) -> Dict[str, Any]:
    """Handle monitor data and return structured information"""
    
    monitor_data = MonitorData(type='Monitor Measurements', variables=[], alarms=[])
    
    try:
        variables_lines = data.split('OBX')
        alarm_id = None
        alarm_state = None
        alarm_priority = None
        
        for i in range(1, len(variables_lines)):
            variable_line = variables_lines[i]
            variable_name = variable_line.split('^')[1]
            
            variable_value = variable_line.split('^')[2].split('|')[2]
            variable_unit = variable_line.split('^')[3]
            
            if variable_unit == '{breath}/min':
                variable_unit = '1/min'
            
            # Handle strange variable/unit names
            if variable_name == 'MDC_ECG_HEART_RATE':
                variable_name = 'Ecg Heart Rate'
            elif variable_name == 'MDC_PULS_OXIM_SAT_O2':
                variable_name = 'Puls Oxim Sat O2'
            elif variable_name == 'MDC_PULS_OXIM_PULS_RATE':
                variable_name = 'Puls Oxim Puls Rate'
            elif variable_name == 'MDC_TTHOR_RESP_RATE':
                variable_name = 'Tthor Resp Rate'
            elif variable_name == 'MDC_TEMP':
                variable_name = 'Temp'
            
            if variable_unit == 'MDC_DIM_BEAT_PER_MIN':
                variable_unit = '1/min'
            elif variable_unit == 'MDC_DIM_PERCENT':
                variable_unit = '%'
            elif variable_unit == 'MDC_DIM_RESP_PER_MIN':
                variable_unit = '1/min'
            elif variable_unit == 'MDC_DIM_DEGC':
                variable_unit = 'ºC'
            
            # Check if variable already exists
            existing_variable = None
            for var in monitor_data.variables:
                if var.name == variable_name:
                    existing_variable = var
                    break
            
            if not existing_variable:
                monitor_data.variables.append(MonitorVariable(
                    name=variable_name,
                    value=str(variable_value),
                    unit=str(variable_unit) if variable_unit else '{unitless}'
                ))
    
    except Exception as err:
        pass
    
    return {
        'type': monitor_data.type,
        'variables': [{'name': v.name, 'value': v.value, 'unit': v.unit} for v in monitor_data.variables],
        'alarms': [{'id': a.id, 'state': a.state, 'priority': a.priority} for a in monitor_data.alarms]
    }
