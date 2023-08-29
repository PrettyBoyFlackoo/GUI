package gui.elements;

import h2d.col.Point;
import h2d.Graphics;

class Button extends Element {

    var sprite:Graphics;
    var txt:Text;

    public var value:String;

    public var clicked(default, null):Bool;

    public function new(x:Float = 0, y:Float = 0, width:Float = 120, height:Float = 50, value:String) {
        super(x, y, width, height);
        
        this.value = value;

        sprite = new Graphics(parent);

        txt = Text.createText(0, 0, this.value);

        Main.elements.push(this);
    }

    override function update() {
        super.update();

        drawButton();

        clicked = isClicking();
    }

    function drawButton():Void {
        sprite.clear();

        //sprite.lineStyle(2, 0x29A1B9);
        sprite.beginFill(0x141414);
        sprite.drawRect(x, y, width, height);
        sprite.endFill();

        ///Text
        var offset = new Point(width / 2, height / 2 - txt.textHeight / 2);
        txt.text = value;
        txt.setPosition(x + offset.x, y + offset.y);
    }
}