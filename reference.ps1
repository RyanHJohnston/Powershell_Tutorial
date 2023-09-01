# This is a reference sheet for pwsh syntax, 
# Note: semicolons are not necessary, but I like having my code look like C code


# basic variables
$firstName;
$lastName;
$age;

# basic variables with specified types
[String]$firstName;
[String]$lastName;
[Int32]$age;

# Assigning variables
$firstName = "Ryan";
$lastName = "Johnston";
$age = 21;

# ArrayList
$namesList = [System.Collections.ArrayList]@("Ryan", "Maggie", "James");
# Note: ArrayList works in the same way as Java, so you can use all the usual commands
# like $namesList.remove, add, etc
$namesList.Add("Ethan");
$namesList.GetRange(1,5);
$namesList.Equals("James");
$namesList.Remove("Ethan");
$namesList.Count; # length of ArrayList 

# etc

# Hash tables
$namesTable = [System.Collections.Hashtable]@{
    ryan = "Ryan", "ryan", "RYAN" # you can have multipke values from a key
    maggie = "Maggie" # or just a single value
    james = "James" # commas indicate multiple values, no comman indicates new key
}
# You can get the values using the keys
$namesTable.Keys;
$namesTable.Values;
$namesTable.ryan # you can also just call the keys and it will output the values

# Creating custom objects
$myCustomObject = New-Object -TypeName PSCustomObject;
$myFirstCustomObject = [PSCustomObject]@{OSBuild = 'x'; OSVersion = 'y'}; # You can also write custom objects like this

# Starting a service
$serviceName = 'wuauserv';
Get-Service -Name $serviceName;
Start-Service -Name $serviceName;

# Piping commands (just like linux!)
Get-Service -Name $serviceName | Start-Service;








