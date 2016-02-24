using utest.Assert;

import utest.Runner;
import utest.ui.Report;

class TestAll{
	
	public function testArrayofInt(){	
		var gcUsage = GcUsage.gatherFrom({
			var array = new Array<Int>();
		});
		
		Assert.equals(1, gcUsage.numAllocations);
		Assert.equals(0, gcUsage.numReallocations);
		Assert.equals(0, gcUsage.numDeallocations);
		Assert.equals(128, gcUsage.bytesUsed);
		Assert.equals(0, gcUsage.bytesReserved);
	}
	
	public function testArrayofIntFirstInsert(){	
		var gcUsage = GcUsage.gatherFrom({
			var array = new Array<Int>();
			array[0] = 1;
		});
		
		Assert.equals(2, gcUsage.numAllocations);
		Assert.equals(0, gcUsage.numReallocations);
		Assert.equals(0, gcUsage.numDeallocations);
		Assert.equals(128, gcUsage.bytesUsed);
		Assert.equals(0, gcUsage.bytesReserved);
	}
	
	public function testMapIntIntFirstInsert(){	
		var gcUsage = GcUsage.gatherFrom({
			var map = new Map<Int,Int>();
			map[0] = 1;
		});
		
		Assert.equals(3, gcUsage.numAllocations);
		Assert.equals(0, gcUsage.numReallocations);
		Assert.equals(0, gcUsage.numDeallocations);
		Assert.equals(128, gcUsage.bytesUsed);
		Assert.equals(0, gcUsage.bytesReserved);
	}
	
	public function testMapIntIntClearViaKeys(){
		var map = new Map<Int,Int>();
		map[0] = 1;	
		map[3] = 2;
		map[5] = 0;
		var gcUsage = GcUsage.gatherFrom({
			for(key in map.keys()){
				map.remove(key);
			}
		});
		
		Assert.equals(3, gcUsage.numAllocations);
		Assert.equals(0, gcUsage.numReallocations);
		Assert.equals(0, gcUsage.numDeallocations);
		Assert.equals(128, gcUsage.bytesUsed);
		Assert.equals(0, gcUsage.bytesReserved);
	}
	
	public function testMapIntIntClearViaNewMap(){
		var test : {map : Map<Int,Int>} = {
			map : null
		}
		
		
		var gcUsage = GcUsage.gatherFrom({
			test.map = new Map<Int,Int>();
			test.map[0] = 1;	
		  test.map[3] = 2;
		  test.map[5] = 0;
			test.map = new Map<Int,Int>();
		});
		
		Assert.equals(7, gcUsage.numAllocations);
		Assert.equals(0, gcUsage.numReallocations);
		//Assert.equals(2, gcUsage.numDeallocations);
		Assert.equals(256, gcUsage.bytesUsed);
		Assert.equals(0, gcUsage.bytesReserved);
	}
	
	public function testInterfaceAcceptingIntAsFunctionParam(){
		var impl = new TestImpl();
		var test = new InterfaceCallTest();
		var gcUsage = GcUsage.gatherFrom({
			test.callInterface(impl,3);
		});
		Assert.equals(1, gcUsage.numAllocations);
		Assert.equals(0, gcUsage.numReallocations);
		Assert.equals(1, gcUsage.numDeallocations);
		Assert.equals(0, gcUsage.bytesUsed);
		Assert.equals(0, gcUsage.bytesReserved);
	}
	
	
	public static function main() {
		var runner = new Runner();

		runner.addCase(new TestAll());

		Report.create(runner);
		runner.run();
	}
	public function new() {}
}

class InterfaceCallTest{
	public function new(){}
	public function callInterface(test : TestInterface, i : Int) : Void{
		test.test(i);
	}

}


interface TestInterface{
	function test(i : Int) : Void;
}

class TestImpl implements TestInterface{
	public function new(){}
	public function test(i : Int) : Void{
		//do nothing
	}
}