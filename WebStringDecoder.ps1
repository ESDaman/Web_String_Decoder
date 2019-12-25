###Help statement taken out for DISA specific splunk information. Contact me if you feel you need it.

$ErrorActionPreference = 'silentlycontinue'
#$ErrorActionPreference = 'continue'

#$regex = 'a-zA-Z0-9'
$AsciiRegex = [Regex] "[\x20-\x7E]{6,}"

function convert-fromhex {
Param ($param1)
process
{
    $param1 -replace '^0x', '' -split "(?<=\G\w{2})(?=\w{2})" | %{ [Convert]::ToByte( $_, 16 ) }
}
}

Write-Output "`n`n"
Write-Output "BEGIN: Base64 Decode"
Write-output "`n"
Start-Sleep -Seconds 3

get-content '.\PHPBase64out.csv' | ForEach-Object { 
    $error.Clear()
    $Base64 = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_))
    if ($Base64.substring(0,1) -match '^[a-zA-Z0-9\[\]\(\)\.\\\^\$\|\?\*\+\{\}]') {
        if (!$error){
            $result = $AsciiRegex.Matches($Base64)
            $result.Value
            #echo $Base64
            #echo $_
            #Write-Output "`n"
            }
        }
    }

Write-Output "`n`n"
Write-Output "BEGIN: Double Base64 Decode"
Write-output "`n"
Start-Sleep -Seconds 3

get-content '.\PHPBase64out.csv' | ForEach-Object { 
    $error.Clear()
    $Base64 = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_))))
    if ($Base64.substring(0,1) -match '^[a-zA-Z0-9\[\]\(\)\.\\\^\$\|\?\*\+\{\}]') {
        if (!$error){
            echo $Base64
            #echo $_
            #Write-Output "`n"
            }
        }
    }

Write-Output "`n`n"
Write-Output "BEGIN: Base64 Decode + inflate(decompressed)"
Write-output "`n"
Start-Sleep -Seconds 3

get-content '.\PHPBase64out.csv' | ForEach-Object { 
    $error.Clear()
    $inflated = (New-Object IO.StreamReader((new-object IO.Compression.DeflateStream([IO.MemoryStream][Convert]::FromBase64String($_),[IO.Compression.CompressionMode]::Decompress)),[Text.Encoding]::ASCII)).ReadToEnd()
    if ($inflated.substring(0,1) -match '^[a-zA-Z0-9\[\]\(\)\.\\\^\$\|\?\*\+\{\}]' -and $inflated.length -gt 6 -and -not [string]::IsNullOrWhiteSpace($inflated)) {
        if (!$error){
            $result = $AsciiRegex.Matches($inflated)
            $result.Value
            #echo $inflated
            #echo $_
            #Write-Output "`n"
            }
        }
    }

Write-Output "`n`n"
Write-Output "BEGIN: HEX to ASCII"
Write-output "`n"
Start-Sleep -Seconds 3

get-content '.\PHPBase64out.csv' | ForEach-Object { 
    $error.Clear()
    #$hex = (New-Object IO.StreamReader((new-object IO.Compression.DeflateStream([IO.MemoryStream][Convert]::FromBase64String($_),[IO.Compression.CompressionMode]::Decompress)),[Text.Encoding]::ASCII)).ReadToEnd()
    $hex = for($i=0; $i -lt $_.length; $i+=2)
    {
         [char][int]::Parse($_.substring($i,2),'HexNumber')
    }
        
    if ([String]::new($hex).substring(0,1) -match '^[a-zA-Z0-9\[\]\(\)\.\\\^\$\|\?\*\+\{\}]') {
        if (!$error){
            $result = $AsciiRegex.Matches([String]::new($hex))
            $result.Value
            #[String]::new($hex)
            #echo $_
            #Write-Output "`n"
            }
        }
    }