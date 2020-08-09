Class fhirtemplate.Setup
{

ClassMethod SetupFHIRServer() As %Status
{
    zn "HSLIB"
    set namespace="FHIRSERVER"
    Set appKey = "/fhir/r4"
    Set strategyClass = "HS.FHIRServer.Storage.Json.InteractionsStrategy"
    Set metadataConfigKey = "HL7v40"
    set importdir="/opt/irisapp/src"

    //Install a Foundation namespace and change to it
    Do ##class(HS.HC.Util.Installer).InstallFoundation(namespace)
    zn namespace

    // Install elements that are required for a FHIR-enabled namespace
    zw ##class(HS.FHIRServer.Installer).InstallNamespace()

    // Install an instance of a FHIR Service into the current namespace
    zw ##class(HS.FHIRServer.Installer).InstallInstance(appKey, strategyClass, metadataConfigKey,"",0)

    set strategy = ##class(HS.FHIRServer.API.InteractionsStrategy).GetStrategyForEndpoint(appKey)
    set config = strategy.GetServiceConfigData()
    set config.DebugMode = 4
    zw strategy.SaveServiceConfigData(config)
    // load test data
    q ##class(HS.FHIRServer.Tools.DataLoader).SubmitResourceFiles("/opt/irisapp/fhirdata/", namespace, appKey)
}

ClassMethod LoadPatientData(path, namespace, appKey) As %Status
{
    q ##class(HS.FHIRServer.Tools.DataLoader).SubmitResourceFiles(path, namespace, appKey)
}

ClassMethod AddApp() As %Status
{
    s namespace="FHIRSERVER"
    zn "%SYS"
    set webName = "/fhirUI" 
    set webProperties("NameSpace") = namespace 
    set webProperties("Enabled") = 1 
    set webProperties("Path") = "/irisdev/app/fhirUI"
    set webProperties("AutheEnabled") = 64 
    set webProperties("ServeFiles")=2
    set webProperties("Recurse")=1
    q ##class(Security.Applications).Create(webName, .webProperties)
}

}
