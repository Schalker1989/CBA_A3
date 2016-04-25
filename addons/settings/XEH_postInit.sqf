#include "script_component.hpp"
SCRIPT(XEH_postInit);

// refresh all settings after postInit to guarantee that events are added
{
    {
        [QGVAR(refreshSetting), _x] call CBA_fnc_localEvent;
    } forEach GVAR(allSettings);
} call CBA_fnc_execNextFrame;
