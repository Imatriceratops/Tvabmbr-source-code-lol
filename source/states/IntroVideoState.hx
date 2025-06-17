package states;

import flixel.util.typeLimit.OneOfTwo;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import openfl.Assets;
import haxe.xml.Access;
import hxvlc.flixel.FlxVideoSprite;

class IntroVideoState extends MusicBeatState
{
	public var videoCutscene:FlxVideoSprite;
	var canSkip:Bool = false;
	var textShit:FlxText;

	var loadShit:String = "hell" + FlxG.random.int(1, 4);
	override function create():Void
	{
		FlxG.mouse.visible = true;
		// fuck that mouse just move on load shit graphic :sob:

        startVideo(loadShit); // boi i gotta kms :3

		super.create();
	}

   	public function startVideo(name:String)
	{
		videoCutscene = new FlxVideoSprite(0, 0);
		add(videoCutscene);
		videoCutscene.load(Paths.video(name));
		videoCutscene.play();
		videoCutscene.alpha = 1;
		videoCutscene.visible = true;
		videoCutscene.bitmap.onEndReached.add(function()
		{
				trace("Start Going 'SillyWarningState'");
				MusicBeatState.switchState(new states.SillyWarningState());
		});

		textShit = new FlxText(12, FlxG.height - 24, 0, "", 32);
		textShit.text = "Click [Enter] To Skip Video";
		textShit.setFormat("VCR OSD Mono", 32);
		textShit.alpha = 0;
		textShit.updateHitbox();
		add(textShit);
		FlxTween.tween(textShit, {'alpha': 1}, 1, {onComplete:function(twnShit:FlxTween){
			canSkip = true;
			textShit.alpha = 1;
			twnShit.destroy();
		}});
	}
	
	override function update(elapsed:Float):Void
	{
		if(!canSkip){
			//nothing else
		}else{
			if(FlxG.keys.justPressed.ENTER){
				videoCutscene.pause();
				trace("uwu i am cring so it's ended video");
				MusicBeatState.switchState(new states.ImportantWarningState());
				}
				}
		super.update(elapsed);
	}
}