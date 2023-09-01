
# This is the two sum problem and solution in powershell
# It's entirely used for syntax practice and to generally get used to the language
# It'll be written only using basic vim (no lsp) so I can learn to write powershell without autocomplete

function Two-Sum {
	
	param(
		[System.Collections.ArrayList]$nums,
		[Int32]$target	
	)

	# create a hash table
	$map = {}; # can be written like this
	$map = [System.Collections.HashTable]@{}; # I like to be verbose instead (like Java)

	for ($i = 0; $i -lt $nums.Count; $i++) {
		$complement = $target - $nums[$i];
		if ($map.ContainsKey($complement)) {
			return @($map[$complement], $i);
		}
		$map[$nums[$i]] = $i;
    }

	throw "No numbers that summed to given target were found";	
}

# create an array of numbers to be tested
$nums = [System.Collections.ArrayList]@(3, 3, 4, 5, 6, 7, 12, 34, 68, 3, 4, 1, 2, 2, 9, 9);
$userTarget = read-host "Enter a target number: ";

write-host "Two sum solution: ";
$result = [System.Collections.ArrayList]@();
$result = Two-Sum -nums $nums -target $userTarget;
write-host "$result";



