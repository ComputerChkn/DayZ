class Mi17_base: Helicopter 
{
	class Turrets: Turrets
	{
		class MainTurret: MainTurret
		{
			class ViewOptics: ViewOptics {};
			class Turrets: Turrets {};
		};
		class BackTurret: MainTurret
		{
			class Turrets: Turrets {};
		};
	};
};

class Mi17_base_CDF: Mi17_base {};
class Mi17_DZ: Mi17_base_CDF {
	displayname = $STR_VEH_NAME_MI17;
	scope = 2;
	side = 2;
	crew = "";
	typicalCargo[] = {};
	hiddenSelections[] = {};
	class TransportMagazines{};
	class TransportWeapons{};
	commanderCanSee = 2+16+32;
	gunnerCanSee = 2+16+32;
	driverCanSee = 2+16+32;
	transportMaxWeapons = 10;
	transportMaxMagazines = 50;
	transportmaxbackpacks = 10;
	
	class Turrets : Turrets 
	{
		class MainTurret : MainTurret 
		{
			magazines[] = {"100Rnd_762x54_PK"};
		};
		class BackTurret : BackTurret
		{
			magazines[] = {"100Rnd_762x54_PK"};
		};
	};
	
	armor=25;
	damageResistance = 0.00394;
	
	class HitPoints:HitPoints
	{
		class HitGlass1:HitGlass1 {armor=0.12;};
		class HitGlass2:HitGlass2 {armor=0.12;};
		class HitGlass3:HitGlass3 {armor=0.12;};
		class HitGlass4:HitGlass4 {armor=0.12;};
		class HitGlass5:HitGlass5 {armor=0.12;};
		class HitGlass6:HitGlass6 {armor=0.12;};
	};
};
