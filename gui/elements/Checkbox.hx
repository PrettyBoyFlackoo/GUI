package gui.elements;

import gui.elements.data.ColorPalette;
import h2d.col.Point;
import h2d.Graphics;

class Checkbox extends Element {

    var sprite:Graphics;
    var txt:Text;
    
    public var size:Float;
    var thickness:Float;
    var thicknessMultiplier:Int = 10;

    var label:String;
    public var isChecked(default, null):Bool;

    var alpha:Float;

    public function new(x:Float = 0, y:Float = 0, size:Float = 32, label:String = '', isChecked:Bool = false, parent) {
        super(x, y, size, size, parent);

        this.size = size;
        this.label = label;
        this.isChecked = isChecked;

        thickness = size / thicknessMultiplier;
        
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

        var sizeBetween = thickness * 2;
        var roomBetween = sizeBetween * 2;

        ///Draw Outer
        sprite.lineStyle(thickness, ColorPalette.surfaceColor);


        var oneSide = thickness / 2;

        //Draw Outer
        sprite.drawRect(x + oneSide, y + oneSide, width - thickness, height - thickness);

        ///Draw Inner
        sprite.lineStyle();
        sprite.beginFill(ColorPalette.surfaceColor, alpha);
        sprite.drawRect(x + sizeBetween, y + sizeBetween, width - roomBetween, height - roomBetween);
        sprite.endFill();


        ///Label Text
        var offsetX:Float = 6;
        var xPos = x + size + thickness * 2 + offsetX + txt.textWidth / 2;
        var yPos = y + size / 2 - txt.textHeight / 2;
        txt.setPosition(xPos, yPos);
    }
}