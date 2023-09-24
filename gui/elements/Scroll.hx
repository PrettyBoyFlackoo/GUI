package gui.elements;


import gui.elements.data.ColorPalette;
import h2d.Object;
import hxd.Key;
import h2d.col.Point;
import h2d.Scene;
import h2d.Mask;
import h2d.Graphics;

using hxd.Math;

class Scroll {

    ///For Parent Container
    var x:Float;
    var y:Float;
    var width:Float;
    var height:Float;

    public var itemCount:Int;
    public var itemHeight:Float;
    public var itemMargin:Float;
    
    var itemListSize:Float;

    var mask:Mask;

    var scrollColor:Int;
    var scrollbarY:Float = 0;
    var scrollbarSize:Float;
    var isReady:Bool;

    var lastmouse = new Point();
    var mouseMovement = new Point();

    var minThumbSize:Float = .1; ///Emtpy space in %, how much empty will see
    public var scrollWidth:Float = 14;

    var parent:Scene;
    public var maskParent:Object;

    ///Scroll Factor
    public var yScroll(default, null):Float;
    public var isHidden(default, null):Bool;

    public function new(container:Element, itemCount:Int, itemHeight:Float, itemMargin:Float, parent:Scene) {
        x = container.x;
        y = container.y;
        width = container.width;
        height = container.height;

        this.itemCount = itemCount;
        this.itemHeight = itemHeight;
        this.itemMargin = itemMargin;

        this.parent = parent;

        ///Mask
        mask = new Mask(Math.round(width), Math.round(height), parent);
        mask.x = x;
        mask.y = y;

        mask.scrollX = x;
        mask.scrollY = y;

        maskParent = mask;
    }

    public function update(sprite:Graphics, x:Float, y:Float, itemCount:Int, itemHeight:Float, itemMargin:Float) {
        mask.x = x;
        mask.y = y;
        mask.scrollX = x;
        mask.scrollY = y;

        itemListSize = itemHeight * itemCount + ((itemCount - 1) * itemMargin);

        ///Get Thumb Size
        scrollbarSize = getScrollSize();

        ///Get Thumb Y pos
        yScroll = getYScrollPos();


        if (Math.abs(getSizeDiff()) > 1.0) {
            isHidden = true;
            return;
        }


        ///Mouse Scroll
        if (!isReady) {
            var factor = 15.0;
            var step = itemListSize / factor;
    
            var abs = height / step;


            if (Key.isPressed(Key.MOUSE_WHEEL_UP) && parent.mouseX > x && parent.mouseX < x + width && parent.mouseY > y && parent.mouseY < y + height) {
                ///Up
                
                scrollbarY -= abs;
    
                scrollbarY = Math.clamp(scrollbarY, 0, height - scrollbarSize);
            }
            else if (Key.isPressed(Key.MOUSE_WHEEL_DOWN) && parent.mouseX > x && parent.mouseX < x + width && parent.mouseY > y && parent.mouseY < y + height) {
                ///Down
    
                scrollbarY += abs;
                
                scrollbarY = Math.clamp(scrollbarY, 0, height - scrollbarSize);
            }
        }
        
        isHidden = false;

        drawScrollbar(sprite, x, y);
    }


    function drawScrollbar(sprite:Graphics, x:Float, y:Float):Void {
        sprite.lineStyle();
        
        ///Draw Scroll
        var xPos = x + width - scrollWidth;
        var yPos = y;

        ///bg
        sprite.beginFill(ColorPalette.scrollTrackColor, .6);
        sprite.drawRect(xPos, yPos, scrollWidth, height);
        sprite.endFill();

        //thumb
        sprite.beginFill(scrollColor);
        sprite.drawRect(xPos, yPos + scrollbarY, scrollWidth, scrollbarSize);
        sprite.endFill();

        var coords = new Point(parent.mouseX, parent.mouseY);


        mouseMovement.x = coords.x - lastmouse.x;
        mouseMovement.y = coords.y - lastmouse.y;

        scrollColor = ColorPalette.scrollThumbColor;

        ///Check clicking
        if (Key.isPressed(Key.MOUSE_LEFT) && coords.x > xPos && coords.x < xPos + scrollWidth && coords.y > y + scrollbarY && coords.y < y + scrollbarY + scrollbarSize&& !isReady) {
            isReady = true;
        }

        if (Key.isDown(Key.MOUSE_LEFT) && isReady) {
            scrollbarY += mouseMovement.y;

            getScrollColor();

          
            scrollbarY = Math.clamp(scrollbarY, 0, height - scrollbarSize);
        }

        if (Key.isReleased(Key.MOUSE_LEFT) && isReady) {
            isReady = false;
        }

        lastmouse.set(coords.x, coords.y);
    }

    function getScrollColor() {
        scrollColor = ColorPalette.scrollActiveThumbColor;

        trace('s');
    }

    function getSizeDiff():Float {
        var hiddenLength = itemListSize - height;

        return -(hiddenLength / itemListSize - 1);
    }

    function getScrollSize():Float {
        var abs = getSizeDiff();

        if (abs < minThumbSize) {
            abs = minThumbSize;
        }

        return abs * height;
    }
    
    function getYScrollPos():Float {
       return -(getAbsScroll() * (itemListSize - height));
    }

    function getAbsScroll():Float {
        var length = height - scrollbarSize;
        
        return scrollbarY / length;
    }
}