package gui.elements;

import gui.elements.data.ColorPalette;
import h2d.col.Point;
import h2d.Graphics;

using hxd.Math;

class Slider extends Element {

    var sprite:Graphics;
    var txt:Text;

    var max:Float;
    var step:Float = 100.;

    var fill:Float = 0;
    var isReady:Bool;

    var label:String;
    public var value(default, null):Float;
    
    public function new(x:Float = 0, y:Float = 0, width:Float = 120, height:Float = 50, value:Float = 0, label:String = '', max:Float = 100, parent) {
        super(x, y, width, height, parent);

        this.label = label;
        this.max = max;

        sprite = new Graphics(parent);
        
        txt = Text.createText(x, y, '-:--', parent);

        setValue(value);
    }

    public function setValue(value:Float):Void {
        this.value = value;

        var val = value / max * width;

        fill = val;
    }

    override function update() {
        super.update();

        if (isClicking() && !isReady) {
            isReady = true;
        }

        if (isClicking(2, false) && isReady) {
            isReady = false;
        }

        if (isClicking(1, false) && isReady) {
            value = getValue();
        }

        setValue(value);

        drawSlider();
    }

    function getValue():Float {
        var val = getAbsFromPos();

        return val * max;
    }

    public function getRelPos():Float {
        var dx = coords.x - x;

        return Math.clamp(dx, 0, width);
    }

    public function getAbsFromPos():Float {
        var pos = getRelPos();

        var temp = pos / width;

        return Math.round(temp * step) / step;
    }

    function drawSlider():Void {
        sprite.clear();

        ///Draw background
        sprite.beginFill(ColorPalette.sliderBackgroundColor, .65);
        sprite.drawRect(x, y, width, height);
        sprite.endFill();

        ///Draw Inner
        sprite.beginFill(ColorPalette.sliderColor);
        sprite.drawRect(x, y, fill, height);
        sprite.endFill();

        ///Draw Value
        txt.text = '$label$value';
        txt.textColor = ColorPalette.textColor;

        var offset = new Point(width / 2, height / 2 - txt.textHeight / 2);
        txt.setPosition(x + offset.x, y + offset.y);
    }
}