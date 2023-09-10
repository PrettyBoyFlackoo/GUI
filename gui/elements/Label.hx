package gui.elements;


import h2d.col.Point;
import h2d.Graphics;

enum LabelPos {
    Left;
    Middle;
}

class Label extends Element {

    var sprite:Graphics;
    var text:Text;

    public var label:String;

    public function new(x:Float = 0, y:Float = 0, width:Float = 100, height:Float = 50, label:String = '', pos:LabelPos = Left, parent) {
        super(x, y, width, height, parent);

        this.label = label;


        sprite = new Graphics(parent);

        text = Text.createText(x, y, label, parent);
    }

    override function update() {
        super.update();

        draw();
    }

    function draw() {

        sprite.clear();

        ///Transparent
        sprite.beginFill(0x141414, 0);
        sprite.drawRect(x, y, width, height);
        sprite.endFill();

    
        var offsetY = 4.;
        var halfTxt = text.textWidth / 2;
        var dx = x + width / 2 - halfTxt;
        var dy = y + height / 2 + text.textHeight / 2 + offsetY;
        var size = 2.;

        ///Draw line
        sprite.beginFill(text.textColor);
        sprite.drawRect(dx, dy, text.textWidth, size);
        sprite.endFill();

        text.text = label;
        text.setPosition(x + width / 2, y + height / 2 - text.textHeight / 2);
    }

    function getPos():Point {
        var pos = new Point();

       

        //text.setPosition(x + width / 2, y + height / 2 - text.textHeight / 2);
        
        return pos;
    }
}