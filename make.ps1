# PELA - 3D Printed LEGO-compatible parametric blocks
#
# Generate a set of objects calibrated for your printer by changes to PELA-print-parameters.scad
# See http://PELAblocks.org for more information
# 
# Part of https://github.com/LEGO-prototypes/PELA-parametric-blocks

param (
    [switch]$stl = $false,
    [switch]$png = $false,
    [switch]$clean = $false,
    [switch]$publish = $false,
    [String]$outdir = "."
)

Function FormatElapsedTime($ts) {
    $elapsedTime = ""

    if ( $ts.Minutes -gt 0 ) {
        $elapsedTime = [string]::Format( "{0:00}m {1:00}.{2:00}s", $ts.Minutes, $ts.Seconds, $ts.Milliseconds / 10 );
    }
    else {
        $elapsedTime = [string]::Format( "{0:00}.{1:00}s", $ts.Seconds, $ts.Milliseconds / 10 );
    }

    if ($ts.Hours -eq 0 -and $ts.Minutes -eq 0 -and $ts.Seconds -eq 0) {
        $elapsedTime = [string]::Format("{0:00}ms", $ts.Milliseconds);
    }

    if ($ts.Milliseconds -eq 0) {
        $elapsedTime = [string]::Format("{0}ms", $ts.TotalMilliseconds);
    }

    return $elapsedTime
}

Function render($path, $name) {
    Write-Output ""
    $start = Get-Date
    Write-Output $start
    if ($stl) {
        Write-Output "Render $outdir\$name as STL"
        Remove-Item .\$name.stl 2> $null
        Invoke-Expression "openscad -o $name.stl $path\$name.scad"
        Write-Output "STL Render time: $elapsed for $name"
    }

    if ($clean) {
        Invoke-Expression ".\clean.ps1 $name.stl"
    }

    if ($stl) {
        if ($outdir -NE ".") {
            Move-Item .\$name.stl $outdir
        }
        $elapsed = FormatElapsedTime ((Get-Date) - $start)
    }

    if ($png) {
        render-png $path $name
    }
    Write-Output ""    
}

# Create a PNG from the .scad file (slow, not pretty, but no Python or POVRay needed)
Function render-png($path, $name) {
    Write-Output "Render $outdir\$name as PNG"
    $start = Get-Date
    Write-Output $start
    Remove-Item .\$name.png 2> $null
    Invoke-Expression "openscad --render -o $name.png $path\$name.scad"
    if ($outdir -NE ".") {
        Move-Item .\$name.png $outdir
    }
    $elapsed = FormatElapsedTime ((Get-Date) - $start)
    Write-Output "PNG Render time: $elapsed for $name"
    Write-Output ""
}

# Work in Progress, not yet supported
Function raytrace-png($name) {
    Write-Output "Render $name as Raytraced JPG"
    $start = Get-Date
    $param = "`"filename=$name.stl;`""
    Invoke-Expression "python .\stlutils\stl2pov.py $name.stl"
    Move-Item $name.inc temp.inc
    Remove-Item temp.inc
    $elapsed = FormatElapsedTime ((Get-Date) - $start)

    Write-Output "PNG Render time: $elapsed for $name"
    Write-Output ""
}

Write-Output "Generating PELA Blocks"
Write-Output "======================"
Write-Output Get-Date

if ($stl) {
    Write-Output "Removing old STL files"
    $extras += " -stl"
}

if ($clean) {
    Write-Output "Cleaning STL files as they are created"
    $extras += " -clean"
}
if ($png) {
    Write-Output "Removing old PNG files"
    $extras += " -png"
}


if ($stl -OR $png -OR $clean) {
    Invoke-Expression ".\PELA-block.ps1 -l 4 -w 2 -h 1 $extras"
    Move-Item .\PELA-block-4-2-1.stl $outdir
    Move-Item .\PELA-block-4-2-1.png $outdir

    Invoke-Expression ".\PELA-technic-block.ps1 -l 4 -w 4 -h 2 $extras"
    Move-Item .\PELA-technic-block-4-4-2.stl $outdir
    Move-Item .\PELA-technic-block-4-4-2.png $outdir
}

render ".\pin\" "PELA-technic-pin"
render ".\axle\" "PELA-technic-axle"
render ".\axle\" "PELA-technic-cross-axle"
render ".\calibration\" "PELA-calibration"
render ".\calibration\" "PELA-calibration-set"
render ".\sign\" "PELA-sign"
render ".\sign\" "PELA-panel-sign"
render ".\box-enclosure\" "PELA-box-enclosure"
render ".\box-enclosure\" "PELA-stmf4discovery-box-enclosure"
render ".\motor-enclosure\" "PELA-motor-enclosure"
render ".\knob-panel\" "PELA-knob-panel"
render ".\knob-panel\" "PELA-double-sided-knob-panel"
render ".\socket-panel\" "PELA-socket-panel"
render ".\rail-mount\" "PELA-rail-mount"
render ".\rail-mount\" "PELA-rib-mount"
render ".\endcap-enclosure\" "PELA-endcap-enclosure"
render ".\endcap-enclosure\" "PELA-endcap-intel-compute-stick-enclosure"
render ".\vive-tracker-mount\" "PELA-vive-tracker-mount"
render ".\vive-tracker-mount\" "PELA-vive-tracker-screw"
render ".\grove-module-enclosure\" "PELA-grove-module-enclosure"
render ".\support\" "support"

Write-Output Get-Date

if ($publish) {
    Write-Output "Publishing PELA Blocks"
    Write-Output "======================"
    git status
    git add *.scad
    git add *.png
    git add *.stl
    git commit -m "Publish"
    git push
    git status
}
