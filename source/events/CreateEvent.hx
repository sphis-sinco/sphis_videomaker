package events;

class CreateEvent extends BaseStateEvent
{
	override public function new(state:String)
	{
		super(state);

		type = 'create';
	}
}
