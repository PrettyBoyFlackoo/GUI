package gui.elements;


import h2d.Graphics;

import gui.elements.data.*;

class Dropdown extends Element {

    var sprite:Graphics;
    var label:Text;
    var texts:Array<Text> = [];
        
    public var values:Array<String> = [];

    var items:Array<Item> = [];

    var isReady:Bool;

    public var value(default, null):String = '-:--';

    public function new(x:Float = 0, y:Float = 0, width:Float = 120, height:Float = 50, values:Array<String>, parent) {
        super(x, y, width, height, parent);

        this.values = values;

        sprite = new Graphics(parent);

        if (values.length > 0) {
            value = values[0];
        }

        label = Text.createText(x, y, value, parent);

        for (i in values) {
            var txt = Text.createText(x, y, i, parent);

            texts.push(txt);
        }
    }

    override function update() {
        super.update();

        if (isClicking()) {
            isReady = !isReady;
        }

        for (i in items) {
            if (!isReady) break;

            if (isClicking(0, false) && coords.x > i.x && coords.x < i.x + i.width && 
                coords.y > i.y && coords.y < i.y + height) {
                    value = i.value;
                    isReady = false;
                }
        }


        drawDropdown();
    }

    function drawDropdown():Void {
        sprite.clear();

        ///Draw Bounds
        sprite.beginFill(ColorPalette.dropdownBoundsColor, .4);
        sprite.drawRect(x, y, width, height);
        sprite.endFill();

        var border = 2;
        var borderSide = border / 2;
        sprite.lineStyle(border, ColorPalette.dropdownBoundsColor);
        sprite.drawRect(x + borderSide, y + borderSide, width - border, height - border);

        label.text = value;
        label.setPosition(x + width / 2, y + height / 2 - label.textHeight / 2);

        for (i in texts) {
            i.visible = isReady;
        }

        ///Open List
        if (!isReady) return;

        items = [];

        ///Draw List
        sprite.lineStyle();
        sprite.beginFill(ColorPalette.dropdownListBackgroundColor);

        var xPos = x;
        var yPos = y + height;
        
        var elementHeight = height; ///can also be other as 32px
        var paddingHeight = 8;

        var listHeight = values.length * elementHeight + (values.length - 1) * paddingHeight;

        sprite.drawRect(xPos, yPos, width, listHeight);
        sprite.endFill();

        ///Draw List Elements
        sprite.beginFill(ColorPalette.dropdownItemBackgroundColor);


        for (i in 0...values.length) {
            var xOffset = xPos;
            var yOffset = yPos + (i * paddingHeight) + (i * elementHeight);
            
            sprite.drawRect(xPos, yOffset, width, elementHeight);

            ///Draw Text
            var val = values[i];
            var txt = texts[i];
            txt.text = val;
            txt.textColor = ColorPalette.dropdownListTextColor;
            txt.setPosition(xOffset + width / 2, yOffset + elementHeight / 2 - txt.textHeight / 2);

            var item:Item = {
                x: xOffset,
                y: yOffset,
                width: width,
                height: elementHeight,
                value: val
            };

            items.push(item);
        }

        sprite.endFill();
    }
}