/**
 * Created by luQF on 2015/9/24.
 */
package com.joe.tool.common {
public class StatusEnum {
    private var _code:int;
    private var _label:String;

    public function StatusEnum(code:int,label:String) {
        _code = code;
        _label = label;
    }

    public function get code():int {
        return _code;
    }

    public function get label():String {
        return _label;
    }
}
}
