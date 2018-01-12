if (dayz_actionInProgress) exitWith { localize "str_player_actionslimit" call dayz_rollingMessages; };
dayz_actionInProgress = true;

private ["_dis","_sfx","_breaking","_countOut","_counter","_isOk","_proceed","_finished","_itemOut","_tree","_distance2d","_chanceResult","_weapons"];

call gear_ui_init;
closeDialog 1;
_countOut = floor(random 3) + 2;

_tree = objNull;
{
	if (typeOf _x in dayz_treeTypes && {alive _x} && {(_x call fn_getModelName) in dayz_trees}) exitWith {
		// Exit since we found a tree
		_tree = _x;
	};
} count nearestObjects [getPosATL player, [], 20];

//if (["forest",dayz_surfaceType] call fnc_inString) then {// Need tree object for PVDZ_objgather_Knockdown
if (!isNull _tree) then {
	_distance2d = [player, _tree] call BIS_fnc_distance2D;	
	if (_distance2d > 5) exitWith {localize "str_player_23" call dayz_rollingMessages;};

    // Start chop tree loop
    _counter = 0;
    _isOk = true;
    _proceed = false;
	
	//check chance before loop, for a maximum amount of 5 loops allowing 5 possiable chances
	_chanceResult = dayz_HarvestingChance call fn_chance;

    while {_isOk} do {
        _dis=20;
        _sfx = "chopwood";
        [player,_sfx,0,false,_dis] call dayz_zombieSpeak;
        [player,_dis,true,(getPosATL player)] call player_alertZombies;
		
		//play action
		_finished = ["Medic",1] call fn_loopAction;
		_weapons = weapons player;
		_weapons set [count _weapons,dayz_onBack];
		
		//Make sure player did not drop hatchet
        if (!_finished or !("MeleeHatchet" in _weapons or ("ItemHatchet" in _weapons))) exitWith {
            _isOk = false;
            _proceed = false;
        };

        if (_finished) then {
			["Working",0,[100,15,10,0]] call dayz_NutritionSystem;
            _breaking = false;
            if (_chanceResult) then {
                _breaking = true;
                if ("MeleeHatchet" in weapons player) then {
                    player removeWeapon "MeleeHatchet";
                } else {
                    if ("ItemHatchet" in weapons player) then {
                        player removeWeapon "ItemHatchet";
                    } else {
                        if (dayz_onBack == "MeleeHatchet") then {
                            dayz_onBack = "";
							if (!isNull findDisplay 106) then {findDisplay 106 displayCtrl 1209 ctrlSetText "";};
                        };
                    };
                };
                if (!("ItemHatchetBroken" in weapons player)) then {
                    player addWeapon "ItemHatchetBroken";
                };
            };
            
            _counter = _counter + 1;
            _itemOut = "ItemLog";
			//Drop Item to ground
			[_itemOut,1,1] call fn_dropItem;
        };
            
        if ((_counter == _countOut) || _breaking) exitWith {
            if (_breaking) then {
                localize "str_HatchetHandleBreaks" call dayz_rollingMessages;
            } else {
                localize "str_player_24_Stoped" call dayz_rollingMessages;
            };
            _isOk = false;
            _proceed = true;
            uiSleep 1;
        };
        format[localize "str_player_24_progress", _counter,_countOut] call dayz_rollingMessages;
    };

	if (_proceed || (_counter > 0)) then {
		//localize "str_choppingTree" call dayz_rollingMessages;
		//localize "str_player_25" call dayz_rollingMessages;
		if (typeOf _tree == "") then {
			// Ask server to setDamage on tree and sync for JIP
			PVDZ_objgather_Knockdown = [_tree,player];
			publicVariableServer "PVDZ_objgather_Knockdown";
		} else {
			deleteVehicle _tree;
		};
	};
    if !(_proceed) then {            
        localize "str_player_24_Stoped" call dayz_rollingMessages;
    };
} else {
	localize "str_player_23" call dayz_rollingMessages;
};

dayz_actionInProgress = false;