/**
 * Created by luQF on 2015/10/23.
 */
package com.joe.tool.common {
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

public class FileUtil {
    public function FileUtil() {
    }

    public static function saveStringToDisk(string:String,file:File):void{
        if(!file.parent.exists){
            file.parent.createDirectory();
        }
        var fs:FileStream = new FileStream();
        fs.open(file,FileMode.WRITE);
        fs.writeUTFBytes(string);
        fs.close();
    }
}
}
