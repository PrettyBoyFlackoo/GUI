package gui.elements;


import gui.elements.data.*;
import h2d.Graphics;

class Panel extends Element {
    
    var sprite:Graphics;
    var texts:Array<Text> = [];
    var scroll:Scroll;

    public var activeItem(default, null):Int;

    var items:Array<Item> = [];
    public var data:Array<Data> = [];

    ///Attributes
    var itemHeight:Float = 32;
    var itemMargin:Float = 5;
    var textXOffset:Float = 16;
    
    public function new(x:Float = 0, y:Float = 0, width:Float = 200, height:Float = 350, data:Array<Data>) {
        super(x, y, width, height);

        this.data = data;

        scroll = new Scroll(this, data.length, itemHeight, itemMargin, parent);

        sprite = new Graphics(scroll.maskParent);

        createItems(data);
    }

    override function update() {
        super.update();

        createItems(data);

        ///Select Items
        hitCheck(items);


        drawPanel();
    }

    function hitCheck(items:Array<Item>):Void {

        if (isClicking(0, false)) {
            for (i in 0...items.length) {
                var e = items[i];

                ///Check if Outside
                if (coords.y > y + height || coords.y < y) continue;

                var sizeX = e.x + e.width;
                var sizeY = e.y + e.height;

                if (!scroll.isHidden) {
                    sizeX -= scroll.scrollWidth;
                }

                if (coords.x > e.x && coords.x < sizeX && coords.y > e.y && coords.y < sizeY) {
                    activeItem = i;
                }
            }
        }
    }

    function createItems(data:Array<Data>) {

        ///Clear Text
        for (i in texts) {
            i.remove();
        }

        items = [];
        texts = [];

        for (i in 0...data.length) {
            var xPos = x;
            var yPos = y + (i * itemHeight) + (i * itemMargin) + scroll.yScroll;
            var value = data[i].label;

            var item:Item = {
                x: xPos,
                y: yPos,
                width: width,
                height: itemHeight,
                value: value
            };

            items.push(item);

            ///Text
            var txt = Text.createText(xPos, yPos, value, cast scroll.maskParent);            
            texts.push(txt);
        }
    }

    function drawPanel() {
        sprite.clear();

        sprite.beginFill(0x141414);
        sprite.drawRect(x, y, width, height);
        sprite.endFill();

        ///Draw Items
        for (i in 0...items.length) {
            var e = items[i];

            var col = 0;

            i == activeItem ? col = 0x444444 : col = 0x303030;

            sprite.beginFill(col);
            sprite.drawRect(e.x, e.y, e.width, e.height);
            sprite.endFill();
        }

        for (i in 0...items.length) {
            var e = items[i];
            var t = texts[i];

            t.text = e.value;
            t.setPosition(e.x + t.textWidth / 2 + textXOffset, e.y + itemHeight / 2 - t.textHeight / 2);
        }
        


        ///Scrollbar
        scroll.update(sprite, x, y, items.length, itemHeight, itemMargin);
    }
}