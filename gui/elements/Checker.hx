package gui.elements;


import hxd.Key;
import gui.elements.data.*;
import h2d.Tile;
import h2d.col.Point;
import h2d.Graphics;

class Checker extends Element {
    
    var sprite:Graphics;
    var scroll:Scroll;

    var restAmount = 0;
    var max = 4;
    var row:Int;

    var checkerSize = 0.;

    public var data:Array<Data> = [];
    var blocks:Array<CheckerBlock> = [];

    public var color(default, null):Int;

    public function new(x = 0, y = 0.0, width = 100.0, height = 100.0, data:Array<Data>) {
        super(x, y, width, height);

        this.data = data;

        scroll = new Scroll(this, row, getCheckerSize(), 0, parent);
        sprite = new Graphics(scroll.maskParent);

        restAmount = data.length;
    }

    override function update() {
        super.update();

        ///Check if click
        if (Key.isPressed(Key.MOUSE_LEFT)) {
            color = getChecker();
        }


        draw();
    }

    function getChecker():Int {
        var mouse = new Point(parent.mouseX, parent.mouseY);

        for (i in blocks) {
            if (mouse.x > i.x && mouse.x < i.x + checkerSize && mouse.y > i.y && mouse.y < i.y + checkerSize) {
                return i.color;
            }
        }

        return 0;
    }

    function draw() {
        createChecker();

        sprite.clear();

        sprite.beginFill(0x141414);
        sprite.drawRect(x, y, width, height);
        sprite.endFill();


        ///Draw Checker
        for (i in blocks) {
            sprite.beginFill(i.color);
            sprite.lineStyle(1, 0xD1D1D1);
            sprite.drawRect(i.x, i.y, checkerSize, checkerSize);

        }
        sprite.endFill();

        ///Draw Scrollbar
        scroll.update(sprite, x, y, row, getCheckerSize(), 0);
    }

    function createChecker():Void {
        checkerSize = getCheckerSize();

        row = getRows(data.length, max);

        blocks = [];

        for (i in 0...row) {
            var delt = 0;

            restAmount >= max ? delt = max : delt = restAmount;

            for (j in 0...delt) {
                restAmount--;

                var xpos = x + (j * checkerSize);
                var ypos = y + (i * checkerSize) + scroll.yScroll;

                var b:CheckerBlock = {
                    x: xpos,
                    y: ypos,
                    color: data[j].color,
                    pos: j
                };

                blocks.push(b);
            }
            
        }

        restAmount = data.length;
    }

    function getRows(amount:Int, maxInOneLine:Int):Int {
        return Math.ceil(amount / maxInOneLine);
    }

    function getCheckerSize():Float {
        return width / max;
    }
}

typedef CheckerBlock = {
    var x:Float;
    var y:Float;
    @:optional var color:Int;
    @:optional var pos:Int;
}