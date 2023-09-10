package gui.elements;


import h2d.Font;
import hxd.Res;
import h2d.Object;
import hxd.res.DefaultFont;

class Text extends h2d.Text {

    private function new(x:Float, y:Float, value:String, parent:Object) {

        var font:Font = null;
        
        try  {
            var loadedFont = Res.loader.load('GuiFont.fnt');
            
            if (loadedFont != null) {
                font = loadedFont.to(hxd.res.BitmapFont).toFont();
            } else {
                trace('not found font');
            }
        } catch(e) {
            trace(e);

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