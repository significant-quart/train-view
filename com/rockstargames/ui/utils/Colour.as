class com.rockstargames.ui.utils.Colour
{
	function Colour()
	{
	}
	static function RGBToHex(r, g, b)
	{
		var _loc2_ = r.toString(16);
		var _loc1_ = g.toString(16);
		var _loc3_ = b.toString(16);
		if (_loc2_ == "0")
		{
			_loc2_ = "00";
		}
		if (_loc1_ == "0")
		{
			_loc1_ = "00";
		}
		if (_loc3_ == "0")
		{
			_loc3_ = "00";
		}
		var _loc4_ = "0x" + _loc2_ + _loc1_ + _loc3_;
		return Number(_loc4_);
	}
	static function HexToRGB(hex)
	{
		var _loc1_ = hex >> 16;
		var _loc2_ = hex - (_loc1_ << 16);
		var _loc3_ = _loc2_ >> 8;
		var _loc4_ = _loc2_ - (_loc3_ << 8);
		return {r:_loc1_, g:_loc3_, b:_loc4_};
	}
}