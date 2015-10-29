package com.joe.tool.xml
{
	import com.yinquduo.common.core.utils.CleanupUtil;
	
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	[Bindable]
	public class TransItem extends EventDispatcher
	{
		private var sourceFile:File;
		private var outputFile:File; 
		
		public function TransItem(source:File, output:File)
		{
			sourceFile = source;
			outputFile = output;
			projectXmlFileName = sourceFile.name;
		}
		
		public var projectXmlFileName:String;
		public var resultXmlFileName:String;
		
		public function translate():void
		{
			var fileStream:FileStream = new FileStream();
			fileStream.open(sourceFile,FileMode.READ);
			//var bytes:ByteArray = new ByteArray();
			//fileStream.readBytes(bytes);
			var xmlString:String = fileStream.readUTFBytes(fileStream.bytesAvailable);
			fileStream.close();
			
			var ignoreWhiteSpace:Boolean = XML.ignoreWhitespace;
			var prettyPrinting:Boolean   = XML.prettyPrinting;
			
			XML.ignoreWhitespace = true;
			XML.prettyPrinting   = false;	
			
			//var xml:XML = new XML(bytes);
			var xml:XML = new XML(xmlString);
			
			var vo:Project = Project.deserialize(xml);
			
			var bookXml:XML = new XML(vo.projectXML);	
			for each( var page:XML in bookXml.book.page){
				var oldLayout:String = page.view.children()[0];
				var newLayout:String = translateURLEncodedString(oldLayout);
				page.view.children()[0] = newLayout;
			}
			
			var stockCoverId:String = bookXml.book.cover.stockCoverSpecID[0];
			
			if(stockCoverId == null){
				var backpageLayout:String = bookXml.book.cover.backPage.view.children()[0];
				var newBL:String = translateURLEncodedString(backpageLayout);
				bookXml.book.cover.backPage.view.children()[0] = newBL; 
				
				var spinepageLayout:String = bookXml.book.cover.spinePage.view.children()[0];
				var newSL:String = translateURLEncodedString(spinepageLayout);
				bookXml.book.cover.spinePage.view.children()[0] = newSL;	
			}
			
			var frontpageLayout:String = bookXml.book.cover.frontPage.view.children()[0];
			var newFL:String = translateURLEncodedString(frontpageLayout);
			bookXml.book.cover.frontPage.view.children()[0] = newFL;
			
			if(stockCoverId != null){
				var frontpagePreviewLayout:String = bookXml.book.cover.frontPage.preview.children()[0];
				var newPFL:String = translateURLEncodedString(frontpagePreviewLayout);
				bookXml.book.cover.frontPage.preview.children()[0] = newPFL;
			}
			
			for each(var projImg:XML in bookXml.imageCollection.projectImage){
				var viewStr:String = projImg.view.children()[0];
				viewStr = viewStr.replace("SFLY_LIGHTBOX","YQD_ALBUM");
				projImg.view.children()[0] = viewStr;
			}
			
			vo.projectXML = bookXml.toXMLString();
			
			var resultXml:XML = Project.serialize(vo);
			var resultBytes:ByteArray = new ByteArray();
			resultBytes.writeUTFBytes(resultXml);

			var opFileStream:FileStream = new FileStream();
			opFileStream.open(outputFile,FileMode.WRITE);
			opFileStream.writeBytes(resultBytes);
			opFileStream.close();
			
			resultXmlFileName = outputFile.name; 
		}
		
		private function translateURLEncodedString(src:String):String{
			var xml:XML = new XML(unescape(src));
			CleanupUtil.cleanup(xml);
			var yqd:Namespace = xml.namespace("yqd");
			var nodes:XMLList = xml..yqd::sflyImageReference;
			for each(var node:XML in nodes){
				node.setLocalName("yqdImageReference");
			}
			
			var newStr:String = escape(xml.toXMLString());
			//newStr = newStr.replace("sflyImageReference","yqdImageReference");
			return newStr;
		}
	}
}