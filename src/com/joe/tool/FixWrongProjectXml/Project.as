/**
 * Created by luQF on 2015/9/24.
 */
package com.joe.tool.FixWrongProjectXml {
import flash.events.EventDispatcher;

import mx.controls.Alert;

import mx.utils.UIDUtil;

[Bindable]
public class Project extends EventDispatcher{
    public function Project(guid:String) {
        this.guid = guid;
        status = 0;
    }

    public var guid: String;
    public var product:String;
    public var cover:String;
    public var size:String;
    public var client:String;
    public var spreadsOrigCount:int;
    public var innerSpreadsOrigCount:int;
    public var spreadsMissedCount:int;
    public var origPageAmount:String;
    public var origXml:XML;
    public var fixedXml:XML;
    private var _status:int;//0 undownload; 1 downloading; 2 downloaded; 3 failed; 4 fixed; 5 right
    public var statusLabel:String = "";

    /**
     * @param stat: 0 undownload; 1 downloading; 2 downloaded; 3 failed; 4 fixed; 5 right
     */
    public function set status(statP:int):void{
        _status = statP;
        if(_status == 0){
            statusLabel = "";
        }else if(_status == 1){
            statusLabel = "downloading...";
        }else if(_status == 2){
            statusLabel = "downloaded";
        }else if(_status == 3){
            statusLabel = "failed";
        }else if(_status == 4){
            statusLabel = "fixed";
        }else if(_status == 5){
            statusLabel = "right";
        }
    }

    public function get status():int{
        return _status;
    }

    public function checkAndFix():Boolean{
        var fixed:Boolean = false;
        var fixedXmlTemp:XML = new XML(origXml);
        origPageAmount = fixedXmlTemp.pageAdded + "";

        var optionXmlList:XMLList = fixedXmlTemp.book.spec.option;
        if(!optionXmlList || optionXmlList.length()<=0){
            client = fixedXmlTemp.@createAuthor +"";
        }else{
            product = fixedXmlTemp.book.spec.option.(@id=="product")[0].@value+"";
            size = fixedXmlTemp.book.spec.option.(@id=="size")[0].@value+"";
            cover = fixedXmlTemp.book.spec.option.(@id=="cover")[0].@value+"";
            client = fixedXmlTemp.book.spec.option.(@id=="client")[0].@value+"";
        }

        var spreadsXmlList:XMLList =  fixedXmlTemp.book.spreads.spread;
        spreadsOrigCount = spreadsXmlList.length();
        innerSpreadsOrigCount = spreadsOrigCount - 1;
        if(spreadsOrigCount >= 11){//不需要修复
           fixed = false;
        }else{//需要修复
            fixed = true;
            spreadsMissedCount = 11 - spreadsOrigCount;
            for(var i=1; i<= spreadsMissedCount; i++){
                var newSpreadXml:XML = new XML(spreadsXmlList[1]);
                newSpreadXml.setChildren(new XML("<elements></elements>"));
                newSpreadXml.@pageNumber = spreadsOrigCount-1+i;
                newSpreadXml.@id = UIDUtil.createUID();
                fixedXmlTemp.book.spreads[0].appendChild(newSpreadXml);
            }
            //修复完成
            fixedXml = fixedXmlTemp;
        }
        return fixed;
    }
}
}
