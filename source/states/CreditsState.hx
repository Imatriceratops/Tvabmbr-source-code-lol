// This is a simple credit roll created by Santiago [https://santiagocalebe.neocities.org/]
package states;
// Here you add the libaries, if you just wanna use this menu. Don't change anything.
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.addons.display.FlxBackdrop;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class CreditsState extends MusicBeatState {

    // Here is the velocity of the scroll, 120 is default.
    private var scrollSpeed:Float = 120;

    private var creditsText:FlxText;
	private var instructionsText:FlxText;
    private var instructionsText2:FlxText;

	var checker:FlxBackdrop;

    override public function create() {
        super.create();

		checker = new FlxBackdrop(Paths.image('grid'));
		//checker.velocity.set(112, 110);
		checker.updateHitbox();
		checker.scrollFactor.set(0, 0);
		checker.alpha = 0.2;
		checker.screenCenter(X);
		add(checker);

        creditsText = new FlxText(0, FlxG.height, FlxG.width, 
			"Team The Awesome Bday Team \n\n\n" +
            "StarJai \n Artist." +
            "ProdByProto \n Composer." +
            "This is just a test btw lol"
            /*

            How does this part work?

            First of all, you should have your text ready, so,
            you add here, it should look like this:

            __________________________________________________

            "Team Teamname \n" +
            "People1 \n Artist." +
            "People2 \n Composer." +
            ...
            "People71 \n Whatever this guy did."

            __________________________________________________

            If you wanna add text, use:

            "YourText"

            If you wanna do a jump a line, use:

            \n

            If you wanna jump multiple lines, repeat the '\n', so, basically,
            "I wanna jump 3 lines!"

            \n\n\n

            REMINDER: ALWAYS ADD A '+' in the end to it continue!!! (You only won't add if it is the last line of the text!)

            __________________________________________________

            Right:

            "Team Peakness \n\n\n" + 
            "PeakDick - Artist." +
            "MassivePeak - Composer." +
            ...
            "Thank you for playing!"

            __________________________________________________

            Wrong:

            "Team Peakness \n\n\n"
            "PeakDick - Artist."
            "MassivePeak - Composer."
            ...
            "Thank you for playing!"

            */
            
        );

                              // Font      // Size      // Color  // Pos.
        creditsText.setFormat("VCR OSD Mono", 64, FlxColor.WHITE, "center");
        add(creditsText);

        instructionsText = new FlxText(10, 50, FlxG.width - 20, 
            "Press ESC to skip"
        );
                                   // Font      // Size      // Color  // Pos.
		instructionsText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, "bottom");
		add(instructionsText);

        instructionsText2 = new FlxText(10, 100, FlxG.width - 20, 
            // Default if GB (Gamebanana), change this if you want to.
            "Press 'G' to access GB Page."
        );
                                  // Font      // Size      // Color  // Pos.
		instructionsText2.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, "bottom");
		add(instructionsText2);

        var duration:Float = (creditsText.height + FlxG.height) / scrollSpeed;
        FlxTween.tween(creditsText, { y: -creditsText.height }, duration, {
            type: FlxTween.ONESHOT,
            onComplete: function(tween:FlxTween) {
                // Change this if you want it to go to another state.
                MusicBeatState.switchState(new MainMenuState());
            }
        });
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

		checker.x += .5*(elapsed/(1/120)); 
		checker.y -= 0.16;

        if (FlxG.keys.justPressed.ESCAPE) {
             // Change this if you want it to go to another state.
            MusicBeatState.switchState(new MainMenuState());
        }

        // Santiago, i want to use other Keybind!! Check https://api.haxeflixel.com/flixel/input/keyboard/FlxKeyList.html
        if (FlxG.keys.justPressed.G) {
            // Change 'https://example.com' with your Gamebanana page or something.
            CoolUtil.browserLoad('https://example.com');
        }
    }
}
