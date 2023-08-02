package elements;

import h2d.col.Point;
import h2d.Graphics;

using hxd.Math;

class Slider extends Element {

    var sprite:Graphics;
    var txt:Text;

    var max:Float = 100;
    var step:Float = 100.;

    var fill:Float = 0;
    var isReady:Bool;

    public var value(default, null):Float;
    
    public function new(x:Float, y:Float, width:Float, height:Float, value:Float) {
        super(x, y, width, height);


        sprite = new Graphics(parent);
        
        txt = Text.createText(x, y, '-:--');

        setValue(value);
    }

    function setValue(value:Float):Void {
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
            setValue(getValue());
        }

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
        sprite.beginFill(0x141414, .75);
        sprite.drawRect(x, y, width, height);
        sprite.endFill();

        ///Draw Inner
        sprite.beginFill(0x282828);
        sprite.drawRect(x, y, fill, height);
        sprite.endFill();

        ///Draw Value
        txt.text = '$value';

        var offset = new Point(width / 2, height / 2 - txt.textHeight / 2);
        txt.setPosition(x + offset.x, y + offset.y);
    }
}