<#
Get-CultureTables.ps1
#>


# Set the common parameters
$path = $env:temp
$start_time = Get-Date
$ErrorActionPreference = "Stop"
$cultures = @()
$entities = @()
$languages = @()
$merge = @()
$global = 0




# Step 1
# Get-Cultures (n = over 250, perhaps? Depends on the .NET Framework.)
# Source: https://msdn.microsoft.com/en-us/library/system.globalization.culturetypes(v=vs.110).aspx
$installed_cultures = [System.Globalization.CultureInfo]::GetCultures('InstalledWin32Cultures')
$culture_list = [System.Globalization.CultureInfo]::GetCultures('AllCultures')

        ForEach ($culture in $culture_list) {


                    If ((($culture | Select-Object -ExpandProperty Parent).EnglishName) -like "*Invariant Language*") {
                        $name = $culture.EnglishName
                    } Else {
                        $name = (($culture | Select-Object -ExpandProperty Parent).EnglishName)
                    } # Else


                    If ($name.Contains("(")) {
                        $real_name = ($name.Split("(")[0]).Trim()
                    } Else {
                        $real_name = $name
                    } # Else


                            $cultures += New-Object -TypeName PSCustomObject -Property @{

                                        'Parent'                                    = $culture.Parent
                                        'LCID'                                      = $culture.LCID
                                        'LCID 2'                                    = ($culture | Select-Object -ExpandProperty TextInfo).LCID
                                        'KeyboardLayoutId'                          = $culture.KeyboardLayoutId
                                        'Name'                                      = $culture.Name
                                        'RealName'                                  = $name
                                        'RealRealName'                              = $real_name
                                        'Locale'                                    = ($culture | Select-Object -ExpandProperty TextInfo).CultureName
                                        'IetfLanguageTag'                           = $culture.IetfLanguageTag
                                        'DisplayName'                               = $culture.DisplayName
                                        'NativeName'                                = $culture.NativeName
                                        'EnglishName'                               = $culture.EnglishName
                                        'TwoLetterISOLanguageName'                  = $culture.TwoLetterISOLanguageName
                                        'ThreeLetterISOLanguageName'                = $culture.ThreeLetterISOLanguageName
                                        'ThreeLetterWindowsLanguageName'            = $culture.ThreeLetterWindowsLanguageName
                                        'CompareInfo'                               = $culture.CompareInfo
                                        'TextInfo'                                  = $culture.TextInfo
                                        'IsNeutralCulture'                          = $culture.IsNeutralCulture
                                        'CultureTypes'                              = $culture.CultureTypes
                                        'Calendar'                                  = $calendar
                                        'CalendarType'                              = ($culture | Select-Object -ExpandProperty Calendar).AlgorithmType
                                        'calendar_original'                         = $culture.Calendar
                                        'UseUserOverride'                           = $culture.UseUserOverride
                                        'IsReadOnly'                                = $culture.IsReadOnly
                                        'IsRightToLeft'                             = ($culture | Select-Object -ExpandProperty TextInfo).IsRightToLeft
                                        'ListSeparator'                             = ($culture | Select-Object -ExpandProperty TextInfo).ListSeparator
                                        'ANSICodePage'                              = ($culture | Select-Object -ExpandProperty TextInfo).ANSICodePage
                                        'OEMCodePage'                               = ($culture | Select-Object -ExpandProperty TextInfo).OEMCodePage
                                        'MacCodePage'                               = ($culture | Select-Object -ExpandProperty TextInfo).MacCodePage
                                        'EBCDICCodePage'                            = ($culture | Select-Object -ExpandProperty TextInfo).EBCDICCodePage
                                        'ParentLCID'                                = ($culture | Select-Object -ExpandProperty Parent).LCID
                                        'ParentKeyboardLayoutId'                    = ($culture | Select-Object -ExpandProperty Parent).KeyboardLayoutId
                                        'ParentName'                                = ($culture | Select-Object -ExpandProperty Parent).Name
                                        'ParentIetfLanguageTag'                     = ($culture | Select-Object -ExpandProperty Parent).IetfLanguageTag
                                        'ParentDisplayName'                         = ($culture | Select-Object -ExpandProperty Parent).DisplayName
                                        'ParentNativeName'                          = ($culture | Select-Object -ExpandProperty Parent).NativeName
                                        'ParentEnglishName'                         = ($culture | Select-Object -ExpandProperty Parent).EnglishName
                                        'ParentTwoLetterISOLanguageName'            = ($culture | Select-Object -ExpandProperty Parent).TwoLetterISOLanguageName
                                        'ParentThreeLetterISOLanguageName'          = ($culture | Select-Object -ExpandProperty Parent).ThreeLetterISOLanguageName
                                        'ParentThreeLetterWindowsLanguageName'      = ($culture | Select-Object -ExpandProperty Parent).ThreeLetterWindowsLanguageName

                            } # New-Object

        } # ForEach $culture

$cultures.PSObject.TypeNames.Insert(0,"Cultures")
$cultures_selection = $cultures | Select-Object 'EnglishName','RealRealName','ParentNativeName','DisplayName','ParentTwoLetterISOLanguageName','ParentIetfLanguageTag','Parent','ThreeLetterWindowsLanguageName','Name','Locale','IetfLanguageTag','OEMCodePage','KeyboardLayoutId','ANSICodePage','IsNeutralCulture','ParentThreeLetterISOLanguageName','ParentThreeLetterWindowsLanguageName','ParentName','Calendar','ParentKeyboardLayoutId','LCID','UseUserOverride','ThreeLetterISOLanguageName','IsRightToLeft','ParentEnglishName','ParentDisplayName','NativeName','MacCodePage','EBCDICCodePage','ListSeparator','ParentLCID','TwoLetterISOLanguageName','CalendarType','IsReadOnly','RealName','LCID 2','TextInfo','CompareInfo','calendar_original','CultureTypes'
$cultures_selection | Out-GridView
$cultures_selection | Export-Csv "$path\cultures.csv" -Delimiter ";" -NoTypeInformation -Encoding UTF8




# Step 2
# Check if the computer is connected to the Internet                                          # Credit: ps1: "Test Internet connection"
If (([Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]'{DCB00C01-570F-4A9B-8D69-199FDBA5723B}')).IsConnectedToInternet) -eq $false) {
    $empty_line | Out-String
    Return "The Internet connection doesn't seem to be working. Exiting without downloading any culture files."
} Else {
    $shell = New-Object -Com Shell.Application
    $empty_line | Out-String
    $timestamp = Get-Date -Format HH:mm:ss
    $update_text = "$timestamp - Initiating the culture files download session..."
    Write-Output $update_text
} # else

# "Manual" progress bar variables
$activity             = "Downloading Culture Files"
$status               = "Status"
$id                   = 1 # For using more than one progress bar
$total_steps          = 45 # Total number of the steps or tasks, which will increment the progress bar
$task_number          = 0.2 # An increasing numerical value, which is set at the beginning of each of the steps that increments the progress bar (and the value should be less or equal to total_steps). In essence, this is the "progress" of the progress bar.
$task                 = "Setting Initial Variables" # A description of the current operation, which is set at the beginning of each of the steps that increments the progress bar.

# Start the progress bar
Write-Progress -Id $id -Activity $activity -Status $status -CurrentOperation $task -PercentComplete (($task_number / $total_steps) * 100)




# Step 3
# Get-Languages (n = ~8000, plus some regions and other variants - totaling OVER 9000!, lol)
# Retrieve a Language Tags list from Internet Assigned Numbers Authority (IANA) Protocol Registry - Language Subtag Registry (RFC 5646)
# Source: http://www.iana.org/protocols
# Source: Tobias Weltner: "PowerTips Monthly vol 10 March 2014" (Read raw web page content)
# Source: http://stackoverflow.com/questions/8163061/passing-a-function-to-powershells-replace-function
# Source: https://datatracker.ietf.org/doc/rfc5646/
$task_number = 1
$task = "Downloading RFC 5646 Language Subtag Registry from the Internet Assigned Numbers Authority (IANA)..."
Write-Progress -Id $id -Activity $activity -Status $status -CurrentOperation $task -PercentComplete (($task_number / $total_steps) * 100)

$secondary_download_url = 'https://www.ietf.org/assignments/language-subtag-registry/language-subtag-registry'
$iana_url = 'http://www.iana.org/assignments/language-subtag-registry/language-subtag-registry'
$web_crawler = New-Object System.Net.WebClient
$raw_iana_language_data = $web_crawler.DownloadString($iana_url)
$raw_iana_language_data | Out-File "$path\languages_IANA.txt" -Encoding Default


# Modify the IANA file
# In the IANA file double space_bar-hits ("  ") seem to represent a carriage_return/line_feed/tabulator -command-combo inside a topic or a header.
# $lines = $entry.Split("`n")
# $string = Get-Content test.txt -ReadCount $lines.Count | ForEach {$_ -Join ""}
$task_number = 4
$task = "Converting the RFC 5646 Language Subtag Registry list file to CSV..."
Write-Progress -Id $id -Activity $activity -Status $status -CurrentOperation $task -PercentComplete (($task_number / $total_steps) * 100)

$file_date_info = $raw_iana_language_data.Split("`n")[0]
    $info_obj = ConvertFrom-StringData (("Type = $file_date_info;Number = 0").Replace(";","`n"))
    $entities += $info_obj
$iana_modified_data = $raw_iana_language_data.Replace("$file_date_info","").Replace('"','\/').Replace("\/","'").Replace(';',' -').Replace('Type: ',';Type = ').Replace("  ","¤¤  ").Replace('Tag: ',';Tag = ').Replace('Subtag: ',';Subtag = ').Replace('Description: ',';Description = ').Replace('Added: ',';Added = ').Replace('Deprecated: ',';Deprecated = ').Replace('Preferred-Value: ',';Preferred-Value = ').Replace('Comments: ',';Comments = ').Replace('Suppress-Script: ',';Suppress-Script = ').Replace('Scope: ',';Scope = ').Replace('Macrolanguage: ',';Macrolanguage = ').Replace('Prefix: ',';Prefix = ').Replace("`n","").Replace("¤¤ ","")
$registry_items = $iana_modified_data.Replace("%%","%%Number =").Split('%%') | Where { ($_.Trim() -ne "") }

ForEach ($entry in $registry_items) {

    $global += 1

    $counter_1 = 0
    $counter_2 = 0
    $pattern_1 = "Description ="
    $pattern_2 = "Prefix ="
    $lines = $entry -split ';'
    $string_data = ForEach ($line in $lines) {

            # Replace the duplicate headers with generic header names
            If ($line.Contains($pattern_1) -eq $true) {
                Write-Verbose "Multiple occurrences of the Description-header found in a single entry."
                $counter_1++
                $line.Replace(($pattern_1.TrimEnd(" =")), "Description_" + $counter_1)
            } ElseIf ($line.Contains($pattern_2) -eq $true) {
                Write-Verbose "Multiple occurrences of the Prefix-header found in a single entry."
                $counter_2++
                $line.Replace(($pattern_2.TrimEnd(" =")), "Prefix_" + $counter_2)
            } Else {
                $line
            } # Else

        } # ForEach $line

    $alfa = $string_data -join ";"
    $beta = $alfa.Replace("Number =", ";Number = $($global)")




    # Add extra ("missing") headers (/empty data) for the CSV export
    If (($beta -match ';Subtag =') -eq $false)              { $gamma = $beta.Replace(";Number =", ";Subtag =;Number =") }                 Else { $gamma = $beta }
    If (($gamma -match ';Description_1 =') -eq $false)      { $delta = $gamma.Replace(";Number =", ";Description_1 =;Number =") }         Else { $delta = $gamma }
    If (($delta -match ';Added =') -eq $false)              { $epsilon = $delta.Replace(";Number =", ";Added =;Number =") }               Else { $epsilon = $delta }
    If (($epsilon -match ';Comments =') -eq $false)         { $zeta = $epsilon.Replace(";Number =", ";Comments =;Number =") }             Else { $zeta = $epsilon }
    If (($zeta -match ';Deprecated =') -eq $false)          { $eta = $zeta.Replace(";Number =", ";Deprecated =;Number =") }               Else { $eta = $zeta }
    If (($eta -match ';Macrolanguage =') -eq $false)        { $theta = $eta.Replace(";Number =", ";Macrolanguage  =;Number =") }          Else { $theta = $eta }
    If (($theta -match ';Suppress-Script =') -eq $false)    { $iota = $theta.Replace(";Number =", ";Suppress-Script =;Number =") }        Else { $iota = $theta }
    If (($iota -match ';Preferred-Value =') -eq $false)     { $kappa = $iota.Replace(";Number =", ";Preferred-Value =;Number =") }        Else { $kappa = $iota }
    If (($kappa -match ';Scope =') -eq $false)              { $lamda = $kappa.Replace(";Number =", ";Scope =;Number =") }                 Else { $lamda = $kappa }
    If (($lamda -match ';Prefix_1 =') -eq $false)           { $mu = $lamda.Replace(";Number =", ";Prefix_1 =;Number =") }                 Else { $mu = $lamda }
    If (($mu -match ';Tag =') -eq $false)                   { $nu = $mu.Replace(";Number =", ";Tag =;Number =") }                         Else { $nu = $mu }
    If (($nu -match ';Description_2 =') -eq $false)         { $xi = $nu.Replace(";Number =", ";Description_2 =;Number =") }               Else { $xi = $nu }
    If (($xi -match ';Description_3 =') -eq $false)         { $omicron = $xi.Replace(";Number =", ";Description_3 =;Number =") }          Else { $omicron = $xi }
    If (($omicron -match ';Description_4 =') -eq $false)    { $pi = $omicron.Replace(";Number =", ";Description_4 =;Number =") }          Else { $pi = $omicron }
    If (($pi -match ';Description_5 =') -eq $false)         { $rho = $pi.Replace(";Number =", ";Description_5 =;Number =") }              Else { $rho = $pi }
    If (($rho -match ';Description_6 =') -eq $false)        { $sigma = $rho.Replace(";Number =", ";Description_6 =;Number =") }           Else { $sigma = $rho }
    If (($sigma -match ';Description_7 =') -eq $false)      { $tau = $sigma.Replace(";Number =", ";Description_7 =;Number =") }           Else { $tau = $sigma }
    If (($tau -match ';Prefix_2 =') -eq $false)             { $upsilon = $tau.Replace(";Number =", ";Prefix_2 =;Number =") }              Else { $upsilon = $tau }
    If (($upsilon -match ';Prefix_3 =') -eq $false)         { $phi = $upsilon.Replace(";Number =", ";Prefix_3 =;Number =") }              Else { $phi = $upsilon }
    If (($phi -match ';Prefix_4 =') -eq $false)             { $chi = $phi.Replace(";Number =", ";Prefix_4 =;Number =") }                  Else { $chi = $phi }
    If (($chi -match ';Prefix_5 =') -eq $false)             { $psi = $chi.Replace(";Number =", ";Prefix_5 =;Number =") }                  Else { $psi = $chi }
    If (($psi -match ';Prefix_6 =') -eq $false)             { $omega = $psi.Replace(";Number =", ";Prefix_6 =;Number =") }                Else { $omega = $psi }
    If (($omega -match ';Prefix_7 =') -eq $false)           { $alfa_alfa = $omega.Replace(";Number =", ";Prefix_7 =;Number =") }          Else { $alfa_alfa = $omega }
    If (($alfa_alfa -match ';Prefix_8 =') -eq $false)       { $alfa_beta = $alfa_alfa.Replace(";Number =", ";Prefix_8 =;Number =") }      Else { $alfa_beta = $alfa_alfa }
    If (($alfa_beta -match ';Prefix_9 =') -eq $false)       { $alfa_gamma = $alfa_beta.Replace(";Number =", ";Prefix_9 =;Number =") }     Else { $alfa_gamma = $alfa_beta }
    If (($alfa_gamma -match ';Prefix_10 =') -eq $false)     { $alfa_delta = $alfa_gamma.Replace(";Number =", ";Prefix_10 =;Number =") }   Else { $alfa_delta = $alfa_gamma }

    $output = $alfa_delta.Replace(";","`n")

    $obj = ConvertFrom-StringData $output

    $entities += $obj

} # ForEach $entry




ForEach ($item in $entities) {

                    $languages += New-Object -TypeName PSCustomObject -Property @{

                                'Added'                           = $item.Get_Item("Added")
                                'Comments'                        = $item.Get_Item("Comments")
                                'Deprecated'                      = $item.Get_Item("Deprecated")
                                'Description_1'                   = $item.Get_Item("Description_1")
                                'Description_2'                   = $item.Get_Item("Description_2")
                                'Description_3'                   = $item.Get_Item("Description_3")
                                'Description_4'                   = $item.Get_Item("Description_4")
                                'Description_5'                   = $item.Get_Item("Description_5")
                                'Description_6'                   = $item.Get_Item("Description_6")
                                'Description_7'                   = $item.Get_Item("Description_7")
                                'Macrolanguage'                   = $item.Get_Item("Macrolanguage")
                                'Number'                          = [int]$item.Get_Item("Number")
                                'Preferred-Value'                 = $item.Get_Item("Preferred-Value")
                                'Prefix_1'                        = $item.Get_Item("Prefix_1")
                                'Prefix_2'                        = $item.Get_Item("Prefix_2")
                                'Prefix_3'                        = $item.Get_Item("Prefix_3")
                                'Prefix_4'                        = $item.Get_Item("Prefix_4")
                                'Prefix_5'                        = $item.Get_Item("Prefix_5")
                                'Prefix_6'                        = $item.Get_Item("Prefix_6")
                                'Prefix_7'                        = $item.Get_Item("Prefix_7")
                                'Prefix_8'                        = $item.Get_Item("Prefix_8")
                                'Prefix_9'                        = $item.Get_Item("Prefix_9")
                                'Prefix_10'                       = $item.Get_Item("Prefix_10")
                                'Scope'                           = $item.Get_Item("Scope")
                                'Subtag'                          = $item.Get_Item("Subtag")
                                'Suppress-Script'                 = $item.Get_Item("Suppress-Script")
                                'Tag'                             = $item.Get_Item("Tag")
                                'Type'                            = $item.Get_Item("Type")

                    } # New-Object

} # ForEach $item

$languages.PSObject.TypeNames.Insert(0,"Languages")
$languages_selection = $languages | Select-Object 'Type','Number','Subtag','Description_1','Added','Comments','Deprecated','Macrolanguage','Suppress-Script','Preferred-Value','Scope','Prefix_1','Tag','Description_2','Description_3','Description_4','Description_5','Description_6','Description_7','Prefix_2','Prefix_3','Prefix_4','Prefix_5','Prefix_6','Prefix_7','Prefix_8','Prefix_9','Prefix_10'
# $languages_selection | Out-GridView
$languages_selection | Export-Csv "$path\languages_IANA.csv" -Delimiter ";" -NoTypeInformation -Encoding Default




# Step 4
# Get-Languages (n = ~480 + )
# ISO 639-2 Registration Authority (RA) and ISO 639-1 language codes as hosted by US Library of Congress.
# Download a list of ISO 639-2/RA language codes with their language names with five headers:
# Source: http://www.loc.gov/standards/iso639-2/
# Source: http://www.loc.gov/standards/iso639-2/php/code_list.php
# Source: http://www.loc.gov/standards/iso639-2/ascii_8bits.html

<#
            ISO 639-2 Alpha-3 Code (B) Bibliographic
            ISO 639-2 Alpha-3 Code (T) Terminology
            ISO 639-1 Alpha-2 Code
            English Name of Language
            French Name of Language
#>
$task_number = 6
$task = "Downloading ISO 639-2 Registration Authority (RA) and ISO 639-1 language codes..."
Write-Progress -Id $id -Activity $activity -Status $status -CurrentOperation $task -PercentComplete (($task_number / $total_steps) * 100)

$us_iso_639_url = 'http://www.loc.gov/standards/iso639-2/ISO-639-2_utf-8.txt'
$downloader = New-Object System.Net.WebClient
$raw_language_data = $downloader.DownloadString($us_iso_639_url)
$raw_language_data | Out-File "$path\languages_ISO_639.txt" -Encoding Default

$task_number = 9
$task = "Converting the ISO 639-2 Registration Authority (RA) and ISO 639-1 language codes file to CSV..."
Write-Progress -Id $id -Activity $activity -Status $status -CurrentOperation $task -PercentComplete (($task_number / $total_steps) * 100)

$modified_language_data = $raw_language_data.Replace(";",",")
$languages_iso_639 = ConvertFrom-Csv $modified_language_data -Delimiter "|" -Header "ISO 639-2 Alpha-3 Code (B) Bibliographic","ISO 639-2 Alpha-3 Code (T) Terminology","ISO 639-1 Alpha-2 Code","English Name of Language","French Name of Language"
# $languages_iso_639 | Out-GridView
$languages_iso_639 | Export-Csv "$path\languages_ISO_639.csv" -Delimiter ";" -NoTypeInformation -Encoding Default




# Step 5
# Internet Engineering Task Force (IETF) Language Codes
# Source: https://github.com/datasets/language-codes
$task_number = 11
$task = "Downloading ISO 639-2 Registration Authority (RA) and ISO 639-1 language codes..."
Write-Progress -Id $id -Activity $activity -Status $status -CurrentOperation $task -PercentComplete (($task_number / $total_steps) * 100)

$csv_url = 'https://raw.githubusercontent.com/datasets/language-codes/master/data/ietf-language-tags.csv'
$csv_crawler = New-Object System.Net.WebClient
$csv_file = $csv_crawler.DownloadString($csv_url)
$csv_file | ConvertFrom-Csv | Export-Csv "$path\languages_IETF.csv" -Delimiter ";" -NoTypeInformation -Encoding Default




# Step 6
# Script Names ISO 15924
# Alphabetical list of four-letter script names - Normative plain-text version (UTF-8) ISO 15924
# Codes for the representation of names of scripts
# Alphabetical list of English script names
# Source: http://www.unicode.org/iso15924/codelists.html
# Source: http://www.unicode.org/iso15924/iso15924-en.html
# Source: http://www.unicode.org/iso15924/iso15924-text.html
$task_number = 14
$task = "Downloading ISO 15924 alphabetical list of four-letter script names..."
Write-Progress -Id $id -Activity $activity -Status $status -CurrentOperation $task -PercentComplete (($task_number / $total_steps) * 100)

$script_downloader = New-Object System.Net.WebClient
$script_url = 'http://www.unicode.org/iso15924/iso15924.txt.zip'
$script = $script_downloader.DownloadString($script_url)
$filename_12 = "script.zip"
$script_zip_path = "$path\$filename_12"
$script | Out-File "$script_zip_path" -Encoding Default

# Unzip with PowerShell                                                                       # Credit: Ameer Deen: "How to zip/unzip files in Powershell?"
$task_number = 17
$task = "Converting the ISO 15924 alphabetical list of four-letter script names to CSV..."
Write-Progress -Id $id -Activity $activity -Status $status -CurrentOperation $task -PercentComplete (($task_number / $total_steps) * 100)

$output_folder = "$path\script"

        If ((Test-Path $output_folder) -eq $false) {
            New-Item -ItemType Directory -Path $output_folder -Force
        } Else {
            $continue = $true
        } # Else

$script_zip_obj = $shell.NameSpace($path + "\$filename_12")
# $script_zip_obj = $shell.NameSpace((Get-Location).Path + "\$filename_12")
$output = $shell.NameSpace("$output_folder")
$output.CopyHere($script_zip_obj.Items())
Start-Sleep -s 1
$list = Get-ChildItem $output_folder

        If (($list.Count) -ge 0) {
            Remove-Item $script_zip_path -Force
        } Else {
            $continue = $true
        } # Else

        # Copy script name files to $path
        If ((($list | Where { $_.Name -like "*txt" } | Measure-Object).Count) -eq 1) {
            copy "$output_folder\*.txt" "$path\script_names_ISO_15924.txt"
        } Else {
            copy "$output_folder\*.txt" "$path\*.txt"
        } # Else

# ConvertFrom-Csv $scipt_data -Delimiter ";" -Header "Code","N°","English Name","Nom français","PVA","Date" | Export-Csv "$path\script_names_ISO_15924.csv" -Delimiter ";" -NoTypeInformation -Encoding Default
$output_path = "$path\script_names_ISO_15924.csv"
New-Item -ItemType File -Path $output_path -Force
$header = "Code;Number;English Name;French Name;PVA;Date"
$scipt_data = (Get-Content "$path\script_names_ISO_15924.txt") -notmatch '^#' | Where { ($_.Trim() -ne "") }
Add-Content -Path $output_path -Value $header
Add-Content -Path $output_path -Value $scipt_data


# Purge the unzip folder
Start-Sleep -s 1
Remove-Item "$output_folder" -Recurse -Force




# Step 7
# Unicode Common Locale Data Repository (CLDR)
<#
        >       &gt;
        <       &lt;
        "       &quot;
        '       &apos;
        &       &amp;
#>
# $content = [System.IO.File]::ReadAllText("$path\$filename_10").Replace(">","&gt;").Replace("<","&lt;")
# [System.IO.File]::WriteAllText("$path\$filename_10", $content)
# Copyright: http://www.unicode.org/copyright.html
# License: http://unicode.org/repos/cldr/tags/latest/unicode-license.txt
# Source: http://cldr.unicode.org/index/downloads/latest
# Source: http://unicode.org/Public/cldr/latest
$task_number = 19
$task = "Downloading files from the Unicode Common Locale Data Repository (CLDR)..."
Write-Progress -Id $id -Activity $activity -Status $status -CurrentOperation $task -PercentComplete (($task_number / $total_steps) * 100)

$license_url = 'http://unicode.org/repos/cldr/tags/latest/unicode-license.txt'
$license_crawler = New-Object System.Net.WebClient
$license_file = $license_crawler.DownloadString($license_url)
$license_file | Out-File "$path\unicode_license.txt" -Encoding Default

$xml_url_1 = 'http://unicode.org/repos/cldr/tags/latest/common/supplemental/languageInfo.xml'
$filename_1 = [string]'unicode_' + $($xml_url_1.Split("/")[-1])
$filepath_1 = "$path\$filename_1"
$xml_1 = New-Object -TypeName XML
$xml_1.Load($xml_url_1)
# $modified_xml_1 = ($xml_1.InnerXml).Replace("../../common/dtd/ldmlSupplemental.dtd","$path\unicode_ldmlSupplemental.dtd")
$modified_xml_1 = ($xml_1.InnerXml).Replace('<!DOCTYPE supplementalData SYSTEM "../../common/dtd/ldmlSupplemental.dtd"[]>','')
$modified_xml_1 | Out-File "$filepath_1" -Encoding UTF8

$xml_url_2 = 'http://unicode.org/repos/cldr/tags/latest/common/supplemental/supplementalData.xml'
# $xml_url_2 = 'http://unicode.org/repos/cldr/trunk/common/supplemental/supplementalData.xml'
# Check import text
$filename_2 = [string]'unicode_' + $($xml_url_2.Split("/")[-1])
$filepath_2 = "$path\$filename_2"
$xml_2 = New-Object -TypeName XML
$xml_2.Load($xml_url_2)
$modified_xml_2 = ($xml_2.InnerXml).Replace('<!DOCTYPE supplementalData SYSTEM "../../common/dtd/ldmlSupplemental.dtd"[]>','')
$modified_xml_2 | Out-File "$filepath_2" -Encoding UTF8

$xml_url_3 = 'http://unicode.org/repos/cldr/tags/latest/common/supplemental/windowsZones.xml'
# Check import text
$filename_3 = [string]'unicode_' + $($xml_url_3.Split("/")[-1])
$filepath_3 = "$path\$filename_3"
$xml_3 = New-Object -TypeName XML
$xml_3.Load($xml_url_3)
$modified_xml_3 = ($xml_3.InnerXml).Replace('<!DOCTYPE supplementalData SYSTEM "../../common/dtd/ldmlSupplemental.dtd"[]>','')
$modified_xml_3 | Out-File $filepath_3 -Encoding UTF8

$xml_url_4 = 'http://unicode.org/repos/cldr/tags/latest/common/supplemental/telephoneCodeData.xml'
$filename_4 = [string]'unicode_' + $($xml_url_4.Split("/")[-1])
$filepath_4 = "$path\$filename_4"
$xml_4 = New-Object -TypeName XML
$xml_4.Load($xml_url_4)
$modified_xml_4 = ($xml_4.InnerXml).Replace('<!DOCTYPE supplementalData SYSTEM "../../common/dtd/ldmlSupplemental.dtd"[]>','')
$modified_xml_4 | Out-File "$filepath_4" -Encoding UTF8

$xml_url_5 = 'http://unicode.org/repos/cldr/tags/latest/common/supplemental/subdivisions.xml'
$filename_5 = [string]'unicode_' + $($xml_url_5.Split("/")[-1])
$filepath_5 = "$path\$filename_5"
$xml_5 = New-Object -TypeName XML
$xml_5.Load($xml_url_5)
$modified_xml_5 = ($xml_5.InnerXml).Replace('<!DOCTYPE supplementalData SYSTEM "../../common/dtd/ldmlSupplemental.dtd"[]>','')
$modified_xml_5 | Out-File "$filepath_5" -Encoding UTF8

$xml_url_6 = 'http://unicode.org/repos/cldr/tags/latest/common/supplemental/numberingSystems.xml'
$filename_6 = [string]'unicode_' + $($xml_url_6.Split("/")[-1])
$filepath_6 = "$path\$filename_6"
$xml_6 = New-Object -TypeName XML
$xml_6.Load($xml_url_6)
$modified_xml_6 = ($xml_6.InnerXml).Replace('<!DOCTYPE supplementalData SYSTEM "../../common/dtd/ldmlSupplemental.dtd"[]>','')
$modified_xml_6 | Out-File "$filepath_6" -Encoding UTF8

$xml_url_7 = 'http://unicode.org/repos/cldr/tags/latest/common/supplemental/metaZones.xml'
$filename_7 = [string]'unicode_' + $($xml_url_7.Split("/")[-1])
$filepath_7 = "$path\$filename_7"
$xml_7 = New-Object -TypeName XML
$xml_7.Load($xml_url_7)
$modified_xml_7 = ($xml_7.InnerXml).Replace('<!DOCTYPE supplementalData SYSTEM "../../common/dtd/ldmlSupplemental.dtd"[]>','')
$modified_xml_7 | Out-File "$filepath_7" -Encoding UTF8

$xml_url_8 = 'http://unicode.org/repos/cldr/tags/latest/common/supplemental/likelySubtags.xml'
$filename_8 = [string]'unicode_' + $($xml_url_8.Split("/")[-1])
$filepath_8 = "$path\$filename_8"
$xml_8 = New-Object -TypeName XML
$xml_8.Load($xml_url_8)
$modified_xml_8 = ($xml_8.InnerXml).Replace('<!DOCTYPE supplementalData SYSTEM "../../common/dtd/ldmlSupplemental.dtd"[]>','')
$modified_xml_8 | Out-File "$filepath_8" -Encoding UTF8

$xml_url_9 = 'http://unicode.org/repos/cldr/tags/latest/common/supplemental/dayPeriods.xml'
$filename_9 = [string]'unicode_' + $($xml_url_9.Split("/")[-1])
$filepath_9 = "$path\$filename_9"
$xml_9 = New-Object -TypeName XML
$xml_9.Load($xml_url_9)
$modified_xml_9 = ($xml_9.InnerXml).Replace('<!DOCTYPE supplementalData SYSTEM "../../common/dtd/ldmlSupplemental.dtd"[]>','')
$modified_xml_9 | Out-File "$filepath_9" -Encoding UTF8

$xml_url_10 = 'http://unicode.org/repos/cldr/tags/latest/common/bcp47/currency.xml'
$filename_10 = [string]'unicode_' + $($xml_url_10.Split("/")[-1])
$filepath_10 = "$path\$filename_10"
$xml_10 = New-Object -TypeName XML
$xml_10.Load($xml_url_10)
$modified_xml_10 = ($xml_10.InnerXml).Replace('<!DOCTYPE ldmlBCP47 SYSTEM "../../common/dtd/ldmlBCP47.dtd"[]>','')
$modified_xml_10 | Out-File "$filepath_10" -Encoding UTF8

<#
        $xml = New-Object -TypeName XML
        $xml.Load($filepath_10)

        $text_url = 'http://unicode.org/repos/cldr/tags/latest/common/uca/CollationTest_CLDR_NON_IGNORABLE_SHORT.txt'
        $text_crawler = New-Object System.Net.WebClient
        $text_file = $text_crawler.DownloadString($text_url)
        $text_file | Out-File "$path\unicode_text.txt" -Encoding Default

        $dtd_url_1 = 'http://unicode.org/repos/cldr/tags/latest/common/dtd/ldmlSupplemental.dtd'
        $filename_dtd_1 = [string]'unicode_' + $($dtd_url_1.Split("/")[-1])
        $dtd_crawler_1 = New-Object System.Net.WebClient
        $dtd_1 = $dtd_crawler_1.DownloadString($dtd_url_1)
        $dtd_1 | Out-File "$path\$filename_dtd_1" -Encoding Default

        $dtd_url_2 = 'http://unicode.org/repos/cldr/tags/latest/common/dtd/ldmlBCP47.dtd'
        $filename_dtd_2 = [string]'unicode_' + $($dtd_url_2.Split("/")[-1])
        $dtd_crawler_2 = New-Object System.Net.WebClient
        $dtd_2 = $dtd_crawler_2.DownloadString($dtd_url_2)
        $dtd_2 | Out-File "$path\$filename_dtd_2" -Encoding Default
#>




# Step 8
# United Nations Code for Trade and Transport Locations (UN/LOCODE)
# The list of country names in alphabetical order (plus the official short name in English as in ISO 3166) and states/subdivisions/cities/other sublocations of a country
# Source: http://www.unece.org/cefact/codesfortrade/codes_index.html
# Source: http://www.unece.org/cefact/locode/welcome.html
# Source: http://www.unece.org/cefact/locode/service/location.html
# Source: http://www.unece.org/cefact/locode
$task_number = 25
$task = "Downloading UN/LOCODE (United Nations Code for Trade and Transport Locations)..."
Write-Progress -Id $id -Activity $activity -Status $status -CurrentOperation $task -PercentComplete (($task_number / $total_steps) * 100)

$unlocode_downloader = New-Object System.Net.WebClient
$unlocode_url = 'http://www.unece.org/fileadmin/DAM/cefact/locode/loc161csv.zip'
$unlocode = $unlocode_downloader.DownloadString($unlocode_url)
$filename_11 = "unlocode.zip"
$zip_file_path = "$path\$filename_11"
$unlocode | Out-File "$zip_file_path" -Encoding Default

# Unzip with PowerShell                                                                       # Credit: Ameer Deen: "How to zip/unzip files in Powershell?"
$task_number = 28
$task = "Merging the UN/LOCODE (United Nations Code for Trade and Transport Locations) CSVs to a single CSV..."
Write-Progress -Id $id -Activity $activity -Status $status -CurrentOperation $task -PercentComplete (($task_number / $total_steps) * 100)

$target_folder = "$path\Unlocode"

        If ((Test-Path $target_folder) -eq $false) {
            New-Item -ItemType Directory -Path $target_folder -Force
        } Else {
            $continue = $true
        } # Else

$zip_file_obj = $shell.NameSpace($path + "\$filename_11")
# $zip_file_obj = $shell.NameSpace((Get-Location).Path + "\$filename_11")
$destination = $shell.NameSpace("$target_folder")
$destination.CopyHere($zip_file_obj.Items())
Start-Sleep -s 1
$dir = Get-ChildItem $target_folder

        If (($dir.Count) -ge 0) {
            Remove-Item $zip_file_path -Force
        } Else {
            $continue = $true
        } # Else

        # Notes
        # $unlocode_notes_url = 'http://www.unece.org/fileadmin/DAM/cefact/locode/2015-2_UNLOCODE_SecretariatNotes.pdf'
        # $unlocode_notes = $unlocode_downloader.DownloadString($unlocode_notes_url)
        # $unlocode_notes | Out-File "$path\unlocode_notes.pdf" -Encoding Default
        If ((($dir | Where { $_.Name -like "*pdf" } | Measure-Object).Count) -eq 1) {
            copy "$target_folder\*.pdf" "$path\unlocode_notes.pdf"
        } Else {
            copy "$target_folder\*.pdf" "$path\*.pdf"
        } # Else

$subdivision = $dir | Where { $_.Name -like "*subdivision*" }

        # Subdivision Codes (n = ~4700)
        If ((($subdivision | Measure-Object).Count) -eq 1) {
            copy "$target_folder\$($subdivision.Name)" "$path\unlocode_subdivisions.csv"
        } Else {
                ForEach ($file in $subdivision) {
                copy "$target_folder\$($file.Name)" "$path\$($file.Name)"
                    } Else {
                        $continue = $true
                } # ForEach
        } # Else

$part1 = $dir | Where { $_.Name -like "*part1*" }

        # Part 1 (n = ~48000)
        If ((($part1 | Measure-Object).Count) -eq 1) {
            $first_path = "$path\unlocode_part1.csv"
            copy "$target_folder\$($part1.Name)" "$first_path"
            $merge += "$part1"
        } Else {
                ForEach ($file in $part1) {
                copy "$target_folder\$($file.Name)" "$path\$($file.Name)"
                    } Else {
                        $continue = $true
                } # ForEach
        } # Else

$part2 = $dir | Where { $_.Name -like "*part2*" }

        # Part 2 (n = ~25900)
        If ((($part2 | Measure-Object).Count) -eq 1) {
            $second_path = "$path\unlocode_part2.csv"
            copy "$target_folder\$($part2.Name)" "$second_path"
            $merge += "$part2"
        } Else {
                ForEach ($file in $part2) {
                copy "$target_folder\$($file.Name)" "$path\$($file.Name)"
                    } Else {
                        $continue = $true
                } # ForEach
        } # Else

$part3 = $dir | Where { $_.Name -like "*part3*" }

        # Part 3 (n = ~31000)
        If ((($part3 | Measure-Object).Count) -eq 1) {
            $third_path = "$path\unlocode_part3.csv"
            copy "$target_folder\$($part3.Name)" "$third_path"
            $merge += "$part3"
        } Else {
                ForEach ($file in $part3) {
                copy "$target_folder\$($file.Name)" "$path\$($file.Name)"
                    } Else {
                        $continue = $true
                } # ForEach
        } # Else


# Merge UN/LOCODE CSV-files (append)
If ((($merge).Count) -eq 3) {
<#
        Indicator
        ISO 3166 alpha-2 Country Code
        3-character Code for the Place Name (Location)
        Place Name (national language version), Romanized
        Place Name Without Diacritics, Romanized
        Subdivision ISO 1-3 (latter part of the complete ISO 3166-2/1998 element)
        Function
        Status
        Date (Year/Month)
        IATA Code for the Location (if it differs from the Location column)
        Coordinates
        Remarks
#>
    $destination_path = "$path\unlocode.csv"
    New-Item -ItemType File -Path $destination_path -Force
    $header = "Indicator,ISO 3166 alpha-2 Country Code,3-character Code for the Place Name (Location),Place Name (national language version) - Romanized,Place Name Without Diacritics - Romanized,Subdivision ISO 1-3 (latter part of the complete ISO 3166-2/1998 element),Function,Status,Date (Year/Month),IATA Code for the Location (if it differs from the Location column),Coordinates,Remarks"
    $first_part = Get-Content "$first_path"
    $second_part = Get-Content "$second_path"
    $third_part = Get-Content "$third_path"
    Add-Content -Path $destination_path -Value $header
    Add-Content -Path $destination_path -Value $first_part
    Add-Content -Path $destination_path -Value $second_part
    Add-Content -Path $destination_path -Value $third_part
    Remove-Item "$first_path" -Force
    Remove-Item "$second_path" -Force
    Remove-Item "$third_path" -Force
    # Import-Csv $destination_path
<#
        Function
        0   Function not known, to be specified                             (0-------)
        1   Port, as defined in Rec. 16                                     (1-------)
        2   Rail terminal                                                   (-2------)
        3   Road terminal                                                   (--3-----)
        4   Airport                                                         (---4----)
        5   Postal exchange office                                          (----5---)
        [6] Reserved for Multimodal functions, ICDs, etc.                   (-----6--)
        [7] Reserved for fixed transport functions (e.g. Oil platform)      (------7-)
        B   Border crossing                                                 (-------B)
#>
<#
        Status
        AA  =  Approved by competent national government agency
        AC  =  Approved by Customs Authority
        AF  =  Approved by national facilitation body
        AI  =  Code adopted by international organisation (IATA or ECLAC)
        AM  =  Approved by the UN/LOCODE Maintenance Agency
        AS  =  Approved by national standardisation body
        AQ  =  Entry approved, functions not verified
        RL  =  Recognised location - Existence and representation of location name confirmed by check against nominated gazetteer or other reference work
        RN  =  Request from credible national sources for locations in their own country
        RQ  =  Request under consideration
        RR  =  Request rejected
        QQ  =  Original entry not verified since date indicated
        UR  =  Entry included on user's request; not officially approved
        XX  =  Entry that will be removed from the next issue of UN/LOCODE
#>
} Else {
    $continue = $true
} # Else

$task_number = 30
$task = "Downloading Supplementary Ancillary UN/LOCODE files..."
Write-Progress -Id $id -Activity $activity -Status $status -CurrentOperation $task -PercentComplete (($task_number / $total_steps) * 100)

# UNECE Recommendation No. 16 on "Codes for Trade and Transport Locations"
$unlocode_recommendation_url = 'http://www.unece.org/trade/untdid/download/99trd227.pdf'
$unlocode_recommendation = $unlocode_downloader.DownloadString($unlocode_recommendation_url)
$unlocode_recommendation | Out-File "$path\unlocode_recommendation.pdf" -Encoding Default


# UN/LOCODE Manual
$unlocode_manual_url = 'http://www.unece.org/fileadmin/DAM/cefact/locode/unlocode_manual.pdf'
$unlocode_manual = $unlocode_downloader.DownloadString($unlocode_manual_url)
$unlocode_manual | Out-File "$path\unlocode_manual.pdf" -Encoding Default


# Purge the unzip folder
Start-Sleep -s 1
Remove-Item "$target_folder" -Recurse -Force




# Step 9
# International Telecommunication Union (ITU)
# Source: http://www.itu.int/opb/publications.aspx?parent=T-SP&view=T-SP2
$task_number = 34
$task = "Downloading PDF-files from International Telecommunication Union (ITU)..."
Write-Progress -Id $id -Activity $activity -Status $status -CurrentOperation $task -PercentComplete (($task_number / $total_steps) * 100)

$itu_downloader = New-Object System.Net.WebClient

# List of Recommendation ITU-T E.164 assigned country codes
# http://www.itu.int/dms_pub/itu-t/opb/sp/T-SP-E.164D-2016-MSW-E.docx
$itu_url_1 = 'http://www.itu.int/dms_pub/itu-t/opb/sp/T-SP-E.164D-2016-PDF-E.pdf'
$itu_country_codes = $itu_downloader.DownloadString($itu_url_1)
$itu_country_codes | Out-File "$path\itu_country_codes_E.164.pdf" -Encoding Default

# List of Signalling Area/Network Codes (SANC)
# http://www.itu.int/dms_pub/itu-t/opb/sp/T-SP-Q.708A-2014-MSW-E.docx
$itu_url_2 = 'http://www.itu.int/dms_pub/itu-t/opb/sp/T-SP-Q.708A-2014-PDF-E.pdf'
$itu_network_codes = $itu_downloader.DownloadString($itu_url_2)
$itu_network_codes | Out-File "$path\itu_network_codes_SANC.pdf" -Encoding Default

# List of Mobile Country or Geographical Area Codes
# http://www.itu.int/dms_pub/itu-t/opb/sp/T-SP-E.212A-2012-MSW-E.doc
$itu_url_3 = 'http://www.itu.int/dms_pub/itu-t/opb/sp/T-SP-E.212A-2012-PDF-E.pdf'
$itu_mobile_codes = $itu_downloader.DownloadString($itu_url_3)
$itu_mobile_codes | Out-File "$path\itu_mobile_codes.pdf" -Encoding Default

# List of Country or Geographical Area Codes for non standard facilities in telematic services
# http://www.itu.int/dms_pub/itu-t/opb/sp/T-SP-T.35-2012-OAS-MSW-E.doc
$itu_url_4 = 'http://www.itu.int/dms_pub/itu-t/opb/sp/T-SP-T.35-2012-OAS-PDF-E.pdf'
$itu_geographical_codes_non_standard = $itu_downloader.DownloadString($itu_url_4)
$itu_geographical_codes_non_standard | Out-File "$path\itu_geographical_non-std.pdf" -Encoding Default

# List of Data Country or Geographical Area Codes
# http://www.itu.int/dms_pub/itu-t/opb/sp/T-SP-X.121A-2011-MSW-E.doc
$itu_url_5 = 'http://www.itu.int/dms_pub/itu-t/opb/sp/T-SP-X.121A-2011-PDF-E.pdf'
$itu_geographical_codes = $itu_downloader.DownloadString($itu_url_5)
$itu_geographical_codes | Out-File "$path\itu_geographical_codes.pdf" -Encoding Default

# List of terrestrial trunk radio mobile country codes
# http://www.itu.int/dms_pub/itu-t/opb/sp/T-SP-E.218-2011-MSW-E.doc
$itu_url_6 = 'http://www.itu.int/dms_pub/itu-t/opb/sp/T-SP-E.218-2011-PDF-E.pdf'
$itu_terrestrial_codes = $itu_downloader.DownloadString($itu_url_6)
$itu_terrestrial_codes | Out-File "$path\itu_terrestrial_codes.pdf" -Encoding Default

# Five-letter Code Groups for the use of the International Public Telegram Service
# http://www.itu.int/dms_pub/itu-t/opb/sp/T-SP-F.1-1998-MSW-E.doc
$itu_url_7 = 'http://www.itu.int/dms_pub/itu-t/opb/sp/T-SP-F.1-1998-PDF-E.pdf'
$itu_telegram_codes = $itu_downloader.DownloadString($itu_url_7)
$itu_telegram_codes | Out-File "$path\itu_telegram_codes.pdf" -Encoding Default




<#
        # Step 10
        # United Nations' esu lacitsitats rof snoiger lacihpargoeg dna sedoc aera ro yrtnuoc dradnats**
        # Source: http://unstats.un.org/unsd/methods/m49/m49.htm
        # Note: Please read the copyright info below, access to the content is restricted.
        # Copyright: http://unstats.un.org/unsd/copyright.htm


        Summary of the UN Copyright:*
        Without the prior permission of the copyright owner (UN) any part of the material that appears after the links (URLs) that are mentioned here in Step 10 are accessed may not be reproduced or transmitted in any form or by any means, electronic, mechanical, photocopying, recording or otherwise.

            Copyright enquiries could be addressed to:

            draoB snoitacilbuP snoitaN detinU**
            snoitaN detinU**
            kroY weN**
            ASU 71001 YN**
            9654 369/212 1+ :xaF**

            gro.nu@scitsitats :ot deipoc osla eb thgim seiriuqnE**

            * Please see http://unstats.un.org/unsd/copyright.htm for the actual copyright info.
            ** In PowerShell, please try:
                    $string = "This is a test."
                    ([regex]::Matches($string,'.','RightToLeft') | ForEach { $_.Value }) -join ''
                    # Source: https://learn-powershell.net/2012/08/12/reversing-a-string-using-powershell/


        So if a permission from the copyright owner (UN) is obtained, the following script could perhaps work:

        # Note: Without the ancillary supporting html style files (stylesheet/css), the pages will probably be broken. The source code for the tables themselves, however, seems to be in pretty straight forward basic html-format.
        # Note: Please make sure to obtain a permission from the copyright owner before downloading any files listed below (in this Step 10).
        # Copyright: http://unstats.un.org/unsd/copyright.htm
        # Source: http://unstats.un.org/unsd/methods/m49/m49.htm
        $un_downloader = New-Object System.Net.WebClient

        # snoitaiverbba dna sedoc ,saera ro seirtnuoC**
        $un_url_1 = 'http://unstats.un.org/unsd/methods/m49/m49alpha.htm'
        $un_country_codes = $un_downloader.DownloadString($un_url_1)
        $un_country_codes | Out-File "$path\un_country_codes.html" -Encoding Default

        # sgnipuorg rehto dna cimonoce detceles dna ,snoiger-bus lacihpargoeg ,snoiger )latnenitnoc( lacihpargoeg orcam fo noitisopmoC**
        $un_url_2 = 'http://unstats.un.org/unsd/methods/m49/m49regin.htm'
        $un_region_codes = $un_downloader.DownloadString($un_url_2)
        $un_region_codes | Out-File "$path\un_region_codes.html" -Encoding Default

        # 2891 ecnis degnahc ro dedda sedoc laciremun aera ro yrtnuoC**
        $un_url_3 = 'http://unstats.un.org/unsd/methods/m49/m49chang.htm'
        $un_changelog = $un_downloader.DownloadString($un_url_3)
        $un_changelog | Out-File "$path\un_changelog.html" -Encoding Default
#>




# Step 11
# The International Standard for Currency Codes - ISO 4217:2015
# Source: http://www.iso.org/iso/home/standards/currency_codes.htm
# Source: http://www.currency-iso.org/en/home/tables.html
# Schema (ISO 20022): http://www.currency-iso.org/dam/downloads/schema.xsd
$task_number = 40
$task = "Downloading ISO 4217:2015 (The International Standard for Currency Codes) files..."
Write-Progress -Id $id -Activity $activity -Status $status -CurrentOperation $task -PercentComplete (($task_number / $total_steps) * 100)

$currency_downloader = New-Object System.Net.WebClient

# Current currency & funds code list
# http://www.currency-iso.org/dam/downloads/lists/list_one.xml
$currency_url_1 = 'http://www.currency-iso.org/dam/downloads/lists/list_one.xls'
$currency_current = $currency_downloader.DownloadString($currency_url_1)
$currency_current | Out-File "$path\currency_current_ISO_4217.xls" -Encoding Default

# Fund codes list
$currency_url_2 = 'http://www.currency-iso.org/dam/downloads/lists/list_two.doc'
$currency_funds = $currency_downloader.DownloadString($currency_url_2)
$currency_funds | Out-File "$path\currency_fund_codes.doc" -Encoding Default

# List of codes for historic denominations of currencies & funds
# http://www.currency-iso.org/dam/downloads/lists/list_three.xml
$currency_url_3 = 'http://www.currency-iso.org/dam/downloads/lists/list_three.xls'
$currency_historic = $currency_downloader.DownloadString($currency_url_3)
$currency_historic | Out-File "$path\currency_historic.xls" -Encoding Default




# Step 12
# Close the progress bar
$task_number = 45
$task = "Finished Downloading Culture Files."
Write-Progress -Id $id -Activity $activity -Status $status -CurrentOperation $task -PercentComplete (($task_number / $total_steps) * 100) -Completed

# Find out how long the script took to complete
$end_time = Get-Date
$runtime = ($end_time) - ($start_time)

    If ($runtime.Days -ge 2) {
        $runtime_result = [string]$runtime.Days + ' days ' + $runtime.Hours + ' h ' + $runtime.Minutes + ' min'
    } ElseIf ($runtime.Days -gt 0) {
        $runtime_result = [string]$runtime.Days + ' day ' + $runtime.Hours + ' h ' + $runtime.Minutes + ' min'
    } ElseIf ($runtime.Hours -gt 0) {
        $runtime_result = [string]$runtime.Hours + ' h ' + $runtime.Minutes + ' min'
    } ElseIf ($runtime.Minutes -gt 0) {
        $runtime_result = [string]$runtime.Minutes + ' min ' + $runtime.Seconds + ' sec'
    } ElseIf ($runtime.Seconds -gt 0) {
        $runtime_result = [string]$runtime.Seconds + ' sec'
    } ElseIf ($runtime.Milliseconds -gt 1) {
        $runtime_result = [string]$runtime.Milliseconds + ' milliseconds'
    } ElseIf ($runtime.Milliseconds -eq 1) {
        $runtime_result = [string]$runtime.Milliseconds + ' millisecond'
    } ElseIf (($runtime.Milliseconds -gt 0) -and ($runtime.Milliseconds -lt 1)) {
        $runtime_result = [string]$runtime.Milliseconds + ' milliseconds'
    } Else {
        $runtime_result = [string]''
    } # else (if)

        If ($runtime_result.Contains(" 0 h")) {
            $runtime_result = $runtime_result.Replace(" 0 h"," ")
            } If ($runtime_result.Contains(" 0 min")) {
                $runtime_result = $runtime_result.Replace(" 0 min"," ")
                } If ($runtime_result.Contains(" 0 sec")) {
                $runtime_result = $runtime_result.Replace(" 0 sec"," ")
        } # if ($runtime_result: first)

# Display the runtime in console
$empty_line | Out-String
$timestamp_end = Get-Date -Format HH:mm:ss
$empty_line | Out-String
$end_text = "$timestamp_end - Culture files downloaded."
Write-Output $end_text
$empty_line | Out-String
$runtime_text = "The culture files were obtained in $runtime_result."
Write-Output $runtime_text
$empty_line | Out-String




# [End of Line]


<#

   ____        _   _
  / __ \      | | (_)
 | |  | |_ __ | |_ _  ___  _ __  ___
 | |  | | '_ \| __| |/ _ \| '_ \/ __|
 | |__| | |_) | |_| | (_) | | | \__ \
  \____/| .__/ \__|_|\___/|_| |_|___/
        | |
        |_|


# Open the ISO 3166 - Codes for countries and their subdivisions web page in the default browser - (n = ~249), officially assigned country codes
# Click-Path: Country codes > [Magnifier] (Search) > Results per page: 300
# Source: http://www.iso.org/iso/country_codes_glossary.html
Start-Process -FilePath "https://www.iso.org/obp/ui/#search" | Out-Null

# Open the United Nations' esu lacitsitats rof snoiger lacihpargoeg dna sedoc aera ro yrtnuoc dradnats -dataset in the default browser**
# Source: http://unstats.un.org/unsd/methods/m49/m49.htm
# Copyright: http://unstats.un.org/unsd/copyright.htm

# snoitaiverbba dna sedoc ,saera ro seirtnuoC**
Start-Process -FilePath "http://unstats.un.org/unsd/methods/m49/m49alpha.htm" | Out-Null

# sgnipuorg rehto dna cimonoce detceles dna ,snoiger-bus lacihpargoeg ,snoiger )latnenitnoc( lacihpargoeg orcam fo noitisopmoC**
Start-Process -FilePath "http://unstats.un.org/unsd/methods/m49/m49regin.htm" | Out-Null

# 2891 ecnis degnahc ro dedda sedoc laciremun aera ro yrtnuoC**
Start-Process -FilePath "http://unstats.un.org/unsd/methods/m49/m49chang.htm" | Out-Null

        ** In PowerShell, please try:
                $string = "This is a test."
                ([regex]::Matches($string,'.','RightToLeft') | ForEach { $_.Value }) -join ''
                # Source: https://learn-powershell.net/2012/08/12/reversing-a-string-using-powershell/

   _____
  / ____|
 | (___   ___  _   _ _ __ ___ ___
  \___ \ / _ \| | | | '__/ __/ _ \
  ____) | (_) | |_| | | | (_|  __/
 |_____/ \___/ \__,_|_|  \___\___|


http://powershell.com/cs/blogs/tips/archive/2011/05/04/test-internet-connection.aspx                    # ps1: "Test Internet connection"
http://serverfault.com/questions/18872/how-to-zip-unzip-files-in-powershell#201604                      # Ameer Deen: "How to zip/unzip files in Powershell?"


  _    _      _
 | |  | |    | |
 | |__| | ___| |_ __
 |  __  |/ _ \ | '_ \
 | |  | |  __/ | |_) |
 |_|  |_|\___|_| .__/
               | |
               |_|
#>

<#

.SYNOPSIS
Retrieves culture related data from the local computer and the Internet and
writes the datasets as table formatted files.

.DESCRIPTION
Get-CultureTables accesses the System.Globalization.CultureInfo .NET Framework
Class Library and tries to read the AllCultures CultureType, which lists all the
cultures that ship with the .NET Framework, including neutral and specific cultures,
cultures installed in the Windows operating system (InstalledWin32Cultures) and
custom cultures created by the user. The info is written to a CSV-file
(cultures.csv) and the results are outputted to a pop-up window (Out-GridView).

After checking that the computer is connected to the Internet Get-CultureTables
tries to download culture related data from several different domains and write
that info to separate files at $path. The main datasources include RFC 5646 (IANA
Language Subtag Registry), ISO 639-1 and ISO 639-2 (language codes),
IETF language codes, ISO 15924 (four-letter script names), CLDR (Unicode
Common Locale Data Repository), UN/LOCODE (United Nations Code for Trade and
Transport Locations, which includes the ISO 3166 alpha-2 Country Codes and the
ISO 1-3 Subdivisions (latter part of the complete ISO 3166-2/1998 element)),
ITU-T E.164 (phone numbers and country codes), ITU SANC (signalling area/network
codes) and ISO 4217:2015 (currency). Please see the Outputs-section below for the
full filelist.

.OUTPUTS
Displays the local machine culture information in a pop-up window
"$cultures_selection"


        Name                                Description
        ----                                -----------
        $cultures_selection                 Displays a list of .NET Framework cultures


and writes that data to a file as described below. Also, if a working internet
connection is detected, after accessing several domains Get-CultureTables writes
in the default scenario the following files at $path ($env:temp):

$env:temp\cultures.csv                  CSV     .NET Framework "AllCultures" CultureType
$env:temp\languages_IANA.txt            TXT     IANA Language Subtag Registry (RFC 5646) original
$env:temp\languages_IANA.csv            CSV     IANA Language Subtag Registry (RFC 5646)
$env:temp\languages_ISO_639.csv         CSV     ISO 639-1 and ISO 639-2 Language Codes
$env:temp\languages_IETF.csv            CSV     IETF Language Codes
$env:temp\script_names_ISO_15924.csv    CSV     ISO 15924 Script Names
$env:temp\unicode_license.txt           TXT     Unicode Licence
$env:temp\unicode_languageInfo.xml      XML     Unicode Language Info
$env:temp\unicode_supplementalData.xml  XML     Unicode Supplemental Data
$env:temp\unicode_windowsZones.xml      XML     Unicode Windows Zones
$env:temp\unicode_telephoneCodeData.xml XML     Unicode Telephone Code Data
$env:temp\unicode_subdivisions.xml      XML     Unicode Subdivisions
$env:temp\unicode_numberingSystems.xml  XML     Unicode Numbering Systems
$env:temp\unicode_metaZones.xml         XML     Unicode Meta Zones
$env:temp\unicode_likelySubtags.xml     XML     Unicode Likely Subtags
$env:temp\unicode_dayPeriods.xml        XML     Unicode Day Periods
$env:temp\unicode_currency.xml          XML     Unicode Currency
$env:temp\unlocode_notes.pdf            PDF     UN/LOCODE Notes
$env:temp\unlocode_subdivisions.csv     CSV     UN/LOCODE Subdivisions
$env:temp\unlocode.csv                  CSV     UN/LOCODE (United Nations Code for Trade and
                                                Transport Locations)
$env:temp\unlocode_recommendation.pdf   PDF     UNECE Recommendation No. 16 on UN/LOCODE
$env:temp\unlocode_manual.pdf           PDF     UN/LOCODE Manual
$env:temp\itu_country_codes_E.164.pdf   PDF     ITU-T E.164 Phone Numbers and Country Codes
$env:temp\itu_network_codes_SANC.pdf    PDF     ITU Signalling Area/Network Codes (SANC)
$env:temp\itu_mobile_codes.pdf          PDF     ITU Mobile Country or Geographical Area Codes
$env:temp\itu_geographical_non-std.pdf  PDF     ITU List of Country or Geographical Area Codes
                                                for non standard facilities in telematic services
$env:temp\itu_geographical_codes.pdf    PDF     ITU List of Data Country or Geographical Area Codes
$env:temp\itu_terrestrial_codes.pdf     PDF     ITU List of terrestrial trunk radio mobile country codes
$env:temp\itu_telegram_codes.pdf        PDF     ITU Five-letter Code Groups for the use of the
                                                International Public Telegram Service
$env:temp\currency_current_ISO_4217.xls XLS     ISO 4217:2015 Currency
$env:temp\currency_fund_codes.doc       DOC     Fund Codes List
$env:temp\currency_historic.xls         XLS     List of codes for historic denominations of currencies

.NOTES
Please note that all the Unicode Common Locale Data Repository (CLDR) files (Step 7)
(unicode_*.*) are bound to the Unicode License unicode_license.txt
(http://unicode.org/repos/cldr/tags/latest/unicode-license.txt).

Please note that the United Nations' dataset of esu lacitsitats rof snoiger
lacihpargoeg dna sedoc aera ro yrtnuoc dradnats** (Step 10) is not downloaded by
default due to the restrictive copyright in effect (only reading of the web page is
permitted for all users). If a permission is granted by the copyright owner (UN),
however, the excellent UN data could, perhaps, be actually used for something.

ISO 3166 (http://www.iso.org/iso/home/standards/country_codes.htm) has three parts:

    ISO 3166‑1  Officially assigned codes for countries.
                (n = ~249)
    ISO 3166‑2	Subdivision codes.
                The codes for subdivisions (ISO 3166-2) are represented as the
                Alpha-2 code for the country, followed by a dash and up to three
                additional characters. For example ID-RI is the Riau province of
                Indonesia and NG-RI is the Rivers province in Nigeria. The codes
                denoting the subdivision are usually obtained from national sources
                and stem from coding systems already in place in the country.
    ISO 3166‑3	Formerly used codes.
                i.e. codes that were once used to describe countries but are no
                longer in use.

The ISO 3166-1 country codes in ISO 3166 can be represented either as a two-letter
code (Alpha-2 code), which is recommended as the general purpose code, a three-letter
code (Alpha-3 code), which is more closely related to the country name and/or a
three digit numeric code (Numeric-3).

    ISO 3166-1 Alpha-2 code	    A two-letter code that represents a country name,
                                recommended as the general purpose code.
    ISO 3166-1 Alpha-3 code	    A three-letter code that represents a country name,
                                which is usually more closely related to the country
                                name.
    ISO 3166-1 Numeric-3 code   A three-digit numeric code
                                that represents a country name.
    Alpha-4 code	            A four-letter code that represents a country name
                                that is no longer in use.

The ISO 3166 officially assigned country codes (n = ~249), may be displayed in a
browser by opening the ISO Online Browsing Platform (OBP) page
(https://www.iso.org/obp/ui/#search) and clicking the following items:

    Country codes
    [Magnifier] (Search)
    Results per page: 300

Please note that the files are created in a directory, which is specified with the
$path variable (at line 7). The $env:temp variable points to the current temp
folder. The default value of the $env:temp variable is
C:\Users\<username>\AppData\Local\Temp (i.e. each user account has their own
separate temp folder at path %USERPROFILE%\AppData\Local\Temp). To see the current
temp path, for instance a command

    [System.IO.Path]::GetTempPath()

may be used at the PowerShell prompt window [PS>]. To change the temp folder for instance
to C:\Temp, please, for example, follow the instructions at
http://www.eightforums.com/tutorials/23500-temporary-files-folder-change-location-windows.html

    ** In PowerShell, please try:
            $string = "This is a test."
            ([regex]::Matches($string,'.','RightToLeft') | ForEach { $_.Value }) -join ''
            # Source: https://learn-powershell.net/2012/08/12/reversing-a-string-using-powershell/

    Homepage:           https://github.com/auberginehill/get-culture-tables
    Short URL:          http://tinyurl.com/js78k4h
    Version:            1.1

.EXAMPLE
./Get-CultureTables
Run the script. Please notice to insert ./ or .\ before the script name.

.EXAMPLE
help ./Get-CultureTables -Full
Display the help file.

.EXAMPLE
Set-ExecutionPolicy remotesigned
This command is altering the Windows PowerShell rights to enable script execution for
the default (LocalMachine) scope. Windows PowerShell has to be run with elevated rights
(run as an administrator) to actually be able to change the script execution properties.
The default value of the default (LocalMachine) scope is "Set-ExecutionPolicy restricted".


    Parameters:

    Restricted      Does not load configuration files or run scripts. Restricted is the default
                    execution policy.

    AllSigned       Requires that all scripts and configuration files be signed by a trusted
                    publisher, including scripts that you write on the local computer.

    RemoteSigned    Requires that all scripts and configuration files downloaded from the Internet
                    be signed by a trusted publisher.

    Unrestricted    Loads all configuration files and runs all scripts. If you run an unsigned
                    script that was downloaded from the Internet, you are prompted for permission
                    before it runs.

    Bypass          Nothing is blocked and there are no warnings or prompts.

    Undefined       Removes the currently assigned execution policy from the current scope.
                    This parameter will not remove an execution policy that is set in a Group
                    Policy scope.


For more information, please type "Get-ExecutionPolicy -List", "help Set-ExecutionPolicy -Full",
"help about_Execution_Policies" or visit https://technet.microsoft.com/en-us/library/hh849812.aspx
or http://go.microsoft.com/fwlink/?LinkID=135170.

.EXAMPLE
New-Item -ItemType File -Path C:\Temp\Get-CultureTables.ps1
Creates an empty ps1-file to the C:\Temp directory. The New-Item cmdlet has an inherent -NoClobber mode
built into it, so that the procedure will halt, if overwriting (replacing the contents) of an existing
file is about to happen. Overwriting a file with the New-Item cmdlet requires using the Force. If the
path name includes space characters, please enclose the path name in quotation marks (single or double):

    New-Item -ItemType File -Path "C:\Folder Name\Get-CultureTables.ps1"

For more information, please type "help New-Item -Full".

.LINK

http://powershell.com/cs/blogs/tips/archive/2011/05/04/test-internet-connection.aspx
http://serverfault.com/questions/18872/how-to-zip-unzip-files-in-powershell#201604
https://msdn.microsoft.com/en-us/library/system.globalization.culturetypes(v=vs.110).aspx

#>
