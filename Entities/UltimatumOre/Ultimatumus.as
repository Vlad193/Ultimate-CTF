
void onInit(CBlob@ this)
{
  if (getNet().isServer())
  {
    this.set_u8("decay step", 14);
  }

  //this.maxQuantity = 15;

  //this.getCurrentScript().runFlags |= Script::remove_after_this;
}



void onThisAddToInventory(CBlob@ this, CBlob@ inventoryBlob)
{
	if (inventoryBlob is null) return;

	CInventory@ inv = inventoryBlob.getInventory();

	if (inv is null) return;

	this.doTickScripts = true;
	inv.doTickScripts = true;
}

void onTick(CBlob@ this){
  if (this.isInInventory())
		{
			CBlob@ inventoryBlob = this.getInventoryBlob();

			if (inventoryBlob.hasTag("sanctfied")) return;
			
			if (inventoryBlob !is null)
			{
				inventoryBlob.AddForce(Vec2f(0, 250));
			}
		}
  if (this.isAttached())
	{
		AttachmentPoint@ att = this.getAttachmentPoint(0);   //only have one
		if (att !is null)
		{
			CBlob@ b = att.getOccupied();
			if (b !is null)
			{
				b.AddForce(Vec2f(0, 250));
			}
		}
	}
}