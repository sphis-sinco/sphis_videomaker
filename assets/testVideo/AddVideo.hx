import events.AddedEvent;
import events.CreateEvent;
import events.UpdateEvent;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

function onAdded(event:AddedEvent)
{
	VideoSelector.videos.push('testVideo');
}

var testVidText:FlxText;

function onCreate(event:CreateEvent)
{
	if (event.state == 'testVideo')
	{
		testVidText = new FlxText();
		testVidText.size = 16;
		testVidText.text = 'Yo!';
		testVidText.fieldWidth = FlxG.width;
		testVidText.alignment = 'center';
		PlayState.instance.add(testVidText);

		FlxTimer.wait(1, () ->
		{
			testVidText.text += '\n';
			testVidText.text += 'Uh...';
			testVidText.text += '\n';
		});
		FlxTimer.wait(1.2, () ->
		{
			testVidText.text += 'Dunno ';
		});
		FlxTimer.wait(1.25, () ->
		{
			testVidText.text += 'what ';
		});
		FlxTimer.wait(1.3, () ->
		{
			testVidText.text += 'really ';
		});
		FlxTimer.wait(1.35, () ->
		{
			testVidText.text += 'to ';
		});
		FlxTimer.wait(1.4, () ->
		{
			testVidText.text += 'ty';
		});
		FlxTimer.wait(1.45, () ->
		{
			testVidText.text += 'pe.';
			testVidText.text += '\n';
		});
		FlxTimer.wait(1.75, () ->
		{
			testVidText.text += 'So ';
		});
		FlxTimer.wait(1.9, () ->
		{
			testVidText.text += 'um';
		});
		FlxTimer.wait(1.95, () ->
		{
			testVidText.text += '.';
		});
		FlxTimer.wait(1.98, () ->
		{
			testVidText.text += '.';
		});
		FlxTimer.wait(2.0, () ->
		{
			testVidText.text += '.';
		});
		FlxTimer.wait(2.05, () ->
		{
			testVidText.text += '.';
		});
		FlxTimer.wait(FlxG.random.float(3, 10), () ->
		{
			testVidText.text += '\n';
			testVidText.text += 'PP.';
		});
	}
}

function onUpdate(event:UpdateEvent)
{
	if (event.state == 'testVideo')
		testVidText.screenCenter();
}
