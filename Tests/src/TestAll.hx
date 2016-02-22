using utest.Assert;

import utest.Runner;
import utest.ui.Report;

class TestAll{
	
	public function testArrayofInt(){	
		var gcUsage = Gc.gatherGcUsageFor({
			var array = new Array<Int>();
		});
		
		Assert.equals(1, gcUsage.numAllocations);
		Assert.equals(0, gcUsage.numReallocations);
		Assert.equals(0, gcUsage.numDeallocations);
	}
	
	public function testArrayofIntFirstInsert(){	
		var gcUsage = Gc.gatherGcUsageFor({
			var array = new Array<Int>();
			array[0] = 1;
		});
		
		Assert.equals(2, gcUsage.numAllocations);
		Assert.equals(0, gcUsage.numReallocations);
		Assert.equals(0, gcUsage.numDeallocations);
	}
	
	public function testMapIntIntFirstInsert(){	
		var gcUsage = Gc.gatherGcUsageFor({
			var map = new Map<Int,Int>();
			map[0] = 1;
		});
		
		Assert.equals(3, gcUsage.numAllocations);
		Assert.equals(0, gcUsage.numReallocations);
		Assert.equals(0, gcUsage.numDeallocations);
	}
	
	public function testMapIntIntClearViaKeys(){
		var map = new Map<Int,Int>();
		map[0] = 1;	
		map[3] = 2;
		map[5] = 0;
		var gcUsage = Gc.gatherGcUsageFor({
			for(key in map.keys()){
				map.remove(key);
			}
		});
		
		Assert.equals(3, gcUsage.numAllocations);
		Assert.equals(0, gcUsage.numReallocations);
		Assert.equals(0, gcUsage.numDeallocations);
	}
	
	public function testMapIntIntClearViaNewMap(){
		var test : {map : Map<Int,Int>} = {
			map : null
		}
		
		
		var gcUsage = Gc.gatherGcUsageFor({
			test.map = new Map<Int,Int>();
			test.map[0] = 1;	
		  test.map[3] = 2;
		  test.map[5] = 0;
			test.map = new Map<Int,Int>();
		});
		
		Assert.equals(7, gcUsage.numAllocations);
		Assert.equals(0, gcUsage.numReallocations);
		Assert.equals(2, gcUsage.numDeallocations);
	}
	
	
	public static function main() {
		var runner = new Runner();

		runner.addCase(new TestAll());

		Report.create(runner);
		runner.run();
	}
	public function new() {}
}