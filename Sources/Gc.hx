import haxe.macro.Expr;
import haxe.macro.Context;
class Gc{
	macro public static function gatherGcUsageFor(expr : Expr) : Expr{
		var pos = Context.currentPos();
		if(!Context.defined("cpp") || !Context.defined("HXCPP_TELEMETRY") || !Context.defined("HXCPP_STACK_TRACE")){
			Context.error("only cpp target with '-D HXCPP_TELEMETRY' and '-D HXCPP_STACK_TRACE' supported",pos);
			return null;
		}
		
		var newExpr = macro {
		var __gcUsage = @:privateAccess new Gc.GcUsage();
		@:privateAccess __gcUsage.begin();
	};

	newExpr = append(newExpr,expr);
	newExpr = append(newExpr,macro {
		@:privateAccess __gcUsage.end();
		__gcUsage;
	});
	
	
	return newExpr;
	}
	
	static function append(expr : Expr, exprToAdd : Expr) : Expr{
		return
		switch(expr.expr){
			case EBlock(exprs):
				exprs.push(exprToAdd);
				expr;
			default :
				expr.expr = EBlock([{pos:expr.pos,expr:expr.expr}, exprToAdd]);
				expr;
		}
	}
}

#if !macro
class GcUsage{
	
	public var numAllocations(default,null) : Int = -1;
	public var numReallocations(default,null) : Int = -1;
	public var numDeallocations(default,null) : Int = -1;
	var threadNum : Int = -1;
	private function new(){
	}
	
	private function begin(){
		cpp.vm.Gc.run(true);
		threadNum = untyped  __global__.__hxcpp_hxt_start_telemetry(true, true);
		untyped  __global__.__hxcpp_hxt_ignore_allocs(1);
		cpp.vm.Gc.run(true);
		untyped  __global__.__hxcpp_hxt_ignore_allocs(-1);
	}
	
	
	private function end(){
		cpp.vm.Gc.run(true);
		untyped  __global__.__hxcpp_hxt_ignore_allocs(1);
		untyped  __global__.__hxcpp_hxt_stash_telemetry();
		gatherData();
	}
	
	@:functionCode('
		TelemetryFrame* frame = __hxcpp_hxt_dump_telemetry(threadNum);
		numAllocations = -1;
		numDeallocations = -1;
		numReallocations = -1;
		if (frame->allocation_data!=0){
			int size = frame->allocation_data->size();
			int i = 0;
			numAllocations = 0;
			numReallocations = 0;
			numDeallocations = 0;
			while (i<size) {
				if (frame->allocation_data->at(i)==0) {
					i+=5;
					numAllocations++;
				}
				else if (frame->allocation_data->at(i)==1) { 
					i+=2; 
					numDeallocations ++; 
				}
				else if (frame->allocation_data->at(i)==2) {
					i+=4; 
					numReallocations ++; 
				}
			}
			return null();
		}
		
		')
	function gatherData(){
		
	}

}
#end