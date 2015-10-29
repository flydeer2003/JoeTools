package com.joe.tool.generateTemplatesPackage
{
	import com.artisanstate.model.core.IdEntity;
	import com.artisanstate.model.cache.AssetCache;
	import com.artisanstate.model.cache.AssetCacheItem;
	import com.artisanstate.model.cache.events.AssetCacheItemEvent;
	
	import flash.display.Bitmap;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	[Event(name="complete",type="flash.events.Event")]
	[Event(name="error",type="flash.events.ErrorEvent")]
	[Event(name="progress",type="flash.events.ProgressEvent")]
	[Bindable]
	public class ImageContent extends IdEntity
	{
		public static const CONTENT_CACHE_NAME_PREFIX:String = "Image-Content-Cache";
		
		public function ImageContent(uri:String)
		{
			this.uri = uri;
		}
		
		public var uri:String;
		
		private var _content:Bitmap;
		public var contentLoading:Boolean = false;
		public var contentBytesLoaded:uint = 0;
		public var contentBytesTotal:uint = 0;
		public var contentError:Boolean = false;
		public var contentErrorDetail:*;
		
		private var _cacheInstanceName:String;
		protected function get cacheInstanceName():String{
			if(_cacheInstanceName == null){
				_cacheInstanceName = CONTENT_CACHE_NAME_PREFIX;
			}
			return _cacheInstanceName;
		}
		
		protected function get cacheItem():AssetCacheItem{
			var item:AssetCacheItem = AssetCache.getCache(cacheInstanceName).getCacheItem(uri);
			return item;
		}
		
		public function load():void{
			if(contentLoading || content){
				return;
			}
			contentLoading = true;
			var item:AssetCacheItem = cacheItem;
			
			if(item.getContent()!=null){
				content = item.getContent();
				contentLoading = false;
			}else{
				configEventListeners(item);
				item.loadContent();	
			}
		}
		
		private function configEventListeners(item:AssetCacheItem):void{
			if(item.hasEventListener(AssetCacheItemEvent.LOAD_COMPLETEED)==false){
				cacheItem.addEventListener(AssetCacheItemEvent.LOAD_COMPLETEED,onLoadCompleted);
			}
			if(item.hasEventListener(AssetCacheItemEvent.LOAD_ERROR)==false){
				cacheItem.addEventListener(AssetCacheItemEvent.LOAD_ERROR,onLoadError);
			}
			if(item.hasEventListener(AssetCacheItemEvent.LOAD_PROGRESS)==false){
				cacheItem.addEventListener(AssetCacheItemEvent.LOAD_PROGRESS,onLoadProgress);
			}
		}
		
		private function removeEventListeners(item:AssetCacheItem):void{
			if(item.hasEventListener(AssetCacheItemEvent.LOAD_COMPLETEED)==false){
				cacheItem.removeEventListener(AssetCacheItemEvent.LOAD_COMPLETEED,onLoadCompleted);
			}
			if(item.hasEventListener(AssetCacheItemEvent.LOAD_ERROR)==false){
				cacheItem.removeEventListener(AssetCacheItemEvent.LOAD_ERROR,onLoadError);
			}
			if(item.hasEventListener(AssetCacheItemEvent.LOAD_PROGRESS)==false){
				cacheItem.removeEventListener(AssetCacheItemEvent.LOAD_PROGRESS,onLoadProgress);
			}	
		}
		
		private function onLoadCompleted(event:AssetCacheItemEvent):void{
			contentLoading = false;
			content = event.item.getContent();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function onLoadError(event:AssetCacheItemEvent):void{
			contentLoading = false;
			contentError = true;
			contentErrorDetail = event.error;
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,event.error));
		}
		
		private function onLoadProgress(event:AssetCacheItemEvent):void{
			contentBytesLoaded = event.item.bytesLoaded;
			contentBytesTotal = event.item.bytesTotal;
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,contentBytesLoaded,contentBytesTotal));
		}
		
		[Bindable("contentChanged")]
		public function get content():Bitmap
		{
			if(_content == null){
				_content = cacheItem.getContent();
			}
			return _content;
		}
		
		public function set content(value:Bitmap):void
		{
			if(_content != value){
				_content = value;
				dispatchEvent(new Event("contentChanged"));
			}
		}
		
		public function dispose():void{
			if(cacheItem){
				removeEventListeners(cacheItem);
			}
			AssetCache.getCache(cacheInstanceName).clearCacheItem(uri);
			if(_content){
				if(_content.bitmapData){
					_content.bitmapData.dispose();
				}
				_content.bitmapData = null;
				_content = null;
			}
		}
	}
}