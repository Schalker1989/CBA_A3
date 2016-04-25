/* ----------------------------------------------------------------------------
Internal Function: CBA_settings_fnc_setEventHandler

Description:
    Set event that is executed when the setting is changed.

Parameters:
    _setting - Setting name. <STRING>
    _script  - Type of setting. Can be "BOOLEAN", "LIST", "SLIDER" or "COLOR" <STRING>

Returns:
    None

Author:
    commy2
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [["_setting", "", [""]], ["_script", {}, [{}]]];

(GVAR(defaultSettings) getVariable _setting) set [9, [_script]];
