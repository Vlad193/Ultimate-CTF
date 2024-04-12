// ArcherShop.as
//My first mode, by vladkvs193
#include "Requirements.as"
#include "ShopCommon.as"
#include "Descriptions.as"
#include "CheckSpam.as"
#include "Costs.as"
#include "GenericButtonCommon.as"

void onInit(CBlob@ this)
{
	this.set_TileType("background tile", CMap::tile_wood_back);

	this.getSprite().SetZ(-50); //background
	this.getShape().getConsts().mapCollisions = false;

	this.Tag("has window");

	//INIT COSTS
	InitCosts();

	// SHOP
	this.set_Vec2f("shop offset", Vec2f_zero);
	this.set_Vec2f("shop menu size", Vec2f(4, 2));
	this.set_string("shop description", "Buy");
	this.set_u8("shop icon", 25);

	// CLASS
	this.set_Vec2f("class offset", Vec2f(-6, 0));
	this.set_string("required class", "builder");
	AddIconToken("$StoneArrows$", "Materials.png", Vec2f(16, 16), 32);
	AddIconToken("$MineArrows$", "Materials.png", Vec2f(16, 16), 33);
	AddIconToken("$FOOD$", "UltimateShop.png", Vec2f(16, 16), 16);
	AddIconToken("$BOMBC$", "UltimateShop.png", Vec2f(16, 16), 17);
	AddIconToken("$ANGRYKEG$", "UltimateShop.png", Vec2f(16, 16), 18);
	AddIconToken("$BOMBER$", "UltimateShop.png", Vec2f(16, 16), 19);

	{
		ShopItem@ s = addShopItem(this, "Stone Arrows", "$StoneArrows$", "mat_stonearrows", "Just stone in arrow?", true);
		AddRequirement(s.requirements, "coin", "", "Coins", 30);
	}
	{
		ShopItem@ s = addShopItem(this, "Mine Arrows", "$MineArrows$", "mat_minearrows", "Delivered from HELL", true);
		AddRequirement(s.requirements, "coin", "", "Coins", 70);
	}
	{
		ShopItem@ s = addShopItem(this, "Bomb???", "$BOMBC$", "bombc", "Why its costs 100 coins??", true);
		AddRequirement(s.requirements, "coin", "", "Coins", 100);
	}
	{
		ShopItem@ s = addShopItem(this, "Keg?", "$ANGRYKEG$", "angrykeg", "Its just keg, nothing wrong, yes?...", true);
		AddRequirement(s.requirements, "coin", "", "Coins", 90);
	}
	{
		ShopItem@ s = addShopItem(this, "Bomber", "$BOMBER$", "bomber", "Useful balloon", true);
		AddRequirement(s.requirements, "coin", "", "Coins", 200);
	}
	{
		ShopItem@ s = addShopItem(this, "ULTIMATUM FOOD", "$FOOD$", "beer", "Have you heard about the GLASS CANNON? Can stack. You lose it when die.", false);
		s.spawnNothing = true;
		AddRequirement(s.requirements, "coin", "", "Coins", 85);
	}
}

void GetButtonsFor(CBlob@ this, CBlob@ caller)
{
	if (!canSeeButtons(this, caller)) return;

	if (caller.getConfig() == this.get_string("required class"))
	{
		this.set_Vec2f("shop offset", Vec2f_zero);
	}
	else
	{
		this.set_Vec2f("shop offset", Vec2f(6, 0));
	}
	this.set_bool("shop available", this.isOverlapping(caller));
}

void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
	if (cmd == this.getCommandID("shop made item"))
	{
		this.getSprite().PlaySound("/ChaChing.ogg");
		u16 caller, item;
		string name;

		if (!params.saferead_netid(caller) || !params.saferead_netid(item) || !params.saferead_string(name))
		{
			return;
		}
		CBlob@ callerBlob = getBlobByNetworkID(caller);
		if (callerBlob is null)
		{
			return;
		}
		if (name == "beer")
		{
			this.getSprite().PlaySound("/Gulp.ogg");
			if (isServer())
			{
				callerBlob.set_f32("COFFEE POWER", callerBlob.get_f32("COFFEE POWER")+1.0f);
				//callerBlob.server_SetHealth(callerBlob.getHealth()/2);
				//getInitialHealth()
				//callerBlob.setInitialHealth(10.0f);
			}
		}
	}
}