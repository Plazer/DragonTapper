/**
 * Created by Plazer on 21.04.2021.
 */
package {
import flash.display.Stage;

import starling.core.Starling;
import starling.display.Button;
import starling.display.DisplayObjectContainer;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

import starling.extensions.animate.AnimAssetManager;
import starling.extensions.animate.Animation;
import starling.textures.Texture;

public class DragonsRoot extends Sprite {

    private static const DRAGON_APPEARING:String = "greenDragonAppearing";
    private static const DRAGON_WAITING:String = "greenDragonWaiting";
    private static const DRAGON_TAPPED:String = "greenDragonTapped";

    private static const MAX_NUM_DRAGONS:int = 30;

    private var _assets:AnimAssetManager;
    private var _addDragonButton:Button;
    private var _dragonCounter:int;

    public function DragonsRoot() {
//        trace("Root created");
    }

    public function start(assets:AnimAssetManager):void {
        _assets = assets;
        addButton();
        addEventListener(Event.TRIGGERED, onAddButtonTriggered);

//        for(var j:int = 0; j < 20; j++){
//            addDragon();
//        }
    }

    private function addButton():void
    {
        var buttonScale:int = 2.0;
        var buttonTexture:Texture = (_assets.getTexture("button"));
        _addDragonButton = new Button(buttonTexture);
        _addDragonButton.x = Starling.current.nativeStage.fullScreenWidth - _addDragonButton.width*buttonScale;
        _addDragonButton.y = Starling.current.nativeStage.fullScreenHeight * 0.5;
        _addDragonButton.scale = buttonScale;

        addChild(_addDragonButton);
    }

    private function addButtonOn():void
    {
        _addDragonButton.enabled = true;
    }

    private function addButtonOff():void
    {
        _addDragonButton.enabled = false;
    }

    private function onAddButtonTriggered(event:Event):void {
        addDragon();
//        for(var j:int = 0; j < 10; j++){
//            addDragon();
//        }
    }

    private function addDragon():void {
        if(_dragonCounter < MAX_NUM_DRAGONS){
            addButtonOff();
            var animatedObject:Animation = addAnimationByName(DRAGON_APPEARING);
            setRandomCoordInArea(animatedObject);
//            animatedObject.scale = 0.2;
            animatedObject.addEventListener(Event.COMPLETE, onAppearingAnimationEnd);
            _dragonCounter++;
        }
    }

    private function addAnimationByName(animationName:String):Animation {
        var tmpAnimation:Animation = _assets.createAnimation(animationName);
        tmpAnimation.alignPivot();
//        tmpAnimation.frameRate = 30;
        tmpAnimation.scale = 0.5;
        addChild(tmpAnimation);
        Starling.juggler.add(tmpAnimation);

        return tmpAnimation;
    }

    private function dragonTapped(target:Animation):void
    {
        var tappedAnimation:Animation = addAnimationByName(DRAGON_TAPPED);
        tappedAnimation.x = target.x;
        tappedAnimation.y = target.y;
        tappedAnimation.addEventListener(Event.COMPLETE, onTappedAnimationEnd);

        target.removeEventListener(TouchEvent.TOUCH, onTouchDragon);
        removeChild(target);
        Starling.juggler.remove(target);
    }

    private function onAppearingAnimationEnd(event:Event):void
    {
        var target:Animation = event.currentTarget as Animation;
        target.removeEventListener(TouchEvent.TOUCH, onAppearingAnimationEnd);

        var waitingAnimation:Animation = addAnimationByName(DRAGON_WAITING);
        waitingAnimation.x = target.x;
        waitingAnimation.y = target.y;
        waitingAnimation.addEventListener(TouchEvent.TOUCH, onTouchDragon);
        removeChild(target);
        Starling.juggler.remove(target);
        addButtonOn();
    }

    private function onTappedAnimationEnd(event:Event):void
    {
        var target:Animation = event.currentTarget as Animation;
        target.removeEventListener(TouchEvent.TOUCH, onTappedAnimationEnd);

        removeChild(target);
        Starling.juggler.remove(target);
        _dragonCounter--;
//        trace("dragons left: " + _dragonCounter);
    }

    private function onTouchDragon(event:TouchEvent):void
    {
        var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
        if (touch)
        {
            dragonTapped(event.currentTarget as Animation);
        }
    }

    private function setRandomCoordInArea(target:DisplayObjectContainer):void
    {
//        var areaObject:Stage = Starling.current.nativeStage;
        var minX:int = target.width/2.0; //for central pivoted targets
        var maxX:int = Starling.current.nativeStage.fullScreenWidth - 3*minX; //extra space for button
        var minY:int = target.height/2.0; //for central pivoted targets
        var maxY:int = Starling.current.nativeStage.fullScreenHeight - 2*minY;

        var newX:int = Math.random()*maxX;
        var newY:int = Math.random()*maxY;
        target.x = minX + newX;
        target.y = minY + newY;
    }
}
}
