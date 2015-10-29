package com.joe.tool.xml
{
	import com.yinquduo.common.core.utils.StringUtil;
	
	import flash.events.EventDispatcher;

	/**
	 * VO containing all Project related details required to call Save/Load openfly API
	 * 
	 * Same VO is used for carrying the retrieved data from Save/Load openfly API response
	 * 
	 */ 
	public class Project extends EventDispatcher
	{
		/**
		 * Serializes a project into XML
		 *  
		 * @param projectVO a project VO
		 * @return an XML representation of the data
		 */
		public static function serialize(projectVO:Project):XML
		{
			var projectGUID:String = (projectVO.projectGUID == null) ? "" : projectVO.projectGUID;
			var data:XML = new XML("<![CDATA[" + projectVO.projectXML + "]]>");
			
			// Create the request body
			if(projectVO.projectGUID){
				var xml:XML = <feed xmlns="http://www.w3.org/2005/Atom" xmlns:project="http://site.yqdapi.yinquduo.com/v1.0#project" xmlns:yqdapi="http://yqdapi.yinquduo.com/v1.0">
											  <category term="project" scheme="http://www.yinquduo.com/v1.0" />
											  <rights>Copyright (C) Yinquduo 2011-2012. All rights reserved.</rights>
											  <project:guid>{projectGUID}</project:guid>
											  <project:title>{projectVO.title}</project:title>
											  <project:userId>{projectVO.userId}</project:userId>
											  <project:creationTime>{projectVO.creationTime}</project:creationTime>
											  <project:updateTime>{projectVO.updateTime}</project:updateTime>
											  <project:state>{projectVO.status}</project:state>
											  <project:details validationSchemaLocation="http://www.yinquduo.com/book.xsd"> {data}</project:details>
											  <project:type>{projectVO.type}</project:type>
										  </feed>;
			}else{
				var xml:XML = <feed xmlns="http://www.w3.org/2005/Atom" xmlns:project="http://site.yqdapi.yinquduo.com/v1.0#project" xmlns:yqdapi="http://yqdapi.yinquduo.com/v1.0">
							  <category term="project" scheme="http://www.yinquduo.com/v1.0" />
							  <rights>Copyright (C) Yinquduo 2011-2012. All rights reserved.</rights>
							  <project:guid>{projectGUID}</project:guid>
							  <project:title>{projectVO.title}</project:title>
							  <project:userId>{projectVO.userId}</project:userId>
							  <project:state>{projectVO.status}</project:state>
							  <project:details validationSchemaLocation="http://www.yinquduo.com/book.xsd"> {data}</project:details>
							  <project:type>{projectVO.type}</project:type>
						  </feed>;
			}
			return xml;
		}
		
		/**
		 * Deserializes a project XML into a Project VO
		 * 
		 * @param response the project XML
		 * @return an object representation of the Project XML
		 */
		public static function deserialize(projXML:XML):Project
		{
			// obtain the openfly namespace
			var openflyNS:Namespace	= projXML.namespace("openfly");
			// obtain the project namespace
			var projectNS:Namespace = projXML.namespace("project");
			
			//prepare the vo
			var projectVO:Project = new Project();
			projectVO.projectGUID =  projXML.projectNS::guid;
			projectVO.userId = projXML.projectNS::userId;
			projectVO.title = projXML.projectNS::title;
			projectVO.creationTime = projXML.projectNS::creationTime;
			projectVO.updateTime = projXML.projectNS::updateTime;
			projectVO.status = projXML.projectNS::state;
			projectVO.type = projXML.projectNS::type;
			projectVO.projectXML = projXML.projectNS::details;
			projectVO.response =  projXML;
			
			return projectVO;
		}
		
		public function Project()
		{
		}
		
		private var _title:String;
		private var _projectXML:String;
		private var _projectGUID:String;
		private var _userId:String;
		private var _status:String;
		private var _type:String;
		private var _creationTime:String;
		private var _updateTime:String;
		private var _authenticationToken:String;
        private var _dateAuthenticated:Date;
		
		private var _response:XML;
		private var _serviceClassName:String;
		private var _source:String;
		private var _serviceBaseURL:String;		
		private var _oflyAppId:String;
		private var _isRequestFatal:Boolean;
		
		private var _baseSku:String;
		private var _firstImageId:String;
		
		public function get authenticationToken():String
		{
			return _authenticationToken;
		}

		public function set authenticationToken(v:String):void
		{
			_authenticationToken = v;
		}

		public function get dateAuthenticated():Date
		{
            return _dateAuthenticated;
		}

		public function set dateAuthenticated(v:Date):void
		{
			_dateAuthenticated = v;
		}

		public function get oflyAppId():String
		{
			
			return _oflyAppId;
		}

		public function set oflyAppId(v:String):void
		{
			
			_oflyAppId = v;
		}		
		public function get updateTime():String
		{
			
			return _updateTime;
		}

		public function set updateTime(v:String):void
		{			_updateTime = v;
		}

		public function get creationTime():String
		{
			return _creationTime;
		}

		public function set creationTime(v:String):void
		{
			
			_creationTime = v;
		}

		public function get type():String
		{
			
			return _type;
		}

		public function set type(v:String):void
		{
			
			_type = v;
		}

		public function get status():String
		{
			
			return _status;
		}

		public function set status(v:String):void
		{
			
			_status = v;
		}

		public function get title():String
		{
			
			return _title;
		}

		public function set title(v:String):void
		{
			
			_title = v;
		}

		public function get userId():String
		{
			
			return _userId;
		}

		public function set userId(v:String):void
		{
			
			_userId = v;
		}

		public function get projectGUID():String
		{
			
			return _projectGUID;
		}

		public function set projectGUID(v:String):void
		{
			//don't accept empty string.  Empty string should be replaced with null
			//this is because we treat a null guid as no guid at all, while "" would be accepted as valid (which we don't want).
			if(StringUtil.isEmpty(v)) {
				v = null;
			}
			
			_projectGUID = v;
		}

		public function get projectXML():String
		{
			
			return _projectXML;
		}

		public function set projectXML(v:String):void
		{
			
			_projectXML = v;
		}

		public function get source():String
		{
			
			return _source;
		}
		
		public function set source(source:String):void
		{
			
			_source = source;
		}
		
		public function get serviceClassName():String
		{
			
			return _serviceClassName;
		}
		
		public function set serviceClassName(serviceName:String):void
		{
			
			_serviceClassName = serviceName;
		}
		
		public function get serviceBaseURL():String
		{
			
			return _serviceBaseURL;
		}
		
		public function set serviceBaseURL(serviceBaseURL:String):void
		{
			
			_serviceBaseURL = serviceBaseURL;
		}
		
		public function get response():XML
		{
			
			return _response;
		}
		
		public function set response(res:XML):void
		{
			
			_response = res;
		}
		
		public function get isRequestFatal():Boolean
		{
			
			return _isRequestFatal;
		}

		public function set isRequestFatal(v:Boolean):void
		{
			
			_isRequestFatal = v;
		}		

		public function get baseSku():String
		{
			return _baseSku;
		}

		public function set baseSku(value:String):void
		{
			_baseSku = value;
		}

		public function get firstImageId():String
		{
			return _firstImageId;
		}

		public function set firstImageId(value:String):void
		{
			_firstImageId = value;
		}


	}
}
