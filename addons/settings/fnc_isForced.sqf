/* ----------------------------------------------------------------------------
Internal Function: CBA_settings_fnc_isForced

Description:
    Check if setting is forced.

Parameters:
    _setting - Name of the setting <STRING>
    _source  - Can be "client", "server" or "mission" (optional, default: "client") <STRING>

Returns:
    _forced - Whether or not the setting is forced <BOOLEAN>

Author:
    commy2
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [["_setting", "", [""]], ["_source", "client", [""]]];

switch (toLower _source) do {
    case ("client"): {
        [GVAR(clientSettings) getVariable _setting] param [0, []] param [1, false]
    };
    case ("server"): {
        [GVAR(serverSettings) getVariable _setting] param [0, []] param [1, false]
    };
    case ("mission"): {
        [GVAR(missionSettings) getVariable _setting] param [0, []] param [1, false]
    };
    default {nil};
};
