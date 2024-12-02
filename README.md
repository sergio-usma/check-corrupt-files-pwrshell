# 🔍 File Integrity Check Script

This PowerShell script is designed to check the integrity of files within a specified folder and its subfolders. It attempts to open each file to verify it was copied correctly and is not corrupted. The script also supports handling long file paths that exceed the Windows `MAX_PATH` length limitation.

## ✨ Features

- **Recursive Scanning:** Scans all files in the specified folder and its subfolders
- **Long Path Support:** Uses the `\\?\` prefix to bypass the Windows path length limit of 260 characters
- **Error Handling:** Identifies and logs files that cannot be opened
- **Progress Bar:** Displays a real-time progress bar during the scan
- **Summary Report:** Outputs a summary of the scan in the console, including:
  - Total files scanned
  - Number of good files
  - Number of damaged or corrupted files
- **Log File Generation:** Saves detailed results to a log file for further review

## 🛠️ Prerequisites

- PowerShell 5.1 or later
- Long path support enabled in Windows 10 or later. To enable it:
  1. Open the Group Policy Editor (`gpedit.msc`)
  2. Navigate to `Local Computer Policy > Computer Configuration > Administrative Templates > System > Filesystem`
  3. Enable the policy `Enable Win32 long paths`

## 📚 Usage

1. **Clone or download the script**
2. **Modify the script:**
   - Set the `RootFolderPath` variable to the full path of the folder you want to scan
   - Set the `LogFilePath` variable to the desired path for the log file
3. **Run the script:**
   Open PowerShell as Administrator and execute the script:

```sh
./CheckFileIntegrity.ps1
```

## 📋 Output

### 💻 Console
- A progress bar showing the scanning progress
- A summary report, including:
  - Total files scanned
  - Number of good files
  - Number of damaged or corrupted files
- Lists of problematic files directly in the console

### 📝 Log File
A log file is generated at the specified `LogFilePath`, containing:
- A list of all files scanned and their statuses (OK or Error)
- A summary of the total, good, and problematic files

### 📊 Example Output

#### Console Output

```sh
Scanning all files in 'C:\Path\To\Your\Root_Folder', including all subfolders...

Scan Summary Report:
=====================
Total files scanned: 100
Good files: 95
Damaged or corrupted files: 5

The following files could not be opened:
C:\Path\To\Your\Root_Folder\DamagedFile1.txt
C:\Path\To\Your\Root_Folder\DamagedFile2.txt

Scan complete. Log file saved to 'C:\Path\To\Your\LogFile.log'
```

#### Log File Output

```sh
File Integrity Check Log
========================
Scan started on: 2024-12-01 12:34:56

File OK: C:\Path\To\Your\Root_Folder\File1.txt
File OK: C:\Path\To\Your\Root_Folder\File2.txt
Error opening file: C:\Path\To\Your\Root_Folder\DamagedFile1.txt
Error opening file: C:\Path\To\Your\Root_Folder\DamagedFile2.txt

========================
Summary
========================
Total files scanned: 100
Good files: 95
Damaged or corrupted files: 5
```

## ⚙️ Customization

- **Change the root folder path:** Modify the `RootFolderPath` variable in the script to scan a different folder
- **Change the log file location:** Modify the `LogFilePath` variable to save the log file in a different location

## 📌 Notes

- Ensure you have read permissions for all files and folders being scanned
- The script does not validate file content but only checks whether files can be opened

## ❓ Troubleshooting

If the script fails to run due to execution policy restrictions, you can bypass them temporarily:

```sh
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

## 📜 License

This script is open-source and free to use. Modify it as needed to suit your requirements.
