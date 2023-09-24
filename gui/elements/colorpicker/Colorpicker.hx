package gui.elements.colorpicker;

import gui.elements.data.ColorPalette;
import h3d.Vector;
import h2d.Tile;
import h2d.Bitmap;
import h2d.Graphics;

using StringTools;
using hxd.Math;

class Colorpicker extends Element {

    var sprite:Graphics;
    var pickerSprite:Graphics;
    var text:Text;

    ///Components
    var gradientPicker:Bitmap;
    var gradientPickerX:Float;
    var gradientPickerY:Float;
    var gradientPickerWidth:Int;
    var gradientPickerheight:Int;
    var isGradientPickerActive:Bool;

    var gradientShader:GradientShader;

    var huePicker:Bitmap;
    var huePickerX:Float;
    var huePickerY:Float;
    var huePickerWidth:Int;
    var huePickerHeight:Int = 32;
    var isHuePickerActive:Bool;

    var hueShader:HueShader;

    var previewX:Float;
    var previewY:Float;
    var previewWidth:Int;
    var previewHeight:Int;


    ///Spacing
    var separationSize:Float = 2;
    var margin:Float = 16;

    
    public var hsv(default, null):Vector = new Vector(360, 100, 100);
    public var color(default, null):Int;
    
    public function new(x:Float = 0, y:Float = 0, width:Float = 200, height:Float = 500, parent) {
        super(x, y, width, height, parent);
        
        sprite = new Graphics(parent);

        ///Components
        getTransform();

        gradientPicker = new Bitmap(Tile.fromColor(0, gradientPickerWidth, gradientPickerheight), parent);
        gradientPicker.addShader(gradientShader = new GradientShader());

        huePicker = new Bitmap(Tile.fromColor(0xFF0000, huePickerWidth, huePickerHeight), parent);
        huePicker.addShader(new HueShader());

        applyTransform();


        ///Create Picker
        pickerSprite = new Graphics(parent);

        ///Text
        text = Text.createText(x, y, '', parent);
    }

    override function update() {
        super.update();

        ///X y
        applyTransform();

        ///Controls

        //Hue
        if (isClicking(0, false) && !isHuePickerActive) {
            if (checkHover(huePickerX, huePickerY, huePickerWidth, huePickerHeight)) {
                isHuePickerActive = true;
            }
        }

        if (isClicking(1, false) && isHuePickerActive) {
            hsv.x = getHue();
        }

        if (isClicking(2, false) && isHuePickerActive) {
            isHuePickerActive = false;
        }

        ///Gradient
        if (isClicking(0, false) && !isGradientPickerActive) {
            if (checkHover(gradientPickerX, gradientPickerY, gradientPickerWidth, gradientPickerheight)) {
                isGradientPickerActive = true;
            }
        }

        if (isClicking(1, false) && isGradientPickerActive) {
            hsv.y = getSaturation();
            hsv.z = getValue();
        }

        if (isClicking(2, false) && isGradientPickerActive) {
            isGradientPickerActive = false;
        }


        ///Apply Shader
        gradientShader.hue = hsv.x / 360;


        ///Get Final Color
        var rgb = hsvToRgb(hsv.x, hsv.y, hsv.z);
        color = rgbToHex(rgb.r, rgb.g, rgb.b);

        drawColorpicker();

        ///Draw Text
        var margin = 16;
        var ypos = huePickerY + huePickerHeight + margin;
        var xpos = x + width / 2;

        text.text = '0x' + color.hex();
        text.x = xpos;
        text.y = ypos;
    }

    function drawColorpicker():Void {
        sprite.clear();

        sprite.beginFill(ColorPalette.surfaceColor);
        sprite.drawRect(x, y, width, height);
        sprite.endFill();

        var blockHeight = separationSize;
        sprite.beginFill(0x26B3EB);
        sprite.drawRect(gradientPickerX, gradientPickerY + gradientPickerheight, gradientPickerWidth, blockHeight);
        sprite.endFill();

        ///Draw Preview
        sprite.beginFill(color);
        sprite.drawRect(previewX, previewY, previewWidth, previewHeight);
        sprite.endFill();


        ///Draw Pickers
        pickerSprite.clear();

        ///Hue
        var width = 6;
        var huePickerXPos = hsv.x / 360 * (huePickerWidth - width);
        pickerSprite.lineStyle(1, 0xFFFFFF);
        pickerSprite.beginFill(ColorPalette.colorpickerHueThumbColor, .5);
        pickerSprite.drawRect(huePickerX + huePickerXPos, huePickerY, width, huePickerHeight);

        ///Gradient
        var size = 12;
        var gradientPickerXPos = hsv.y / 100 * gradientPickerWidth;
        var gradientPickerYPos = hsv.z / 100 * gradientPickerheight;
        pickerSprite.drawCircle(gradientPickerX + gradientPickerXPos, gradientPickerY + gradientPickerYPos, size, size * 2);
        
        var innerSize = 4;
        pickerSprite.lineStyle();
        pickerSprite.beginFill(ColorPalette.colorpickerGradientThumbInnerColor, 1);
        pickerSprite.drawCircle(gradientPickerX + gradientPickerXPos, gradientPickerY + gradientPickerYPos, innerSize, innerSize * 2);
        pickerSprite.endFill();
    }

    function getTransform() {
        gradientPickerX = x;
        gradientPickerY = y;
        gradientPickerWidth = Math.round(width);
        gradientPickerheight = gradientPickerWidth;

        huePickerX = gradientPickerX;
        huePickerY = gradientPickerY + gradientPickerheight + separationSize;
        huePickerWidth = gradientPickerWidth;

        previewWidth = Math.round(width);
        previewHeight = previewWidth;
    }

    function applyTransform() {
        getTransform();

        ///apply to bmps
        gradientPicker.x = gradientPickerX;
        gradientPicker.y = gradientPickerY;

        huePicker.x = huePickerX;
        huePicker.y = huePickerY;

        var textSpace = 64;
        previewX = x;
        previewY = y + gradientPickerheight + huePickerHeight + textSpace;

        var totalHeight = gradientPickerheight + huePickerHeight + textSpace + previewHeight;
        height = totalHeight;
    }

    function getHue() {
        var abs = (coords.x - huePickerX) / huePickerWidth;

        if (abs < 0) {
            abs = 0;
        }
        else if (abs > 1) {
            abs = 1;
        }

        return abs * 360;
    }

    function getSaturation() {
        var abs = (coords.x - gradientPickerX) / gradientPickerWidth;

        if (abs < 0) {
            abs = 0;
        }
        else if (abs > 1) {
            abs = 1;
        }

        return abs * 100;
    }

    function getValue() {
        var abs = (coords.y - gradientPickerY) / gradientPickerheight;

        if (abs < 0) {
            abs = 0;
        }
        else if (abs > 1) {
            abs = 1;
        }

        return abs * 100;
    }

    inline function checkHover(startX:Float, startY:Float, width:Float, height:Float):Bool {
        if (coords.x > startX && coords.x < startX + width && coords.y > startY && coords.y < startY + height) {
            return true;
        }

        return false;
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

    function rgbToHex(r:Int, g:Int, b:Int):Int {
        var r = (r & 0xFF) << 16;
        var g = (g & 0xFF) << 8;
        var b = (b & 0xFF);

        return Std.parseInt('0x' + (r + g + b).hex());
    }
}

typedef RGB = {
    var r:Int;
    var g:Int;
    var b:Int;
}