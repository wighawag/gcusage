
haxe 3.2.1 : [![travis status](https://travis-ci.org/wighawag/gcusage.svg?branch=master)](https://travis-ci.org/wighawag/gcusage)

haxe dev : [![travis status](https://travis-ci.org/wighawag/gcusage.svg?branch=dev)](https://travis-ci.org/wighawag/gcusage/branches)

lib to gather gc usage in code
See Tests/src/TestAll.hx for code examples

The Tests also serve as a live documentation on how Haxe and hxcpp deal with various type regarding gc usage.

The most notable is how adding a first element to an array or map create allocation on top of the one required for creating the array/map in the first place. 

