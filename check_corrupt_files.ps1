# Define the folder path
$RootFolderPath = "C:\Path\To\Your\Root_Folder"

# Define the log file path
$LogFilePath = "C:\Path\To\Your\LogFile.log"

# Initialize variables
$GoodFiles = 0
$DamagedFiles = 0
$ProblematicFiles = @()
$LogContent = @()

# Add header to the log file
$LogContent += "File Integrity Check Log"
$LogContent += "========================"
$LogContent += "Scan started on: $(Get-Date)"
$LogContent += ""

Write-Host "Scanning all files in '$RootFolderPath', including all subfolders..." -ForegroundColor Cyan

try {
    # Recursively get all files in the root folder and its subfolders
    $Files = Get-ChildItem -Path $RootFolderPath -File -Recurse
} catch {
    Write-Host "Error accessing folder: $RootFolderPath" -ForegroundColor Red
    $LogContent += "Error accessing folder: $RootFolderPath"
    $LogContent | Out-File -FilePath $LogFilePath -Encoding UTF8
    exit
}

$totalFiles = $Files.Count
$currentFileIndex = 0

foreach ($File in $Files) {
    $currentFileIndex++

    # Update progress bar
    Write-Progress -Activity "Checking files" `
                   -Status "Processing $currentFileIndex of $totalFiles" `
                   -PercentComplete (($currentFileIndex / $totalFiles) * 100)

    # Convert the file path to long path format
    $LongPath = "\\?\$($File.FullName)"

    try {
        # Try to open the file in read-only mode using long path support
        $Stream = [System.IO.File]::Open($LongPath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read)
        $Stream.Close() # Close the file stream if successful
        $LogContent += "File OK: $($File.FullName)"
        $GoodFiles++
    } catch {
        # Catch any error and add the file to the problematic list
        $ErrorMessage = "Error opening file: $($File.FullName)"
        Write-Host $ErrorMessage -ForegroundColor Red
        $LogContent += $ErrorMessage
        $ProblematicFiles += $File.FullName
        $DamagedFiles++
    }
}

# Add summary to the log file
$LogContent += ""
$LogContent += "========================"
$LogContent += "Summary"
$LogContent += "========================"
$LogContent += "Total files scanned: $($Files.Count)"
$LogContent += "Good files: $GoodFiles"
$LogContent += "Damaged or corrupted files: $DamagedFiles"
$LogContent += ""

# Display summary report in console
Write-Host ""
Write-Host "Scan Summary Report:" -ForegroundColor Cyan
Write-Host "====================="
Write-Host "Total files scanned: $totalFiles"
Write-Host "Good files: $GoodFiles"
Write-Host "Damaged or corrupted files: $DamagedFiles" -ForegroundColor Red
Write-Host ""

if ($DamagedFiles -eq 0) {
    Write-Host "All files in '$RootFolderPath' and its subfolders were copied successfully!" -ForegroundColor Green
} else {
    Write-Host "The following files could not be opened:" -ForegroundColor Yellow
    $ProblematicFiles | ForEach-Object { Write-Host $_ }
}

# Write the log content to the log file
$LogContent | Out-File -FilePath $LogFilePath -Encoding UTF8

Write-Host "Scan complete. Log file saved to '$LogFilePath'" -ForegroundColor Green
