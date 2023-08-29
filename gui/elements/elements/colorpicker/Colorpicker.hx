package gui.elements.colorpicker;

import h2d.Tile;
import h2d.Bitmap;
import h2d.col.Point;
import hxd.Math;
import hxd.Key;
import h3d.Vector;
import h2d.Graphics;

using StringTools;

class Colorpicker extends Element {

    var sprite:Graphics;
    var picker:Graphics;
    var pickerPos = new Point();
    var huePickerPosX:Float;


    var colorpicker:Bitmap;
    var gradient:GradientShader;

    var huePicker:Bitmap;
    var hueGradient:HueShader;

    ///Attributes
    var padding:Float = 8;
    var huePickerSize:Float = 32;
    var previewSize:Float;


    public var color(default, null):Int = 0;
    var hsv = new Vector(360, 100, 100);
  
    var isReady:Bool;
    var isHueReady:Bool;
    var isPickerReady:Bool;

    public function new(x = .0, y = .0, width = 256.) {
        
        previewSize = width;

        var height = previewSize * 2 + (padding * 2) + huePickerSize; ///Preview - padding - hue - padding - picker

        super(x, y, width, height);

        sprite = new Graphics(parent);

        //Create Colorpicker
        colorpicker = new Bitmap(Tile.fromColor(0, cast width, cast width), parent);
        colorpicker.setPosition(x, y + previewSize + huePickerSize);

        gradient = new GradientShader();

        colorpicker.addShader(gradient);


        ///Create Hue Picker
        huePicker = new Bitmap(Tile.fromColor(0, cast width - padding * 2, cast huePickerSize), parent);
        huePicker.setPosition(x + padding, y + previewSize + padding);

        hueGradient = new HueShader();

        huePicker.addShader(hueGradient);

        
        ///Picker
        picker = new Graphics(parent);


        pickerPos.x = x + width;
        pickerPos.y = y + previewSize + huePickerSize + width;

        huePickerPosX = x;
    }

    inline function getMousePos(start:Point, end:Point, ?absolute:Bool):Point {
        var mouse = new Point(parent.mouseX, parent.mouseY);

        var dx = mouse.x - start.x;
        var dy = mouse.y - start.y;

        dx = Math.clamp(dx, 0, end.x);
        dy = Math.clamp(dy, 0, end.y);

        if (absolute) {
            dx /= end.x;
            dy /= end.y;
        }

        return new Point(dx, dy);
    }

    function getHue():Float {
        var abs = getMousePos(new Point(x + padding, y + previewSize), new Point(width - padding, huePickerSize), true);

        var h = abs.x * 360;

        var t = abs.x * (width - padding * 2);

        huePickerPosX = t;

        return h;
    }

    function getSaturation():Float {
        var abs = getMousePos(new Point(x, y + previewSize + huePickerSize), new Point(width, width), true);


        pickerPos.x = abs.x * width;

        return abs.x * 100;
    }

    function getValue():Float {
        var abs = getMousePos(new Point(x, y + previewSize + huePickerSize), new Point(width, width), true);

        pickerPos.y = abs.y * width;

        return abs.y * 100;
    }

    override function update() {
        super.update();

        ///Get Values from User Input
        checkInput();
        
        var getRgb = hsvToRgb(hsv.x, hsv.y, hsv.z);
        color = rgbToHex(getRgb.r, getRgb.g, getRgb.b);

        draw();
    }

    function checkInput():Void {
        if (Key.isPressed(Key.MOUSE_LEFT) && !isHueReady) {

            ///Check Hue
            if (checkMouseOver(new Point(x, y + previewSize + padding), new Point(x + width, y + previewSize + padding + huePickerSize))) {
                isHueReady = true;
            }
            
        }
        if (Key.isPressed(Key.MOUSE_LEFT) && !isPickerReady) {

            ///Check Hue
            if (checkMouseOver(new Point(x, y + previewSize + padding * 2 + huePickerSize), new Point(x + width, y + previewSize + padding * 2 + huePickerSize + width))) {
                isPickerReady = true;
            }
        }

        ///Hue
        if (Key.isDown(Key.MOUSE_LEFT) && isHueReady) {
            hsv.x = getHue();
        }

        ///Sat & Val
        if (Key.isDown(Key.MOUSE_LEFT) && isPickerReady) {
            hsv.y = getSaturation();
            hsv.z = getValue();

            ///Move Picker
            pickerPos.x = coords.x;
            pickerPos.y = coords.y;

            
            ///Keep Horizontal
            if (pickerPos.x < x) {
                pickerPos.x = x;
            }
            else if (pickerPos.x > x + width) {
                pickerPos.x = x + width;
            }

            ///Keep Vertical
            if (pickerPos.y < y + previewSize + huePickerSize + padding * 2) {
                pickerPos.y = y + previewSize + huePickerSize + padding * 2;
            }
            else if (pickerPos.y > y + previewSize + huePickerSize + padding * 2 + width) {
                pickerPos.y = y + previewSize + huePickerSize + padding * 2 + width;
            }
        }

        if (Key.isReleased(Key.MOUSE_LEFT) && isHueReady) {
            isHueReady = false;
        }

        if (Key.isReleased(Key.MOUSE_LEFT) && isPickerReady) {
            isPickerReady = false;
        }
    }

    function checkMouseOver(start:Point, end:Point):Bool {
        if (coords.x > start.x && coords.x < end.x && coords.y > start.y && coords.y < end.y) {
            return true;
        }

        return false;
    }

    function draw() {
        sprite.clear();

        sprite.beginFill(0x272727);
        sprite.drawRect(x, y, width, height);
        sprite.endFill();

        ///Set Shader pos
        huePicker.setPosition(x + padding, y + previewSize + padding);
        colorpicker.setPosition(x, y + previewSize + huePickerSize + padding * 2);

        ///Draw Preview
        sprite.beginFill(color);
        sprite.drawRect(x, y, previewSize, previewSize);
        sprite.endFill();

        gradient.hue = hsv.x / 360;

        ///Draw Picker
        picker.clear();
        picker.lineStyle(2, 0xCECECE);
        picker.beginFill(0xFFFFFF, .5);
        picker.drawCircle(pickerPos.x, pickerPos.y, 12, 18);
        picker.endFill();


        picker.lineStyle();
        picker.beginFill(0x242424, .7);
        picker.drawCircle(pickerPos.x, pickerPos.y, 4, 12);
        picker.endFill();

        ///Draw Hue Picker
        var width = 8;
        picker.lineStyle(1, 0xFFFFFF);
        picker.beginFill(0xFFFFFF, .7);
        picker.drawRect(x + huePickerPosX + width / 2, y + previewSize + padding, width, huePickerSize);
        picker.endFill();
    }

    function vecToRgb(x:Int, y:Int, z:Int):RGB {
        var r = Math.round(x * 255);
        var g = Math.round(y * 255);
        var b = Math.round(z * 255);

        var rgb:RGB = {
            r: r,
            g: g,
            b: b
        };

        return rgb;
    }

    function rgbToVec(r:Int, g:Int, b:Int):Vector {
        var r = r / 255;
        var g = g / 255;
        var b = b / 255;

        return new Vector(r, g, b);
    }

    function rgbToHex(r:Int, g:Int, b:Int):Int {
        var r = (r & 0xFF) << 16;
        var g = (g & 0xFF) << 8;
        var b = (b & 0xFF);

        return Std.parseInt('0x' + (r + g + b).hex());
    }

    function toHex(r:Int, g:Int, b:Int) {
        
        var r = (r & 0xFF) << 16;
        var g = (g & 0xFF) << 8;
        var b = (b & 0xFF);

        return Std.parseInt('0x' + (r + g + b).hex());
    }

    function hsvToRgb(hue:Float, saturation:Float, brightness:Float):RGB {
		var r:Float = 0, g:Float = 0, b:Float = 0, i:Float, f:Float, p:Float, q:Float, t:Float;
		hue%=360;

		if(brightness==0) 
		{

			brightness = 0.01;
		}
		saturation*=0.01;
		brightness*=0.01;
		hue/=60;
		i = Math.floor(hue);
		f = hue-i;
		p = brightness*(1-saturation);
		q = brightness*(1-(saturation*f));
		t = brightness*(1-(saturation*(1-f)));
		if (i==0) {r=brightness; g=t; b=p;}
		else if (i==1) {r=q; g=brightness; b=p;}
		else if (i==2) {r=p; g=brightness; b=t;}
		else if (i==3) {r=p; g=q; b=brightness;}
		else if (i==4) {r=t; g=p; b=brightness;}
		else if (i==5) {r=brightness; g=p; b=q;}

        var c:RGB = {
            r: cast r * 255,
            g: cast g * 255,
            b: cast b * 255
        };

		return c;
	}
}

typedef RGB = {
    var r:Int;
    var g:Int;
    var b:Int;
}