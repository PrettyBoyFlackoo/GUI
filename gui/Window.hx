package gui;

import h2d.Mask;
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

    public var parent:Scene;

    public var isLocked:Bool = true;

    var isReady:Bool;
    var mousemovement = new Point();
    var lastmouse = new Point();

    public var children:Array<Element> = [];

    var elementHeight:Float;
    var lastElement:Element;
    var labelHeight:Float = 48;

    var currentHeight:Float;

    public function new(x:Float = 0, y:Float = 0, width:Float = 100, label:String = '', parent:Scene) {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = labelHeight;
        this.parent = parent;

        sprite = new Graphics(parent);

        text = Text.createText(x, y, label);

        Main.windows.push(this);
    }

    public function update():Void {

        if (!isLocked) {
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
            }

            if (Key.isReleased(Key.MOUSE_LEFT) && isReady) {
                isReady = false;
            }

        }


        mousemovement.x = parent.mouseX - lastmouse.x;
        mousemovement.y = parent.mouseY - lastmouse.y;

        lastmouse.x = parent.mouseX;
        lastmouse.y = parent.mouseY;

        
        getWindowHeight();

        drawContainer();

         ///update gui elements
        for (c in children) { 
           c.update();
        }
    }

    function getWindowHeight():Void {
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

    function getNextYpos():Float {
        var startPos = y + labelHeight;

        var dy = 0.0;

        if (lastElement != null) {
            var temp = lastElement.y - startPos;
            dy = temp + lastElement.height;
        }

        return startPos + dy;
    }

    public function createSeparator():Void {
        var separator = new Separator(x, getNextYpos(), width, elementHeight, parent);

        addElement(separator);
    }

    public function createButton(label:String = ''):Button {
        var button:Button = new Button(x, getNextYpos(), width, 32, label, parent);

        addElement(button);

        return button;
    }

    public function createSlider(value:Float = 0, label:String = ''):Slider {
        var slider = new Slider(x, getNextYpos(), width, 32, value, label, parent);

        addElement(slider);

        return slider;
    }

    public function createLabel(label:String):Label {
        var label = new Label(x, getNextYpos(), width, 50, label, parent);

        addElement(label);

        return label;
    }

    public function createCheckbox(checked:Bool = false, label:String = ''):Checkbox {
        var check = new Checkbox(x, getNextYpos(), elementHeight, label, checked, parent);

        addElement(check);

        return check;
    }

    public function createDropdown(values:Array<String>):Dropdown {
        var dropdown = new Dropdown(x, getNextYpos(), width, elementHeight, values, parent);

        addElement(dropdown);

        return dropdown;
    }

    public function createPanel(data:Array<Data>):Panel {
        var panel = new Panel(x, getNextYpos(), width, 150, data, parent);

        addElement(panel);

        return panel;
    }

    public function createColorpicker():Colorpicker {
        var colorpicker = new Colorpicker(x, getNextYpos(), width, parent);

        addElement(colorpicker);

        return colorpicker;
    }

    function addElement(e:Element) {
        lastElement = e;
        elementHeight = e.height;

        e.parent = parent;


        children.push(e);
    }
}