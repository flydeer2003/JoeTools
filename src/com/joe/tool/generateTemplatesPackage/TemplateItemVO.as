package com.joe.tool.generateTemplatesPackage
{
	import com.yinquduo.common.core.utils.StringUtil;
	
	import flash.events.EventDispatcher;
	
	[Bindable]
	public class TemplateItemVO extends EventDispatcher
	{
		public static const SHEET_TYPE_INNER:String = "INNER";
		public var guid:String;
		public var xml:XML;
		public var productTypeCode:int;
		private var _xmlDownloadStatus:int = -1;//-1: 未下载,0:下载中，1:下载成功
		private var _thumbnailDownloadStatus:int = -1;//-1: 未下载,0:下载中，1:下载成功
		public var xmlStatusLabel:String;
		public var thumbnailStatusLabel:String;
		
		public var imageNum:Number = 0;
		public var horizontalNum:Number = 0;
		public var verticalNum:Number = 0;
		public var squareNum:Number = 0;
		
		public var xmlFileFullPath:String;
		public var thumbnailFileFullPath:String;
		public var storageFolderBase:String;
		public var designSize:String;
		public var sheetType:String;
		
		protected var filePathBase:String;
		
		public function TemplateItemVO(theProductTypeCode:int)
		{
			this.productTypeCode = theProductTypeCode;
		}
		
		public function parse(templateItemXml:XML):void{
			this.xml = templateItemXml;
			this.guid = templateItemXml.guid;
			this.sheetType = templateItemXml.sheetType;
			this.designSize = templateItemXml.designSize;
			this.imageNum = templateItemXml.imageNum;
			this.horizontalNum = templateItemXml.horizontalNum;
			this.verticalNum = templateItemXml.verticalNum;
			this.squareNum = templateItemXml.squareNum;
			var imageNumStr:String = this.imageNum < 10 ? "0"+this.imageNum : this.imageNum+"";
			switch(this.productTypeCode){
				case ProductType.BOOK.code:
					this.filePathBase = "/data/i_"+imageNumStr+"f_"+this.horizontalNum+"h"+this.verticalNum+"v/"+this.guid;
					break;
				default:
					this.filePathBase = "/data/"+this.guid;
					break;
			}
			this.xmlFileFullPath = this.storageFolderBase + this.designSize+this.xmlFilePath;
			this.thumbnailFileFullPath = this.storageFolderBase + this.designSize + this.thumbnailFilePath;
		}		

		public function get xmlFilePath():String{
			return this.filePathBase + ".xml";
		}
		
		public function get thumbnailFilePath():String{
			return this.filePathBase + ".jpg";
		}
		
		public function get xmlDownloadStatus():int
		{
			return _xmlDownloadStatus;
		}
	
		public function set xmlDownloadStatus(value:int):void
		{
			_xmlDownloadStatus = value;
			if(_xmlDownloadStatus == -1){
				xmlStatusLabel = "";
			}else if(_xmlDownloadStatus == 0){
				xmlStatusLabel = "downloading ..";
			}else if(_xmlDownloadStatus == 1){
				xmlStatusLabel = "downloaded";
			}
		}
		
		public function get thumbnailDownloadStatus():int
		{
			return _thumbnailDownloadStatus;
		}
		
		public function set thumbnailDownloadStatus(value:int):void
		{
			_thumbnailDownloadStatus = value;
			if(_thumbnailDownloadStatus == -1){
				thumbnailStatusLabel = "";
			}else if(_thumbnailDownloadStatus == 0){
				thumbnailStatusLabel = "downloading ..";
			}else if(_thumbnailDownloadStatus == 1){
				thumbnailStatusLabel = "downloaded";
			}
		}
	}
}