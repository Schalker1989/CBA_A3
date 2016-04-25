#include "script_component.hpp"

#define PREP(func) if (isNil QFUNC(func)) then {FUNC(func) = uiNamespace getVariable QFUNC(func)}
#include "XEH_PREP.sqf"
// --------------------------------------------------

call FUNC(init);

params ["_display"];

uiNamespace setVariable [QGVAR(display), _display];

// ----- create addons list (filled later)
private _ctrlAddonsGroup = _display displayCtrl IDC_ADDONS_GROUP;
private _ctrlAddonList = _display ctrlCreate [QGVAR(AddonsList), -1, _ctrlAddonsGroup];

_ctrlAddonsGroup ctrlEnable false;
_ctrlAddonsGroup ctrlShow false;

_ctrlAddonList ctrlAddEventHandler ["LBSelChanged", FUNC(gui_addonChanged)];

private _addons = [];

// ----- create settings lists

#include "gui_createMenu.sqf"

// ----- fill addons list
{
    private _displayName = getText (configFile >> "CBA_Settings" >> _x >> "displayName");

    if (_displayName isEqualTo "") then {
        _displayName = _x;
    };

    private _index = _ctrlAddonList lbAdd _displayName;

    _ctrlAddonList lbSetData [_index, str _index];
    _display setVariable [str _index, _x];
} forEach _addons;

lbSort _ctrlAddonList;
_ctrlAddonList lbSetCurSel (uiNamespace getVariable [QGVAR(addonIndex), 0]);

// ----- create export and import buttons
private _ctrlButtonImport = _display ctrlCreate ["RscButtonMenu", IDC_BTN_IMPORT];

_ctrlButtonImport ctrlSetPosition [
    24.4 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX),
    20.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2)),
    POS_X(6),
    POS_Y(1)
];

_ctrlButtonImport ctrlCommit 0;
_ctrlButtonImport ctrlSetText localize LSTRING(ButtonImport);
_ctrlButtonImport ctrlSetTooltip localize LSTRING(ButtonImport_tooltip);
_ctrlButtonImport ctrlEnable false;
_ctrlButtonImport ctrlShow false;
_ctrlButtonImport ctrlAddEventHandler ["ButtonClick", {[copyFromClipboard, uiNamespace getVariable QGVAR(source)] call FUNC(import)}];

uiNamespace setVariable [QGVAR(ctrlButtonImport), _ctrlButtonImport];

private _ctrlButtonExport = _display ctrlCreate ["RscButtonMenu", IDC_BTN_EXPORT];

_ctrlButtonExport ctrlSetPosition [
    30.5 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX),
    20.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2)),
    POS_X(6),
    POS_Y(1)
];

_ctrlButtonExport ctrlCommit 0;
_ctrlButtonExport ctrlSetText localize LSTRING(ButtonExport);
_ctrlButtonExport ctrlSetTooltip localize LSTRING(ButtonExport_tooltip);
_ctrlButtonExport ctrlEnable false;
_ctrlButtonExport ctrlShow false;
_ctrlButtonExport ctrlAddEventHandler ["ButtonClick", {[uiNamespace getVariable QGVAR(source)] call FUNC(export)}];

uiNamespace setVariable [QGVAR(ctrlButtonExport), _ctrlButtonExport];

// ----- source buttons (client, server, mission)
{
    _x ctrlEnable false;
    _x ctrlShow false;
    _x ctrlAddEventHandler ["ButtonClick", FUNC(gui_sourceChanged)];
} forEach [_display displayCtrl IDC_BTN_CLIENT, _display displayCtrl IDC_BTN_SERVER, _display displayCtrl IDC_BTN_MISSION];

GVAR(clientSettingsTemp) = [] call (uiNamespace getVariable "CBA_fnc_createNamespace");
GVAR(serverSettingsTemp) = [] call (uiNamespace getVariable "CBA_fnc_createNamespace");
GVAR(missionSettingsTemp) = [] call (uiNamespace getVariable "CBA_fnc_createNamespace");

(_display displayCtrl IDC_BTN_CONFIGURE_ADDONS) ctrlAddEventHandler ["ButtonClick", FUNC(gui_configure)];

// ----- scripted OK button
(_display displayCtrl 999) ctrlAddEventHandler ["ButtonClick", {true call FUNC(gui_closeMenu)}];

// set this per script to avoid it being all upper case
(_display displayCtrl IDC_TXT_FORCE) ctrlSetText localize LSTRING(force);
