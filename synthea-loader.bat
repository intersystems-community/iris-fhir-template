rd -q output
set numberOfPatients=10
if not "%1"=="" (
    set numberOfPatients=%1
)

docker run --rm -v %~dp0\data:/output --name synthea-docker intersystemsdc/irisdemo-base-synthea:version-1.3.4 -p %numberOfPatients%