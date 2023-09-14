package gui.elements;


import sys.FileSystem;
import hxd.fs.LocalFileSystem;
import hxd.res.Loader;
import h2d.Font;
import h2d.Object;
import hxd.res.DefaultFont;

class Text extends h2d.Text {

    var loader:Loader;

    private function new(x:Float, y:Float, value:String, parent:Object) {

        var font:Font = null;


        ///Load Custom Font
        loader = new Loader(new LocalFileSystem('src/gui/assets', ''));

        
        ///Check Custom Font
        if (FileSystem.exists('src/gui/assets/Font.fnt')) {
            var customFont = loader.load('Font.fnt').to(hxd.res.BitmapFont).toFont();
            
            font = customFont;
        }
        else {
            font = DefaultFont.get();
        }

        
        super(font, parent);


        text = value;
        textAlign = Center;
        setPosition(x, y);
    }

    public static function createText(dx:Float, dy:Float, value:String, ?parent:Object):Text {

        return new Text(dx, dy, value, cast parent);
    }
}