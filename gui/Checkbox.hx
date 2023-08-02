package elements;

import h2d.col.Point;
import h2d.Graphics;

class Checkbox extends Element {

    var sprite:Graphics;
    
    var size:Float = 32;
    var thickness:Float = 4;

    public var isChecked(default, null):Bool;

    var alpha:Float;
    var rounded:Bool = false;

    public function new(x:Float, y:Float, isChecked:Bool = false) {
        super(x, y, size, size);

        this.isChecked = isChecked;
        
        sprite = new Graphics(parent);
    }

    override function update() {
        super.update();

        if (isClicking()) {
            isChecked = !isChecked;
        }

        isChecked ? alpha = 1 : alpha = 0;

        drawCheckbox();
    }

    function drawCheckbox():Void {
        sprite.clear();

        var padding = 0.0; ///additional space inside

        var room = thickness / 2 + padding;
        var margin = size - thickness * 2 - (room * 2);

        ///Draw Outer
        sprite.lineStyle(thickness, 0x141414);

        if (rounded) {
            sprite.drawCircle(x + size / 2 + thickness, y + size / 2 + thickness, size, cast size);

            var margin = size - thickness * 2;
            
            sprite.lineStyle();
            sprite.beginFill(0x141414, alpha);
            sprite.drawCircle(x + size / 2 + thickness, y + size / 2 + thickness, margin, cast size);
            sprite.endFill();
            return;

        }

        sprite.drawRect(x, y, size, size);


        ///Draw Inner
        sprite.lineStyle();
        sprite.beginFill(0x141414, alpha);
        sprite.drawRect(x + thickness + room, y + thickness + room, margin, margin);
        sprite.endFill();
    }

    inline function checkRadius():Bool {
        var dist = new Point(x + size / 2 + thickness, y + size / 2 + thickness).distance(new Point(parent.mouseX, parent.mouseY));

        if (dist < size + thickness + size - thickness * 2) {
            return true;
        }

        return false;
    }
}