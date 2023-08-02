package elements;

import h2d.Graphics;

class Panel extends Element {

    var sprite:Graphics;
    var label:Text;
    var labelHeight:Float;

    var scrollbar:Graphics;
    var scrollbarWidth:Float = 14;
    var scrollbarHeight:Float = 50;

    var elements:Array<Element> = [];

    var isReady:Bool;

    var isLocked:Bool;
    var lastMouseX:Float;
    var lastMouseY:Float;
    var mouseMovementX:Float;
    var mouseMovementY:Float;

    public function new(label:String, x:Float, y:Float, width:Float, height:Float) {
        super(x, y, width, height);

        sprite = new Graphics(parent);

        this.label = Text.createText(x, y, label);
    }

    override function update() {
        super.update();

        mouseMovementX = 0;
        mouseMovementY = 0;

        if (isClicking(0, false) && !isReady && coords.x > x && coords.x < x + width && coords.y > y && coords.y < y + labelHeight) {
            isReady = true;
        }

        if (isClicking(1, false) && isReady) {

            if (isLocked) return;
            
            ///Move Around
            mouseMovementX += coords.x - lastMouseX;
            mouseMovementY += coords.y - lastMouseY;

            x += mouseMovementX;
            y += mouseMovementY;
        }

        if (isClicking(2, false) && isReady) {
            isReady = false;
        }


        lastMouseX = coords.x;
        lastMouseY = coords.y;

        drawPanel();
    }

    public function setElements(elements:Array<Element>):Void {
        this.elements = elements;

        scrollbar = new Graphics(parent);
    }

    function drawPanel():Void {
        sprite.clear();

        ///Draw Panel
        sprite.beginFill(0x070707);
        sprite.drawRect(x, y, width, height);
        sprite.endFill();

        //Draw Panel Label
        var padding:Float = 15;
        var topheight:Float = label.textHeight + padding;
        labelHeight = topheight;

        sprite.beginFill(0x202020);
        sprite.drawRect(x, y, width, topheight);
        sprite.endFill();


        label.setPosition(x + width / 2, y + topheight / 2 - label.textHeight / 2);


        if (elements.length == 0) return;

        ///Calculate Dimensions
        var eWidth = width;
        var eHeight = height / elements.length;
        var maxHeight = 50;

        eHeight = Math.min(eHeight, maxHeight);

        ///Draw Elements
        for (i in 0...elements.length) {

            ///Set Size
            elements[i].setDimension(eWidth, eHeight);
            
            ///Set Position
            var xPos = x;
            var yPos = y + topheight + (i * eHeight);

            elements[i].setPosition(xPos, yPos);
        }

        //drawScrollbar();
    }

    function drawScrollbar():Void {
        scrollbar.clear();

        ///Draw Scrollbar

        var xPos = x + width - scrollbarWidth;

        //Bg
        scrollbar.beginFill(0x353535, .6);
        scrollbar.drawRect(xPos, y + labelHeight, scrollbarWidth, height - labelHeight);
        scrollbar.endFill();

        //Thumb
        scrollbar.beginFill(0x404040);
        scrollbar.drawRect(xPos, y + labelHeight, scrollbarWidth, scrollbarHeight);
        scrollbar.endFill();
    }
}