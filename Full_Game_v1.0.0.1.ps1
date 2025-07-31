<################################################################################################################
   PMP Processes Game

   This will prompt you to match the process with the categories

################################################################################################################>







$error.clear() 
Try{
<################################################################################################################
                                            Columns
                    # Logic for the columns--In order to use, type $data and $description
################################################################################################################>

# Define two lists
$Column1 = @("A. Integration", "B. Scope", "C. Schedule", "D. Cost", "E. Quality", "F. Resource", "G. Communications", "H. Risk", "I. Procurement", "J. Stakeholder")
$Column2 = @("1. Initiating", "2. Planning", "3. Executing", "4. Monitor and Control", "5. Closing")

# Create objects for the two columns
$Data = @()
for ($i = 0; $i -lt $Column1.Count; $i++) {
    $Data += [PSCustomObject]@{
        Column1 = $Column1[$i]
        Column2 = $Column2[$i]
    }
}

# Display the data in two columns
$description = "`n`nTo answer, Select the letter of an option from Column 1, and a Number from Column 2`
(ex: If you believe the answer falls into the Cost section during the planning, type 'D2 (Cost,Planning)'" 
$Data | Format-Table -AutoSize


<################################################################################################################
                                            Hashtable and randomized list 
################################################################################################################>

# Import the CSV file
$csvpath = gci -file -Path $(($MyInvocation.MyCommand.Path) | Split-Path) | where {$_.Name -match "answer_key"}
$csvData = Import-Csv -Path $csvpath.fullname
# Create an empty hashtable
$answerkey = @{}
# Populate the hashtable
foreach ($row in $csvData) {  
    $answerkey[$row.question] = $row.answer
} 


#Create an array that we can sort properly from the hash table
$keys = @()
$keys = $answerkey.keys
$shuffledKeys = $keys | Sort-Object {Get-Random}


<################################################################################################################
                                            Main Game Logic
################################################################################################################>
#game intro
cls
Write-host "`n `n"
$gameintro = ""
$gameintro = gci -file -Path $(($MyInvocation.MyCommand.Path) | Split-Path) | where {$_.Name -match "GameHeader"}
Get-Content $gameintro.fullname 
read-host "`n `n Press any key to Continue..."
cls
$n = ""
while ( -not([int]$n -ge 1 -and $n -le 49)) {
         $n = read-host "How many questions would you like to have? (Pick a number between 1 - 49)"        
         
    } 

#variables for a new round 

[int]$score = 0 

#for statement that goes through all questions


for ($i = 1; $i -le $n; $i++)
{ 
    clear-host
    $question= ""
    $question = $shuffledkeys[($i-1)]
    #set question variable here with random item. iterate through list
    $answer = "" 
    $answer = $answerkey[$question]
    Write-Host "###################################"
    #This will display the columns of the options
    $description
    $Data | Format-Table -AutoSize
    Write-Host "###################################"  
    
    
    [int]$wrongcounter = "0"
     while ($guess -ne $answer) {
         $guess = Read-host "What categories does $question fall into?"         
         $wrongcounter++
    } 

   #give user 1 point for right answer
    [int]$score = ($score + 1)

    #calculate how many tries it took to get the answer
    
    $wrongcounter -= 1 

    write-host "This question took you $($wrongcounter + 1) try/tries" -ForegroundColor Black -BackgroundColor White

    [int]$score = ($score - $wrongcounter) 

    write-host "Your current score is: $score. This is question $i of $n" -ForegroundColor Red -BackgroundColor White
    start-sleep -s 7.5

}

clear-host 
Write-host "Your Final Score is $score! Thanks for playing!" -ForegroundColor Red -BackgroundColor White
Start-sleep -s 25 


} Catch {

#create and dump error log 
$date = get-date -Format MMddyyyy_hhmm
$logname = "PMP Game Error" 
$logname+= ($date + ".log")
#create error log
New-item -Path C:\temp -Name $logname -ItemType File -Force -Verbose
$logfile = gci c:\temp | where {$_.name -match $logname} 
$error | out-file $logfile.FullName -Force

}