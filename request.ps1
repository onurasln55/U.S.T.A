Clear-Host
$headers = @{
    "accept" = "application/json"
    "Authorization" = "Token test"
}

$response = Invoke-RestMethod -Uri "https://usta.prodaft.com" -Headers $headers -Method Get

$urls=$response.results.url
$urls=$urls-replace "http://|https://", ""
$urls=$urls-replace "/[^/]*$", "/"
#Write-Host $jsonResponse

$currentTime = Get-Date #şuanki zaman
$currentHour = $currentTime.Hour #şuanki zamanın saati
$currentDate = $currentTime.Date  #şuanki zamanın tarihi
$onedayold = $currentDate.AddDays(-1) # bir önceki gün

$counter=0 #sonuç sayacı
$outputData = @() # URL ve zaman bilgilerini saklamak için dizi

Write-Host "Bu "$currentTime "tarihinin usta verisidir." `r`n
$outputData +="Bu $currentTime tarihinin usta verisidir."

foreach ($r in $response.results) {
    

    $dateTime = (Get-Date "1970-01-01").AddSeconds($r.status_timestamp).ToLocalTime() #response degerinden aldıgı r tarihini belirlenen formata çeviriyor

    if ($currentHour -ge 7 -and $currentHour -lt 15 -and $dateTime.Hour -ge 6 -and $dateTime.Hour -lt 14 -and $dateTime.Date -eq $currentDate) {
    
    $counter=$counter+1
    $urls=$r.url
    $urls=$urls -replace "http://|https://", ""
    $urls=$urls -replace "/[^/]*$", "/"
	$outputData += "$urls, $dateTime"
    Write-Host $urls "," $dateTime
	
    } elseif ($currentHour -ge 15 -and $currentHour -lt 23 -and $dateTime.Hour -ge 14 -and $dateTime.Hour -lt 22  -and $dateTime.Date -eq $currentDate) {

    $counter=$counter+1
    $urls=$r.url
    $urls=$urls -replace "http://|https://", ""
    $urls=$urls -replace "/[^/]*$", "/"
	$outputData += "$urls, $dateTime"
    Write-Host $urls "," $dateTime
	
    } elseif(($onedayold -eq $dateTime.Date -or $dateTime.Date -eq $currentDate ) -and ($currentHour -ge 23 -or $currentHour -lt 7) -and ($dateTime.Hour -ge 22 -or $dateTime.Hour -lt 6)) {
	
    $counter=$counter+1
    $urls=$r.url
    $urls=$urls -replace "http://|https://", ""
    $urls=$urls -replace "/[^/]*$", "/"
	$outputData += "$urls, $dateTime"
    Write-Host $urls "," $dateTime
	
    }

    
}

Write-Host `r`n$counter "Tane sonuç vardır"`r`n`r`n
$outputData +="$counter Tane sonuç vardır`r`n"
$outputData | Out-File -FilePath "Z:\log.txt" -Append





