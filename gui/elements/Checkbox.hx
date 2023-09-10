package gui.elements;

import h2d.col.Point;
import h2d.Graphics;

class Checkbox extends Element {

    var sprite:Graphics;
    var txt:Text;
    
    public var size:Float = 32;
    var thickness:Float = 4;

    var label:String;
    public var isChecked(default, null):Bool;

    var alpha:Float;
    var rounded:Bool = false;

    public function new(x:Float = 0, y:Float = 0, height:Float = 32, label:String = '', isChecked:Bool = false, parent) {

        size = width = height;

        super(x, y, size, size, parent);

        isBlock = false;

        this.label = label;
        this.isChecked = isChecked;
        
        sprite = new Graphics(parent);

        txt = Text.createText(x, y, label, parent);
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

        var padding = 0; ///additional space inside

        var room = thickness / 2 + padding;
        var margin = size - thickness * 2 - (room * 2);

        ///get height
        calculateHeight(thickness);

        ///Draw Outer
        sprite.lineStyle(thickness, 0x282828);

        if (rounded) {
            sprite.drawCircle(x + size / 2 + thickness, y + size / 2 + thickness, size, cast size);

            var margin = size - thickness * 2;
            
            sprite.lineStyle();
            sprite.beginFill(0x282828, alpha);
            sprite.drawCircle(x + size / 2 + thickness, y + size / 2 + thickness, margin, cast size);
            sprite.endFill();
            return;

        }

        var oneSide = thickness / 2;

        sprite.drawRect(x + oneSide, y + oneSide, size, size);


        ///Draw Inner
        sprite.lineStyle();
        sprite.beginFill(0x282828, alpha);
        sprite.drawRect(x + (thickness * 2) + room - oneSide, y + thickness + room + oneSide, margin, margin);
        sprite.endFill();


        ///Label Text
        var offsetX:Float = 6;
        var xPos = x + size + thickness * 2 + offsetX + txt.textWidth / 2;
        var yPos = y + size / 2 - txt.textHeight / 2;
        txt.setPosition(xPos, yPos);
    }

    function calculateHeight(border:Float) {
        height = border + size;
    }

    inline function checkRadius():Bool {
       /* var dist = new Point(x + size / 2 + thickness, y + size / 2 + thickness).distance(new Point(parent.mouseX, parent.mouseY));

        if (dist < size + thickness + size - thickness * 2) {
            return true;
        }

        return false;*/

        return false;
    }
}