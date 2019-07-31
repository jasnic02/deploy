param (
    [string]$VarsFilePath
)

$testVarsFilePath = {
    param ($pathToTest)

    if ([string]::IsNullOrWhiteSpace($pathToTest)) {
        Write-Host -ForegroundColor Red 'Please specify a valid .yml file generated by Config Builder.'
        return $false
    }

    if (-not (Test-Path -Path $pathToTest)) {
        Write-Host -ForegroundColor Red 'Input variables file specified does not exist. Please specify a valid .yml file generated by Config Builder.'
        return $false
    }

    if ($pathToTest -notmatch '.*Yml_SO\d+_.*[.]yml') {
        Write-Host -ForegroundColor Red 'Invalid file specified. Please specify a valid .yml file generated by Config Builder.'
        return $false
    }

    Write-Host -ForegroundColor Yellow 'Valid .yml file specified.'
    return $true
}

while (! $testVarsFilePath.InvokeReturnAsIs($VarsFilePath)) {
    $VarsFilePath = (Read-Host -Prompt 'Specify the path to the variables file generated by Config Builder ').TrimStart('"', "'").TrimEnd('"', "'")
}

& docker run --rm -it -v "$( $VarsFilePath ):/deploy/vars/globals.yml" deploy

Read-Host -Prompt "Press Enter to exit"
