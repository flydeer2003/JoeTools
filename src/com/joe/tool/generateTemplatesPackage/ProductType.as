package com.joe.tool.generateTemplatesPackage
{
	public class ProductType
	{
		public static const BOOK:ProductType = create(0,"Book");
		public static const NEW_FRAME:ProductType = create(2,"New Frame");
		
		public var code:int;
		public var name:String;
		
		public function ProductType()
		{
		}
		
		protected static function create(theCode:int,theName:String):ProductType{
			var productType:ProductType = new ProductType();
			productType.code = theCode;
			productType.name = theName;
			return productType;
		}
	}
}