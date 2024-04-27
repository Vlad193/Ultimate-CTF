// Genreic building
//My first mode, by vladkvs193
#include "Requirements.as"
#include "ShopCommon.as"
#include "Descriptions.as"
#include "Costs.as"
#include "CheckSpam.as"
#include "GenericButtonCommon.as"
#include "TeamIconToken.as"

//are builders the only ones that can finish construction?
const bool builder_only = false;

void onInit(CBlob@ this)
{
	//AddIconToken("$stonequarry$", "../Mods/Entities/Industry/CTFShops/Quarry/Quarry.png", Vec2f(40, 24), 4);
	this.set_TileType("background tile", CMap::tile_wood_back);
	//this.getSprite().getConsts().accurateLighting = true;

	this.getSprite().SetZ(-50); //background
	this.getShape().getConsts().mapCollisions = false;

	this.Tag("has window");

	//INIT COSTS
	InitCosts();

	// SHOP
	this.set_Vec2f("shop offset", Vec2f(0, 0));
	this.set_Vec2f("shop menu size", Vec2f(4, 5));
	this.set_string("shop description", "Construct");
	this.set_u8("shop icon", 12);
	this.Tag(SHOP_AUTOCLOSE);

	int team_num = this.getTeamNum();
	AddIconToken("$Tier1$", "UltimateShop.png", Vec2f(40, 24), 0);
	AddIconToken("$Tier2$", "UltimateShop.png", Vec2f(40, 24), 6);
	AddIconToken("$Tier3$", "UltimateShop.png", Vec2f(40, 24), 7);
	AddIconToken("$Tier4$", "UltimateShop.png", Vec2f(40, 24), 8);

	{
		ShopItem@ s = addShopItem(this, "Tier 1", "$Tier1$", "tier1", Descriptions::archershop);
		s.spawnNothing = true;
		AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 500);
		AddRequirement(s.requirements, "coin", "", "Coins", 25);
	}
	{
		ShopItem@ s = addShopItem(this, "Tier 2", "$Tier2$", "tier2", Descriptions::archershop);
		s.spawnNothing = true;
		AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 1000);
		AddRequirement(s.requirements, "blob", "heart", "Heart", 2);
		AddRequirement(s.requirements, "coin", "", "Coins", 100);
	}
	{
		ShopItem@ s = addShopItem(this, "Tier 3", "$Tier3$", "tier3", Descriptions::archershop);
		s.spawnNothing = true;
		AddRequirement(s.requirements, "blob", "ultimatumus", "Ultimatumus", 1);
		AddRequirement(s.requirements, "blob", "heart", "Heart", 3);
		AddRequirement(s.requirements, "coin", "", "Coins", 250);
	}
	{
		ShopItem@ s = addShopItem(this, "Tier 3", "$Tier4$", "tier4", Descriptions::archershop);
		s.spawnNothing = true;
		AddRequirement(s.requirements, "blob", "ultimatumus", "Ultimatumus", 8);
	}
	/*{
		ShopItem@ s = addShopItem(this, "Stone Quarry", "$stonequarry$", "quarry", Descriptions::quarry);
		AddRequirement(s.requirements, "blob", "mat_stone", "Stone", CTFCosts::quarry_stone);
		AddRequirement(s.requirements, "blob", "mat_gold", "Gold", CTFCosts::quarry_gold);
		AddRequirement(s.requirements, "no more", "quarry", "Stone Quarry", CTFCosts::quarry_count);
	}*/
}

void GetButtonsFor(CBlob@ this, CBlob@ caller)
{
	if (!canSeeButtons(this, caller)) return;

	if (this.isOverlapping(caller))
		this.set_bool("shop available", !builder_only || caller.getName() == "builder");
	else
		this.set_bool("shop available", false);
}

void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
	bool isServer = getNet().isServer();
	if (cmd == this.getCommandID("shop made item"))
	{
		this.Tag("shop disabled"); //no double-builds

		CBlob@ caller = getBlobByNetworkID(params.read_netid());
		CBlob@ item = getBlobByNetworkID(params.read_netid());
		string name = params.read_string();
		if (item !is null && caller !is null)
		{
			this.getSprite().PlaySound("/Construct.ogg");
			this.getSprite().getVars().gibbed = true;
			this.server_Die();
			caller.ClearMenus();

			// open factory upgrade menu immediately
			if (item.getName() == "factory")
			{
				CBitStream factoryParams;
				factoryParams.write_netid(caller.getNetworkID());
				item.SendCommand(item.getCommandID("upgrade factory menu"), factoryParams);
			}
		}
		if (name == "tier1" || name == "tier2" || name == "tier3" || name == "tier4"){
			this.getSprite().PlaySound("/Construct.ogg");
			this.getSprite().getVars().gibbed = true;
			this.server_Die();
			caller.ClearMenus();
			CBlob@ shopa = server_CreateBlobNoInit("ultimateshop");
			if (shopa !is null)
			{
				shopa.Tag(name);
				shopa.Init();
				shopa.server_setTeamNum(this.getTeamNum());
				shopa.setPosition(this.getPosition());
			}
		}
	}
}
