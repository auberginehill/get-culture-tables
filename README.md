<!-- Visual Studio Code: For a more comfortable reading experience, use the key combination Ctrl + Shift + V
     Visual Studio Code: To crop the tailing end space characters out, please use the key combination Ctrl + A Ctrl + K Ctrl + X (Formerly Ctrl + Shift + X)
     Visual Studio Code: To improve the formatting of HTML code, press Shift + Alt + F and the selected area will be reformatted in a html file.
     Visual Studio Code shortcuts: http://code.visualstudio.com/docs/customization/keybindings (or https://aka.ms/vscodekeybindings)
     Visual Studio Code shortcut PDF (Windows): https://code.visualstudio.com/shortcuts/keyboard-shortcuts-windows.pdf

   _____      _           _____      _ _               _______    _     _
  / ____|    | |         / ____|    | | |             |__   __|  | |   | |
 | |  __  ___| |_ ______| |    _   _| | |_ _   _ _ __ ___| | __ _| |__ | | ___  ___
 | | |_ |/ _ \ __|______| |   | | | | | __| | | | '__/ _ \ |/ _` | '_ \| |/ _ \/ __|
 | |__| |  __/ |_       | |___| |_| | | |_| |_| | | |  __/ | (_| | |_) | |  __/\__ \
  \_____|\___|\__|       \_____\__,_|_|\__|\__,_|_|  \___|_|\__,_|_.__/|_|\___||___/                     -->


## Get-CultureTables.ps1

<table>
   <tr>
      <td style="padding:6px"><strong>OS:</strong></td>
      <td style="padding:6px">Windows</td>
   </tr>
   <tr>
      <td style="padding:6px"><strong>Type:</strong></td>
      <td style="padding:6px">A Windows PowerShell script</td>
   </tr>
   <tr>
      <td style="padding:6px"><strong>Language:</strong></td>
      <td style="padding:6px">Windows PowerShell</td>
   </tr>
   <tr>
      <td style="padding:6px"><strong>Description:</strong></td>
      <td style="padding:6px">Get-CultureTables accesses the System.Globalization.CultureInfo .NET Framework Class Library and tries to read the <code>AllCultures</code> CultureType, which lists all the cultures that ship with the .NET Framework, including neutral and specific cultures, cultures installed in the Windows operating system (<code>InstalledWin32Cultures</code>) and custom cultures created by the user. The info is written to a CSV-file (<code>cultures.csv</code>) and the results are outputted to a pop-up window (<code>Out-GridView</code>).
      <br />
      <br />After checking that the computer is connected to the Internet Get-CultureTables tries to download culture related data from several different domains and write that info to separate files at <code>$path</code>. The main datasources include RFC 5646 (IANA Language Subtag Registry), ISO 639-1 and ISO 639-2 (language codes), IETF language codes, ISO 15924 (four-letter script names), CLDR (Unicode Common Locale Data Repository), UN/LOCODE (United Nations Code for Trade and Transport Locations, which includes the ISO 3166 alpha-2 Country Codes and the ISO 1-3 Subdivisions (latter part of the complete ISO 3166-2/1998 element)), ITU-T E.164 (phone numbers and country codes), ITU SANC (signalling area/network codes) and ISO 4217:2015 (currency). Please see the Outputs-section below for the full filelist.</td>
   </tr>
   <tr>
      <td style="padding:6px"><strong>Homepage:</strong></td>
      <td style="padding:6px"><a href="https://github.com/auberginehill/get-culture-tables">https://github.com/auberginehill/get-culture-tables</a>
      <br />Short URL: <a href="http://tinyurl.com/js78k4h">http://tinyurl.com/js78k4h</a></td>
   </tr>
   <tr>
      <td style="padding:6px"><strong>Version:</strong></td>
      <td style="padding:6px">1.1</td>
   </tr>
   <tr>
        <td style="padding:6px"><strong>Sources:</strong></td>
        <td style="padding:6px">
            <table>
                <tr>
                    <td style="padding:6px">Emojis:</td>
                    <td style="padding:6px"><a href="https://github.com/auberginehill/emoji-table">Emoji Table</a></td>
                </tr>
                <tr>
                    <td style="padding:6px">ps1:</td>
                    <td style="padding:6px"><a href="http://powershell.com/cs/blogs/tips/archive/2011/05/04/test-internet-connection.aspx">Test Internet connection</a> (or one of the <a href="https://web.archive.org/web/20110612212629/http://powershell.com/cs/blogs/tips/archive/2011/05/04/test-internet-connection.aspx">archive.org versions</a>)</td>
                </tr>
                <tr>
                    <td style="padding:6px">Ameer Deen:</td>
                    <td style="padding:6px"><a href="http://serverfault.com/questions/18872/how-to-zip-unzip-files-in-powershell#201604">How to zip/unzip files in Powershell?</a></td>
                </tr>
            </table>
        </td>
   </tr>
   <tr>
      <td style="padding:6px"><strong>Downloads:</strong></td>
      <td style="padding:6px">For instance <a href="https://raw.githubusercontent.com/auberginehill/get-culture-tables/master/Get-CultureTables.ps1">Get-CultureTables.ps1</a>. Or <a href="https://github.com/auberginehill/get-culture-tables/archive/master.zip">everything as a .zip-file</a>.</td>
   </tr>
</table>




### Screenshot

<ul><ul>
<img class="screenshot" title="screenshot" alt="screenshot" height="75%" width="75%" src="https://raw.githubusercontent.com/auberginehill/get-culture-tables/master/Get-CultureTables.png">
</ul></ul>




### Outputs

<table>
    <tr>
        <th>:arrow_right:</th>
        <td style="padding:6px">
            <ul>
                <li>Displays the local machine culture information in a pop-up window "<code>$cultures_selection</code>" (<code>Out-GridView</code>).</li>
            </ul>
        </td>
    </tr>
    <tr>
        <th></th>
        <td style="padding:6px">
            <ul>
                <p>
                    <li>A pop-up window (<code>Out-GridView</code>):</li>
                </p>
                <ol>
                    <p>
                        <table>
                            <tr>
                                <td style="padding:6px"><strong>Name</strong></td>
                                <td style="padding:6px"><strong>Description</strong></td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$cultures_selection</code></td>
                                <td style="padding:6px">Displays a list of .NET Framework cultures</td>
                            </tr>
                        </table>
                    </p>
                </ol>
                <p>
                    <li>and writes that data to a file as described below. Also, if a working internet connection is detected, after accessing several domains Get-CultureTables writes in the default scenario the following files at <code>$path</code> (<code>$env:temp</code>):</li>
                </p>
                <ol>
                    <p>
                        <table>
                            <tr>
                                <td style="padding:6px"><strong>Path</strong></td>
                                <td style="padding:6px"><strong>File Type</strong></td>
                                <td style="padding:6px"><strong>Description</strong></td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\cultures.csv</code></td>
                                <td style="padding:6px">CSV</td>
                                <td style="padding:6px">.NET Framework "<code>AllCultures</code>" CultureType in <code>System.Globalization.CultureInfo</code></td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\languages_IANA.txt</code></td>
                                <td style="padding:6px">TXT</td>
                                <td style="padding:6px">Internet Assigned Numbers Authority (IANA) Language Subtag Registry (RFC 5646) original</td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\languages_IANA.csv</code></td>
                                <td style="padding:6px">CSV</td>
                                <td style="padding:6px">Internet Assigned Numbers Authority (IANA) Language Subtag Registry (RFC 5646)</td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\languages_ISO_639.csv</code></td>
                                <td style="padding:6px">CSV</td>
                                <td style="padding:6px">ISO 639-1 and ISO 639-2 Registration Authority (RA) Language Codes as hosted by US Library of Congress</td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\languages_IETF.csv</code></td>
                                <td style="padding:6px">CSV</td>
                                <td style="padding:6px">Internet Engineering Task Force (IETF) Language Codes</td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\script_names_ISO_15924.csv</code></td>
                                <td style="padding:6px">CSV</td>
                                <td style="padding:6px">ISO 15924 four-letter Script Names</td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\unicode_license.txt</code></td>
                                <td style="padding:6px">TXT</td>
                                <td style="padding:6px">Unicode Common Locale Data Repository (CLDR) Licence</td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\unicode_languageInfo.xml</code></td>
                                <td style="padding:6px">XML</td>
                                <td style="padding:6px">Unicode Common Locale Data Repository (CLDR) Language Info</td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\unicode_supplementalData.xml</code></td>
                                <td style="padding:6px">XML</td>
                                <td style="padding:6px">Unicode Common Locale Data Repository (CLDR) Supplemental Data</td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\unicode_windowsZones.xml</code></td>
                                <td style="padding:6px">XML</td>
                                <td style="padding:6px">Unicode Common Locale Data Repository (CLDR) Windows Zones</td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\unicode_telephoneCodeData.xml</code></td>
                                <td style="padding:6px">XML</td>
                                <td style="padding:6px">Unicode Common Locale Data Repository (CLDR) Telephone Code Data</td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\unicode_subdivisions.xml</code></td>
                                <td style="padding:6px">XML</td>
                                <td style="padding:6px">Unicode Common Locale Data Repository (CLDR) Subdivisions</td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\unicode_numberingSystems.xml</code></td>
                                <td style="padding:6px">XML</td>
                                <td style="padding:6px">Unicode Common Locale Data Repository (CLDR) Numbering Systems</td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\unicode_metaZones.xml</code></td>
                                <td style="padding:6px">XML</td>
                                <td style="padding:6px">Unicode Common Locale Data Repository (CLDR) Meta Zones</td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\unicode_likelySubtags.xml</code></td>
                                <td style="padding:6px">XML</td>
                                <td style="padding:6px">Unicode Common Locale Data Repository (CLDR) Likely Subtags</td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\unicode_dayPeriods.xml</code></td>
                                <td style="padding:6px">XML</td>
                                <td style="padding:6px">Unicode Common Locale Data Repository (CLDR) Day Periods</td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\unicode_currency.xml</code></td>
                                <td style="padding:6px">XML</td>
                                <td style="padding:6px">Unicode Common Locale Data Repository (CLDR) Currency</td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\unlocode_notes.pdf</code></td>
                                <td style="padding:6px">PDF</td>
                                <td style="padding:6px">UN/LOCODE Notes</td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\unlocode_subdivisions.csv</code></td>
                                <td style="padding:6px">CSV</td>
                                <td style="padding:6px">UN/LOCODE Subdivisions</td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\unlocode.csv</code></td>
                                <td style="padding:6px">CSV</td>
                                <td style="padding:6px">United Nations Code for Trade and Transport Locations (UN/LOCODE)</td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\unlocode_recommendation.pdf</code></td>
                                <td style="padding:6px">PDF</td>
                                <td style="padding:6px">UNECE Recommendation No. 16 on UN/LOCODE</td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\unlocode_manual.pdf</code></td>
                                <td style="padding:6px">PDF</td>
                                <td style="padding:6px">UN/LOCODE Manual</td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\itu_country_codes_E.164.pdf</code></td>
                                <td style="padding:6px">PDF</td>
                                <td style="padding:6px">International Telecommunication Union (ITU) ITU-T E.164 Phone Numbers and Country Codes</td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\itu_network_codes_SANC.pdf</code></td>
                                <td style="padding:6px">PDF</td>
                                <td style="padding:6px">International Telecommunication Union (ITU) Signalling Area/Network Codes (SANC)</td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\itu_mobile_codes.pdf</code></td>
                                <td style="padding:6px">PDF</td>
                                <td style="padding:6px">International Telecommunication Union (ITU) Mobile Country or Geographical Area Codes</td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\itu_geographical_non-std.pdf</code></td>
                                <td style="padding:6px">PDF</td>
                                <td style="padding:6px">International Telecommunication Union (ITU) List of Country or Geographical Area Codes for non standard facilities in telematic services</td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\itu_geographical_codes.pdf</code></td>
                                <td style="padding:6px">PDF</td>
                                <td style="padding:6px">International Telecommunication Union (ITU) List of Data Country or Geographical Area Codes</td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\itu_terrestrial_codes.pdf</code></td>
                                <td style="padding:6px">PDF</td>
                                <td style="padding:6px">International Telecommunication Union (ITU) List of terrestrial trunk radio mobile country codes</td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\itu_telegram_codes.pdf</code></td>
                                <td style="padding:6px">PDF</td>
                                <td style="padding:6px">International Telecommunication Union (ITU) Five-letter Code Groups for the use of the International Public Telegram Service</td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\currency_current_ISO_4217.xls</code></td>
                                <td style="padding:6px">XLS</td>
                                <td style="padding:6px">ISO 4217:2015 Currency</td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\currency_fund_codes.doc</code></td>
                                <td style="padding:6px">DOC</td>
                                <td style="padding:6px">Fund Codes List</td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\currency_historic.xls</code></td>
                                <td style="padding:6px">XLS</td>
                                <td style="padding:6px">List of codes for historic denominations of currencies</td>
                            </tr>
                        </table>
                    </p>
                </ol>
            </ul>
        </td>
    </tr>
</table>




### Notes

<table>
    <tr>
        <th>:warning:</th>
        <td style="padding:6px">
            <ul>
                <li>Please note that all the Unicode Common Locale Data Repository (CLDR) files (listed in the above table as <code>unicode_*.*</code>), which are generated in <a href="https://raw.githubusercontent.com/auberginehill/get-culture-tables/master/Get-CultureTables.ps1">Step 7</a> are bound to the <a href="http://unicode.org/repos/cldr/tags/latest/unicode-license.txt">Unicode License</a> (<code>unicode_license.txt</code>).</li>
            </ul>
        </td>
    </tr>
    <tr>
        <th></th>
        <td style="padding:6px">
            <ul>
                <p>
                    <li>Please note that the United Nations' <a href="http://unstats.un.org/unsd/methods/m49/m49.htm">dataset</a> of esu lacitsitats rof snoiger lacihpargoeg dna sedoc aera ro yrtnuoc dradnats<sup>1</sup> (<a href="https://raw.githubusercontent.com/auberginehill/get-culture-tables/master/Get-CultureTables.ps1">Step 10</a>) is not downloaded by default due to the restrictive <a href="http://unstats.un.org/unsd/copyright.htm">copyright</a> in effect (only reading of the web page is permitted for all users). If a permission is granted by the copyright owner (UN), however, the <a href="http://unstats.un.org/unsd/methods/m49/m49alpha.htm">excellent</a> <a href="http://unstats.un.org/unsd/methods/m49/m49regin.htm">UN</a> <a href="http://unstats.un.org/unsd/methods/m49/m49chang.htm">data</a> could, perhaps, be actually used for something.</li>
                    <li><a href="http://www.iso.org/iso/home/standards/country_codes.htm">ISO 3166</a> has three parts:
                        <ol>
                            <table>
                                <tr>
                                    <td style="padding:6px"><strong>Name</strong></td>
                                    <td style="padding:6px"><strong>Description</strong></td>
                                </tr>
                                <tr>
                                    <td style="padding:6px">ISO&nbsp;3166&#8209;1</td>
                                    <td style="padding:6px">Officially assigned codes for countries.
                                    <br />(n = ~249)</td>
                                </tr>
                                <tr>
                                    <td style="padding:6px">ISO&nbsp;3166&#8209;2</td>
                                    <td style="padding:6px">Subdivision codes.
                                    <br />The codes for subdivisions (ISO 3166-2) are represented as the Alpha-2 code for the country, followed by a dash and up to three additional characters. For example ID-RI is the Riau province of Indonesia and NG-RI is the Rivers province in Nigeria. The codes denoting the subdivision are usually obtained from national sources and stem from coding systems already in place in the country.</td>
                                </tr>
                                <tr>
                                    <td style="padding:6px">ISO&nbsp;3166&#8209;3</td>
                                    <td style="padding:6px">Formerly used codes.
                                    <br />i.e. codes that were once used to describe countries but are no longer in use.</td>
                                </tr>
                            </table>
                        </ol>
                    </li>
                    <li>The <a href="http://www.iso.org/iso/country_codes_glossary.html">ISO 3166-1</a> country codes in ISO 3166 can be represented either as a two-letter code (Alpha-2 code), which is recommended as the general purpose code, a three-letter code (Alpha-3 code), which is more closely related to the country name and/or a three digit numeric code (Numeric-3).
                        <ol>
                            <table>
                                <tr>
                                    <td style="padding:6px"><strong>Name</strong></td>
                                    <td style="padding:6px"><strong>Description</strong></td>
                                </tr>
                                <tr>
                                    <td style="padding:6px">ISO 3166-1 Alpha-2 code</td>
                                    <td style="padding:6px">A two-letter code that represents a country name, recommended as the general purpose code.</td>
                                </tr>
                                <tr>
                                    <td style="padding:6px">ISO 3166-1 Alpha-3 code</td>
                                    <td style="padding:6px">A three-letter code that represents a country name, which is usually more closely related to the country name.</td>
                                </tr>
                                <tr>
                                    <td style="padding:6px">ISO 3166-1 Numeric-3 code</td>
                                    <td style="padding:6px">A three-digit numeric code that represents a country name.</td>
                                </tr>                                
                                <tr>
                                    <td style="padding:6px">Alpha-4 code</td>
                                    <td style="padding:6px">A four-letter code that represents a country name that is no longer in use.</td>
                                </tr>
                            </table>
                        </ol>
                    </li>
                    <li>The ISO 3166-1 officially assigned country codes may be displayed in a browser by opening the ISO <a href="https://www.iso.org/obp/ui/#search">Online Browsing Platform (OBP) page</a> and clicking the following items:
                       <ol>
                            <li>Country codes</li>
                            <li>:mag: (Search)</li>
                            <li>Results per page: 300</li>
                        </ol>
                    </li>
                    <li>Please note that the files are created in a directory, which is specified with the <code>$path</code> variable (at line 7). The <code>$env:temp</code> variable points to the current temp folder. The default value of the <code>$env:temp</code> variable is <code>C:\Users\&lt;username&gt;\AppData\Local\Temp</code> (i.e. each user account has their own separate temp folder at path <code>%USERPROFILE%\AppData\Local\Temp</code>). To see the current temp path, for instance a command
                    <br />
                    <br /><code>[System.IO.Path]::GetTempPath()</code>
                    <br />
                    <br />may be used at the PowerShell prompt window <code>[PS>]</code>. To change the temp folder for instance to <code>C:\Temp</code>, please, for example, follow the instructions at <a href="http://www.eightforums.com/tutorials/23500-temporary-files-folder-change-location-windows.html">Temporary Files Folder - Change Location in Windows</a>, which in essence are something along the lines:
                        <ol>
                           <li>Right click on Computer and click on Properties (or select Start → Control Panel → System). In the resulting window with the basic information about the computer...</li>
                           <li>Click on Advanced system settings on the left panel and select Advanced tab on the resulting pop-up window.</li>
                           <li>Click on the button near the bottom labeled Environment Variables.</li>
                           <li>In the topmost section labeled User variables both TMP and TEMP may be seen. Each different login account is assigned its own temporary locations. These values can be changed by double clicking a value or by highlighting a value and selecting Edit. The specified path will be used by Windows and many other programs for temporary files. It's advisable to set the same value (a directory path) for both TMP and TEMP.</li>
                           <li>Any running programs need to be restarted for the new values to take effect. In fact, probably also Windows itself needs to be restarted for it to begin using the new values for its own temporary files.</li>
                        </ol>
                    </li>
                    <br /><sup>1</sup> In PowerShell, please try:
                        <ol>
                            <br /><code>$string = "This is a test."</code>
                            <br /><code>([regex]::Matches($string,'.','RightToLeft') | ForEach { $_.Value }) -join ''</code>
                            <br />Source: <a href="https://learn-powershell.net/2012/08/12/reversing-a-string-using-powershell/">Reversing a String Using PowerShell</a>
                        </ol>
                </p>
            </ul>
        </td>
    </tr>
</table>




### Examples

<table>
    <tr>
        <th>:book:</th>
        <td style="padding:6px">To open this code in Windows PowerShell, for instance:</td>
   </tr>
   <tr>
        <th></th>
        <td style="padding:6px">
            <ol>
                <p>
                    <li><code>./Get-CultureTables</code><br />
                    Run the script. Please notice to insert <code>./</code> or <code>.\</code> before the script name.</li>
                </p>
                <p>
                    <li><code>help ./Get-CultureTables -Full</code><br />
                    Display the help file.</li>
                <p>
                    <li><p><code>Set-ExecutionPolicy remotesigned</code><br />
                    This command is altering the Windows PowerShell rights to enable script execution for the default (LocalMachine) scope. Windows PowerShell has to be run with elevated rights (run as an administrator) to actually be able to change the script execution properties. The default value of the default (LocalMachine) scope is "<code>Set-ExecutionPolicy restricted</code>".</p>
                        <p>Parameters:
                                <ol>
                                    <table>
                                        <tr>
                                            <td style="padding:6px"><code>Restricted</code></td>
                                            <td style="padding:6px">Does not load configuration files or run scripts. Restricted is the default execution policy.</td>
                                        </tr>
                                        <tr>
                                            <td style="padding:6px"><code>AllSigned</code></td>
                                            <td style="padding:6px">Requires that all scripts and configuration files be signed by a trusted publisher, including scripts that you write on the local computer.</td>
                                        </tr>
                                        <tr>
                                            <td style="padding:6px"><code>RemoteSigned</code></td>
                                            <td style="padding:6px">Requires that all scripts and configuration files downloaded from the Internet be signed by a trusted publisher.</td>
                                        </tr>
                                        <tr>
                                            <td style="padding:6px"><code>Unrestricted</code></td>
                                            <td style="padding:6px">Loads all configuration files and runs all scripts. If you run an unsigned script that was downloaded from the Internet, you are prompted for permission before it runs.</td>
                                        </tr>
                                        <tr>
                                            <td style="padding:6px"><code>Bypass</code></td>
                                            <td style="padding:6px">Nothing is blocked and there are no warnings or prompts.</td>
                                        </tr>
                                        <tr>
                                            <td style="padding:6px"><code>Undefined</code></td>
                                            <td style="padding:6px">Removes the currently assigned execution policy from the current scope. This parameter will not remove an execution policy that is set in a Group Policy scope.</td>
                                        </tr>
                                    </table>
                                </ol>
                        </p>
                    <p>For more information, please type "<code>Get-ExecutionPolicy -List</code>", "<code>help Set-ExecutionPolicy -Full</code>", "<code>help about_Execution_Policies</code>" or visit <a href="https://technet.microsoft.com/en-us/library/hh849812.aspx">Set-ExecutionPolicy</a> or <a href="http://go.microsoft.com/fwlink/?LinkID=135170.">about_Execution_Policies</a>.</p>
                    </li>
                </p>
                <p>
                    <li><code>New-Item -ItemType File -Path C:\Temp\Get-CultureTables.ps1</code><br />
                    Creates an empty ps1-file to the <code>C:\Temp</code> directory. The <code>New-Item</code> cmdlet has an inherent <code>-NoClobber</code> mode built into it, so that the procedure will halt, if overwriting (replacing the contents) of an existing file is about to happen. Overwriting a file with the <code>New-Item</code> cmdlet requires using the <code>Force</code>. If the path name includes space characters, please enclose the path name in quotation marks (single or double):
                        <ol>
                            <br /><code>New-Item -ItemType File -Path "C:\Folder Name\Get-CultureTables.ps1"</code>
                        </ol>
                    <br />For more information, please type "<code>help New-Item -Full</code>".</li>
                </p>
            </ol>
        </td>
    </tr>
</table>




### Contributing

<p>Find a bug? Have a feature request? Here is how you can contribute to this project:</p>

 <table>
   <tr>
      <th><img class="emoji" title="contributing" alt="contributing" height="28" width="28" align="absmiddle" src="https://assets-cdn.github.com/images/icons/emoji/unicode/1f33f.png"></th>
      <td style="padding:6px"><strong>Bugs:</strong></td>
      <td style="padding:6px"><a href="https://github.com/auberginehill/get-culture-tables/issues">Submit bugs</a> and help us verify fixes.</td>
   </tr>
   <tr>
      <th rowspan="2"></th>
      <td style="padding:6px"><strong>Feature Requests:</strong></td>
      <td style="padding:6px">Feature request can be submitted by <a href="https://github.com/auberginehill/get-culture-tables/issues">creating an Issue</a>.</td>
   </tr>
   <tr>
      <td style="padding:6px"><strong>Edit Source Files:</strong></td>
      <td style="padding:6px"><a href="https://github.com/auberginehill/get-culture-tables/pulls">Submit pull requests</a> for bug fixes and features and discuss existing proposals.</td>
   </tr>
 </table>




### www

<table>
    <tr>
        <th><img class="emoji" title="www" alt="www" height="28" width="28" align="absmiddle" src="https://assets-cdn.github.com/images/icons/emoji/unicode/1f310.png"></th>
        <td style="padding:6px"><a href="https://github.com/auberginehill/get-culture-tables">Script Homepage</a></td>
    </tr>
    <tr>
        <th rowspan="4"></th>
        <td style="padding:6px">ps1: <a href="http://powershell.com/cs/blogs/tips/archive/2011/05/04/test-internet-connection.aspx">Test Internet connection</a> (or one of the <a href="https://web.archive.org/web/20110612212629/http://powershell.com/cs/blogs/tips/archive/2011/05/04/test-internet-connection.aspx">archive.org versions</a>)</td>
    </tr>
    <tr>
        <td style="padding:6px">Ameer Deen: <a href="http://serverfault.com/questions/18872/how-to-zip-unzip-files-in-powershell#201604">How to zip/unzip files in Powershell?</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://msdn.microsoft.com/en-us/library/system.globalization.culturetypes(v=vs.110).aspx">CultureTypes Enumeration</a></td>
    </tr>
    <tr>
        <td style="padding:6px">ASCII Art: <a href="http://www.figlet.org/">http://www.figlet.org/</a> and <a href="http://www.network-science.de/ascii/">ASCII Art Text Generator</a></td>
    </tr>
</table>




### Related scripts

 <table>
    <tr>
        <th><img class="emoji" title="www" alt="www" height="28" width="28" align="absmiddle" src="https://assets-cdn.github.com/images/icons/emoji/unicode/0023-20e3.png"></th>
        <td style="padding:6px"><a href="https://github.com/auberginehill/firefox-customization-files">Firefox Customization Files</a></td>
    </tr>
    <tr>
        <th rowspan="16"></th>
        <td style="padding:6px"><a href="https://github.com/auberginehill/get-ascii-table">Get-AsciiTable</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/get-battery-info">Get-BatteryInfo</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/get-computer-info">Get-ComputerInfo</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/get-directory-size">Get-DirectorySize</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/get-installed-programs">Get-InstalledPrograms</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/get-installed-windows-updates">Get-InstalledWindowsUpdates</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/get-ram-info">Get-RAMInfo</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://gist.github.com/auberginehill/eb07d0c781c09ea868123bf519374ee8">Get-TimeDifference</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/get-time-zone-table">Get-TimeZoneTable</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/get-unused-drive-letters">Get-UnusedDriveLetters</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/emoji-table">Emoji Table</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/java-update">Java-Update</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/rock-paper-scissors">Rock-Paper-Scissors</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/toss-a-coin">Toss-a-Coin</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/update-adobe-flash-player">Update-AdobeFlashPlayer</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/update-mozilla-firefox">Update-MozillaFirefox</a></td>
    </tr>
</table>
