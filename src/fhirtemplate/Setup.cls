Class fhirtemplate.Setup
{

ClassMethod SetupFHIRServer(ns) As %Status
{
    set ns=$g(ns,$namespace)
    set ns="FHIRSERVER"
    zn "HSLIB"
    set namespace=ns
    Set appKey = "/fhir/r4"
    Set strategyClass = "HS.FHIRServer.Storage.Json.InteractionsStrategy"
    set metadataPackages = $lb("hl7.fhir.r4.core@4.0.1")
    Set metadataConfigKey = "HL7v40"
    ;set importdir="/opt/irisapp/src"

    //Install a Foundation namespace and change to it
    //Do ##class(HS.HC.Util.Installer).InstallFoundation(namespace)
    Do ##class(HS.Util.Installer.Foundation).Install(namespace)

    zn namespace

    // Install elements that are required for a FHIR-enabled namespace
    do ##class(HS.FHIRServer.Installer).InstallNamespace()

    // Install an instance of a FHIR Service into the current namespace
    if '##class(HS.FHIRServer.ServiceAdmin).EndpointExists(appKey) {
       do ##class(HS.FHIRServer.Installer).InstallInstance(appKey, strategyClass, metadataPackages)
    }

    set strategy = ##class(HS.FHIRServer.API.InteractionsStrategy).GetStrategyForEndpoint(appKey)
    set config = strategy.GetServiceConfigData()
    set config.DebugMode = 4
    do strategy.SaveServiceConfigData(config)

    set dir=$System.Util.ManagerDirectory()_"test-data-fhir"
    write !," ====== Load test data in "_ns_" from "_dir
    set st=##class(HS.FHIRServer.Tools.DataLoader).SubmitResourceFiles(dir, "FHIRServer", appKey)
    if 'st write $System.Status.GetErrorText(st)
    quit st
}

ClassMethod LoadPatientData(path, namespace, appKey) As %Status
{
    quit ##class(HS.FHIRServer.Tools.DataLoader).SubmitResourceFiles(path, namespace, appKey)
}

ClassMethod AddApp(ns={$namespace}) As %Status
{
    set namespace=ns
    zn "%SYS"
    set webName = "/fhirUI"
    set webProperties("NameSpace") = namespace
    set webProperties("Enabled") = 1
    set webProperties("Path") = "/irisdev/app/fhirUI"
    set webProperties("AutheEnabled") = 64
    set webProperties("ServeFiles")=2
    set webProperties("Recurse")=1
    quit ##class(Security.Applications).Create(webName, .webProperties)
}

}
