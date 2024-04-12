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
	this.set_string("required class", "ladder");

	{
		ShopItem@ s = addShopItem(this, "Stone Arrows", "$mat_stone$", "mat_stonearrows", "Just stone in arrow?", true);
		AddRequirement(s.requirements, "coin", "", "Coins", 30);
	}
	{
		ShopItem@ s = addShopItem(this, "Mine Arrows", "$mine$", "mat_minearrows", "Delivered from HELL", true);
		AddRequirement(s.requirements, "coin", "", "Coins", 100);
	}
	{
		ShopItem@ s = addShopItem(this, "Bomb???", "$bombc$", "bombc", "Why its costs 100 coins??", true);
		AddRequirement(s.requirements, "coin", "", "Coins", 100);
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
	}
}