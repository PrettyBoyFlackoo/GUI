package gui.elements;


import hxd.Res;
import h2d.Object;
import h2d.Scene;
import hxd.res.DefaultFont;

class Text extends h2d.Text {
    private function new(x:Float, y:Float, value:String, parent:Object) {

        var font = Res.UIFont.toFont();

        super(font, parent);


        text = value;
        textAlign = Center;
        setPosition(x, y);
    }

    public static function createText(dx:Float, dy:Float, value:String, ?parent:Object):Text {
        if (parent == null) {
            parent = Main.inst;
        }

        return new Text(dx, dy, value, cast parent);
    }
}