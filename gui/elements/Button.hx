package gui.elements;

import gui.elements.data.ColorPalette;
import h2d.col.Point;
import h2d.Graphics;

class Button extends Element {

    var sprite:Graphics;
    var txt:Text;
    var bgColor:Int;

    public var value:String;

    public var clicked(default, null):Bool;

    public function new(x:Float = 0, y:Float = 0, width:Float = 120, height:Float = 50, value:String, parent) {
        super(x, y, width, height, parent);
        
        this.value = value;

        sprite = new Graphics(parent);

        txt = Text.createText(0, 0, this.value, parent);
    }

    override function update() {
        super.update();

        drawButton();

        clicked = isClicking();

        bgColor = ColorPalette.surfaceColor;
        txt.textColor = ColorPalette.textColor;

        if (isClicking(1)) {
            bgColor = ColorPalette.activeSurfaceColor;
            txt.textColor = ColorPalette.activeTextColor;
        }

    }

    function drawButton():Void {
        sprite.clear();

        //sprite.lineStyle(2, 0x29A1B9);
        sprite.beginFill(bgColor);
        sprite.drawRect(x, y, width, height);
        sprite.endFill();

        ///Text
        var offset = new Point(width / 2, height / 2 - txt.textHeight / 2);
        txt.text = value;
        txt.setPosition(x + offset.x, y + offset.y);
    }
}