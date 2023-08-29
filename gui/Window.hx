package gui;

import gui.elements.colorpicker.*;
import gui.elements.data.*;
import hxd.Key;
import h2d.Scene;
import h2d.col.Point;
import h2d.Graphics;
import gui.elements.*;

class Window {

    var sprite:Graphics;
    var text:Text;
    
    public var x:Float;
    public var y:Float;
    public var width:Float;
    public var height:Float;

    var parent:Scene;

    public var canDrag:Bool;

    var isReady:Bool;
    var mousemovement = new Point();
    var lastmouse = new Point();

    public var children:Array<Element> = [];

    var elementHeight:Float;
    var lastElement:Element;
    var labelHeight:Float = 48;

    var currentHeight:Float;

    public function new(x:Float = 0, y:Float = 0, width:Float = 100, label:String = '') {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = labelHeight;

        parent = Main.inst;

        sprite = new Graphics(parent);

        text = Text.createText(x, y, label);
    }

    public function update():Void {
     
        if (canDrag) {
            if (Key.isPressed(Key.MOUSE_LEFT) && !isReady && parent.mouseX > x && parent.mouseX < x + width && parent.mouseY > y && parent.mouseY < y + labelHeight) {
                isReady = true;
            }

            if (Key.isDown(Key.MOUSE_LEFT) && isReady) {
                x += mousemovement.x;
                y += mousemovement.y;

                for (i in children) {
                    i.x += mousemovement.x;
                    i.y += mousemovement.y;
                }

                trace(x + '/' + y);
            }

            if (Key.isReleased(Key.MOUSE_LEFT) && isReady) {
                isReady = false;
            }

        }


        mousemovement.x = parent.mouseX - lastmouse.x;
        mousemovement.y = parent.mouseY - lastmouse.y;

        lastmouse.x = parent.mouseX;
        lastmouse.y = parent.mouseY;

        
        resizeWindow();


        drawContainer();



    }

    function resizeWindow():Void {
        currentHeight = labelHeight;

        ///Calcuatle Current Height
        for (i in children) {
            currentHeight += i.height;

        }
    }

    function drawContainer():Void {
        sprite.clear();

        sprite.beginFill(0x080808);
        sprite.drawRect(x, y, width, currentHeight);
        sprite.endFill();

        sprite.beginFill(0x242424);
        sprite.drawRect(x, y, width, labelHeight);
        sprite.endFill();

        text.setPosition(x + width / 2, y + labelHeight / 2 - text.textHeight / 2);

        ///Blue Line
        sprite.beginFill(0x2dc5e0);
        sprite.drawRect(x, y + labelHeight - 2, width, 2);
        sprite.endFill();
    }

    public inline function getNextYpos():Float {
        var startPos = y + labelHeight;

        var dy = 0.0;

        if (lastElement != null) {
            var temp = lastElement.y - startPos;
            dy = temp + lastElement.height;
        }

        return startPos + dy;
    }

    public function createSeparator():Void {
        var separator = new Separator(x, getNextYpos(), width, elementHeight);

        addElement(separator);
    }

    public function createButton(label:String = '') {
        var button:Button = new Button(x, getNextYpos(), width, 32, label);

        addElement(button);
    }

    public function createSlider(value:Float = 0, label:String = '') {
        var slider = new Slider(x, getNextYpos(), width, 32, value, label);

        addElement(slider);
    }

    public function createLabel(label:String) {
        var label = new Label(x, getNextYpos(), width, 50, label);

        addElement(label);
    }

    public function createCheckbox(checked:Bool = false, label:String = '') {
        var check = new Checkbox(x, getNextYpos(), elementHeight, label, checked);

        addElement(check);
    }

    public function createDropdown(values:Array<String>) {
        var dropdown = new Dropdown(x, getNextYpos(), width, elementHeight, values);

        addElement(dropdown);
    }

    public function createPanel(data:Array<Data>):Panel {
        var panel = new Panel(x, getNextYpos(), width, 150, data);

        addElement(panel);

        return panel;
    }

    public function createColorpicker(r:Float = 1, g:Float = 0, b:Float = 0):Colorpicker {
        var colorpicker = new Colorpicker(x, getNextYpos(), width);

        addElement(colorpicker);

        return colorpicker;
    }

    function addElement(e:Element) {
        lastElement = e;
        elementHeight = e.height;


        children.push(e);
    }

    
/*
    public function createOutliner(data:Array<Data>) {
        var outliner = new Outliner(x, getNextYpos(), width, elementHeight, data);

        addElement(outliner);
    }*/
}