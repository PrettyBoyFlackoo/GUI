package elements;

import hxd.Key;
import h2d.Scene;
import h2d.col.Point;

class Element {
    
    var x:Float;
    var y:Float;
    var width:Float;
    var height:Float;

    public var coords = new Point();

    var parent:Scene;

    public function new(x:Float, y:Float, width:Float, height:Float) {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;

        parent = Main.inst;

        Main.elements.push(this);
    }

    public function update():Void {
        coords.set(parent.mouseX, parent.mouseY);

    }

    public function setPosition(dx:Float, dy:Float):Void {
        x = dx;
        y = dy;
    }

    public function setDimension(width:Float, height:Float):Void {
        this.width = width;
        this.height = height;
    }

    public function isMouseOver():Bool {
        if (coords.x > x && coords.x < x + width &&
            coords.y > y && coords.y < y + height) {
                return true;
            }
        
            return false;
    }

    public function isClicking(?state:Int = 0, ?inBounds:Bool = true):Bool {
        var isOver = isMouseOver();

        if (!isOver && inBounds) return false;

        switch (state) {
            case 0:
                if (Key.isPressed(Key.MOUSE_LEFT)) {
                    return true;
                }
            case 1:
                if (Key.isDown(Key.MOUSE_LEFT)) {
                    return true;
                }
            case 2:
                if (Key.isReleased(Key.MOUSE_LEFT)) {
                    return true;
                }
        }

        return false;
    }
}