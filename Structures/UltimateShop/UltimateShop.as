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
	this.set_TileType("background tile", CMap::tile_castle_back);

	this.getSprite().SetZ(-50); //background
	this.getShape().getConsts().mapCollisions = false;

	this.Tag("has window");

	//INIT COSTS
	InitCosts();

	// SHOP
	this.set_Vec2f("shop offset", Vec2f_zero);
	this.set_Vec2f("shop menu size", Vec2f(4, 4));
	this.set_string("shop description", "Buy");
	this.set_u8("shop icon", 25);

	// CLASS
	this.set_Vec2f("class offset", Vec2f(-6, 0));
	this.set_string("required class", "builder");
	AddIconToken("$StoneArrows$", "Materials.png", Vec2f(16, 16), 32);
	AddIconToken("$MineArrows$", "Materials.png", Vec2f(16, 16), 33);
	AddIconToken("$KegArrows$", "Materials.png", Vec2f(16, 16), 34);
	AddIconToken("$FOOD$", "UltimateShop.png", Vec2f(16, 16), 16);
	AddIconToken("$BOMBC$", "UltimateShop.png", Vec2f(16, 16), 17);
	AddIconToken("$ANGRYKEG$", "UltimateShop.png", Vec2f(16, 16), 18);
	AddIconToken("$BOMBER$", "UltimateShop.png", Vec2f(16, 16), 19);
	AddIconToken("$SkyChicken$", "SkyChicken.png", Vec2f(16, 16), 0);
	AddIconToken("$StoneChicken$", "StoneChicken.png", Vec2f(16, 16), 0);
	AddIconToken("$Ultimatumus$", "Ultimatumus.png", Vec2f(16, 16), 0);
	bool T1 = false;
	bool T2 = false;
	bool T3 = false;
	bool T4 = false;
	this.getSprite().animation.setFrameFromRatio(0);
	if (this.hasTag("tier1")){
		T1 = true;
	}
	if (this.hasTag("tier2")){
		T1 = true;
		T2 = true;
		this.getSprite().animation.setFrameFromRatio(1.0/4);
	}
	if (this.hasTag("tier3")){
		T1 = true;
		T2 = true;
		T3 = true;
		this.set_string("required class", "necromancer");
		this.getSprite().animation.setFrameFromRatio(2.0/4);
	}
	if (this.hasTag("tier4")){
		T1 = true;
		T2 = true;
		T3 = true;
		T4 = true;
		this.set_string("required class", "necromancer");
		this.getSprite().animation.setFrameFromRatio(3.0/4);
	}
	if (T1){
		ShopItem@ s = addShopItem(this, "Ultimatumus", "$Ultimatumus$", "ultimatumus", "Don't let it touch flesh creatures, otherwise it will become very heavy!!!", true);
		AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 1000);
		AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 1000);
		AddRequirement(s.requirements, "coin", "", "Coins", 100);
	}

	if (T1){
		ShopItem@ s = addShopItem(this, "Stone Arrows", "$StoneArrows$", "mat_stonearrows", "Just stone in arrow?", true);
		AddRequirement(s.requirements, "coin", "", "Coins", 30);
	}
	if (T2){
		ShopItem@ s = addShopItem(this, "Mine Arrows", "$MineArrows$", "mat_minearrows", "Delivered from HELL.", true);
		AddRequirement(s.requirements, "blob", "mat_arrows", "Arrows", 1);
		AddRequirement(s.requirements, "coin", "", "Coins", 60);
	}
	if (T3){
		ShopItem@ s = addShopItem(this, "Keg Arrows", "$KegArrows$", "mat_kegarrows", "Now you've seen everything.", true);
		AddRequirement(s.requirements, "blob", "mat_stonearrows", "Stone Arrows", 1);
		AddRequirement(s.requirements, "coin", "", "Coins", 120);
	}
	if (T1){
		ShopItem@ s = addShopItem(this, "Bomb???", "$BOMBC$", "bombc", "Why its costs 100 coins??", true);
		AddRequirement(s.requirements, "coin", "", "Coins", 100);
	}
	if (T2){
		ShopItem@ s = addShopItem(this, "Keg?", "$ANGRYKEG$", "angrykeg", "Its just keg, nothing wrong, yes?...", true);
		AddRequirement(s.requirements, "coin", "", "Coins", 90);
	}
	if (T2){
		ShopItem@ s = addShopItem(this, "Bomber", "$BOMBER$", "bomber", "Useful balloon.", true);
		AddRequirement(s.requirements, "coin", "", "Coins", 200);
	}
	if (T3){
		ShopItem@ s = addShopItem(this, "ULTIMATUM HEART", "$FOOD$", "beer", "Have you heard about the GLASS CANNON? Can stack. You lose it when die.", false);
		s.spawnNothing = true;
		AddRequirement(s.requirements, "blob", "heart", "Heart", 3);
		AddRequirement(s.requirements, "coin", "", "Coins", 85);
	}
	if (T1){
		ShopItem@ s = addShopItem(this, "Stone Chicken", "$StoneChicken$", "stonechicken", "It's just a chicken that ate too much stone.", true);
		AddRequirement(s.requirements, "blob", "chicken", "Chicken", 1);
		AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 250);
		AddRequirement(s.requirements, "coin", "", "Coins", 1);
	}
	if (T3){
		ShopItem@ s = addShopItem(this, "Sky Chicken", "$SkyChicken$", "skychicken", "This is what will happen to you if you cross the upper barrier.", true);
		AddRequirement(s.requirements, "blob", "chicken", "Chicken", 1);
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
			callerBlob.set_f32("COFFEE POWER", callerBlob.get_f32("COFFEE POWER")+1.0f);
		}
	}
}