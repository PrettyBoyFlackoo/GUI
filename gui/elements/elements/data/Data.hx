package gui.elements.data;

import h2d.Tile;

typedef Data = {
    var label:String;
    @:optional var tile:Tile;
    @:optional var color:Int;
}