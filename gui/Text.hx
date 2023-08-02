package elements;

import hxd.res.DefaultFont;

class Text extends h2d.Text {
    private function new(x:Float, y:Float, value:String) {
        super(DefaultFont.get(), Main.inst);

        text = value;
        textAlign = Center;
        setPosition(x, y);
    }

    public static function createText(dx:Float, dy:Float, value:String):Text {
        return new Text(dx, dy, value);
    }
}