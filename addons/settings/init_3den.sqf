#include "script_component.hpp"

// re-apply mission settings each time a mission is loaded
add3DENEventHandler ["onMissionLoad", {
    GVAR(missionSettings) = nil;
    call FUNC(init);
}];
