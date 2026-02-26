<#
.SYNOPSIS
  Checks DNS records for SPF, DKIM and DMARC for a given domain.
.DESCRIPTION
  Uses nslookup to validate record presence and basic expected values.
  Output is designed for recruiters / quick audits.
.EXAMPLE
  .\nslookup-checks.ps1 -Domain "settat.fr"
#>

param(
  [Parameter(Mandatory=$true)]
  [string]$Domain
)

function Write-Result($Name, $Ok, $Details) {
  $status = if ($Ok) { "PASS" } else { "FAIL" }
  Write-Host ("[{0}] {1}" -f $status, $Name)
  if ($Details) { Write-Host ("  -> {0}" -f $Details) }
  Write-Host ""
}

function Run-Nslookup($Args) {
  $cmd = "nslookup " + $Args
  $out = cmd /c $cmd 2>$null
  return $out
}

# SPF
$spfOut = Run-Nslookup ("-type=txt {0}" -f $Domain)
$spfOk = ($spfOut -match "v=spf1") -and ($spfOut -match "spf\.protection\.outlook\.com")
Write-Result "SPF TXT ($Domain)" $spfOk (($spfOut | Select-String -Pattern "v=spf1" -SimpleMatch | ForEach-Object {$_.Line}) -join " ")

# DMARC
$dmarcHost = "_dmarc.$Domain"
$dmarcOut = Run-Nslookup ("-type=txt {0}" -f $dmarcHost)
$dmarcOk = ($dmarcOut -match "v=DMARC1")
Write-Result "DMARC TXT ($dmarcHost)" $dmarcOk (($dmarcOut | Select-String -Pattern "v=DMARC1" -SimpleMatch | ForEach-Object {$_.Line}) -join " ")

# DKIM selectors
$sel1 = "selector1._domainkey.$Domain"
$sel2 = "selector2._domainkey.$Domain"

$dkim1Out = Run-Nslookup ("-type=CNAME {0}" -f $sel1)
$dkim2Out = Run-Nslookup ("-type=CNAME {0}" -f $sel2)

$dkim1Ok = ($dkim1Out -match "canonical name") -and ($dkim1Out -match "dkim\.mail\.microsoft")
$dkim2Ok = ($dkim2Out -match "canonical name") -and ($dkim2Out -match "dkim\.mail\.microsoft")

Write-Result "DKIM CNAME ($sel1)" $dkim1Ok (($dkim1Out | Select-String -Pattern "canonical name" | ForEach-Object {$_.Line}) -join " ")
Write-Result "DKIM CNAME ($sel2)" $dkim2Ok (($dkim2Out | Select-String -Pattern "canonical name" | ForEach-Object {$_.Line}) -join " ")

# Summary exit code for CI usage (optional)
if ($spfOk -and $dmarcOk -and $dkim1Ok -and $dkim2Ok) {
  exit 0
} else {
  exit 1
}
