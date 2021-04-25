/**
 * Created by Plazer on 21.04.2021.
 */
package {
import flash.display.Sprite;
import flash.filesystem.File;
import flash.geom.Rectangle;

import starling.core.Starling;
import starling.events.Event;


import starling.extensions.animate.AnimAssetManager;

public class Startup extends Sprite{
    private var _starling:Starling;

    [SWF(width="800", height="800", frameRate="60", backgroundColor="#000000")]
    public function Startup() {
        var viewPort:Rectangle = new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
        _starling = new Starling(DragonsRoot, stage, viewPort);
        _starling.skipUnchangedFrames = true;
//        _starling.showStats = true;
        _starling.addEventListener(Event.ROOT_CREATED, loadAssets);
        _starling.start();
        Starling.current.nativeStage.frameRate = 60;

    }
    private function loadAssets():void
    {
        var dragonsRoot:DragonsRoot = _starling.root as DragonsRoot;
        var appDir:File = File.applicationDirectory;
        var assets:AnimAssetManager = new AnimAssetManager();
        assets.enqueue(appDir.resolvePath("assets/button.png"));
        assets.enqueue(appDir.resolvePath("assets/greenDragonAppearing/"));
        assets.enqueue(appDir.resolvePath("assets/greenDragonWaiting/"));
        assets.enqueue(appDir.resolvePath("assets/greenDragonTapped/"));

//        assets.enqueue(appDir.resolvePath("button.png"));
//        assets.enqueue(appDir.resolvePath("greenDragonAppearing/"));
//        assets.enqueue(appDir.resolvePath("greenDragonWaiting/"));
//        assets.enqueue(appDir.resolvePath("greenDragonTapped/"));
        assets.loadQueue(dragonsRoot.start);
    }
}
}
