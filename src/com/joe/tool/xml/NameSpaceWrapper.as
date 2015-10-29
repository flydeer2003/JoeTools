package com.joe.tool.xml
{
	import flash.events.EventDispatcher;

	[Bindable]
	public class NameSpaceWrapper extends EventDispatcher
	{
		public function NameSpaceWrapper(ns1:Namespace)
		{
			this._ns = ns1;
			this._uri = ns1.uri;
			this._prefix = ns1.prefix;
		}
		
		private var _prefix:String;
		private var _uri:String;
		private var _ns:Namespace;
		
		public function get prefix():String
		{
			return _prefix;
		}

		public function set prefix(value:String):void
		{
			_prefix = value;
		}

		public function get uri():String
		{
			return _uri;
		}

		public function set uri(value:String):void
		{
			_uri = value;
		}

		public function get ns():Namespace
		{
			return _ns;
		}

		public function set ns(value:Namespace):void
		{
			_ns = value;
		}


	}
}