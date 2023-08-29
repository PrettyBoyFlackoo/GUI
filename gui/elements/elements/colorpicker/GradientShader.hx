package gui.elements.colorpicker;

import hxsl.Shader;

import h3d.shader.Base2d;

class GradientShader extends Shader {
    
    static var SRC = {

        @:import Base2d;
        @param var hue:Float;

        function fragment():Void {
            var c:Vec3 = hsv2rgb(vec3(hue, calculatedUV.x, calculatedUV.y));

            pixelColor = vec4(c.x, c.y, c.z, 1);
        }

        function hsv2rgb(c:Vec3):Vec3 {
            c = vec3(c.x, clamp(c.yz, 0.0, 1.0));
            var K:Vec4 = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
            var p:Vec3 = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
            return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
          }
    }
}