package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class SillyWarningState extends MusicBeatState
{
	public static var leftState:Bool = false;

	override function create()
	{
		super.create();
	
	var menubg:FlxSprite;
	menubg = new FlxSprite().loadGraphic(Paths.image('Silly warning'));
    menubg.antialiasing = ClientPrefs.data.antialiasing;
    menubg.screenCenter();
    add(menubg);
	FlxG.sound.playMusic(Paths.music('Tutorial BM The Talking Track'), 1);
    }

	override function update(elapsed:Float)
	{
		if(!leftState) {
			var back:Bool = controls.BACK;
			if (controls.ACCEPT || back) {
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				if(!back) {
					ClientPrefs.data.flashing = false;
					ClientPrefs.saveSettings();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					{
						new FlxTimer().start(0.5, function (tmr:FlxTimer) {
							MusicBeatState.switchState(new TitleState());
						});
					};
				} else {
					FlxG.sound.play(Paths.sound('cancelMenu'));
					{
						onComplete: function (twn:FlxTween) {
							MusicBeatState.switchState(new TitleState());
						}
					};
				}
			}
		}
		super.update(elapsed);
	}
}