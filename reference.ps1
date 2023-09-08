# This is a reference sheet for pwsh syntax, 
# Note: semicolons are not necessary, but I like having my code look like C code


############################# BASICS AND DATA STRUCTURES #############################
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




################################## FUNCTIONS ############################################
# Cmdlet vs Functions
# Cmdlets are not written in powershell, they're written and compiled in C#
# Functions are written in PowerShell
# You can see which commands are cmdlets or functions by using Get-Command and its CommandType param


# Here's a simple function with all of the bells and whistles
function Install-Software {
    [CmdletBinding()] # Marks it so it can be used as a Cmdlet
        param( # Define a parameter block
                [Parameter(Mandatory)] # Makes the parameter input mandatory
                [ValidateSet('1','2')] # Only values 1 and 2 are valid inputs for $Version
                [string]$Version = "1", # Parameter with datatype and default value

                [Parameter(Mandatory, ValueFromPipeline)] # Allows pipeline support 
                [string]$ComputerName
             )
            process { # Process block is for code you want to exec each time the func receives pipeline input
                Write-Host "Installed software version $Version on $ComputerName";
            }

}

# Here's the function rewritten without the comments
function Install-Software {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet("1", "2")]
        [string]$Version = "1",

        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$ComputerName
    )
    process {
        Write-Host "Installed software version $Version on $ComputerName";
    }
}




########################## MODULES ##################################################

# To find modules in session: 
# Get-Module

# Each line you see from Get-Module output is a module that has been imported into the current session
# All commands inside that module are immediately available to use

# To see all exported commands in a specific module:
# Get-Command -Module Microsoft.PowerShell.Management <- this is the module name

# To get all modules available on computer
# Get-Module -ListAvailable

# System Modules:
# All system modules are found in C:\Windows\System32\WindowsPowerShell\1.0\Modules
# Used for internal PowerShell modules only, it's best practice to not put custom modules there

# User Modules:
# Located in C:\Program Files\Windows PowerShell\Modules
# Loosely called All Users module path, it's where you put any modules you'd like available to all users logged into the computer

# Current User Moduels:
# Located in C:\Useres\<Logged User>\Documents\WindowsPowerShell\Modules
# Any modules that a user created or downloaded that are available only to that current user
# Placing modules in this path allows for some separation if multiple users with different requirements will be logging into the computer

# Get-Module -ListAvailable will read all folder paths and return the modules in each

# Adding New Module Path:
# Use $PSModulePath environment variables
# It's exactly like the $PATH environment variable in Linux
# Adding new folders to module path env variable only works in current session
# To make the change persistent, use the SetEnvironmentVariable() method on Environemtn .NET class
# Examples
$env:PSModulePath
$env:PSModulePath + ';C:\NewModulePath'.

# Adding custom module file path to the env variable permantely
$CurrentValue = [Environment]::GetEnvironmentVariable("PSModulePath", "Machine");
[Environment]::SetEnvironmentVariable("PSModulePath", $CurrentValue + ";C:\MyNewModulePath", "Machine");

# To manually import a module
Import-Module -Name Microsoft.PowerShell.Management; # importing 
Import-Module -Name Microsoft.PowerShell.Management -Force; # reimporting
Remove-Module -Name Microsoft.PowerShell.Management; # removing

# Components of a PowerShell Module
# Any .psm1 file is a PowerShell Module
# It must have functions inside it
# Not strictly required, all functions inside a module should be built around the same concept
# The noun in each cmd function must stay the same, and only the verb changes
# If noun needs to change, then create another module

# Example of Creating functions inside of a module
function Get-Software {
    param()
}

function Install-Software {
    param()
}

function Remove-Software {
    param()
}

# Module Manifest
# While .psm1 file is full of functions, a .psd1 file (module manifest) is an optional but recommended text file written in the form of a PowerShell hashtable
# The table contains elements that describe metadata about the module
# You can write the module manifest from scratch, but you can use the New-ModuleManifest to build a module manifest for your software package

# Creating a module manifest using New-ModuleManifest
New-ModuleManifest -Path 'C:\Program Files\WindowsPowerShell\Modules\Software\Software.psd1' -Author 'Ryan Johnston' -RootModule Software.psm1 -Description 'This module helps in deploying software'

# Example of a .psd1 file, module manifest
# 
# Generated by: Ryan Johnston
#
# Generated on: 00/0/0000
#

@{

    # Script module or binary module file associated with this manifest.
    RootModule = 'Software.psm1'

    # Version number of this module
    ModuleVersion = '1.0'

    # Supported PSEditions
    CompatiblePSEditions = @()
    
    # ID used to uniquely identify this module
    GUID = 'c9f51fa4-8a20-4d35-a9e8-1a960566483e'

    # Author of this module
    Author = 'Ryan Johnston'

    # Company or vendor of this module
    CompanyName = 'Unknown'

    # Copyright statement for this module
    Copyright = '(c) 2019 Adam Bertram. All rights reserved.'
    
    # Description of the functionality provided by this module
    Description = 'This modules helps in deploying software.'
    
    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = ''
    
    # Name of the Windows PowerShell host required by this module
    PowerShellHostName = ''
}


# Finding Modules
# https://www.powershellgallery.com/ is a repo with thousands of pwsh modules and scripts
# PowerShellGet is a cmdlet that interacts with the pwsh gallery

# Listing all PowerShellGet commands
Get-Command -Module PowerShellGet

# Finding a module
Find-Module -Name *VMware*

# Installing a module
Find-Module -Name VMware.PowerCLI | Install-Module

# To check if a module was installed in the All Users module path
Get-Module -Name VMware.PowerCLI -ListAvailable | Select-Object -Property ModuleBase

# To Uninstall (not remove, they are different) a module
Uninstall-Module -Name VMware.PowerCLI

# Removing a module removes a module from the current session, this only unloads the module from the session, it doesn't remove it from the disk
# To take a module off the disk (uninstall it) use Uninstall-Module

# You can create your own module, but it's easier to just find an already existing one
# If you NEED to create a module, read the PowerShell for SysAdmins book for more information




################################ RUNNING SCRIPTS REMOTELY ##############################

# Working with Scriptblocks
# scriptblocks are functions that are code packaged into a single executable unit
# They're different from functions in key ways: they're unnamed and can be assigned to variables

# Example of function and script block differences:

# FUNCTION
function New-Thing {
    param()
    Write-Host "New thing";
}

# SCRIPTBLOCK
$newThing = { Write-Host "New thing"; }

New-Thing;
$newThing;


# Use Invoke-Command to execute code on remote systems
$computerAsset = "rr711091ip01";
Invoke-Command -ScriptBlock { hostname } -ComputerName $computerAsset;

# --- Running local scripts on remote computers ---
# You can use Invoke-Command to exec scripts on a remote machine
# It runs the code inside the specified .ps1 script on the specified remote computer
Invoke-Command -ComputerName $computerAsset -FilePath C:\GetHostName.ps1

# --- Using local variables remotely ---
# Local variables do not work in remote sessions
# You can use a couple of methods to use variables and functions in various runspaces
# Mainly two waysa

# --- Passing varaibles with the ArgumentList Parameter ---
# To get the value of a variable into a remote scriptbloc, you can use the ArgumentList parameter on Invoke-Command
# This parameter allows you to pass an array of local values to the scriptblock, called $args, which you cna use in your scriptblock's code

Invoke-Command -ComputerName $computerAsset -ScriptBlock { Write-Host "The value of foo is $($args[0])" } -ArgumentList $serverFilePath;

# Using the $Using statement to pass variables values
Invoke-Command -ComputerName $computerAsset -ScriptBlock { Write-Host "the value of foo is $using:serverFilePath" }

# --- Creating a New Session ---
# To create a semipermanent session on a remote computer, use the New-PSSession command, which will create a session on the remote computer and reference to that session on your local computer
# To connect using the ComputerName parameter, the user msut be a local administrator or at least in the Remote Management Users group on the remote computer
# If the user is not in the AD domain, you can use the Credential parameter on New-PSSession to pass a PSCredential object containing an alternate credential to authenticate to the remote computer

# Creaing a new session on a remote computer
New-PSSession -ComputerName $computerAsset;

# New-PSSession returns a session
# Once it is established, you can jump in and out of the session with Invoke-Command
# Instead of using -ComputerName, use the Session parameter

# Getting created session
$session = Get-PSSession;
$session;

# --- Inovking Commands in a Session ---
# Pass the established session (stored in a variable) to Invoke-Command and run some code inside the session

# Running Invoke-Command in established session
Invoke-Command -Session $session -ScriptBlock { hostname; }

# Setting variables in remote session and return to the session without losing those variables
Invoke-Command -Session $session -ScriptBlock { $foo = "Please be here next time" }
Invoke-Command -Session $session -ScriptBlock { $foo; }

# --- Opening Interactive Sessions ---
# Using Invoke-Command sends commands to remote computer but it does not open an interactive session
# Enter-PSSession command allows the user to wwork with the session interactively

# Open an interactive session
$computerName = "BBLAB017";
Enter-PSSession -ComputerName $computerName;

# Disconnecting from a session
Get-PSSession | Disconnect-PSSession;

# To reconnect to an already-created session
Connect-PSSession -ComputerName $computerName;

# To check whether your local computer's pwsh version matches the version on the remote computer
Invoke-Command -ComputerName $computerName -ScriptBlock { $PSVersionTable; }

# --- Removing Sessions ---
# Whenever the New-PSSession command creates a new session, that session exists on both the remote server and local computer
# To clean up the servers of the sessions after use, use Remove-PSSession

# Removing session with Remove-PSSession
Get-PSSession | Remove-PSSession

# --- Authentication with CredSSP and Active Directories ---
# See the book for more information



############################## TESTING WITH PESTER ####################################
# A Pester test script consists of a pwsh script ending in .Tests.ps1
# The structure is as follows: 
# A Pester test script is one or more 'describe' blocks that each contain an optional 'context' block that each contain 'it' blocks that each contain 'assertions'

# --- The 'describe' Block ---
# Group like-tests together, the describe blocks can be named
# The one below is named IIS
# They are not if/then conditions
# They are scriptblocks that are passed to the Describe function
# They cannot syntatically work with newline brackets, they must be on the same line

# --- The 'context' Block
# Optinoal context block groups together similar 'it' blocks, which helps organize tests when infrastructure testing
# Ths given 'context' block contains all the tests for Windows features
# Valuable when testing dozen or hundreds of components 

# --- The 'it' Block
# Smaller component that labels the actual test

# --- Assertions ---
# An assertion is an atual test, or the code that compares the expected state to an actual state
# The most common assertion is the 'should' assertion, which has different operators.
# The operators: be, bein, belessthan, and so on
# List of all operators in Pester wiki on their github page

# Full pester block that tests whether a windows feature is installed
Describe 'IIS' {
    Context 'Windows Features' {
        It 'installs the Web-Server Windows feature' {
            $parameters = @{
                ComputerName = 'rr711012ip01'
                Name         = 'Web-Server'
            }
            (Get-WindowsFeature @parameters).Installed | Should Be $true
        }
    }
}

# --- Executing a Pester Test ---
Invoke-Pester -Path C:\Sample.Tests.ps1;



############################### AUTOMATING ACTIVE DIRECTORY ############################
# Employees are entering, leaving, and moving around an organization
# A dynamic system is needed to keep track of the ever shifting flux of employees
# AD (Active Directory) comes in 
# AD objects can be manipulated with pwsh
# Three of the most common AD objects: user accounts, computer accounts, and groups
# These types of objects are the ones an AD admin will most likely encounter on a daily basis

# Check if installed, if not, install it
Get-Module -Name ActiveDirectory -List

# --- Querying and Filtering AD Objects ---
# Look for commands associated with the objects we'll be working with

# Retrieve only the ActiveDirectory commands that begin with Get and ahve the word 'computer' somehwere in verb porition
Get-Command -Module ActiveDirectory -Verb Get -Noun *computer*;

# Repeat with user and group
Get-Command -Module ActiveDirectory -Verb Get -Noun *user*;
Get-Command -Module ActiveDirectory -Verb Get -Noun *group*;

# --- Filerting Objects ---
# Many AD commands use a parameter called Filter
# Filter is similar to Where-Object command as it filters what each command returns, but Filter is different
# Filter parameter uses its own syntax and can be difficult to understand, especially with complex filters
# Filtering AD objects queries to the AD database, so you're essentially writing database queries using fancy pwsh cmds

# For more help on Filter parameter
Get-Help about_ActiveDirectory_Filter;

# Return all users in domain (may take awhile)
Get-ADUser -Filter *;

# To find all computer accounts in AD that start with the letter C
Get-ADComputer -Filter 'Name -like "C*"';

# To find all last names that end with 'son'
Get-ADComputer -Filter 'Name -like "*son"';

# To find all users that have a last name of Jones
Get-ADUser -Filter "surName -eq 'Jones'";

# --- Using Search-ADAccount Cmd ---
# Built-in support fr common filtering scenarioes such as finding all users with an expired password, finding locked-out users, and finding computers that are enabled
# Returns object type of Microsoft.ActiveDirectory.Management.ADUser

# To see full range of parameters for Search-ADAccount
Get-Help Search-ADAccount;

# To find all users who haven't used their account in 90 days
Search-ADAccouunt -AccountInactive -TimeSpan 90.00:00:00 -UsersOnly;

# --- Returning Single Objects ---
# Sometimes you know the exact AD object you're looking for, so there's no need to use Filter
# Use -Identity parameter instead
# -Identity allows you to specify attributes that make an AD object unique, thus returns only a single object
# Every user account has a unique attribute called samAccountName
# You could use the -Filter parameter to find all users with a specific samAccountName

# Find all users with a specific samAccountName
Get-ADUser -Filter "samAccountName -eq 'jjones'";

# Use -Identity for cleaner code
Get-ADUser -Identity jjones;

# Find user accounts that haven't changed their password in 30 days
Get-ADUser -Filter * -Properties passwordlastset | Select-Object name,passwordlastset;

# Now that attribute name is acquired, build a filter for it
$today = Get-Date;
$30DaysAgo = $today.AddDays(-30);
Get-ADUser -Filter "passwordlastset -lt '$30DaysAgo'";

# Add Enabled condition to the filter
Get-ADUser -Filter "Enabled -eq 'True' -and passwordlastset -lt '$30DaysAgo'";

# --- Creating and Changing AD Objects ---
# Users and Computers
# To change users and computer accounts, use a Set command
# Either Set-ADUser or Set-ADComputer

# Let's say an employee named Janes Jones got married and you have to change their last name of their user account
# Before using -Filter, you need to find attributes and pass to the -Filter parameter
# One way to find all available attributes stored in AD is with a little .NET
# Using a schema object, you can find the user class and enumerate all of its attributes
$schema = [DirectoryServices.ActiveDirectory.ActiveDirectorySchema]::GetCurrentSchema();
$userClass = $schema.FindClass('user');
$userClass.GetAllProperties().Name;

# By reviewing the available attribute list, you then find the givenName and surName attribute to use in the -Filter parameter with the Get-ADUser command, finding the user account
# Next you can pass that object to Set-ADUser
Get-ADUser -Filter "givenName -eq 'Jane' -and surName -eq 'Jones'" | Set-ADUser -Surname 'Smith';
Get-ADUser -Filter "givenName -eq 'Jane' -and surName -eq 'Smith'";

# You can also change multiple attributes at once
Get-ADUser -Filter "givenName -eq 'Jane' -and surname -eq 'Smith'" | Set-ADuser -Department 'HR' -Title Director;
Get-ADUser -Filter "givenName -eq 'Jane' -and surname -eq 'Smith'" -Properties GivenName,SurName,Department,Title;

# To create a new AD object (user, computer, group)
New-ADUser -Name $userName;
New-ADComputer -Name $computerName;


# Groups
# Groups are a container for many AD objects
# It's still a single container, just like users and computers
# Querying, creating, and changing groups is the same as users/objects with slight differences

# Create a new group called 'AdamBertramLovers' (-GroupScope could be DomainLocal, Global, or Universal)
New-ADGroup -Name 'AdamBertramLovers' -Description 'All Adam Bertram lovers in the company' -GroupScope DomainLocal

# You can modify the new group AD object
Get-ADGroup -Identity AdamBertramLovers | Set-ADGroup -Description 'More Adam Bertram Lovers';

# Main difference between groups and users/computers is that groups contain users and computers
# When a computer or a user account is contained within a group, the user/computer is a 'member' of that group
# To modify the groups, you need to use Add-ADGroupMember and Remove-ADGroupMember

# Adding/Removing users (group members) from a group AD object (use -Force parameter to skip check)
Get-ADGroup -Identity AdamBertramLovers | Add-ADGroupMember -Members 'jjones';
Get-ADGroup -Identity AdamBertramLovers | Remove-ADGroupMember -Members 'jjones';

# Read the rest of the chapter to see how to:
# Map data source attributes (read csv/excel files or sql databases)
# Finding matches in an active directory
# Change Active Directory Attributes
# Creating functions to return similar properties


