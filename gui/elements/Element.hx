package gui.elements;


import h2d.Graphics;
import hxd.Key;
import h2d.Scene;
import h2d.col.Point;

class Element {

    public var x:Float;
    public var y:Float;
    public var width:Float;
    public var height:Float;

    var hasClicked:Bool;
    public var isLocked:Bool = true;

    public var coords = new Point();
    public var mouseMovement = new Point();
    var lastMouse = new Point();

    public var isBlock:Bool = true;

    public var parent:Scene;

    public function new(x:Float, y:Float, width:Float, height:Float, parent:Scene) {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
        this.parent = parent;
    }

    public function update():Void {
        updateMouse();

        if (!isLocked) {
            x += mouseMovement.x;
            y += mouseMovement.y;
        }
    }

    function updateMouse():Void {
        mouseMovement.set(0, 0);

        coords.set(parent.mouseX, parent.mouseY);


        mouseMovement.x += coords.x - lastMouse.x;
        mouseMovement.y += coords.y - lastMouse.y;

        lastMouse.x = coords.x;
        lastMouse.y = coords.y;
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